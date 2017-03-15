/**
* Manage Security Rules
*/
component extends="baseHandler"{

	// Dependencies
	property name="ruleService"				inject="id:securityRuleService@cb";
	property name="securityInterceptor"		inject="coldbox:interceptor:security@cb";

	// index
	function index(event,rc,prc){
		// Exit Handler
		prc.xehSaveRule 	= "#prc.cbAdminEntryPoint#.securityRules.save";
		prc.xehRemoveRule	= "#prc.cbAdminEntryPoint#.securityRules.remove";
		prc.xehEditorRule	= "#prc.cbAdminEntryPoint#.securityRules.editor";
		prc.xehRuleOrder	= "#prc.cbAdminEntryPoint#.securityRules.changeOrder";
		prc.xehApplyRules	= "#prc.cbAdminEntryPoint#.securityRules.apply";
		prc.xehResetRules	= "#prc.cbAdminEntryPoint#.securityRules.reset";
		prc.xehExport 		= "#prc.cbAdminEntryPoint#.securityRules.export";
		prc.xehExportAll 	= "#prc.cbAdminEntryPoint#.securityRules.exportAll";
		prc.xehImportAll	= "#prc.cbAdminEntryPoint#.securityRules.importAll";
		
		// get content pieces
		prc.rules = ruleService.getAll(sortOrder="order asc" );

		// tab
		prc.tabSystem				= true;
		prc.tabSystem_securityRules	= true;

		// view
		if( event.valueExists( "ajax" ) ){
			event.setView(view="securityRules/rulesTable",noLayout=true);
		}
		else{
			event.setView( "securityRules/index" );
		}
	}

	// Reset Rules
	function reset(event,rc,prc){
		ruleService.resetRules();
		securityInterceptor.loadRules();
		// announce event
		announceInterception( "cbadmin_onResetSecurityRules" );
		cbMessagebox.info( "Security Rules Re-created and Re-applied!" );
		setNextEvent(prc.xehsecurityRules);
	}

	// Apply the security rules
	function apply(event,rc,prc){
		securityInterceptor.loadRules();
		cbMessagebox.info( "Security Rules Applied!" );
		setNextEvent(prc.xehsecurityRules);
	}

	// change order for all rules
	function changeOrder(event,rc,prc){
		event.paramValue( "newRulesOrder","" );
		rc.newRulesOrder = ReplaceNoCase(rc.newRulesOrder, "&rules[]=", ",", "all" );
		rc.newRulesOrder = ReplaceNoCase(rc.newRulesOrder, "rules[]=,", "", "all" );
		for(var i=1;i lte listLen(rc.newRulesOrder);i++) {
			ruleID = listGetAt(rc.newRulesOrder,i);
			var rule = ruleService.get(ruleID);
			if( !isNull( rule ) ){
				rule.setOrder( i );
				ruleService.saveRule( rule );
			}
		}
		event.renderData(type="json",data='true');
	}

	// editor
	function editor(event,rc,prc){

		// tab
		prc.tabSystem				= true;
		prc.tabSystem_securityRules	= true;

		// get new or persisted
		prc.rule  = ruleService.get( event.getValue( "ruleID",0) );

		// exit handlers
		prc.xehRuleSave = "#prc.cbAdminEntryPoint#.securityRules.save";

		// view
		event.setView(view="securityRules/editor" );
	}

	// save rule
	function save(event,rc,prc){

		// populate and get content
		var oRule = populateModel( ruleService.get(id=rc.ruleID) );
		// validate it
		var errors = oRule.validate();
		if( !arrayLen(errors) ){
			// announce event
			announceInterception( "cbadmin_preSecurityRulesSave",{rule=oRule,ruleID=rc.ruleID} );
			// save rule
			ruleService.saveRule( oRule );
			// announce event
			announceInterception( "cbadmin_postSecurityRulesSave",{rule=oRule} );
			// Message
			cbMessagebox.info( "Security Rule saved! Isn't that awesome!" );
		}
		else{
			cbMessagebox.warn(errorMessages=errors);
		}

		// relocate back to editor
		setNextEvent(prc.xehsecurityRules);
	}

	// remove
	function remove(event,rc,prc){
		event.paramValue( "ruleID","" );
		// check for length
		if( len(rc.ruleID) ){
			// announce event
			announceInterception( "cbadmin_preSecurityRulesRemove",{ruleID=rc.ruleID} );
			// remove using hibernate bulk
			ruleService.deleteByID( listToArray(rc.ruleID) );
			// announce event
			announceInterception( "cbadmin_postSecurityRulesRemove",{ruleID=rc.ruleID} );
			// message
			cbMessagebox.info( "Security Rule Removed!" );
		}
		else{
			cbMessagebox.warn( "No ID selected!" );
		}
		setNextEvent(event=prc.xehsecurityRules);
	}
	
	// Export Entry
	function export(event,rc,prc){
		event.paramValue( "format", "json" );
		// get role
		prc.rule  = ruleService.get( event.getValue( "ruleID",0) );
		
		// relocate if not existent
		if( !prc.rule.isLoaded() ){
			cbMessagebox.warn( "ruleID sent is not valid" );
			setNextEvent( "#prc.cbAdminEntryPoint#.securityrules" );
		}
		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "SecurityRule-#prc.rule.getRuleID()#." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=prc.rule.getMemento(), type=rc.format, xmlRootName="securityrule" )
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#" ); 
				break;
			}
			default:{
				event.renderData(data="Invalid export type: #rc.format#" );
			}
		}
	}
	
	// Export All Entries
	function exportAll(event,rc,prc){
		event.paramValue( "format", "json" );
		// get all prepared content objects
		var data  = ruleService.getAllForExport();
		
		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "SecurityRules." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=data, type=rc.format, xmlRootName="securityrules" )
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#" ); 
				break;
			}
			default:{
				event.renderData(data="Invalid export type: #rc.format#" );
			}
		}
	}
	
	// import entries
	function importAll(event,rc,prc){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try{
			if( len( rc.importFile ) and fileExists( rc.importFile ) ){
				var importLog = ruleService.importFromFile( importFile=rc.importFile, override=rc.overrideContent );
				cbMessagebox.info( "Rules imported sucessfully!" );
				flash.put( "importLog", importLog );
			}
			else{
				cbMessagebox.error( "The import file is invalid: #rc.importFile# cannot continue with import" );
			}
		}
		catch(any e){
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			cbMessagebox.error( errorMessage );
		}
		setNextEvent( prc.xehSecurityRules );
	}

}
