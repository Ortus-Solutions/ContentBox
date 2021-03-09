/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Comment Cleanup interceptor
 * If logged in user is an admin, this will asychronously check comment moderation expiration settings and (if applicable ) auto-delete moderated comments
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="securityService" inject="id:securityService@cb";
	property name="settingService" inject="id:settingService@cb";
	property name="siteService" inject="id:siteService@cb";
	property name="commentService" inject="id:commentService@cb";

	/**
	 * Configure
	 */
	function configure(){
	}

	/**
	 * on admin login run our moderation rules
	 * TODO: Refactor to async manager
	 */
	public void function cbadmin_onLogin( event, data ){
		// If we are not an admin, skip out
		if ( !variables.securityService.getAuthorSession().checkPermission( "CONTENTBOX_ADMIN" ) ) {
			return;
		}

		variables.siteService
			.getAll()
			.each( function( thisSite ){
				var commentExpirationDays = variables.settingService.getSiteSetting(
					thisSite.getSlug(),
					"cb_comments_moderation_expiration"
				);
				if ( commentExpirationDays > 0 ) {
					// now we have the green light to find and kill any old, moderated comments
					variables.commentService.deleteUnApproved(
						expirationDays = commentExpirationDays
					);
					// done!
					if ( log.canInfo() )
						log.info(
							"Comment moderation executed for site (#arguments.thisSite.getSlug()#) the last (#commentExpirationDays#) days!"
						);
				}
			} );
	}

}
