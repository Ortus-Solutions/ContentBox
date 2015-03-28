/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
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
* Core Menu Entity
*/
component persistent="true" entityName="cbMenu" table="cb_menu" cachename="cbMenu" cacheuse="read-write" {
    
    // DI Injections
    property name="menuService"     inject="menuService@cb"             persistent="false";
    property name="menuItemService" inject="menuItemService@cb"         persistent="false";
    property name="ORMService"      inject="coldbox:plugin:ORMService"  persistent="false";
    
    // Non-relational Properties
    property name="menuID"
             fieldtype="id"
             generator="native"
             setter="false";

    property name="title"
             notnull="true"
             ormtype="string"
             length="200"
             default=""
             index="idx_menutitle";

    property name="slug"
             notnull="true"
             ormtype="string"
             length="200"
             default=""
             unique="true"
             index="idx_menuslug";

    property name="menuClass"
             ormtype="string"
             length="160"
             default="";

    property name="listClass"
             ormtype="string"
             length="160"
             default="";

    property name="listType"
             ormtype="string"
             length="20"
             default="ul";

    property name="createdDate"
             ormtype="timestamp"
             notnull="true"
             update="false";
    
    // O2M -> Comments
    property name="menuItems"
             singularName="menuItem"
             fieldtype="one-to-many"
             type="array"
             cfc="contentbox.model.menu.item.BaseMenuItem"
             fkcolumn="FK_menuID"
             cascade="all-delete-orphan" 
             inverse="true" 
             lazy="extra"; 

    /************************************** CONSTRUCTOR *********************************************/

    /**
    * constructor
    */
    Menu function init(){
        variables.listType      = "ul";
        variables.menuItems     = [];

        return this;
    }

    /************************************** PUBLIC *********************************************/
    
    /**
    * @Override due to bi-directional relationships 
    */
    Menu function addMenuItem( required menuItem ){
        // add them to the local array
        arrayAppend( variables.menuItems, arguments.menuItem );
        // set the bi-directional relation
        arguments.menuItem.setMenu( this );
        return this;
    }

    /**
    * @Override due to bi-directional relationships
    */
    Menu function setMenuItems( required array menuItems ){
        if( hasMenuItem() ){
            // manual remove, so hibernate can clear the existing relationships
            variables.menuItems.clear();
            // Add the incoming ones to the same array
            variables.menuItems.addAll( arguments.menuItems );
        } else {
            variables.menuItems = arguments.menuItems;
        }
        return this;
    }

    /*
     * In built event handler method, which is called if you set ormsettings.eventhandler = true in Application.cfc
     */
    public void function preInsert(){
        variables.createdDate = now();
    }

    /**
    * is loaded?
    */
    public boolean function isLoaded(){
        return ( len( getMenuID() ) ? true : false );
    }

    /**
     * Creates menu items from raw data object
     * @rawData.hint The raw data from which to create menu items
     */
    public Menu function populateMenuItems( required array rawData ) {
        var items = createMenuItems( arguments.rawData );
        for( var item in items ) {
            addMenuItem( item );
        }
        return this;
    }
    
    /**
     * Retrieves root menu items (only items with no parents)
     */
    public array function getRootMenuItems() {
        var items = [];
        if( hasMenuItem() ) {
            for( var item in getMenuItems() ) {
                if( !item.hasParent() ) {
                    arrayAppend( items, item );
                }
            }
        }
        return items;
    }

    /**
     * Get a flat representation of this menu
     * slugCache.hint Cache of slugs to prevent infinite recursions
     */
    public struct function getMemento(){
        var pList = menuService.getPropertyNames();
        var result = {};
        
        // Do simple properties only
        for( var x=1; x lte arrayLen( pList ); x++ ){
            if( structKeyExists( variables, pList[ x ] ) ){
                if( isSimpleValue( variables[ pList[ x ] ] ) ){
                    result[ pList[ x ] ] = variables[ pList[ x ] ]; 
                }
            }
            else{
                result[ pList[ x ] ] = "";
            }
        }
        // menu items
        if( hasMenuItem() ){
            result[ "menuItems" ] = [];
            for( var thisMenuItem in variables.menuItems ){
                // only export top-level items (items themselves will take care of children)
                if( !( thisMenuItem.hasParent() ) ) {
                    arrayAppend( result[ "menuItems" ], thisMenuItem.getMemento() );
                }                  
            }
        }
        else{
            result[ "menuItems" ] = [];
        }
        return result;
    }

    /************************************** PRIVATE *********************************************/

    /**
    * Recusive function to build menu items hierarchy from raw data
    * @rawData.hint The raw data definitions for the menu items
    */
    private array function createMenuItems( required array rawData ) {
        var items = [];
        // loop over rawData and create items :)
        for( var data in arguments.rawData ) {
            var provider = menuItemService.getProvider( data.menuType );
            var entity   = ORMService.get( entityName=provider.getEntityName(), id=0 );
            var newItem  = menuItemService.populate( target=entity, memento=data, exclude="children" );
                newItem.setMenu( this );
                newItem.setActive( true );
            
            // populate the children
            if( structKeyExists( data, "children" ) && isArray( data.children ) ) {
                var children = createMenuItems( data.children );
                var setter = [];
                for( var child in children ) {
                    child.setParent( newItem );
                    arrayAppend( setter, child );
                }
                newItem.setChildren( setter );
            }
            // add to menu
            arrayAppend( items, newItem );
        }
        return items;
    }
}