/**
* This simulates the onRequest start for the admin interface
*/
component extends="coldbox.system.Interceptor"{

    // DI
    property name="securityService" inject="id:securityService@cb";
    property name="settingService" inject="id:settingService@cb";
    property name="commentService" inject="id:commentService@cb";

    /**
    * Configure
    */
    function configure(){}

    /**
     * If logged in user is an admin, this will asychronously check comment moderation expiration settings and (if applicable ) auto-delete moderated comments
     */
    public void function cbadmin_onLogin( required any event ) {
        thread name="cleancomments_#CreateUUID()#" securityService=securityService, settingService=settingService, commentService=commentService {
            var Author = attributes.securityService.getAuthorSession();
            var isContentBoxAdmin = Author.checkPermission( "CONTENTBOX_ADMIN" );
            // if an admin, continue...
            if( isContentBoxAdmin ) {
                var commentExpiration = attributes.settingService.getSetting( "cb_comments_moderation_expiration" );
                // if more than 0
                if( commentExpiration ) {
                    // now we have the green light to find and kill any old, moderated comments
                    attributes.commentService.deleteUnApprovedComments( expirationDays=commentExpiration );
                    // done!
                }
            }
        }
    }
}