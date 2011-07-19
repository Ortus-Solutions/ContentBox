/**
* Category service for BlogBox
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	// Dependencies
	property name="htmlHelper" inject="coldbox:plugin:HTMLHelper";
	
	/**
	* Constructor
	*/
	CategoryService function init(){
		// init it
		super.init(entityName="bbCategory");
		
		return this;
	}
	
	/**
	* Create categories via a comma delimited list and return the entities created
	*/
	array function createCategories(categories){
		var allCats = [];
		
		// convert to array
		if( isSimpleValue(arguments.categories) ){
			arguments.categories = listToArray( arguments.categories );
		}
		
		// iterate and create
		for(var x=1; x lte arrayLen(arguments.categories); x++){
			var thisCat 	= trim(arguments.categories[x]);
			var properties 	= {category=thisCat, slug=htmlHelper.slugify( thisCat )};
			
			// append to array all new categories populate with sent cat and slug
			arrayAppend( allCats, new(properties=properties) );
		}
		
		// Save all cats
		if( arrayLen(allCats) ){
			saveAll( allCats );
		}
		
		// return them
		return allCats;
	}
	
	/**
	* Inflate categories from a collection via 'category_X' pattern
	*/
	array function inflateCategories(struct memento){
		var categories = [];
		// iterate all memento keys
		for(var key in arguments.memento){
			// match our prefix
			if( findNoCase("category_", key) ){
				// inflate key
				var thisCat = get( arguments.memento[key] );
				// validate it
				if( !isNull(thisCat) ){ arrayAppend(categories, thisCat); }
			}
		}
		return categories;
	}
	
}