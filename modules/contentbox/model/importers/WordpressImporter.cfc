/**
* Import a wordpress database into contentbox
*/
component implements="contentbox.model.importers.ICBImporter"{
	
	// DI
	property name="categoryService"		inject="id:categoryService@cb";
	property name="entryService"		inject="id:entryService@cb";
	property name="authorService"		inject="id:authorService@cb";
	property name="commentService"		inject="id:commentService@cb";
	property name="log"					inject="logbox:logger:{this}";
	property name="htmlHelper"			inject="coldbox:plugin:HTMLHelper";
	
	/**
	* Constructor
	*/
	WordpressImporter function init(){
		return this;
	}
	
	/**
	* Import from wordpress blog, returns the string console.
	*/
	function execute(required dsn,dsnUsername="",dsnPassword="",defaultPassword="",required roleID){
		var authorMap 	= {};
		var catMap 		= {};
		var entryMap 	= {};
		var slugMap 	= {};
		
		log.info("Starting import process: #arguments.toString()#");
		
	transaction action="begin"{
		try{
			// Import categories
			var q = new Query(datasource=arguments.dsn,username=arguments.dsnUsername,
						      password=arguments.dsnPassword,
						      sql="select * from wp_terms a, wp_term_taxonomy b where a.term_id = b.term_id AND b.taxonomy = 'category'").execute().getResult();
			for(var x=1; x lte q.recordcount; x++){
				var props 	= {category=q.name[x], slug=q.slug[x]};
				var cat 	= categoryService.new(properties=props);
				entitySave( cat );
				log.info("Imported category: #props.category#");
				catMap[ q.term_id[x] ] = cat.getCategoryID();
			}
			log.info("Categories imported successfully!");
			
			log.info("Starting to import Authors....");
			// Import Authors
			var q = new Query(datasource=arguments.dsn,username=arguments.dsnUsername,
						     password=arguments.dsnPassword,sql="select * from wp_users").execute().getResult();
			for(var x=1; x lte q.recordcount; x++){
				var props = {email=q.user_email[x], username=q.user_login[x], password=hash(defaultPassword, authorService.getHashType() ),isActive=1,
						     firstName=listFirst(q.display_name[x]," "), lastName=trim(replacenocase(q.display_name[x], listFirst(q.display_name[x]," "), "" ))};
				var author = authorService.new(properties=props);
				entitySave( author );
				log.info("Imported author: #props.firstName# #props.lastName#");
				authorMap[ q.id[x] ] = author.getAuthorID();
			}
			log.info("Authors imported successfully!");
			
			log.info("Starting to import Entries....");
			// Import Entries
			var q = new Query(datasource=arguments.dsn,username=arguments.dsnUsername,
						     password=arguments.dsnPassword,
						     sql="select id,post_title,post_name,post_content,post_status,comment_status,post_password,post_date,post_author from wp_posts where post_type='post'").execute().getResult();
			for(var x=1; x lte q.recordcount; x++){
				var published = true;
				var commentStatus = true;
				if( trim(q.post_status[x]) neq "publish" ){ published = false; }
				if( q.comment_status[x] neq "open" ){ commentSatus = false; }
				var props = {title=q.post_title[x], slug=q.post_name[x], content=q.post_content[x], excerpt="", 
							 publishedDate=q.post_date[x],createdDate=q.post_date[x], isPublished=published,
							 allowComments=commentStatus, passwordProtection=q.post_password[x]};
				// excerpt extract
				var moreLoc = findnocase("<!--more-->", props.content);
				if( moreLoc ){
					props.excerpt = left(props.content,moreLoc-1);
				}
				
				// slug checks
				if( !len(Trim(props.slug)) ){
					props.slug = htmlHelper.slugify(props.title);
				}
				// check if slug already in map
				if( structKeyExists(slugMap, props.slug) ){
					// unique it
					props.slug &= "-" & left(hash(now()),5);
				}
				
				var entry = entryService.new(properties=props);
				entry.setAuthor( authorService.get( authorMap[q.post_author[x]] ) );
				
				// entry categories
				var thisSQL = "
				select a.term_id, a.name, b.term_taxonomy_id, d.post_name, d.id
					from wp_terms a, wp_term_taxonomy b, wp_term_relationships c, wp_posts d
					where a.term_id = b.term_id
					AND b.taxonomy = 'category'
					AND b.term_taxonomy_id = c.term_taxonomy_id
					AND c.object_id = d.id
					AND d.post_type = 'post' 
					AND d.id = '#q.id[x]#'
				";
				var qCategories = new Query(datasource=arguments.dsn,username=arguments.dsnUsername,
						     		    	password=arguments.dsnPassword,
						     		    	sql=thisSQL).execute().getResult();
				var aCategories = [];
				for(var y=1; y lte qCategories.recordcount; y++){
					arrayAppend( aCategories, categoryService.get( catMap[ qCategories.term_id[y]] ) );
				}
				entry.setCategories( aCategories );
				entitySave( entry );
				log.info("Entry imported: #props.title#");
				entryMap[ q.id[x] ] = entry.getContentID();
				slugMap[ entry.getSlug() ] = true;
			}
			log.info("Entries imported successfully!");
			
			log.info("Starting to import Entry Comments....");
			// Import entry comments
			var q = new Query(datasource=arguments.dsn,username=arguments.dsnUsername,
						      password=arguments.dsnPassword,
						      sql="select * from wp_comments").execute().getResult();
			for(var x=1; x lte q.recordcount; x++){
				var props = {
					content = q.comment_content[x], author = q.comment_author[x], authorIP = q.comment_author_ip[x], 
					authorEmail = q.comment_author_email[x], authorURL= q.comment_author_url[x],
					createdDate = q.comment_date[x], isApproved = q.comment_approved[x], 
					wpCommentPostID=q.comment_post_id[x], wpCommentID=q.comment_ID[x]
				};
				// approved checks
				if( !isBoolean(props.isApproved) ){ props.isApproved = false; }
				// existence check, maybe page comments
				if( !structKeyExists(entryMap, q.comment_post_id[x] ) ){
					log.info("Comment skipped as not post type",props);
					continue;	
				}
				
				var entry = entryService.get( entryMap[ q.comment_post_id[x] ] );
				var comment = commentService.new(properties=props);
				comment.setEntry( entry );
				entitySave( comment );
				log.info("Entry Comment imported: #props.authorEmail#", props);
			}
			log.info("Comments imported successfully!");
			
			transaction action="commit"{}
		}
		// end of try
		catch(any e){
			transaction action="rollback"{};
			log.error("Error importing blog: #e.message# #e.detail#",e);
			rethrow;
		}
	}
	// end of transaction
	}

}