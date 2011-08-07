/**
* Import a mango database into blogbox
*/
component implements="blogbox.model.importers.IBBImporter"{
	
	// DI
	property name="categoryService"		inject="id:categoryService@bb";
	property name="entryService"		inject="id:entryService@bb";
	property name="authorService"		inject="id:authorService@bb";
	property name="commentService"		inject="id:commentService@bb";
	property name="log"					inject="logbox:logger:{this}";
	
	/**
	* Constructor
	*/
	MangoImporter function init(){
		return this;
	}
	
	/**
	* Import from mango blog, returns the string console.
	*/
	function execute(required dsn,dsnUsername="",dsnPassword="",defaultPassword=""){
		var authorMap 	= {};
		var catMap 		= {};
		var entryMap 	= {};
		
		log.info("Starting import process: #arguments.toString()#");
		
	transaction action="begin"{
		try{
			// Import categories
			var q = new Query(datasource=arguments.dsn,username=arguments.dsnUsername,
						      password=arguments.dsnPassword,sql="select * from mango_category").execute().getResult();
			for(var x=1; x lte q.recordcount; x++){
				var props 	= {category=q.title[x], slug=q.name[x]};
				var cat 	= categoryService.new(properties=props);
				entitySave( cat );
				log.info("Imported category: #props.category#");
				catMap[ q.id[x] ] = cat.getCategoryID();
			}
			log.info("Categories imported successfully!");
			
			log.info("Starting to import Authors....");
			// Import Authors
			var q = new Query(datasource=arguments.dsn,username=arguments.dsnUsername,
						     password=arguments.dsnPassword,sql="select * from mango_author").execute().getResult();
			for(var x=1; x lte q.recordcount; x++){
				var props = {email=q.email[x], username=q.username[x], password=hash(defaultPassword, authorService.getHashType() ),isActive=1,
						     firstName=listFirst(q.name[x]," "), lastName=trim(replacenocase(q.name[x], listFirst(q.name[x]," "), "" ))};
				var author = authorService.new(properties=props);
				entitySave( author );
				log.info("Imported author: #props.firstName# #props.lastName#");
				authorMap[ q.id[x] ] = author.getAuthorID();
			}
			log.info("Authors imported successfully!");
			
			log.info("Starting to import Entries....");
			// Import Entries
			var q = new Query(datasource=arguments.dsn,username=arguments.dsnUsername,
						     password=arguments.dsnPassword,sql="select * from mango_entry").execute().getResult();
			for(var x=1; x lte q.recordcount; x++){
				var published = true;
				if( q.status[x] neq "published" ){ published = false; }
				var props = {title=q.title[x], slug=q.name[x], content=q.content[x], excerpt=q.excerpt[x], publishedDate=q.last_modified[x],
							 createdDate=q.last_modified[x], isPublished=published, allowComments=q.comments_allowed[x]};
				var entry = entryService.new(properties=props);
				entry.setAuthor( authorService.get( authorMap[q.author_id[x]] ) );
				
				// entry categories
				var qCategories = new Query(datasource=arguments.dsn,username=arguments.dsnUsername,
						     		    password=arguments.dsnPassword,sql="select * from mango_post_category as mp where mp.post_id = '#q.id[x]#'").execute().getResult();
				var aCategories = [];
				for(var y=1; y lte qCategories.recordcount; y++){
					//entry.addCategories( categoryService.get( catMap[ qCategories.category_id[y]] ) );
					arrayAppend( aCategories, categoryService.get( catMap[ qCategories.category_id[y]] ) );
				}
				entry.setCategories( aCategories );
				entitySave( entry );
				log.info("Entry imported: #props.title#");
				entryMap[ q.id[x] ] = entry.getEntryID();
			}
			log.info("Entries imported successfully!");
			
			log.info("Starting to import Entry Comments....");
			// Import entry comments
			var q = new Query(datasource=arguments.dsn,username=arguments.dsnUsername,
						       password=arguments.dsnPassword,sql="select * from mango_comment").execute().getResult();
			for(var x=1; x lte q.recordcount; x++){
				var entry = entryService.get( entryMap[ q.entry_id[x] ] );
				var props = {
					content = q.content[x], author = q.creator_name[x], authorIP = '127.0.0.1', authorEmail = q.creator_email[x], authorURL= q.creator_url[x],
					createdDate = q.created_on[x], isApproved = q.approved[x]	
				};
				var comment = commentService.new(properties=props);
				comment.setEntry( entry );
				entitySave( comment );
				log.info("Entry Comment imported: #props.authorEmail#");
			}
			log.info("Comments imported successfully!");
			
			transaction action="commit"{}
		}
		// end of try
		catch(any e){
			log.error("Error importing blog: #e.message# #e.detail#",e);
			transaction action="rollback"{}
		}
	}
	// end of transaction
	}

}