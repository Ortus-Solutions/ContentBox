/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Unenroll users from two-factor authentication on provider change
*/
component extends="coldbox.system.Interceptor"{

    property name="twoFactorService" inject="id:TwoFactorService@cb";
    property name="securityService"  inject="id:securityService@cb";

    variables.allowedEvents = [
        "contentbox-security:security.changeLang",
        "contentbox-security:security.login",
        "contentbox-security:security.doLogin",
        "contentbox-security:security.doLogout",
        "contentbox-security:security.lostPassword",
        "contentbox-security:security.doLostPassword",
        "contentbox-security:security.verifyReset",
        "contentbox-security:security.doPasswordChange",
        "contentbox-admin:authors.forceTwoFactorEnrollment",
        "contentbox-admin:authors.enrollTwofactor",
        "contentbox-admin:authors.forceTwoFactorEnrollment",
        "contentbox-admin:authors.doTwoFactorEnrollment"
    ];


    /**
    * Configure
    */
    function configure(){}

    /**
     *
     */
    public void function preProcess( required any event, required struct interceptData, buffer, rc, prc ) {
        param prc.oCurrentAuthor = securityService.getAuthorSession();
        param prc.cbAdminEntryPoint = getModuleConfig( "contentbox-admin" ).entryPoint;

        if ( ! event.privateValueExists( "oCurrentAuthor" ) ) {
            return;
        }

        if ( ! prc.oCurrentAuthor.getLoggedIn() ) {
            return;
        }

        if ( ! twoFactorService.isForceTwoFactorAuth() ) {
            return;
        }

        if ( prc.oCurrentAuthor.getIs2FactorAuth() ) {
            return;
        }

        if ( arrayContains( allowedEvents, rc.event ) ) {
            return;
        }

        setNextEvent( "#prc.cbAdminEntryPoint#.authors.forceTwoFactorEnrollment" );
    }

}
