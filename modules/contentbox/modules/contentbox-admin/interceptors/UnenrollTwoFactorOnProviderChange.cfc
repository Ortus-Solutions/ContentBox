/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Unenroll users from two-factor authentication on provider change
*/
component extends="coldbox.system.Interceptor"{

    /**
    * Configure
    */
    function configure(){}

    /**
     * Fires after the save of a page
     * Will cleanup any slug changes for menus
     */
    public void function cbadmin_preSettingsSave( required any event, required struct interceptData ) {
        if ( interceptData.oldSettings.cb_security_2factorAuth_provider != interceptData.newSettings.cb_security_2factorAuth_provider ) {
            queryExecute( "UPDATE cb_author SET is2FactorAuth = 0" );
        }
    }

}
