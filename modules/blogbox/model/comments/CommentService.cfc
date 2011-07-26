/**
* Service to handle comment operations.
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	/**
	* Constructor
	*/
	public CommentService function init(){
		
		super.init(entityName="bbComment");
		
		return this;
	}
	
	/**
	* comment search returns struct with keys [comments,count]
	*/
	struct function search(search="",isApproved,entryID,max=0,offset=0){
		var results = {};
		// get Hibernate Restrictions class
		var restrictions = getRestrictions();	
		// criteria queries
		var criteria = [];
		
		// isApproved filter
		if( structKeyExists(arguments,"isApproved") AND arguments.isApproved NEQ "any"){
			arrayAppend(criteria, restrictions.eq("isApproved", javaCast("boolean",arguments.isApproved)) );
		}		
		// Entry Filter
		if( structKeyExists(arguments,"entryID") AND arguments.entryID NEQ "all"){
			arrayAppend(criteria, restrictions.eq("entry.entryID", javaCast("int",arguments.entryID)) );
		}
		// Search Criteria
		if( len(arguments.search) ){
			// like disjunctions
			var orCriteria = [];
 			arrayAppend(orCriteria, restrictions.like("author","%#arguments.search#%"));
 			arrayAppend(orCriteria, restrictions.like("authorEmail","%#arguments.search#%"));
 			arrayAppend(orCriteria, restrictions.like("content","%#arguments.search#%"));
			// append disjunction to main criteria
			arrayAppend( criteria, restrictions.disjunction( orCriteria ) );
		}
		
		// run criteria query and projections count
		results.comments = criteriaQuery(criteria=criteria,offset=arguments.offset,max=arguments.max,sortOrder="createdDate DESC",asQuery=false);
		results.count 	= criteriaCount(criteria=criteria);
		
		return results;
	}

	/**
	* Bulk Updates
	* @commentID The list or array of ID's to bulk update
	* @status The status either 'approve' or 'moderate'
	*/ 
	any function bulkStatus(any commentID,status){
		var approve = false;
		
		// approve flag
		if( arguments.status eq "approve" ){
			approve = true;
		}
		
		// Get all by id
		var comments = getAll(id=arguments.commentID);
		for(var x=1; x lte arrayLen(comments); x++){
			comments[x].setisApproved( approve );
		}
		// transaction the save of all the comments
		saveAll( comments );
		
		return this;		
	}

}