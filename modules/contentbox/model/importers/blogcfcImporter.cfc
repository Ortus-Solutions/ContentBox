/**
* Import a blogcfc database into contentbox
*/

component implements="contentbox.model.importers.ICBImporter" {

	// DI
	property name="categoryService"		inject="id:categoryService@cb";
	property name="entryService"		inject="id:entryService@cb";
	property name="pageService"			inject="id:pageService@cb";
	property name="authorService"		inject="id:authorService@cb";
	property name="roleService"			inject="id:roleService@cb";
	property name="commentService"		inject="id:commentService@cb";
	property name="customFieldService" 	inject="id:customFieldService@cb";
	property name="log"					inject="logbox:logger:{this}";
	property name="htmlHelper"			inject="coldbox:plugin:HTMLHelper";

	/**
	* Constructor
	*/
	blogcfcImporter function init() {
		return this;
	}

	/**
	* Import from blogcfc blog, returns the string console.
	*/
	function execute(required dsn,dsnUsername="",dsnPassword="",defaultPassword="",required roleID,tableprefix=""){
		var authorMap = {};
		var catMap = {};
		var entryMap = {};
		var slugMap = {};

		log.info("Starting import process: #arguments.toString()#");

		try {
			// Import categories
			var q = new Query(datasource=arguments.dsn, username=arguments.dsnUsername,
			                  password=arguments.dsnPassword,
			                  sql="select categoryid, categoryname, categoryalias, blog FROM tblBlogCategories").execute().getResult();
			for(var x = 1; x lte q.recordcount; x++) {
				var props = {category=q.categoryName[x], slug=q.categoryAlias[x]};
				var cat = categoryService.new(properties=props);
				entitySave(cat);
				log.info("Imported category: #props.category#");
				catMap[q.categoryId[x]] = cat.getCategoryID();
			}
			log.info("Categories imported successfully!");

			log.info("Starting to import Authors....");
			// Get the default role
			var defaultRole = roleService.get( arguments.roleID );

			// Import Authors
			var q = new Query(datasource=arguments.dsn, username=arguments.dsnUsername,
			                  password=arguments.dsnPassword,sql="select username, password, name from tblUsers").execute().getResult();
			for(var x = 1; x lte q.recordcount; x++) {
				var props = {email=q.username[x], username=q.username[x],
				                  password=hash(defaultPassword, authorService.getHashType()),isActive=1,
				                  firstName=listFirst(q.name[x], " "),
				                  lastName=trim(replacenocase(q.name[x], listFirst(q.name[x], " "), ""))};

				var author = authorService.findWhere({username=q.username[x]});
				if( isNull(author) ) {
					author = authorService.new(properties=props);
				}

				author.setRole( defaultRole );
				entitySave(author);
				log.info("Imported author: #props.firstName# #props.lastName#");
				authorMap[q.username[x]] = author.getAuthorID();
			}
			log.info("Authors imported successfully!");

			log.info("Starting to import Entries....");
			// Import Entries
			var q = new Query(datasource=arguments.dsn, username=arguments.dsnUsername,
			                  password=arguments.dsnPassword,
			                  sql="
				                  select id, title, body, posted, morebody, alias, username, blog, allowcomments, enclosure,
				                  		filesize, mimetype, views, released, mailed, summary, subtitle, keywords, duration
									from tblBlogEntries
									").execute().getResult();
			for(var x = 1; x lte q.recordcount; x++) {
				var published = true;
				var commentStatus = true;
				if(!trim(q.released[x])) {
					published = false;
				}
				if(!q.allowComments[x]) {
					commentSatus = false;
				}

				if(findNoCase("<code>",q.moreBody[x]) and findNoCase("</code>",q.moreBody[x])) {
					var counter = findNoCase("<code>", q.moreBody[x]);
					while(counter gte 1) {
						var codeblock = reFindNoCase("(?s)(.*)(<code>)(.*)(</code>)(.*)",q.moreBody[x],1,1);
						if(arrayLen(codeblock.len) gte 6) {
							var codeportion = mid(q.moreBody[x], codeblock.pos[4], codeblock.len[4]);
							if (len(trim(codeportion))) {
								var result = "<pre class='codePrint'>#trim(htmlEditFormat(codeportion))#</pre><br/>";
							}
							var newbody = mid(q.moreBody[x], 1, codeblock.len[2]) & result & mid(q.moreBody[x],codeblock.pos[6],codeblock.len[6]);
							q.moreBody[x] = newBody;
							counter = findNoCase("<code>", q.moreBody[x],counter);
						} else {
							counter = 0;
						}
					}
				}

				var props = {title=q.title[x], slug=q.alias[x], content=q.moreBody[x],
				                  excerpt=q.Body[x], publishedDate=q.posted[x], createdDate=q.posted[x],
				                  isPublished=published,allowComments=commentStatus, hits=q.views[x]
							};

				var entry = entryService.new(properties=props);
				entry.addNewContentVersion(content=props.content, changelog="Imported content", author=authorService.get( authorMap[q.username[x]] ));

				// entry categories
				var thisSQL = "
					select		tblBlogCategories.categoryname,categoryId
					from		tblBlogEntries
					inner join	tblBlogEntriesCategories ON tblBlogEntries.id = tblBlogEntriesCategories.entryidfk
					inner join	tblBlogCategories ON tblBlogEntriesCategories.categoryidfk = tblBlogCategories.categoryid
					where		tblBlogEntriesCategories.entryidfk = '#q.id[x]#'
				";
				var qCategories = new Query(datasource=arguments.dsn, username=arguments.dsnUsername,
				                            password=arguments.dsnPassword,sql=thisSQL).execute().getResult();
				var aCategories = [];
				for(var y = 1; y lte qCategories.recordcount; y++) {
					arrayAppend(aCategories, categoryService.get(catMap[qCategories.categoryId[y]]));
				}
				entry.setCategories(aCategories);

				entitySave(entry);

				log.info("Starting to import Entry Comments....");
				// Import entry comments
				var qComments = new Query(datasource=arguments.dsn, username=arguments.dsnUsername,
				                  password=arguments.dsnPassword,
				                  sql="select * from tblBlogComments where entryidfk = '#q.id[x]#'").execute().getResult();

				for(var y = 1; y lte qComments.recordcount; y++) {
					var props = { content=qComments.comment[y], author=qComments.name[y], authorEmail=qComments.email[y],
					                  createdDate=qComments.posted[y], authorIP = '127.0.0.1',
					                  isApproved=qComments.moderated[y], authorUrl = qComments.website[y]
					            };

					var comment = commentService.new(properties=props);
					comment.setRelatedContent( entry );
					entitySave( comment );
					log.info("Entry Comment imported: #props.authorEmail#");
				}
				log.info("Comments imported successfully!");
				log.info("Entry imported: #entry.getTitle()#");
			}
			log.info("Entries imported successfully!");

		} catch(any e) {
			transaction action="rollback" {}
			log.error("Error importing blog: #e.message# #e.detail#", e);
			rethrow;
		}
		transaction action="commit"{}
	}

}
