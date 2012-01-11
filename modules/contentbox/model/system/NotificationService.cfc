/**
* Notification services event listener for ContentBox
*/
component extends="coldbox.system.Interceptor" accessors="true"{
	
	// DI
	property name="settingService"	inject="id:settingService@cb";
	property name="mailService"		inject="coldbox:plugin:MailService";
	property name="renderer"		inject="coldbox:plugin:Renderer";
	property name="CBHelper"		inject="id:CBHelper@cb";
	
	function configure(){}
	
	/**
	* Listen to when authors are saved
	*/
	function cbadmin_postAuthorSave(event,interceptData){
		var author 		= arguments.interceptData.author;
		
		// Only new authors are announced, not updates.
		if( !arguments.interceptData.isNew ){ return; }
		
		// Get settings
		var settings 	= settingService.getAllSettings(asStruct=true);
		
		// get mail payload
		var bodyTokens = {
			authorName	= author.getName(),
			authorRole	= author.getRole().getRole(),
			authorEmail	= author.getEmail(),
			authorURL 	= CBHelper.linkAdmin("authors.editor.authorID.#author.getAuthorID()#")
		};
		var mail = mailservice.newMail(to=settings.cb_site_email,
									   from=settings.cb_site_outgoingEmail,
									   subject="#settings.cb_site_name# - Author Created - #bodyTokens.authorName#",
									   bodyTokens=bodyTokens);
									   
		// generate content for email from template
		mail.setBody( renderer.renderView(view="email_templates/author_new",module="contentbox") );
		
		// send it out
		mailService.send( mail );
	}
	
	/**
	* Listen to when authors are removed
	*/
	function cbadmin_preAuthorRemove(event,interceptData){
		var author 		= arguments.interceptData.author;
		// Get settings
		var settings 	= settingService.getAllSettings(asStruct=true);
		
		// get mail payload
		var bodyTokens = {
			authorName	= author.getName(),
			authorRole	= author.getRole().getRole(),
			authorEmail	= author.getEmail()
		};
		var mail = mailservice.newMail(to=settings.cb_site_email,
									   from=settings.cb_site_outgoingEmail,
									   subject="#settings.cb_site_name# - Author Removed - #bodyTokens.authorName#",
									   bodyTokens=bodyTokens);
									   
		// generate content for email from template
		mail.setBody( renderer.renderView(view="email_templates/author_remove",module="contentbox") );
		
		// send it out
		mailService.send( mail );
	}
	
}