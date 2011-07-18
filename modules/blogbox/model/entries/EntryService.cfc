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
	* entry search by title or content
	*/
	function search(criteria){
		var r = executeQuery(query="from bbEntry where title like :criteria OR content like :criteria",params={criteria="%#arguments.criteria#%"},asQuery=false);
		return r;
	}
	
}