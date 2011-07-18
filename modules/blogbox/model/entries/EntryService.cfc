/**
* Entry service for BlogBox
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	/**
	* Constructor
	*/
	EntryService function init(){
		// init it
		super.init(entityName="bbEntry");
		
		return this;
	}
	
	/**
	* List entries by author with paging
	*/
	function findByAuthor(authorID,numeric offset=0,numeric max=0){
		var q = executeQuery(query="FROM bbEntry WHERE author.authorID = :authorID ORDER BY publishedDate DESC",
							 params={authorID=arguments.authorID},
							 offset=arguments.offset,
							 max=arguments.max,
							 asQuery=false);
		return q;
	}
	
	/**
	* entry search by title or content, returns struct with keys [entries,count]
	*/
	struct function search(criteria="",max=0,offset=0){
		var results = {};
		
		// do search if criteria passed
		if( len(criteria) ){
			results.entries = executeQuery(query="from bbEntry where title like :criteria OR content like :criteria ORDER BY publishedDate desc",
							 			   params={criteria="%#arguments.criteria#%"},
							 			   offset=arguments.offset,
							 			   max=arguments.max,
							 			   asQuery=false);
			results.count = ORMExecuteQuery("select count(*) as total from bbEntry where title like :criteria OR content like :criteria",{criteria="%#arguments.criteria#%"},true);
		}
		else{
			// else do normal listing with paging
			results.entries = list(sortOrder="publishedDate desc",asQuery=false,offset=arguments.offset,max=arguments.max);
			results.count 	= count();
		}
		
		return results;
	}
	
}