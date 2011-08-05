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
	* Retreieve a content piece by slug
	* @slug The unique slug this content is tied to
	*/
	function findBySlug(required slug){
		var html = findWhere({slug=arguments.slug});
		
		if( !isNull(html) ){ return html; }
		
		throw(message="Custom HTML cannot be found using slug: #arguments.slug#",type="BlogBox.CustomHTMLService.NoContentFound");
	}
	
}