/**
* Manage email templates
*/
component extends="baseHandler"{

	// Dependencies
	property name="templateService"	inject="id:emailtemplateService@cb";
	
	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab control
		prc.tabSystem = true;
		prc.tabSystem_emailtemplates = true;
	}
	
	// index
	function index(event,rc,prc){
		// exit Handlers
		prc.xehTemplateEditor = "#prc.cbAdminEntryPoint#.emailtemplates.edit";
		// get templates
		prc.templates = templateService.getTemplates();
		prc.templatesPath = templateService.getTemplatesPath();
		// view
		event.setView("emailtemplates/index");
	}
	
	// Editor
	function edit(event,rc,prc){
		// decode
		rc.encodedTemplate = rc.template;
		rc.template = urlDecode( rc.template );
		// Exit handlers
		prc.xehTemplateSave = "#prc.cbAdminEntryPoint#.emailtemplates.save";
		// Verify Existence
		if( !templateService.templateExists( rc.template ) ){
			getPlugin("MessageBox").error("The template you are trying to edit: #rc.template# does not exist");
			setNextEvent(prc.xehEmailTemplates);
			return;
		}
		// Get Code
		prc.templateCode = templateService.getTemplateCode( rc.template );
		// view		
		event.setView("emailtemplates/edit");
	}
	
	// Save Code
	function save(event,rc,prc){
		// decode
		rc.template = urlDecode( rc.template );
		// Save the code
		templateService.saveTemplateCode( rc.template, rc.templateCode );
		// stay or relocate?
		if( event.isAjax() ){
			event.renderData(data=true,type="json");
		}
		else{
			getPlugin("MessageBox").info("Email Template Code Saved!");
			setNextEvent(prc.xehEmailTemplates);
		}
	}
}
