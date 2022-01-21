/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Notification services for the ContentBox Administrator
 * This class will listen to major events like:
 * - Author Creation and removals
 * - Entry Saving and removals
 * - Page Saving and removals
 * - ContentStore saving and removals
 */
component extends="coldbox.system.Interceptor" accessors="true" {

	// DI
	property name="settingService" inject="settingService@contentbox";
	property name="siteService" inject="siteService@contentbox";
	property name="securityService" inject="securityService@contentbox";
	property name="mailService" inject="mailService@cbmailservices";
	property name="renderer" inject="coldbox:renderer";
	property name="CBHelper" inject="CBHelper@contentbox";

	/**
	 * Configure the Service
	 */
	function configure(){
	}

	/**
	 * Listen to when authors are created in the system.
	 *
	 * @event  ColdBox Event
	 * @data   Intercept Data
	 * @buffer Output buffer
	 */
	function cbadmin_postNewAuthorSave( event, data, buffer ){
		var author   = arguments.data.author;
		var settings = variables.settingService.getAllSettings();

		// Only new authors are announced, not updates, and also verify author notifications are online.
		if ( NOT settings.cb_notify_author ) {
			return;
		}

		// get current logged in author performing the action
		var currentAuthor = variables.securityService.getAuthorSession();
		var defaultSite   = variables.siteService.getDefaultSite();

		// get mail payload
		var bodyTokens = {
			authorName       : author.getFullName(),
			authorRole       : author.getRole().getRole(),
			permissionGroups : author.getPermissionGroupsList(),
			authorEmail      : author.getEmail(),
			authorURL        : CBHelper.linkAdmin(
				event = "authors.editor.authorID.#author.getAuthorID()#",
				ssl   = settings.cb_admin_ssl
			),
			currentAuthor      : currentauthor.getFullName(),
			currentAuthorEmail : currentAuthor.getEmail()
		};
		var mail = variables.mailservice.newMail(
			to         = settings.cb_site_email,
			from       = settings.cb_site_outgoingEmail,
			subject    = "#defaultSite.getName()# - Author Created - #bodyTokens.authorName#",
			bodyTokens = bodyTokens,
			type       = "html",
			server     = settings.cb_site_mail_server,
			username   = settings.cb_site_mail_username,
			password   = settings.cb_site_mail_password,
			port       = settings.cb_site_mail_smtp,
			useTLS     = settings.cb_site_mail_tls,
			useSSL     = settings.cb_site_mail_ssl
		);

		// generate content for email from template
		mail.setBody(
			renderer.renderLayout(
				view   = "/contentbox/email_templates/author_new",
				layout = "/contentbox/email_templates/layouts/email",
				args   = { gravatarEmail : currentAuthor.getEmail() }
			)
		);

		// send it out
		variables.mailService.send( mail );
	}

	/**
	 * Listen to when authors are removed
	 *
	 * @event  ColdBox Event
	 * @data   Intercept Data
	 * @buffer Output buffer
	 */
	function cbadmin_preAuthorRemove( event, data, buffer ){
		var author   = arguments.data.author;
		// Get settings
		var settings = variables.settingService.getAllSettings();

		// Only notify when enabled.
		if ( NOT settings.cb_notify_author ) {
			return;
		}

		// get current logged in author performing the action
		var currentAuthor = variables.securityService.getAuthorSession();
		var defaultSite   = variables.siteService.getDefaultSite();

		// get mail payload
		var bodyTokens = {
			authorName         : author.getFullName(),
			authorRole         : author.getRole().getRole(),
			authorEmail        : author.getEmail(),
			currentAuthor      : currentauthor.getFullName(),
			currentAuthorEmail : currentAuthor.getEmail()
		};
		var mail = variables.mailservice.newMail(
			to         = settings.cb_site_email,
			from       = settings.cb_site_outgoingEmail,
			subject    = "#defaultSite.getName()# - Author Removed - #bodyTokens.authorName#",
			bodyTokens = bodyTokens,
			type       = "html",
			server     = settings.cb_site_mail_server,
			username   = settings.cb_site_mail_username,
			password   = settings.cb_site_mail_password,
			port       = settings.cb_site_mail_smtp,
			useTLS     = settings.cb_site_mail_tls,
			useSSL     = settings.cb_site_mail_ssl
		);

		// generate content for email from template
		mail.setBody(
			renderer.renderLayout(
				view   = "/contentbox/email_templates/author_remove",
				layout = "/contentbox/email_templates/layouts/email",
				args   = { gravatarEmail : currentAuthor.getEmail() }
			)
		);
		// send it out
		variables.mailService.send( mail );
	}

	/**
	 * Listen to when entries are saved
	 *
	 * @event  ColdBox Event
	 * @data   Intercept Data
	 * @buffer Output buffer
	 */
	function cbadmin_postEntrySave( event, data, buffer ){
		// Only new entries are announced, not updates, and also verify entry notifications are online.
		if ( NOT arguments.data.isNew ) {
			return;
		}

		// Setup the entry + site
		var entry    = arguments.data.content;
		var site     = entry.getSite();
		var settings = variables.settingService.getAllSettings();

		// Only notify when enabled.
		if ( !site.getNotifyOnEntries() && !settings.cb_notify_entry ) {
			return;
		}

		// get current logged in author performing the action
		var currentAuthor = variables.securityService.getAuthorSession();

		// get mail payload
		var bodyTokens = {
			entryTitle         : entry.getTitle(),
			entryExcerpt       : "",
			entryURL           : CBHelper.linkEntry( entry = entry, ssl = site.getIsSSL() ),
			entryAuthor        : currentauthor.getFullName(),
			entryAuthorEmail   : currentAuthor.getEmail(),
			entryIsPublished   : entry.getIsPublished(),
			entryPublishedDate : entry.getDisplayPublishedDate(),
			entryExpireDate    : entry.getDisplayExpireDate()
		};

		if ( entry.hasExcerpt() ) {
			bodyTokens.entryExcerpt = entry.renderExcerpt();
		} else {
			bodyTokens.entryExcerpt = entry.renderContentSilent( entry.getActiveContent().getContent() );
		}

		var mail = variables.mailservice.newMail(
			to        : getNotifiers( site, settings ),
			from      : settings.cb_site_outgoingEmail,
			subject   : "#site.getName()# - Blog Entry Created - #bodyTokens.entryTitle#",
			bodyTokens: bodyTokens,
			type      : "html",
			server    : settings.cb_site_mail_server,
			username  : settings.cb_site_mail_username,
			password  : settings.cb_site_mail_password,
			port      : settings.cb_site_mail_smtp,
			useTLS    : settings.cb_site_mail_tls,
			useSSL    : settings.cb_site_mail_ssl
		);

		// generate content for email from template
		mail.setBody(
			renderer.renderLayout(
				view   = "/contentbox/email_templates/entry_new",
				layout = "/contentbox/email_templates/layouts/email",
				args   = { gravatarEmail : currentAuthor.getEmail() }
			)
		);

		// send it out
		variables.mailService.send( mail );
	}

	/**
	 * Listen to when entries are removed
	 *
	 * @event  ColdBox Event
	 * @data   Intercept Data
	 * @buffer Output buffer
	 */
	function cbadmin_preEntryRemove( event, data, buffer ){
		var entry    = arguments.data.content;
		var site     = entry.getSite();
		// Get settings
		var settings = variables.settingService.getAllSettings();

		// Only notify when enabled.
		if ( !site.getNotifyOnEntries() && !settings.cb_notify_entry ) {
			return;
		}

		// get current logged in author performing the action
		var currentAuthor = variables.securityService.getAuthorSession();

		// get mail payload
		var bodyTokens = {
			entryTitle       : entry.getTitle(),
			entryExcerpt     : "",
			entryURL         : CBHelper.linkEntry( entry = entry, ssl = site.getIsSSL() ),
			entryAuthor      : currentauthor.getFullName(),
			entryAuthorEmail : currentAuthor.getEmail()
		};
		if ( entry.hasExcerpt() ) {
			bodyTokens.entryExcerpt = entry.renderExcerpt();
		} else {
			bodyTokens.entryExcerpt = entry.renderContent();
		}

		var mail = variables.mailservice.newMail(
			to         = getNotifiers( site, settings ),
			from       = settings.cb_site_outgoingEmail,
			subject    = "#site.getName()# - Entry Removed - #bodyTokens.entryTitle#",
			bodyTokens = bodyTokens,
			type       = "html",
			server     = settings.cb_site_mail_server,
			username   = settings.cb_site_mail_username,
			password   = settings.cb_site_mail_password,
			port       = settings.cb_site_mail_smtp,
			useTLS     = settings.cb_site_mail_tls,
			useSSL     = settings.cb_site_mail_ssl
		);

		// generate content for email from template
		mail.setBody(
			renderer.renderLayout(
				view   = "/contentbox/email_templates/entry_remove",
				layout = "/contentbox/email_templates/layouts/email",
				args   = { gravatarEmail : currentAuthor.getEmail() }
			)
		);
		// send it out
		variables.mailService.send( mail );
	}

	/**
	 * Listen to when pages are saved
	 *
	 * @event  ColdBox Event
	 * @data   Intercept Data
	 * @buffer Output buffer
	 */
	function cbadmin_postPageSave( event, data, buffer ){
		// Only new pages are announced, not updates, and also verify page notifications are online.
		if ( NOT arguments.data.isNew ) {
			return;
		}

		var page     = arguments.data.content;
		var site     = page.getSite();
		var settings = variables.settingService.getAllSettings();

		// Only notify when enabled.
		if ( !site.getNotifyOnPages() && !settings.cb_notify_page ) {
			return;
		}

		// get current logged in author performing the action
		var currentAuthor = variables.securityService.getAuthorSession();

		// get mail payload
		var bodyTokens = {
			pageTitle         : page.getTitle(),
			pageURL           : CBHelper.linkPage( page = page, ssl = site.getIsSSL() ),
			pageAuthor        : currentauthor.getFullName(),
			pageAuthorEmail   : currentAuthor.getEmail(),
			pageIsPublished   : page.getIsPublished(),
			pagePublishedDate : page.getDisplayPublishedDate(),
			pageExpireDate    : page.getDisplayExpireDate()
		};

		if ( page.hasExcerpt() ) {
			bodyTokens.pageExcerpt = page.renderExcerpt();
		} else {
			bodyTokens.pageExcerpt = page.renderContentSilent( page.getActiveContent().getContent() );
		}

		var mail = variables.mailservice.newMail(
			to         = getNotifiers( site, settings ),
			from       = settings.cb_site_outgoingEmail,
			subject    = "#site.getName()# - Page Created - #bodyTokens.pageTitle#",
			bodyTokens = bodyTokens,
			type       = "html",
			server     = settings.cb_site_mail_server,
			username   = settings.cb_site_mail_username,
			password   = settings.cb_site_mail_password,
			port       = settings.cb_site_mail_smtp,
			useTLS     = settings.cb_site_mail_tls,
			useSSL     = settings.cb_site_mail_ssl
		);

		// generate content for email from template
		mail.setBody(
			renderer.renderLayout(
				view   = "/contentbox/email_templates/page_new",
				layout = "/contentbox/email_templates/layouts/email",
				args   = { gravatarEmail : currentAuthor.getEmail() }
			)
		);

		// send it out
		variables.mailService.send( mail );
	}

	/**
	 * Listen to when pages are removed
	 *
	 * @event  ColdBox Event
	 * @data   Intercept Data
	 * @buffer Output buffer
	 */
	function cbadmin_prePageRemove( event, data, buffer ){
		var page     = arguments.data.content;
		var site     = page.getSite();
		// Get settings
		var settings = variables.settingService.getAllSettings();

		// Only notify when enabled.
		if ( !site.getNotifyOnPages() && !settings.cb_notify_page ) {
			return;
		}

		// get current logged in author performing the action
		var currentAuthor = variables.securityService.getAuthorSession();

		// get mail payload
		var bodyTokens = {
			pageTitle       : page.getTitle(),
			pageExcerpt     : "",
			pageURL         : CBHelper.linkPage( page = page, ssl = site.getIsSSL() ),
			pageAuthor      : currentauthor.getFullName(),
			pageAuthorEmail : currentAuthor.getEmail()
		};
		if ( page.hasExcerpt() ) {
			bodyTokens.pageExcerpt = page.renderExcerpt();
		} else {
			bodyTokens.pageExcerpt = page.renderContent();
		}

		var mail = variables.mailservice.newMail(
			to         = getNotifiers( site, settings ),
			from       = settings.cb_site_outgoingEmail,
			subject    = "#site.getName()# - Page Removed - #bodyTokens.pageTitle#",
			bodyTokens = bodyTokens,
			type       = "html",
			server     = settings.cb_site_mail_server,
			username   = settings.cb_site_mail_username,
			password   = settings.cb_site_mail_password,
			port       = settings.cb_site_mail_smtp,
			useTLS     = settings.cb_site_mail_tls,
			useSSL     = settings.cb_site_mail_ssl
		);

		// generate content for email from template
		mail.setBody(
			renderer.renderLayout(
				view   = "/contentbox/email_templates/page_remove",
				layout = "/contentbox/email_templates/layouts/email",
				args   = { gravatarEmail : currentAuthor.getEmail() }
			)
		);

		// send it out
		variables.mailService.send( mail );
	}

	/**
	 * Listen to when contentstore are saved
	 *
	 * @event  ColdBox Event
	 * @data   Intercept Data
	 * @buffer Output buffer
	 */
	function cbadmin_postContentStoreSave( event, data, buffer ){
		// Only new pages are announced, not updates
		if ( NOT arguments.data.isNew ) {
			return;
		}

		var content  = arguments.data.content;
		var site     = content.getSite();
		var settings = variables.settingService.getAllSettings();

		// Only notify when enabled.
		if ( !site.getNotifyOnContentStore() && !settings.cb_notify_contentstore ) {
			return;
		}

		// get current logged in author performing the action
		var currentAuthor = variables.securityService.getAuthorSession();

		// get mail payload
		var bodyTokens = {
			contentTitle         : content.getTitle(),
			contentDescription   : content.getDescription(),
			contentAuthor        : currentauthor.getFullName(),
			contentAuthorEmail   : currentAuthor.getEmail(),
			contentIsPublished   : content.getIsPublished(),
			contentPublishedDate : content.getDisplayPublishedDate(),
			contentExpireDate    : content.getDisplayExpireDate(),
			contentURL           : arguments.event.buildLink(
				to  = "#CBHelper.adminRoot()#.contentStore.export/contentID/#content.getContentID()#",
				ssl = settings.cb_admin_ssl
			),
			contentExcerpt : content.renderContentSilent( content.getActiveContent().getContent() )
		};

		var mail = variables.mailservice.newMail(
			to         = getNotifiers( site, settings ),
			from       = settings.cb_site_outgoingEmail,
			subject    = "#site.getName()# - ContentStore Created - #bodyTokens.contentTitle#",
			bodyTokens = bodyTokens,
			type       = "html",
			server     = settings.cb_site_mail_server,
			username   = settings.cb_site_mail_username,
			password   = settings.cb_site_mail_password,
			port       = settings.cb_site_mail_smtp,
			useTLS     = settings.cb_site_mail_tls,
			useSSL     = settings.cb_site_mail_ssl
		);

		// generate content for email from template
		mail.setBody(
			renderer.renderLayout(
				view   = "/contentbox/email_templates/contentstore_new",
				layout = "/contentbox/email_templates/layouts/email",
				args   = { gravatarEmail : currentAuthor.getEmail() }
			)
		);

		// send it out
		variables.mailService.send( mail );
	}

	/**
	 * Listen to when content store objects are removed
	 *
	 * @event  ColdBox Event
	 * @data   Intercept Data
	 * @buffer Output buffer
	 */
	function cbadmin_preContentStoreRemove( event, data, buffer ){
		var content  = arguments.data.content;
		var site     = content.getSite();
		// Get settings
		var settings = variables.settingService.getAllSettings();

		// Only notify when enabled.
		if ( !site.getNotifyOnContentStore() && !settings.cb_notify_contentstore ) {
			return;
		}

		// get current logged in author performing the action
		var currentAuthor = variables.securityService.getAuthorSession();

		// get mail payload
		var bodyTokens = {
			contentTitle         : content.getTitle(),
			contentDescription   : content.getDescription(),
			contentAuthor        : currentauthor.getFullName(),
			contentAuthorEmail   : currentAuthor.getEmail(),
			contentIsPublished   : content.getIsPublished(),
			contentPublishedDate : content.getDisplayPublishedDate(),
			contentExpireDate    : content.getDisplayExpireDate(),
			contentURL           : arguments.event.buildLink(
				to  = "#CBHelper.adminRoot()#.contentStore.export/contentID/#content.getContentID()#",
				ssl = settings.cb_admin_ssl
			),
			contentExcerpt : content.renderContentSilent( content.getActiveContent().getContent() )
		};

		var mail = variables.mailservice.newMail(
			to         = getNotifiers( site, settings ),
			from       = settings.cb_site_outgoingEmail,
			subject    = "#site.getName()# - ContentStore Removed - #bodyTokens.contentTitle#",
			bodyTokens = bodyTokens,
			type       = "html",
			server     = settings.cb_site_mail_server,
			username   = settings.cb_site_mail_username,
			password   = settings.cb_site_mail_password,
			port       = settings.cb_site_mail_smtp,
			useTLS     = settings.cb_site_mail_tls,
			useSSL     = settings.cb_site_mail_ssl
		);

		// generate content for email from template
		mail.setBody(
			renderer.renderLayout(
				view   = "/contentbox/email_templates/contentstore_remove",
				layout = "/contentbox/email_templates/layouts/email",
				args   = { gravatarEmail : currentAuthor.getEmail() }
			)
		);

		// send it out
		variables.mailService.send( mail );
	}

	/**
	 * Assemble a list of the notifiers to send a notification to
	 *
	 * @site     The site the notification is from
	 * @settings The global settings
	 */
	private function getNotifiers( required site, required settings ){
		var notifiers = "";
		// Site Notifiers
		if ( arguments.site.getNotifyOnEntries() ) {
			notifiers &= arguments.site.getNotificationEmails();
		}
		// Global Notifiers
		if ( arguments.settings.cb_notify_entry ) {
			notifiers &= "," & arguments.settings.cb_site_email;
		}
		return notifiers;
	}

}
