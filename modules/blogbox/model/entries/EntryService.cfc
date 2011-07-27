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
	* Update an entry's hits
	*/
	function updateHits(entry){
		var q = new Query(sql="UPDATE bb_entry SET hits = hits + 1 WHERE entryID = #arguments.entry.getEntryID()#").execute();
	}
	
	/**
	* entry search returns struct with keys [entries,count]
	*/
	struct function search(search="",isPublished,category,author,max=0,offset=0){
		var results = {};
		// get Hibernate Restrictions class
		var restrictions = getRestrictions();	
		// criteria queries
		var criteria = [];
		
		// isPublished filter
		if( structKeyExists(arguments,"isPublished") AND arguments.isPublished NEQ "any"){
			arrayAppend(criteria, restrictions.eq("isPublished", javaCast("boolean",arguments.isPublished)) );
		}		
		// Author Filter
		if( structKeyExists(arguments,"author") AND arguments.author NEQ "all"){
			arrayAppend(criteria, restrictions.eq("author.authorID", javaCast("int",arguments.author)) );
		}
		// Search Criteria
		if( len(arguments.search) ){
			// like disjunctions
			var orCriteria = [];
 			arrayAppend(orCriteria, restrictions.like("title","%#arguments.search#%"));
 			arrayAppend(orCriteria, restrictions.like("content","%#arguments.search#%"));
			// append disjunction to main criteria
			arrayAppend( criteria, restrictions.disjunction( orCriteria ) );
		}
		// Category Filter
		if( structKeyExists(arguments,"category") AND arguments.category NEQ "all"){
			
			// Uncategorized?
			if( arguments.category eq "none" ){
				arrayAppend(criteria, restrictions.isEmpty("categories") );
			}
			// With categories
			else{
				// create association criteria, by passing a simple value the method will inflate.
				arrayAppend(criteria, "categories");
				// add the association criteria to the main search
				arrayAppend(criteria, restrictions.in("categories.categoryID",JavaCast("java.lang.Integer[]",[arguments.category])));
			}			
		}	
		
		// run criteria query and projections count
		results.entries = criteriaQuery(criteria=criteria,offset=arguments.offset,max=arguments.max,sortOrder="createdDate DESC",asQuery=false);
		results.count 	= criteriaCount(criteria=criteria);
		
		return results;
	}
	
	/**
	* @override Create a new hibernate criteria object according to entityname and criterion array objects
	*/
	private any function createCriteriaQuery(required entityName, array criteria=ArrayNew(1)){
		var qry = ORMGetSession().createCriteria( arguments.entityName );

		for(var i=1; i LTE ArrayLen(arguments.criteria); i++) {
			if( isSimpleValue( arguments.criteria[i] ) ){
				// create criteria out of simple values for associations with alias
				qry.createCriteria( arguments.criteria[i], arguments.criteria[i] );
			}
			else{
				// add criterion
				qry.add( arguments.criteria[i] );
			}
		}

		return qry;
	}
	
}