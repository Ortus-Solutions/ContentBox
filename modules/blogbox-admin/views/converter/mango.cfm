<cfscript>
dsn = "coldboxblog";
categoryService = wirebox.getInstance("categoryService@bb");
authorService = wirebox.getInstance("authorService@bb");
commentService = wirebox.getInstance("commentService@bb");
entryService = wirebox.getInstance("entryService@bb");
pop = wirebox.getObjectPopulator();
authorMap = {};
catMap = {};
entryMap = {};
defaultPassword = "blogbox";

// transaction safe call, start one
tx = ORMGetSession().beginTransaction();
try{
			
	// categories
	q = new Query(datasource=dsn,sql="select * from mango_category").execute().getResult();
	for(x=1; x lte q.recordcount; x++){
		props = {category=q.title[x], slug=q.name[x]};
		cat = categoryService.new(properties=props);
		entitySave( cat );
		catMap[ q.id[x] ] = cat.getCategoryID();
	}
	
	// authors
	q = new Query(datasource=dsn,sql="select * from mango_author").execute().getResult();
	for(x=1; x lte q.recordcount; x++){
		props = {email=q.email[x], username=q.username[x], password=hash(defaultPassword,"SHA-256"),isActive=1,
				 firstName=listFirst(q.name[x]," "), lastName=trim(replacenocase(q.name[x], listFirst(q.name[x]," "), "" ))};
		author = authorService.new(properties=props);
		entitySave( author );
		authorMap[ q.id[x] ] = author.getAuthorID();
	}
	
	// entries
	q = new Query(datasource=dsn,sql="select * from mango_entry").execute().getResult();
	for(x=1; x lte q.recordcount; x++){
		if( q.status[x] eq "published" ){ published = true; }else{ published = false; }
		props = {title=q.title[x], slug=q.name[x], content=q.content[x], excerpt=q.excerpt[x], publishedDate=q.last_modified[x],
		createdDate=q.last_modified[x], isPublished=published, allowComments=q.comments_allowed[x]};
		entry = entryService.new(properties=props);
		entry.setAuthor( authorService.get( authorMap[q.author_id[x]] ) );
		
		// entry categories
		qCategories = new Query(datasource=dsn,sql="select * from mango_post_category as mp where mp.post_id = '#q.id[x]#'").execute().getResult();
		for(y=1; y lte qCategories.recordcount; y++){
			entry.addCategories( categoryService.get( catMap[ qCategories.category_id[y]] ) );
		}
		entitySave( entry );
		entryMap[ q.id[x] ] = entry.getEntryID();
	}
	
	// entry comments
	q = new Query(datasource=dsn,sql="select * from mango_comment").execute().getResult();
	for(x=1; x lte q.recordcount; x++){
		entry = entryService.get( entryMap[ q.entry_id[x] ] );
		props = {
			content = q.content[x], author = q.creator_name[x], authorIP = '127.0.0.1', authorEmail = q.creator_email[x], authorURL= q.creator_url[x],
			createdDate = q.created_on[x], isApproved = q.approved[x]	
		};
		comment = commentService.new(properties=props);
		comment.setEntry( entry );
		entitySave( comment );
	}

}
catch(any e){
	// rollback
	try{
		tx.rollback();
	}
	catch(any e){
		// silent rollback as something really went wrong
		//writeDump(e);abort;
	}
	//throw it
	rethrow;
}
</cfscript>
<h2>Mango Blog Converted to BlogBox</h2>