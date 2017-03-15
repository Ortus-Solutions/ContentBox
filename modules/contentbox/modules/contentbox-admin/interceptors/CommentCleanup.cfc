/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Comment Cleanup interceptor
* If logged in user is an admin, this will asychronously check comment moderation expiration settings and (if applicable ) auto-delete moderated comments
*/
component extends="coldbox.system.Interceptor"{

    // DI
    property name="securityService" inject="id:securityService@cb";
    property name="settingService"  inject="id:settingService@cb";
    property name="commentService"  inject="id:commentService@cb";

    /**
    * Configure
    */
    function configure(){}

    /**
     * on admin login
     */
    public void function cbadmin_onLogin( event, interceptData ) async="true" {
        var author 				= securityService.getAuthorSession();
        var isContentBoxAdmin 	= author.checkPermission( "CONTENTBOX_ADMIN" );
        // if an admin, continue...
        if( isContentBoxAdmin ) {
            var commentExpiration = settingService.getSetting( "cb_comments_moderation_expiration" );
            // if more than 0
            if( commentExpiration ) {
                // now we have the green light to find and kill any old, moderated comments
                commentService.deleteUnApprovedComments( expirationDays=commentExpiration );
                // done!
                if( log.canInfo() )
                    log.info( "Comment moderation executed for the last (#commentExpiration#) days!" );
            }
        }
    }
}