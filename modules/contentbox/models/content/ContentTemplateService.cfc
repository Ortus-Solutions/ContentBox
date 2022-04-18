/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Template service for contentbox
 */
component extends="cborm.models.VirtualEntityService" singleton {

	// Dependencies
	property name="dateUtil" inject="DateUtil@contentbox";
	property name="contentService" inject="ContentService@contentbox";

	/**
	 * Constructor
	 */
	ContentTemplateService function init(){
		// init it
		super.init( entityName = "cbContentTemplate", useQueryCaching = true );

		return this;
	}

	/**
	 * Content Template search with filters
	 *
	 * @search    The search term for the name
	 * @siteID    The site id to filter on
	 * @isPublic  Filter on this public (true) / private (false) or all (null)
	 * @max       The max records
	 * @offset    The offset to use
	 * @sortOrder The sort order
	 *
	 * @return struct of { count, templates }
	 */
	struct function search(
		search = "",
		siteID = "",
		max       = 0,
		offset    = 0,
		sortOrder = "name asc"
	){
		var results = { "count" : 0, "templates" : [] };
		var c       = newCriteria()
			// Site Filter
			.when( len( arguments.siteID ), function( c ){
				c.isEq( "site.siteID", siteID );
			} )
			// Search Criteria
			.when( len( arguments.search ), function( c ){
				c.or(
					c.restrictions.like( "name","%#search#%" ),
					c.restrictions.like( "description","%#search#%" )
				);
			} );

		// run criteria query and projections count
		results.count      = c.count( "contentTemplateID" );
		results.templates = c.list(
			offset   : arguments.offset,
			max      : arguments.max,
			sortOrder: arguments.sortOrder
		);

		return results;
	}


	/**
	 * Delete a template which also removes itself from all many-to-many relationships
	 *
	 * @template The template object to remove from the system
	 */
	boolean function delete( required template ){
		transaction {
			// Remove content relationships
			var assignedContent = removeTemplateAssignments( arguments.template );
			// Save the related content
			if ( arrayLen( assignedContent ) ) {
				contentService.saveAll( assignedContent );
			}
			// Remove it
			super.delete( arguments.template );
			// evict queries
			ormEvictQueries( getQueryCacheRegion() );
		}

		// return results
		return true;
	}

	/*
	 * Remove all content associations from a template and returns all the content objects it was removed from
	 * @template.hint The template object
	 */
	array function removeTemplateAssignments( required template ){
		var assignedContent = contentService
			.newCriteria()
			.isEq( "contentTemplate", arguments.template )
			.list();

		assignedContent.each( function( contentItem ){
			contentItem.setContentTemplate( javacast( "null", 0 ) );
		} );

		var childrenAssignments = contentService
								.newCriteria()
								.isEq( "childContentTemplate", arguments.template )
								.list();

		childrenAssignments.each( function( contentItem ){
			contentItem.setChildContentTemplate( javacast( "null", 0 ) );
		} );

		assignedContent.append( childrenAssignments, true );

		return assignedContent;
	}

	/**
	 * Get all data prepared for export
	 *
	 * @site The site to export from
	 */
	array function getAllForExport( required site ){
		return findAllWhere( { site : arguments.site } ).map( function( thisItem ){
			return thisItem.getMemento( profile: "export" );
		} );
	}

	/**
	 * Import data from a ContentBox JSON file. Returns the import log
	 *
	 * @importFile The json file to import
	 * @override   Override content if found in the database, defaults to false
	 *
	 * @return The console log of the import
	 *
	 * @throws InvalidImportFormat
	 */
	string function importFromFile( required importFile, boolean override = false ){
		var data      = fileRead( arguments.importFile );
		var importLog = createObject( "java", "java.lang.StringBuilder" ).init(
			"Starting import with override = #arguments.override#...<br>"
		);

		if ( !isJSON( data ) ) {
			throw( message = "Cannot import file as the contents is not JSON", type = "InvalidImportFormat" );
		}

		// deserialize packet: Should be array of { settingID, name, value }
		return importFromData(
			deserializeJSON( data ),
			arguments.override,
			importLog
		);
	}

	/**
	 * Import data from an array of structures or a single structure of data
	 *
	 * @importData A struct or array of data to import
	 * @override   Override content if found in the database, defaults to false
	 * @importLog  The import log buffer
	 *
	 * @return The console log of the import
	 *
	 * @throws InvalidImportFormat
	 */
	string function importFromData(
		required importData,
		boolean override = false,
		importLog
	){
		var allTemplates = [];
		var siteService   = getWireBox().getInstance( "siteService@contentbox" );

		// if struct, inflate into an array
		if ( isStruct( arguments.importData ) ) {
			arguments.importData = [ arguments.importData ];
		}

		transaction {
			// iterate and import
			for ( var thisTemplate in arguments.importData ) {
				var assignedSite = siteService.getBySlugOrFail( thisTemplate.site.slug );
				// Get new or persisted
				var oTemplate = this.findBySiteAndName( site=assignedSite, name=thisTemplate.site.name );
				oTemplate     = ( isNull( oTemplate ) ? new() : oTemplate );

				// populate content from data
				getBeanPopulator().populateFromStruct(
					target              : oTemplate,
					memento             : thisTemplate,
					exclude             : "templateID",
					composeRelationships: false
				);

				// Link the site
				oTemplate.setSite( assignedSite );

				// if new or persisted with override then save.
				if ( !oTemplate.isLoaded() ) {
					arguments.importLog.append( "New template imported for site #assignedSite.getName()#: #thisTemplate.name#<br>" );
					arrayAppend( allTemplates, oTemplate );
				} else if ( oTemplate.isLoaded() and arguments.override ) {
					arguments.importLog.append( "Persisted template overriden for site #assignedSite.getName()#: #thisTemplate.name#<br>" );
					arrayAppend( allTemplates, oTemplate );
				} else {
					arguments.importLog.append( "Skipping persisted template for site #assignedSite.getName()#: #thisTemplate.name#<br>" );
				}
			}
			// end import loop

			// Save them?
			if ( arrayLen( allTemplates ) ) {
				saveAll( allTemplates );
				arguments.importLog.append( "Saved all imported and overriden templates!" );
			} else {
				arguments.importLog.append(
					"No templates imported as none where found or able to be overriden from the import file."
				);
			}
		}
		// end of transaction
		return arguments.importLog.toString();
	}

}
