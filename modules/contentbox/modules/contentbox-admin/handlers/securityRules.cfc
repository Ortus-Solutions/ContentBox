/**
 * Manage Security Rules
 */
component extends="baseHandler" {

	// Dependencies
	property name="ruleService" inject="securityRuleService@contentbox";
	property name="permissionService" inject="permissionService@contentbox";
	property name="roleService" inject="roleService@contentbox";
	property name="securityInterceptor" inject="coldbox:interceptor:cbsecurity@global";

	// index
	function index( event, rc, prc ){
		// Exit Handler
		prc.xehSaveRule   = "#prc.cbAdminEntryPoint#.securityRules.save";
		prc.xehRemoveRule = "#prc.cbAdminEntryPoint#.securityRules.remove";
		prc.xehEditorRule = "#prc.cbAdminEntryPoint#.securityRules.editor";
		prc.xehRuleOrder  = "#prc.cbAdminEntryPoint#.securityRules.changeOrder";
		prc.xehApplyRules = "#prc.cbAdminEntryPoint#.securityRules.apply";
		prc.xehResetRules = "#prc.cbAdminEntryPoint#.securityRules.reset";
		prc.xehExport     = "#prc.cbAdminEntryPoint#.securityRules.export";
		prc.xehExportAll  = "#prc.cbAdminEntryPoint#.securityRules.exportAll";
		prc.xehImportAll  = "#prc.cbAdminEntryPoint#.securityRules.importAll";

		// get content pieces
		prc.rules = ruleService.getAll( sortOrder = "order asc" );

		// tab
		prc.tabSystem               = true;
		prc.tabSystem_securityRules = true;

		// view
		if ( event.valueExists( "ajax" ) ) {
			event.setView( view = "securityRules/rulesTable", noLayout = true );
		} else {
			event.setView( "securityRules/index" );
		}
	}

	// Reset Rules
	function reset( event, rc, prc ){
		ruleService.resetRules();
		securityInterceptor.loadRules();
		// announce event
		announce( "cbadmin_onResetSecurityRules" );
		cbMessagebox.info( "Security Rules Re-created and Re-applied!" );
		relocate( prc.xehsecurityRules );
	}

	// Apply the security rules
	function apply( event, rc, prc ){
		securityInterceptor.loadRules();
		cbMessagebox.info( "Security Rules Applied!" );
		relocate( prc.xehsecurityRules );
	}

	// change order for all rules
	function changeOrder( event, rc, prc ){
		event.paramValue( "tableID", "rules" ).paramValue( "newRulesOrder", "" );
		// decode + cleanup incoming rules data
		// We replace _ to - due to the js plugin issue of not liking dashes
		var aOrderedContent = urlDecode( rc.newRulesOrder )
			.replace( "_", "-", "all" )
			.listToArray( "&" )
			.map( function( thisItem ){
				return reReplaceNoCase(
					arguments.thisItem,
					"#rc.tableID#\[\]\=",
					"",
					"all"
				);
			} )
			// Inflate
			.map( function( thisId, index ){
				return variables.ruleService.get( arguments.thisId ).setOrder( arguments.index );
			} );


		// save them
		if ( arrayLen( aOrderedContent ) ) {
			variables.ruleService.saveAll( aOrderedContent );
		}

		// Send response with the data in the right order
		event
			.getResponse()
			.setData(
				aOrderedContent.map( function( thisItem ){
					return arguments.thisItem.getContentID();
				} )
			)
			.addMessage( "Rules ordered successfully!" );
	}

	// editor
	function editor( event, rc, prc ){
		// tab
		prc.tabSystem               = true;
		prc.tabSystem_securityRules = true;

		// get new or persisted
		if ( isNull( prc.rule ) ) {
			prc.rule = ruleService.get( event.getValue( "ruleID", 0 ) );
		}
		// Load permissions
		prc.aPermissions = variables.permissionService.list( sortOrder = "permission", asQuery = false );
		// Load roles
		prc.aRoles       = variables.roleService.list( sortOrder = "role", asQuery = false );
		// exit handlers
		prc.xehRuleSave  = "#prc.cbAdminEntryPoint#.securityRules.save";
		// view
		event.setView( "securityRules/editor" );
	}

	function save( event, rc, prc ){
		// populate and get content
		prc.rule     = populateModel( model: variables.ruleService.get( rc.ruleID ), exclude: "ruleID" );
		// validate it
		var vResults = validate( prc.rule );
		if ( !vResults.hasErrors() ) {
			// announce event
			announce( "cbadmin_preSecurityRulesSave", { rule : prc.rule, ruleID : rc.ruleID } );
			// save rule
			variables.ruleService.saveRule( prc.rule );
			// announce event
			announce( "cbadmin_postSecurityRulesSave", { rule : prc.rule } );
			// Message + Relocate
			cbMessagebox.info( "Security Rule saved! Isn't that awesome!" );
			relocate( prc.xehsecurityRules );
		} else {
			cbMessagebox.warn( vResults.getAllErrors() );
			return editor( argumentCollection = arguments );
		}
	}

	function remove( event, rc, prc ){
		event.paramValue( "ruleID", "" );
		// check for length
		if ( len( rc.ruleID ) ) {
			// announce event
			announce( "cbadmin_preSecurityRulesRemove", { ruleID : rc.ruleID } );
			// remove using hibernate bulk
			ruleService.deleteByID( listToArray( rc.ruleID ) );
			// announce event
			announce( "cbadmin_postSecurityRulesRemove", { ruleID : rc.ruleID } );
			// message
			cbMessagebox.info( "Security Rule Removed!" );
		} else {
			cbMessagebox.warn( "No ID selected!" );
		}
		relocate( event = prc.xehsecurityRules );
	}

	// Export Entry
	function export( event, rc, prc ){
		return variables.ruleService.get( event.getValue( "ruleID", 0 ) ).getMemento();
	}

	// Export All Entries
	function exportAll( event, rc, prc ){
		param rc.securityRuleID = "";
		// Export all or some
		if ( len( rc.securityRuleID ) ) {
			return rc.securityRuleID
				.listToArray()
				.map( function( id ){
					return variables.ruleService.get( arguments.id ).getMemento( profile: "export" );
				} );
		} else {
			return variables.ruleService.getAllForExport();
		}
	}

	// import entries
	function importAll( event, rc, prc ){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try {
			if ( len( rc.importFile ) and fileExists( rc.importFile ) ) {
				var importLog = ruleService.importFromFile( importFile = rc.importFile, override = rc.overrideContent );
				cbMessagebox.info( "Rules imported sucessfully!" );
				flash.put( "importLog", importLog );
			} else {
				cbMessagebox.error( "The import file is invalid: #rc.importFile# cannot continue with import" );
			}
		} catch ( any e ) {
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			cbMessagebox.error( errorMessage );
		}
		relocate( prc.xehSecurityRules );
	}

}
