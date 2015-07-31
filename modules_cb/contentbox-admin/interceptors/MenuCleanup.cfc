/**
* Comment Cleanup interceptor
*/
component extends="coldbox.system.Interceptor"{
    // DI
    property name="menuItemService" inject="id:menuItemService@cb";

    /**
    * Configure
    */
    function configure(){}

    /**
     * Fires after the save of a page
     * Will cleanup any slug changes for menus
     */
    public void function cbadmin_postPageSave( required any event, required struct interceptData ) async="true" {
        var criteria = menuItemService.newCriteria();
        var menuItemsInNeed = criteria.eq( "contentSlug", "#arguments.interceptData.originalSlug#" ).list();
        for( var menuItem in menuItemsInNeed ){
            menuItem.setContentSlug( arguments.interceptData.page.getSlug() );
            menuItemService.save( entity=menuItem );
        }
    }
    /**
     * Fires before deletion of a page
     * Will cleanup any slug changes for menus
     */
    public void function cbadmin_prePageRemove( required any event, required struct interceptData ) {
        var criteria = menuItemService.newCriteria();
        var menuItemsInNeed = criteria.eq( "contentSlug", "#arguments.interceptData.page.getSlug()#" ).list();
        for( var menuItem in menuItemsInNeed ){
            menuItem.setContentSlug( JavaCast( "null", "" ) );
            menuItem.setActive( false );
            menuItemService.save( entity=menuItem );
        }
    }
    /**
     * Fires after the save of an entry
     * Will cleanup any slug changes for menus
     */
    public void function cbadmin_postEntrySave( required any event, required struct interceptData ) async="true" {
        var criteria = menuItemService.newCriteria();
        var menuItemsInNeed = criteria.eq( "contentSlug", "#arguments.interceptData.originalSlug#" ).list();
        for( var menuItem in menuItemsInNeed ){
            menuItem.setContentSlug( arguments.interceptData.entry.getSlug() );
            menuItemService.save( entity=menuItem );
        }
    }
    /**
     * Fires before deletion of an entry
     * Will cleanup any slug changes for menus
     */
    public void function cbadmin_preEntryRemove( required any event, required struct interceptData ) {
        var criteria = menuItemService.newCriteria();
        var menuItemsInNeed = criteria.eq( "contentSlug", "#arguments.interceptData.entry.getSlug()#" ).list();
        for( var menuItem in menuItemsInNeed ){
            menuItem.setContentSlug( JavaCast( "null", "" ) );
            menuItem.setActive( false );
            menuItemService.save( entity=menuItem );
        }
    }
    /**
     * Fires after the save of a menu
     * Will cleanup any slug changes for child menus
     */
    public void function cbadmin_postMenuSave( required any event, required struct interceptData ) async="true" {
        // Update all affected menuitems if any on slug updates
        var criteria = menuItemService.newCriteria();
        var menuItems = criteria.eq( "menuSlug", "#arguments.interceptData.originalSlug#" ).list();
        for( var item in menuItems ){
            item.setMenuSlug( arguments.interceptData.menu.getSlug() );
            menuItemService.save( entity=item  );
        }
    }
    /**
     * Fires before deletion of a menu
     * Will cleanup any slug changes for menus
     */
    public void function cbadmin_preMenuRemove( required any event, required struct interceptData ) {
        var criteria = menuItemService.newCriteria();
        var menuItemsInNeed = criteria.eq( "menuSlug", "#arguments.interceptData.menu.getSlug()#" ).list();
        for( var menuItem in menuItemsInNeed ){
            menuItem.setMenuSlug( JavaCast( "null", "" ) );
            menuItem.setActive( false );
            menuItemService.save( entity=menuItem );
        }
    }
    /**
     * Fires after the rename of a media item
     * Will cleanup any name changes for menus
     */
    public void function fb_postFileRename( required any event, required struct interceptData ) async="true" {
        var rc = event.getCollection();
        // make sure we have settings
        if( structKeyExists( rc, "filebrowser" ) ) {
            var settings = rc.filebrowser.settings;
            // old path is full path from directoryRoot up...so strip that out
            var oldFileName = replaceNoCase( arguments.interceptData.original, settings.directoryRoot, '', 'all' );
            // match with mediaPath and leftover name
            var matcher = settings.mediaPath & oldFileName;
            // Update all affected menuitems if any on slug updates
            var criteria = menuItemService.newCriteria();
            var menuItems = criteria.eq( "mediaPath", "#matcher#" ).list();
            for( var item in menuItems ){
                item.setMediaPath( settings.mediaPath & "/" & arguments.interceptData.newName );
                menuItemService.save( entity=item  );
            }
        }
    }
    /**
     * Fires before deletion of a file
     */
    public void function fb_preFileRemoval( required any event, required struct interceptData ) async="true" {
        var criteria = menuItemService.newCriteria();
        var menuItemsInNeed = criteria.eq( "mediaPath", "#arguments.interceptData.path#" ).list();
        for( var menuItem in menuItemsInNeed ){
            menuItem.setMediaPath( JavaCast( "null", "" ) );
            menuItem.setActive( false );
            menuItemService.save( entity=menuItem );
        }
    }    
}