/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Notification services for the ContentBox Administrator
*/
component extends="coldbox.system.Interceptor" accessors="true"{
	
	// DI
	property name="settingService"	inject="id:settingService@cb";
	property name="securityService"	inject="id:securityService@cb";
	property name="mailService"		inject="mailService@cbmailservices";
	property name="renderer"		inject="provider:ColdBoxRenderer";
	property name="CBHelper"		inject="id:CBHelper@cb";
	
	function configure(){}
	
	/**
	* Listen to when authors are saved
	*/
	function cbadmin_postAuthorSave( event, interceptData, buffer ){
		var author 		= arguments.interceptData.author;
		// Get settings
		var settings 	= settingService.getAllSettings(asStruct=true);
		
		// Only new authors are announced, not updates, and also verify author notifications are online.
		if( NOT arguments.interceptData.isNew OR NOT settings.cb_notify_author ){ return; }
		
		// get current logged in author performing the action
		var currentAuthor = securityService.getAuthorSession();
		
		// get mail payload
		var bodyTokens = {
			authorName	= author.getName(),
			authorRole	= author.getRole().getRole(),
			authorEmail	= author.getEmail(),
			authorURL 	= CBHelper.linkAdmin( event="authors.editor.authorID.#author.getAuthorID()#", ssl=settings.cb_admin_ssl ),
			currentAuthor		= currentAuthor.getName(),
			currentAuthorEmail 	= currentAuthor.getEmail()
		};
		var mail = mailservice.newMail(to=settings.cb_site_email,
									   from=settings.cb_site_outgoingEmail,
									   subject="#settings.cb_site_name# - Author Created - #bodyTokens.authorName#",
									   bodyTokens=bodyTokens,
									   type="html",
									   server=settings.cb_site_mail_server,
									   username=settings.cb_site_mail_username,
									   password=settings.cb_site_mail_password,
									   port=settings.cb_site_mail_smtp,
									   useTLS=settings.cb_site_mail_tls,
									   useSSL=settings.cb_site_mail_ssl);
									   
		// generate content for email from template
		mail.setBody( renderer.get().renderLayout( 
			view="/contentbox/email_templates/author_new", 
			layout="/contentbox/email_templates/layouts/email", 
			args = { gravatarEmail= currentAuthor.getEmail() }
		));
		// send it out
		mailService.send( mail );
	}
	
	/**
	* Listen to when authors are removed
	*/
	function cbadmin_preAuthorRemove( event, interceptData, buffer ){
		var author 		= arguments.interceptData.author;
		// Get settings
		var settings 	= settingService.getAllSettings(asStruct=true);
		
		// Only notify when enabled.
		if( NOT settings.cb_notify_author ){ return; }
		// get current logged in author performing the action
		var currentAuthor = securityService.getAuthorSession();
		
		// get mail payload
		var bodyTokens = {
			authorName	= author.getName(),
			authorRole	= author.getRole().getRole(),
			authorEmail	= author.getEmail(),
			currentAuthor		= currentAuthor.getName(),
			currentAuthorEmail 	= currentAuthor.getEmail()
		};
		var mail = mailservice.newMail(to=settings.cb_site_email,
									   from=settings.cb_site_outgoingEmail,
									   subject="#settings.cb_site_name# - Author Removed - #bodyTokens.authorName#",
									   bodyTokens=bodyTokens,
									   type="html",
									   server=settings.cb_site_mail_server,
									   username=settings.cb_site_mail_username,
									   password=settings.cb_site_mail_password,
									   port=settings.cb_site_mail_smtp,
									   useTLS=settings.cb_site_mail_tls,
									   useSSL=settings.cb_site_mail_ssl);
									   
		// generate content for email from template
		mail.setBody( renderer.get().renderLayout( 
			view="/contentbox/email_templates/author_remove", 
			layout="/contentbox/email_templates/layouts/email", 
			args = { gravatarEmail= currentAuthor.getEmail() } 
		));
		// send it out
		mailService.send( mail );
	}
	
	/**
	* Listen to when entries are saved
	*/
	function cbadmin_postEntrySave( event, interceptData, buffer ){
		var entry 		= arguments.interceptData.entry;
		// Get settings
		var settings 	= settingService.getAllSettings(asStruct=true);
		
		// Only new entries are announced, not updates, and also verify entry notifications are online.
		if( NOT arguments.interceptData.isNew OR NOT settings.cb_notify_entry ){ return; }
		
		// get current logged in author performing the action
		var currentAuthor = securityService.getAuthorSession();
	
		// get mail payload
		var bodyTokens = {
			entryTitle			= entry.getTitle(),
			entryExcerpt		= "",
			entryURL			= CBHelper.linkEntry( entry=entry, ssl=settings.cb_site_ssl ),
			entryAuthor			= currentAuthor.getName(),
			entryAuthorEmail 	= currentAuthor.getEmail(),
			entryIsPublished	= entry.getIsPublished(),
			entryPublishedDate	= entry.getDisplayPublishedDate(),
			entryExpireDate		= entry.getDisplayExpireDate()
		};
		if( entry.hasExcerpt() ){
			bodyTokens.entryExcerpt = entry.renderExcerpt();
		}
		else{
			bodyTokens.entryExcerpt = entry.renderContentSilent( entry.getContentVersions()[1].getContent() );
		}
		
		var mail = mailservice.newMail(to=settings.cb_site_email,
									   from=settings.cb_site_outgoingEmail,
									   subject="#settings.cb_site_name# - Blog Entry Created - #bodyTokens.entryTitle#",
									   bodyTokens=bodyTokens,
									   type="html",
									   server=settings.cb_site_mail_server,
									   username=settings.cb_site_mail_username,
									   password=settings.cb_site_mail_password,
									   port=settings.cb_site_mail_smtp,
									   useTLS=settings.cb_site_mail_tls,
									   useSSL=settings.cb_site_mail_ssl);
									   
		// generate content for email from template
		mail.setBody( renderer.get().renderLayout( 
			view="/contentbox/email_templates/entry_new", 
			layout="/contentbox/email_templates/layouts/email", 
			args = { gravatarEmail= currentAuthor.getEmail() }
		));
		// send it out
		mailService.send( mail );
	}
	
	/**
	* Listen to when entries are removed
	*/
	function cbadmin_preEntryRemove( event, interceptData, buffer ){
		var entry 		= arguments.interceptData.entry;
		// Get settings
		var settings 	= settingService.getAllSettings(asStruct=true);
		
		// Only notify when enabled.
		if( NOT settings.cb_notify_entry ){ return; }
		
		// get current logged in author performing the action
		var currentAuthor = securityService.getAuthorSession();
		
		// get mail payload
		var bodyTokens = {
			entryTitle			= entry.getTitle(),
			entryExcerpt		= "",
			entryURL			= CBHelper.linkEntry( entry=entry, ssl=settings.cb_site_ssl ),
			entryAuthor			= currentAuthor.getName(),
			entryAuthorEmail 	= currentAuthor.getEmail()
		};
		if( entry.hasExcerpt() ){
			bodyTokens.entryExcerpt = entry.renderExcerpt();
		}
		else{
			bodyTokens.entryExcerpt = entry.renderContent();
		}
		
		var mail = mailservice.newMail(to=settings.cb_site_email,
									   from=settings.cb_site_outgoingEmail,
									   subject="#settings.cb_site_name# - Entry Removed - #bodyTokens.entryTitle#",
									   bodyTokens=bodyTokens,
									   type="html",
									   server=settings.cb_site_mail_server,
									   username=settings.cb_site_mail_username,
									   password=settings.cb_site_mail_password,
									   port=settings.cb_site_mail_smtp,
									   useTLS=settings.cb_site_mail_tls,
									   useSSL=settings.cb_site_mail_ssl);
									   
		// generate content for email from template
		mail.setBody( renderer.get().renderLayout( 
			view="/contentbox/email_templates/entry_remove", 
			layout="/contentbox/email_templates/layouts/email", 
			args = { gravatarEmail= currentAuthor.getEmail() }
		));
		// send it out
		mailService.send( mail );
	}
	
	/**
	* Listen to when pages are saved
	*/
	function cbadmin_postPageSave( event, interceptData, buffer ){
		var page 		= arguments.interceptData.page;
		// Get settings
		var settings 	= settingService.getAllSettings(asStruct=true);
		
		// Only new pages are announced, not updates, and also verify page notifications are online.
		if( NOT arguments.interceptData.isNew OR NOT settings.cb_notify_page ){ return; }
		
		// get current logged in author performing the action
		var currentAuthor = securityService.getAuthorSession();
	
		// get mail payload
		var bodyTokens = {
			pageTitle			= page.getTitle(),
			pageURL				= CBHelper.linkPage( page=page, ssl=settings.cb_site_ssl ),
			pageAuthor			= currentAuthor.getName(),
			pageAuthorEmail 	= currentAuthor.getEmail(),
			pageIsPublished		= page.getIsPublished(),
			pagePublishedDate	= page.getDisplayPublishedDate(),
			pageExpireDate		= page.getDisplayExpireDate()
		};
		if( page.hasExcerpt() ){
			bodyTokens.pageExcerpt = page.renderExcerpt();
		}
		else{
			bodyTokens.pageExcerpt = page.renderContentSilent( page.getContentVersions()[1].getContent() );
		}
		
		var mail = mailservice.newMail(to=settings.cb_site_email,
									   from=settings.cb_site_outgoingEmail,
									   subject="#settings.cb_site_name# - Page Created - #bodyTokens.pageTitle#",
									   bodyTokens=bodyTokens,
									   type="html",
									   server=settings.cb_site_mail_server,
									   username=settings.cb_site_mail_username,
									   password=settings.cb_site_mail_password,
									   port=settings.cb_site_mail_smtp,
									   useTLS=settings.cb_site_mail_tls,
									   useSSL=settings.cb_site_mail_ssl);
									   
		// generate content for email from template
		mail.setBody( renderer.get().renderLayout( 
			view="/contentbox/email_templates/page_new", 
			layout="/contentbox/email_templates/layouts/email", 
			args = { gravatarEmail= currentAuthor.getEmail() } 
		));
		// send it out
		mailService.send( mail );
	}
	
	/**
	* Listen to when pages are removed
	*/
	function cbadmin_prePageRemove( event, interceptData, buffer ){
		var page 		= arguments.interceptData.page;
		// Get settings
		var settings 	= settingService.getAllSettings(asStruct=true);
		
		// Only notify when enabled.
		if( NOT settings.cb_notify_page ){ return; }
		
		// get current logged in author performing the action
		var currentAuthor = securityService.getAuthorSession();
		
		// get mail payload
		var bodyTokens = {
			pageTitle			= page.getTitle(),
			pageExcerpt			= "",
			pageURL				= CBHelper.linkPage( page=page, ssl=settings.cb_site_ssl ),
			pageAuthor			= currentAuthor.getName(),
			pageAuthorEmail 	= currentAuthor.getEmail()
		};
		if( page.hasExcerpt() ){
			bodyTokens.pageExcerpt = page.renderExcerpt();
		}
		else{
			bodyTokens.pageExcerpt = page.renderContent();
		}
		
		var mail = mailservice.newMail(to=settings.cb_site_email,
									   from=settings.cb_site_outgoingEmail,
									   subject="#settings.cb_site_name# - Page Removed - #bodyTokens.pageTitle#",
									   bodyTokens=bodyTokens,
									   type="html",
									   server=settings.cb_site_mail_server,
									   username=settings.cb_site_mail_username,
									   password=settings.cb_site_mail_password,
									   port=settings.cb_site_mail_smtp,
									   useTLS=settings.cb_site_mail_tls,
									   useSSL=settings.cb_site_mail_ssl);
									   
		// generate content for email from template
		mail.setBody( renderer.get().renderLayout( 
			view="/contentbox/email_templates/page_remove", 
			layout="/contentbox/email_templates/layouts/email", 
			args = { gravatarEmail= currentAuthor.getEmail() } 
		));
		// send it out
		mailService.send( mail );
	}

	/**
	* Listen to when contentstore are saved
	*/
	function cbadmin_postContentStoreSave( event, interceptData, buffer ){
		var content 	= arguments.interceptData.content;
		// Get settings
		var settings 	= settingService.getAllSettings( asStruct=true );
		
		// Only new pages are announced, not updates, and also verify page notifications are online.
		if( NOT arguments.interceptData.isNew OR NOT settings.cb_notify_contentstore ){ return; }
		
		// get current logged in author performing the action
		var currentAuthor = securityService.getAuthorSession();
		
		// get mail payload
		var bodyTokens = {
			contentTitle			= content.getTitle(),
			contentDescription		= content.getDescription(),
			contentAuthor			= currentAuthor.getName(),
			contentAuthorEmail 		= currentAuthor.getEmail(),
			contentIsPublished		= content.getIsPublished(),
			contentPublishedDate	= content.getDisplayPublishedDate(),
			contentExpireDate		= content.getDisplayExpireDate(),
			contentURL 				= arguments.event.buildLink( linkto="#CBHelper.adminRoot()#.contentStore.export/contentID/#content.getContentID()#", ssl=settings.cb_admin_ssl ),
			contentExcerpt			= content.renderContentSilent( content.getContentVersions()[ 1 ].getContent() )
		};
		
		var mail = mailservice.newMail( to=settings.cb_site_email,
									    from=settings.cb_site_outgoingEmail,
									    subject="#settings.cb_site_name# - ContentStore Created - #bodyTokens.contentTitle#",
									    bodyTokens=bodyTokens,
									    type="html",
									    server=settings.cb_site_mail_server,
									    username=settings.cb_site_mail_username,
									    password=settings.cb_site_mail_password,
									    port=settings.cb_site_mail_smtp,
									    useTLS=settings.cb_site_mail_tls,
									    useSSL=settings.cb_site_mail_ssl );
									   
		// generate content for email from template
		mail.setBody( renderer.get().renderLayout( 
			view="/contentbox/email_templates/contentstore_new", 
			layout="/contentbox/email_templates/layouts/email", 
			args = { gravatarEmail= currentAuthor.getEmail() }
		));
		// send it out
		mailService.send( mail );
	}
	
	/**
	* Listen to when content store objects are removed
	*/
	function cbadmin_preContentStoreRemove( event, interceptData, buffer ){
		var content 	= arguments.interceptData.content;
		// Get settings
		var settings 	= settingService.getAllSettings( asStruct=true );
		
		// Only notify when enabled.
		if( NOT settings.cb_notify_contentstore ){ return; }
		
		// get current logged in author performing the action
		var currentAuthor = securityService.getAuthorSession();
		
		// get mail payload
		var bodyTokens = {
			contentTitle			= content.getTitle(),
			contentDescription		= content.getDescription(),
			contentAuthor			= currentAuthor.getName(),
			contentAuthorEmail 		= currentAuthor.getEmail(),
			contentIsPublished		= content.getIsPublished(),
			contentPublishedDate	= content.getDisplayPublishedDate(),
			contentExpireDate		= content.getDisplayExpireDate(),
			contentURL 				= arguments.event.buildLink( linkto="#CBHelper.adminRoot()#.contentStore.export/contentID/#content.getContentID()#", ssl=settings.cb_admin_ssl ),
			contentExcerpt			= content.renderContentSilent( content.getContentVersions()[ 1 ].getContent() )
		};
		
		var mail = mailservice.newMail( to=settings.cb_site_email,
									    from=settings.cb_site_outgoingEmail,
									    subject="#settings.cb_site_name# - ContentStore Removed - #bodyTokens.contentTitle#",
									    bodyTokens=bodyTokens,
									    type="html",
									    server=settings.cb_site_mail_server,
									    username=settings.cb_site_mail_username,
									    password=settings.cb_site_mail_password,
									    port=settings.cb_site_mail_smtp,
									    useTLS=settings.cb_site_mail_tls,
									    useSSL=settings.cb_site_mail_ssl );
									   
		// generate content for email from template
		mail.setBody( renderer.get().renderLayout( 
			view="/contentbox/email_templates/contentstore_remove", 
			layout="/contentbox/email_templates/layouts/email", 
			args = { gravatarEmail= currentAuthor.getEmail() } 
		));
		// send it out
		mailService.send( mail );
	}
	
}
