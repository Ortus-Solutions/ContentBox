/**
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
 * Provider for SubMenu-type menu items
 */
component implements="contentbox.model.menu.providers.IMenuItemProvider" extends="contentbox.model.menu.providers.BaseProvider" accessors=true {
    property name="menuService" inject="id:menuService@cb";
    property name="requestService"  inject="coldbox:requestService";

    /**
     * Constructor
     */
    public SubMenuProvider function init() {
        setName( "SubMenu" );
        setType( "SubMenu" );
        setIconCls( "icon-sort-by-attributes-alt" );
        setEntityName( "cbSubMenuItem" );
        setDescription( "A menu item which encapsulates another menu" );
        return this;
    }
    /**
     * Retrieves template for use in admin screens for this type of menu item provider
     * @menuItem.hint The menu item object
     * @options.hint Additional arguments to be used in the method
     */ 
    public string function getAdminTemplate( required any menuItem, required struct options={} ) {
        var rc = requestService.getContext().getCollection();
        var criteria = menuService.newCriteria();
        var existingSlug = "";
        if( structKeyExists( rc, "menuID" ) && len( rc.menuID ) ) {
            criteria.ne( "menuID", JavaCast( "int", rc.menuID ) );
        }
        if( !isNull( arguments.menuItem.getMenuSlug() ) ) {
             existingSlug = arguments.menuItem.getMenuSlug();
        }
        var menus = criteria.list( sortOrder="title ASC" );
        var viewArgs = {
            menus = menus,
            existingSlug = existingSlug
        };
        return renderer.get().renderView( 
            view="menus/providers/submenu/admin", 
            module="contentbox-admin",
            args = viewArgs
        );
    }
    /**
     * Retrieves template for use in rendering menu item on the site
     * @menuItem.hint The menu item object
     * @options.hint Additional arguments to be used in the method
     */ 
    public string function getDisplayTemplate( required any menuItem, required struct options={} ) {
        var viewArgs = {
            menuItem=arguments.menuItem,
            data = arguments.menuItem.getMemento(),
            slugCache = arguments.options.slugCache
        };
        return renderer.get().renderView( 
            view="menus/providers/submenu/display", 
            module="contentbox-admin",
            args = viewArgs
        );
    }
}