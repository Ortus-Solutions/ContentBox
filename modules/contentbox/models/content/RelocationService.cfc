/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License" );
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
* A generic content service for content objects
*/
component extends="cborm.models.VirtualEntityService" singleton {

	// DI
	property name="log" inject="logbox:logger:{this}";
	property name="CBHelper" inject="CBHelper@contentbox";

	/**
	 * Constructor
	 */
	function init(){
		super.init( entityname = "cbRelocation", queryCaching = true );
		return this;
	}

	/**
	 * Relocation search with filters
	 *
	 * @search    The search term for the name
	 * @siteID    The site id to filter on
	 * @isPublic  Filter on this public (true) / private (false) or all (null)
	 * @max       The max records
	 * @offset    The offset to use
	 * @sortOrder The sort order
	 *
	 * @return struct of { count, relocations }
	 */
	struct function search(
		search = "",
		siteID = "",
		boolean isPublic,
		max       = 0,
		offset    = 0,
		sortOrder = "slug asc"
	){
		var results = { "count" : 0, "relocations" : [] };
		var c       = newCriteria()
			// Search Criteria
			.when( len( arguments.search ), function( c ){
				c.like( "slug", "%#search#%" );
			} )
			// Site Filter
			.when( len( arguments.siteID ), function( c ){
				c.isEq( "site.siteID", siteID );
			} )
			// Content ID filter
			.when( !isNull( arguments.contentID ), function( c ){
				c.isEq( "relatedContent.contentID", arguments.contentID );
			} );

		// run criteria query and projections count
		results.count       = c.count( "relocationID" );
		results.relocations = c.list(
			offset   : arguments.offset,
			max      : arguments.max,
			sortOrder: arguments.sortOrder
		);

		return results;
	}

	/**
	 * Creates a content-assigned relocation
	 *
	 * @contentItem 	the content item to associate to this relocation
	 * @originalSlug	the slug which will be relocated
	 */
	Relocation function createContentRelocation( required BaseContent contentItem, required string originalSlug ){
		var site       = arguments.contentItem.getSite();
		var relocation = newCriteria()
			.isEq( "site", site )
			.isEq( "slug", arguments.originalSlug )
			.get();
		if ( isNull( relocation ) ) {
			relocation = new (
				properties = {
					"slug"           : arguments.originalSlug,
					"relatedContent" : arguments.contentItem,
					"site"           : site
				}
			);
		} else {
			relocation.setRelatedContent( arguments.contentItem ).setTarget( javacast( "null", 0 ) );
		}
		save( relocation );
		return relocation;
	}

	/**
	 * Creates a target ( no content assigned ) relocation for global site relocations
	 *
	 * @slug 	The URI to be checked
	 * @target 	The target to relocate the URI to
	 */
	Relocation function createTargetRelocation( required string slug, required string target ){
		var site       = variables.cbHelper.site();
		var relocation = newCriteria()
			.isEq( "site", site )
			.isEq( "slug", arguments.originalSlug )
			.get();
		if ( isNull( relocation ) ) {
			relocation = new (
				properties = {
					"slug"   : arguments.slug,
					"target" : arguments.target,
					"site"   : site
				}
			);
		} else {
			relocation.setTarget( arguments.target )
						.setRelatedContent( nullValue() );
		}
		save( relocation );
		return relocation;
	}

	/**
	 * Returns a relocation by slug, contentType, and site
	 *
	 * @slug  		the URI value to test
	 * @contentType the content type to restrict
	 * @site 		the site to restrict the search to
	 */
	any function getRelocationBySlug(
		required string slug,
		string contentType = "Page",
		Site site
	){
		param arguments.site = variables.CBHelper.site();

		return newCriteria()
			.createAlias( "relatedContent", "c" )
			.isEq( "c.contentType", arguments.contentType )
			.isEq( "site", arguments.site )
			.isEq( "slug", arguments.slug )
			.get();
	}

}
