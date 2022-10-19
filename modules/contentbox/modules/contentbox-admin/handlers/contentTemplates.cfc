component extends="baseHandler" {

	property name="templateService" inject="ContentTemplateService@contentbox";
	property name="categoryService" inject="CategoryService@contentbox";

	function preHandler( event, rc, prc ){
		prc.jwtTokens    = getInstance( "JWTService@cbsecurity" ).fromUser( prc.oCurrentAuthor );
		prc.xehExport    = "#prc.cbAdminEntryPoint#.contentTemplates.export";
		prc.xehExportAll = "#prc.cbAdminEntryPoint#.contentTemplates.exportAll";
		prc.xehImportAll = "#prc.cbAdminEntryPoint#.contentTemplates.importAll";
		prc.themeRecord  = getInstance( "ThemeService@contentbox" ).getActiveTheme();
		prc.globalData   = {
			"templateSchema"      : templateService.new().getSchema(),
			"availableLayouts"    : listToArray( reReplaceNoCase( prc.themeRecord.layouts, "blog,?", "" ) ),
			"availableCategories" : variables.categoryService
				.newCriteria()
				.isEq( "site", prc.oCurrentSite )
				.withProjections( property = "categoryID:id,category:label,slug:value,isPublic" )
				.asStruct()
				.list()
		};
	}

	/**
	 * Main Content Templates Admin View
	 */
	function index( event, rc, prc ){
		event.setView( "contentTemplates/index" );
	}

	/**
	 * Exports a single Template
	 */
	function export( event, rc, prc ){
		event.setHTTPHeader(
			name  = "content-disposition",
			value = "attachment; filename=#urlEncodedFormat( "template-export-" & rc.templateId & ".json" )#"
		);
		return templateService.get( rc.templateID ).getMemento( profile = "export" );
	}

	/**
	 * Exports multiple selected templates
	 */
	function exportAll( event, rc, prc ){
		event.setHTTPHeader(
			name  = "content-disposition",
			value = "attachment; filename=#urlEncodedFormat( "template-export.json" )#"
		);
		return templateService
			.newCriteria()
			.isIn( "templateID", listToArray( rc.templateID ) )
			.list()
			.map( function( template ){
				return template.getMemento( profile = "export" )
			} );
	}

	/**
	 * Imports a JSON file containing multiple Templates
	 */
	function importAll( event, rc, prc ){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		var validationManager = getInstance( "ValidationManager@cbvalidation" );
		try {
			if ( len( rc.importFile ) and fileExists( rc.importFile ) ) {
				var templates = deserializeJSON( fileRead( rc.importFile ) ).map( function( template ){
					param template.creator = prc.oCurrentAuthor;
					param template.site    = prc.oCurrentSite;
					// Population arguments
					if ( rc.overrideContent ) {
						var templateEntity = templateService
							.newCriteria()
							.isEq( "site", prc.oCurrentSite )
							.isEq( "name", template.name )
							.get();
						if ( isNull( templateEntity ) ) {
							structDelete( template, "templateID" );
							templateEntity = templatService.new();
						} else {
						}
					} else {
						structDelete( template, "templateID" );
						var templateEntity = templateService.new();
					}
					var populateArgs = { "memento" : template, "model" : templateEntity };


					// Populate it
					populateModel( argumentCollection = populateArgs );

					// Validate it
					validationManager.validateOrFail( target = templateEntity );

					return templateEntity;
				} );

				templateService.saveAll( templates );
				cbMessagebox.info( "Content Templates imported sucessfully!" );
				cbMessagebox.info( "Templates #templates
					.map( function( t ){
						return t.getName();
					} )
					.toList()# are now associated to site #prc.oCurrentSite.getName()#" );
			} else {
				cbMessagebox.error( "The import file is invalid: #rc.importFile# cannot continue with import" );
			}
		} catch ( any e ) {
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			cbMessagebox.error( errorMessage );
		}
		relocate( "#prc.cbAdminEntryPoint#.contentTemplates.index" );
	}

}
