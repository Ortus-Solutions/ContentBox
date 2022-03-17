/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Service to handle comment operations.
 */
component extends="cborm.models.VirtualEntityService" singleton {

	// DI
	property name="mailService" inject="mailService@cbmailservices";
	property name="renderer" inject="coldbox:renderer";
	property name="settingService" inject="id:settingService@contentbox";
	property name="securityService" inject="id:securityService@contentbox";
	property name="CBHelper" inject="id:CBHelper@contentbox";
	property name="log" inject="logbox:logger:{this}";
	property name="interceptorService" inject="coldbox:interceptorService";
	property name="loginTrackerService" inject="loginTrackerService@contentbox";

	/**
	 * Constructor
	 */
	CommentService function init(){
		super.init( entityName = "cbComment", useQueryCaching = "true" );
		return this;
	}

	/**
	 * Get the total comment counts by content object
	 *
	 * @contentId  The content id to filter on
	 * @isApproved If passed, use it to filter on
	 */
	numeric function getTotalCountByContent( string contentId = "", boolean isApproved ){
		return newCriteria()
			.isEq( "relatedContent.contentID", arguments.contentId )
			.when( !isNull( arguments.isApproved ), function( c ){
				c.isEq( "isApproved", javacast( "Boolean", isApproved ) );
			} )
			.count();
	}

	/**
	 * Get the total comment counts in the system
	 *
	 * @siteID The site to filter on
	 */
	numeric function getTotalCount( string siteID = "" ){
		return newCriteria()
			.when( len( arguments.siteID ), function( c ){
				c.joinTo( "relatedContent", "relatedContent" ).isEq( "relatedContent.site.siteID", siteID );
			} )
			.count();
	}

	/**
	 * Get the total number of approved comments in the system
	 *
	 * @siteID The site to filter on
	 */
	numeric function getApprovedCount( string siteID = "" ){
		return newCriteria()
			.isTrue( "isApproved" )
			.when( len( arguments.siteID ), function( c ){
				c.joinTo( "relatedContent", "relatedContent" ).isEq( "relatedContent.site.siteID", siteID );
			} )
			.count();
	}

	/**
	 * Get the total number of unapproved comments in the system
	 *
	 * @siteID The site to filter on
	 */
	numeric function getUnApprovedCount( string siteID = "" ){
		return newCriteria()
			.isFalse( "isApproved" )
			.when( len( arguments.siteID ), function( c ){
				c.joinTo( "relatedContent", "relatedContent" ).isEq( "relatedContent.site.siteID", siteID );
			} )
			.count();
	}

	/**
	 * Comment listing for UI of approved comments, returns struct of results=[comments,count]
	 *
	 * @contentID   The content ID to filter on
	 * @contentType The content type discriminator to filter on
	 * @max         The maximum number of records to return, 0 means all
	 * @offset      The offset in the paging, 0 means 0
	 * @sortOrder   Sort the comments asc or desc, by default it is desc
	 * @siteID      The site to filter on if needed
	 *
	 * @return struct with { comments, count }
	 */
	struct function findAllApproved(
		contentID,
		contentType,
		max              = 0,
		offset           = 0,
		string sortOrder = "desc",
		string siteID    = ""
	){
		var results = { "count" : 0, "comments" : [] };
		var c       = newCriteria()
			// only approved comments
			.isTrue( "isApproved" )
			// By Content?
			.when( !isNull( arguments.contentID ) AND len( arguments.contentID ), function( c ){
				c.isEq( "relatedContent.contentID", contentID );
			} )
			// By Content Type Discriminator: class is a special hibernate deal
			.when( !isNull( arguments.contentType ) AND len( arguments.contentType ), function( c ){
				c.createCriteria( "relatedContent" ).isEq( "class", contentType );
			} )
			// Site Filter
			.when( len( arguments.siteID ), function( c ){
				c.joinTo( "relatedContent", "relatedContent" ).isEq( "relatedContent.site.siteID", siteID );
			} );

		// run criteria query and projections count
		results.count    = c.count();
		results.comments = c.list(
			offset   : arguments.offset,
			max      : arguments.max,
			sortOrder: "createdDate #arguments.sortOrder#",
			asQuery  : false
		);

		return results;
	}

	/**
	 * Deletes unapproved comments
	 *
	 * @expirationDays Required level of staleness in days to delete (0=all unapproved)
	 */
	CommentService function deleteUnApproved( numeric expirationDays = 0 ){
		var hqlQuery = "from cbComment where isApproved = :approved";
		var params   = { "approved" : false };

		// if we have an expirationDays setting greater than 0, add it to query for our date filter
		if ( arguments.expirationDays ) {
			var expirationDate = dateAdd( "d", -arguments.expirationDays, now() );
			hqlQuery &= " and createdDate < :expiration";
			params[ "expiration" ] = expirationDate;
		}
		// run the delete
		deleteByQuery( query = hqlQuery, params = params );

		return this;
	}

	/**
	 * Save a comment according to our rules and process it. Returns a structure of information
	 * results = [moderated:boolean,messages:array]
	 *
	 * @comment      The comment to try to save
	 * @loggedInUser The current logged in user making the comment. If no logged in User, this is a non-persisted entity
	 * @result       Return a struct of : { moderated:boolean, messages : array }
	 */
	struct function saveComment( required comment, required loggedInUser ){
		transaction {
			// Comment reference
			var inComment    = arguments.comment;
			// get site settings
			var siteSettings = variables.settingService.getAllSiteSettings(
				siteSlug: inComment.getRelatedContent().getSiteSlug()
			);
			// results
			var results = { "moderated" : true, "messages" : [] };

			// Log the IP Address
			inComment.setAuthorIP( variables.securityService.getRealIP() );
			// Default moderation unless user is logged in
			inComment.setIsApproved( arguments.loggedInUser.isLoggedIn() ? true : false );

			// Run moderation rules if not logged in.
			if (
				arguments.loggedInUser.isLoggedIn()
				OR
				runModerationRules( comment = inComment, settings = siteSettings )
			) {
				// send for saving, finally phew!
				save( inComment );
				// Send Notification or Moderation Email? TODO: Async this
				sendNotificationEmails( inComment, siteSettings );
				// Return results
				if ( inComment.getIsApproved() ) {
					results.moderated = false;
				} else {
					arrayAppend(
						results.messages,
						"Comment was moderated! Please wait for the system administrator to approve it."
					);
				}
			} else {
				// Messages
				arrayAppend( results.messages, "Geez! Comment was blocked!" );
				// discard it from session
				evictEntity( inComment );
				// log it
				if ( log.canWarn() ) {
					log.warn( "Incoming comment was blocked!", inComment.getMemento() );
				}
			}
		}

		return results;
	}

	/**
	 * Sends subscription emails to subscribers of the content
	 *
	 * @comment The comment object
	 */
	public void function sendSubscriptionNotifications( required any comment ){
		var content            = arguments.comment.getRelatedContent();
		// get subscribers for this content item
		var subscriptions      = content.getCommentSubscriptions();
		var settings           = variables.settingService.getAllSettings();
		var commentAuthorEmail = arguments.comment.getAuthorEmail();

		// get body tokens; can reuse most for all emails
		var bodyTokens               = arguments.comment.getMemento();
		bodyTokens[ "contentURL" ]   = CBHelper.linkContent( content );
		bodyTokens[ "contentTitle" ] = arguments.comment.getParentTitle();

		// loop over subscribers
		for ( var subscription in subscriptions ) {
			var subscriber = subscription.getSubscriber();

			// don't send email if the comment author is also subscribed...
			if ( subscriber.getSubscriberEmail() != commentAuthorEmail ) {
				// get mail payload
				bodyTokens[ "unsubscribeURL" ] = CBHelper.linkContentUnsubscribe( subscription.getSubscriptionToken() );

				// Send it baby!
				var mail = variables.mailService.newMail(
					to         = subscriber.getSubscriberEmail(),
					from       = settings.cb_site_outgoingEmail,
					subject    = "New comment was added",
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
					variables.renderer.renderLayout(
						view   = "/contentbox/email_templates/comment_notification",
						layout = "/contentbox/email_templates/layouts/email",
						args   = { gravatarEmail : commentAuthorEmail }
					)
				);

				// send it out
				variables.mailService.send( mail );
			}
		}
	}

	/**
	 * Run moderation rules on an incoming comment and set of contentbox settings. If this method returns a false then the comment is moderated
	 * and can continue to be saved. If returns false, then it is blocked and must NOT be saved.
	 *
	 * @comment  Comment to moderate check
	 * @settings The contentbox settings to moderate against
	 */
	private boolean function runModerationRules( required comment, required settings ){
		// Comment reference
		var inComment  = arguments.comment;
		var inSettings = arguments.settings;
		var allowSave  = true;

		// Not moderation, just approve and return
		if ( NOT settings.cb_comments_moderation ) {
			inComment.setIsApproved( true );
			return true;
		}

		// Check if user has already an approved comment. If they do, then approve them
		if (
			inSettings.cb_comments_moderation_whitelist AND userHasPreviousAcceptedComment(
				inComment.getAuthorEmail()
			)
		) {
			inComment.setIsApproved( true );
			return true;
		}

		// Execute moderation queries
		if (
			len( inSettings.cb_comments_moderation_blacklist ) AND anyKeywordMatch(
				inComment,
				inSettings.cb_comments_moderation_blacklist
			)
		) {
			inComment.setIsApproved( false );
			allowSave = true;
		}

		// Execute blocking queries
		if (
			len( inSettings.cb_comments_moderation_blockedlist ) AND anyKeywordMatch(
				inComment,
				inSettings.cb_comments_moderation_blockedlist
			)
		) {
			inComment.setIsApproved( false );
			allowSave = false;
		}

		// announce it.
		var iData = {
			comment   : arguments.comment,
			settings  : arguments.settings,
			allowSave : allowSave
		};
		interceptorService.announce( "cbui_onCommentModerationRules", iData );

		// return if allowed save or block
		return iData.allowSave;
	}

	/**
	 * Regex matching of a list of entries against a comment and matching keyword list
	 */
	private boolean function anyKeywordMatch( comment, matchList ){
		var inComment = arguments.comment;
		var del       = chr( 13 ) & chr( 10 );
		var inList    = listToArray( arguments.matchList, del );

		for ( var x = 1; x lte arrayLen( inList ); x++ ) {
			// Verify each keword via regex
			if (
				reFindNoCase( inList[ x ], inComment.getContent() ) OR
				reFindNoCase( inList[ x ], inComment.getAuthor() ) OR
				reFindNoCase( inList[ x ], inComment.getAuthorIP() )
			) {
				return true;
			}
		}

		return false;
	}

	/**
	 * Check if the user has already a comment in the system
	 *
	 * @email The email address to check.
	 */
	private boolean function userHasPreviousAcceptedComment( required email ){
		var args = { "authorEmail" : arguments.email, "isApproved" : true };
		return ( countWhere( argumentCollection = args ) GT 0 );
	}

	/**
	 * Send a notification email for comments
	 *
	 * @comment      Comment to moderate check
	 * @siteSettings The contentbox site settings to moderate against
	 */
	private void function sendNotificationEmails( required comment, required siteSettings ){
		// Comment reference
		var inComment = arguments.comment;
		var settings  = variables.settingService.getAllSettings();
		var site      = inComment.getRelatedContent().getSite();
		var outEmails = settings.cb_site_email;
		var subject   = "";
		var template  = "";

		// Verify if we have active notifications, else just quit notification process
		if ( !arguments.siteSettings.cb_comments_notify ) {
			return;
		}

		// More notification emails?

		if ( len( arguments.siteSettings.cb_comments_notifyemails ) ) {
			outEmails &= "," & arguments.siteSettings.cb_comments_notifyemails;
		}

		// get mail payload
		var bodyTokens             = inComment.getMemento();
		bodyTokens[ "whoisURL" ]   = settings.cb_comments_whoisURL;
		bodyTokens[ "commentURL" ] = CBHelper.linkComment( comment = inComment, ssl = site.getIsSSL() );
		bodyTokens[ "deleteURL" ]  = CBHelper.linkAdmin( event = "comments.moderate", ssl = settings.cb_admin_ssl ) & "?commentID=#inComment.getCommentID()#";
		bodyTokens[ "approveURL" ] = CBHelper.linkAdmin( event = "comments.moderate", ssl = settings.cb_admin_ssl ) & "?commentID=#inComment.getCommentID()#";
		bodyTokens[ "contentURL" ] = CBHelper.linkContent(
			content = inComment.getRelatedContent(),
			ssl     = site.getIsSSL()
		);
		bodyTokens[ "contentTitle" ] = inComment.getParentTitle();

		// Moderation Email? Comment is moderated?
		if ( inComment.getIsApproved() eq false AND arguments.siteSettings.cb_comments_moderation_notify ) {
			subject  = "New comment needs moderation on post: #bodyTokens.contentTitle#";
			template = "comment_moderation";
		} else {
			// Else, new comment notification
			subject  = "New comment on post: #bodyTokens.contentTitle#";
			template = "comment_new";
		}

		// Send it baby!
		var mail = variables.mailservice.newMail(
			to         = outEmails,
			from       = settings.cb_site_outgoingEmail,
			subject    = subject,
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
				view   = "/contentbox/email_templates/#template#",
				layout = "/contentbox/email_templates/layouts/email",
				args   = { gravatarEmail : inComment.getAuthorEmail() }
			)
		);

		// send it out
		variables.mailService.send( mail );
	}

	/**
	 * comment search returns struct with keys [comments,count]
	 *
	 * @search     Search query
	 * @isApproved approved bit
	 * @contentID  matching content id
	 * @max        max records
	 * @offset     offset for pagination
	 * @sortOrder  The sort order, defaults to `createdDate DESC`
	 * @siteID     The site to filter on if needed
	 *
	 * @return struct with { comments, count }
	 */
	struct function search(
		search = "",
		isApproved,
		contentID,
		numeric max    = 0,
		numeric offset = 0,
		sortOrder      = "createdDate DESC",
		string siteID  = ""
	){
		var results = { "count" : 0, "comments" : [] };
		var c       = newCriteria();

		// isApproved filter
		if ( !isNull( arguments.isApproved ) AND arguments.isApproved NEQ "any" ) {
			c.isEq( "isApproved", javacast( "boolean", arguments.isApproved ) );
		}

		// Content Filter
		if ( !isNull( arguments.contentID ) AND arguments.contentID NEQ "all" ) {
			c.isEq( "relatedContent.contentID", arguments.contentID );
		}

		// Search Criteria
		if ( len( arguments.search ) ) {
			// OR disjunction on author, authorEmail and content.
			c.$or(
				c.restrictions.like( "author", "%#arguments.search#%" ),
				c.restrictions.like( "authorEmail", "%#arguments.search#%" ),
				c.restrictions.like( "content", "%#arguments.search#%" )
			);
		}

		// Site Filter
		if ( len( arguments.siteID ) ) {
			c.joinTo( "relatedContent", "relatedContent" ).isEq( "relatedContent.site.siteID", arguments.siteID );
		}

		// run criteria query and projections count
		results.count    = c.count();
		results.comments = c.list(
			offset    = arguments.offset,
			max       = arguments.max,
			sortOrder = arguments.sortOrder,
			asQuery   = false
		);

		return results;
	}

	/**
	 * Bulk Updates
	 *
	 * @commentID The list or array of ID's to bulk update
	 * @status    The status either 'approve' or 'moderate'
	 *
	 * @return CommentService
	 */
	any function bulkStatus( any commentID, status = "" ){
		var approve = false;

		// approve flag
		if ( arguments.status eq "approve" ) {
			approve = true;
		}

		// Get all by id
		var comments = getAll( id = arguments.commentID ).map( function( thisComment ){
			thisComment.setIsApproved( approve );
			return thisComment;
		} );

		// transaction the save of all the comments
		saveAll( comments );

		return this;
	}

}
