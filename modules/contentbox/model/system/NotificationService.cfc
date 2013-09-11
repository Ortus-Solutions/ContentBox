﻿/**
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
* Notification services event listener for ContentBox
*/
component extends="coldbox.system.Interceptor" accessors="true"{
	
	// DI
	property name="settingService"	inject="id:settingService@cb";
	property name="securityService"	inject="id:securityService@cb";
	property name="mailService"		inject="coldbox:plugin:MailService";
	property name="renderer"		inject="provider:ColdBoxRenderer";
	property name="CBHelper"		inject="id:CBHelper@cb";
	
	function configure(){}
	
	/**
	* Listen to when authors are saved
	*/
	function cbadmin_postAuthorSave(event,interceptData){
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
			authorURL 	= CBHelper.linkAdmin("authors.editor.authorID.#author.getAuthorID()#"),
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
		mail.setBody( renderer.get().renderExternalView(view="/contentbox/email_templates/author_new") );
		
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
		mail.setBody( renderer.get().renderExternalView(view="/contentbox/email_templates/author_remove") );
		
		// send it out
		mailService.send( mail );
	}
	
	/**
	* Listen to when entries are saved
	*/
	function cbadmin_postEntrySave(event,interceptData){
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
			entryURL			= CBHelper.linkEntry( entry ),
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
		mail.setBody( renderer.get().renderExternalView(view="/contentbox/email_templates/entry_new") );
		
		// send it out
		mailService.send( mail );
	}
	
	/**
	* Listen to when entries are removed
	*/
	function cbadmin_preEntryRemove(event,interceptData){
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
			entryURL			= CBHelper.linkEntry( entry ),
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
		mail.setBody( renderer.get().renderExternalView(view="/contentbox/email_templates/entry_remove") );
		
		// send it out
		mailService.send( mail );
	}
	
	/**
	* Listen to when pages are saved
	*/
	function cbadmin_postPageSave(event,interceptData){
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
			pageURL				= CBHelper.linkPage( page ),
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
		mail.setBody( renderer.get().renderExternalView(view="/contentbox/email_templates/page_new") );
		
		// send it out
		mailService.send( mail );
	}
	
	/**
	* Listen to when pages are removed
	*/
	function cbadmin_prePageRemove(event,interceptData){
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
			pageURL				= CBHelper.linkPage( page ),
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
		mail.setBody( renderer.get().renderExternalView(view="/contentbox/email_templates/page_remove") );
		
		// send it out
		mailService.send( mail );
	}
	
}