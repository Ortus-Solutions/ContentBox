/**
* Custom HTML service for BlogBox
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	// Dependencies
	property name="htmlHelper" inject="coldbox:plugin:HTMLHelper";
	
	/**
	* Constructor
	*/
	CustomHTMLService function init(){
		// init it
		super.init(entityName="bbCustomHTML");
		
		return this;
	}
	
	/**
	* custom HTML search returns struct with keys [entries,count]
	*/
	struct function search(search="",max=0,offset=0){
		var results = {};
		// get Hibernate Restrictions class
		var restrictions = getRestrictions();	
		// criteria queries
		var criteria = [];
		
		// Search Criteria
		if( len(arguments.search) ){
			// like disjunctions
			var orCriteria = [];
 			arrayAppend(orCriteria, restrictions.like("slug","%#arguments.search#%"));
 			arrayAppend(orCriteria, restrictions.like("title","%#arguments.search#%"));
 			arrayAppend(orCriteria, restrictions.like("content","%#arguments.search#%"));
			// append disjunction to main criteria
			arrayAppend( criteria, restrictions.disjunction( orCriteria ) );
		}
		
		// run criteria query and projections count
		results.entries = criteriaQuery(criteria=criteria,offset=arguments.offset,max=arguments.max,sortOrder="title",asQuery=false);
		results.count 	= criteriaCount(criteria=criteria);
		
		return results;
	}
	
	/**
	* Retreieve a content piece by slug
	* @slug The unique slug this content is tied to
	*/
	function findBySlug(required slug){
		var html = findWhere({slug=arguments.slug});
		
		if( !isNull(html) ){ return html; }
		
		throw(message="Custom HTML cannot be found using slug: #arguments.slug#",type="BlogBox.CustomHTMLService.NoContentFound");
	}
	
}