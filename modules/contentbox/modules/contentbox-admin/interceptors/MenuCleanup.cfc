/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Menu cleanup interceptor
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="menuItemService" inject="id:menuItemService@contentbox";

	/**
	 * Configure
	 */
	function configure(){
	}

	/**
	 * Fires after the save of a page
	 * Will cleanup any slug changes for menus
	 */
	function cbadmin_postPageSave( required any event, required struct data ){
		var criteria        = menuItemService.newCriteria();
		var menuItemsInNeed = criteria.isEq( "contentSlug", "#arguments.data.originalSlug#" ).list();
		for ( var menuItem in menuItemsInNeed ) {
			menuItem.setContentSlug( arguments.data.content.getSlug() );
			menuItemService.save( entity = menuItem );
		}
	}
	/**
	 * Fires before deletion of a page
	 * Will cleanup any slug changes for menus
	 */
	function cbadmin_prePageRemove( required any event, required struct data ){
		var criteria        = menuItemService.newCriteria();
		var menuItemsInNeed = criteria.isEq( "contentSlug", "#arguments.data.content.getSlug()#" ).list();
		for ( var menuItem in menuItemsInNeed ) {
			menuItem.setContentSlug( javacast( "null", "" ) );
			menuItem.setActive( false );
			menuItemService.save( entity = menuItem );
		}
	}
	/**
	 * Fires after the save of an entry
	 * Will cleanup any slug changes for menus
	 */
	function cbadmin_postEntrySave( required any event, required struct data ){
		var criteria        = menuItemService.newCriteria();
		var menuItemsInNeed = criteria.isEq( "contentSlug", "#arguments.data.originalSlug#" ).list();
		for ( var menuItem in menuItemsInNeed ) {
			menuItem.setContentSlug( arguments.data.content.getSlug() );
			menuItemService.save( entity = menuItem );
		}
	}
	/**
	 * Fires before deletion of an entry
	 * Will cleanup any slug changes for menus
	 */
	function cbadmin_preEntryRemove( required any event, required struct data ){
		var criteria        = menuItemService.newCriteria();
		var menuItemsInNeed = criteria.isEq( "contentSlug", "#arguments.data.content.getSlug()#" ).list();
		for ( var menuItem in menuItemsInNeed ) {
			menuItem.setContentSlug( javacast( "null", "" ) );
			menuItem.setActive( false );
			menuItemService.save( entity = menuItem );
		}
	}
	/**
	 * Fires after the save of a menu
	 * Will cleanup any slug changes for child menus
	 */
	function cbadmin_postMenuSave( required any event, required struct data ){
		// Update all affected menuitems if any on slug updates
		var criteria  = menuItemService.newCriteria();
		var menuItems = criteria.isEq( "menuSlug", "#arguments.data.originalSlug#" ).list();
		for ( var item in menuItems ) {
			item.setMenuSlug( arguments.data.menu.getSlug() );
			menuItemService.save( entity = item );
		}
	}
	/**
	 * Fires before deletion of a menu
	 * Will cleanup any slug changes for menus
	 */
	function cbadmin_preMenuRemove( required any event, required struct data ){
		var criteria        = menuItemService.newCriteria();
		var menuItemsInNeed = criteria.isEq( "menuSlug", "#arguments.data.menu.getSlug()#" ).list();
		for ( var menuItem in menuItemsInNeed ) {
			menuItem.setMenuSlug( javacast( "null", "" ) );
			menuItem.setActive( false );
			menuItemService.save( entity = menuItem );
		}
	}
	/**
	 * Fires after the rename of a media item
	 * Will cleanup any name changes for menus
	 */
	function fb_postFileRename( required any event, required struct data ){
		var rc = event.getCollection();
		// make sure we have settings
		if ( structKeyExists( rc, "filebrowser" ) ) {
			var settings    = rc.filebrowser.settings;
			// old path is full path from directoryRoot up...so strip that out
			var oldFileName = replaceNoCase(
				arguments.data.original,
				settings.directoryRoot,
				"",
				"all"
			);
			// match with mediaPath and leftover name
			var matcher   = settings.mediaPath & oldFileName;
			// Update all affected menuitems if any on slug updates
			var criteria  = menuItemService.newCriteria();
			var menuItems = criteria.isEq( "mediaPath", "#matcher#" ).list();
			for ( var item in menuItems ) {
				item.setMediaPath( settings.mediaPath & "/" & arguments.data.newName );
				menuItemService.save( entity = item );
			}
		}
	}
	/**
	 * Fires before deletion of a file
	 */
	function fb_preFileRemoval( required any event, required struct data ){
		var criteria        = menuItemService.newCriteria();
		var menuItemsInNeed = criteria.isEq( "mediaPath", "#arguments.data.path#" ).list();
		for ( var menuItem in menuItemsInNeed ) {
			menuItem.setMediaPath( javacast( "null", "" ) );
			menuItem.setActive( false );
			menuItemService.save( entity = menuItem );
		}
	}

}
