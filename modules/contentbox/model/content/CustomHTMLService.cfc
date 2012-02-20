/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
* Custom HTML service for ContentBox
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	// Dependencies
	property name="htmlHelper" inject="coldbox:plugin:HTMLHelper";
	
	/**
	* Constructor
	*/
	CustomHTMLService function init(){
		// init it
		super.init(entityName="cbCustomHTML");
		
		return this;
	}
	
	/**
	* Save a custom HTML snippet
	*/
	function saveCustomHTML(required customHTML){
		var c = newCriteria();
		
		// Prepare for slug uniqueness
		c.eq("slug", arguments.customHTML.getSlug() );
		if( arguments.customHTML.isLoaded() ){ c.ne("contentID", arguments.customHTML.getContentID() ); }
		
		// Verify uniqueness of slug
		if( c.count() GT 0){
			// make slug unique
			arguments.customHTML.setSlug( arguments.customHTML.getSlug() & "-#left(hash(now()),5)#");
		}
		
		// send to saving.
		save( arguments.customHTML );
	}
	
	/**
	* custom HTML search returns struct with keys [entries,count]
	*/
	struct function search(search="",max=0,offset=0){
		var results = {};
		// criteria queries
		var c = newCriteria();
		
		// Search Criteria
		if( len(arguments.search) ){
			// like disjunctions
			c.or( c.restrictions.like("slug","%#arguments.search#%"),
				  c.restrictions.like("title","%#arguments.search#%"),
				  c.restrictions.like("description","%#arguments.search#%"),
				  c.restrictions.like("content","%#arguments.search#%") );
		}
		
		// run criteria query and projections count
		results.count 	= c.count();
		results.entries = c.list(offset=arguments.offset,max=arguments.max,sortOrder="title",asQuery=false);
		
		return results;
	}
	
	/**
	* Retrieve a content piece by slug
	* @slug The unique slug this content is tied to
	*/
	function findBySlug(required slug){
		var html = findWhere({slug=arguments.slug});
		
		if( !isNull(html) ){ return html; }
		
		throw(message="Custom HTML cannot be found using slug: #arguments.slug#",type="ContentBox.CustomHTMLService.NoContentFound");
	}
	
}