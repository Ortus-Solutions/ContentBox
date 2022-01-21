/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Content version services
 */
component extends="cborm.models.VirtualEntityService" singleton {

	/**
	 * Constructor
	 */
	ContentVersionService function init(){
		// init it
		super.init( entityName = "cbContentVersion" );

		return this;
	}

	/**
	 * Get the total version counts by content object and if the versions are active or not or all
	 *
	 * @contentId The content id to count on
	 * @isActive  If passed, it evaluated the total using active or non-active versions. If not passed, it does them all
	 *
	 * @return The number of versions a content object has by filters
	 */
	numeric function getNumberOfVersions( string contentId = "", boolean isActive ){
		return newCriteria()
			.isEq( "relatedContent.contentID", arguments.contentId )
			.when( !isNull( arguments.isActive ), function( c ){
				c.isEq( "isActive", javacast( "Boolean", isActive ) );
			} )
			.count();
	}

	/**
	 * Get an active version according to content
	 *
	 * @contentID The content id to get the active version for
	 *
	 * @return The active version if found, else a new ContentVersion object
	 */
	function getActiveVersion( required contentId ){
		// Get all the active versions
		var aVersions = newCriteria()
			.isEq( "relatedContent.contentID", arguments.contentId )
			.isTrue( "isActive" )
			.list();

		// Check if we found anything? If so, return the first one
		if ( arrayLen( aVersions ) ) {
			return aVersions[ 1 ];
		} else {
			return this.new();
		}
	}

	/**
	 * Find all the versions related to the passed content Id
	 *
	 * @contentID The content id to get the versions for
	 * @max       Maximum records to get
	 * @offset    The pagination offset
	 *
	 * @return struct of { count : numeric, versions : array}
	 */
	struct function findRelatedVersions( required contentID, max = 0, offset = 0 ){
		var results = {};

		// Find it
		var c = newCriteria().isEq( "relatedContent.contentID", arguments.contentId );

		// run criteria query and projections count
		results.count    = c.count();
		results.versions = c.list(
			offset    = arguments.offset,
			max       = arguments.max,
			sortOrder = "version DESC",
			asQuery   = false
		);

		return results;
	}

}
