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
* Base entity for all subclasses of Menu Items
*/
component persistent="true" entityName="cbMenuItem" table="cb_menuItem" cachename="cbMenuItem" cacheuse="read-write" discriminatorColumn="menuType" {
    // DI Injections
    property name="menuItemService" inject="menuItemService@cb" persistent="false";
    // Non-relational Properties
    property name="menuItemID" fieldtype="id" generator="native" setter="false";
    property name="title"   notnull="true"  ormtype="string" length="200" default="" index="idx_menuitemtitle";
    property name="label"   notnull="false" ormtype="string" length="200" default="";
    property name="cls"     notnull="false" ormtype="string" length="200" default="";
    property name="data"    notnull="false" ormtype="string" default="";
    property name="active"  ormtype="boolean" default="1";
    property name="menuType" insert="false" update="false";
    // M20 - Owning menu
    property name="menu" cfc="contentbox.model.menu.Menu" fieldtype="many-to-one" fkcolumn="FK_menuID" lazy="true" fetch="join" notnull="true";
    // M20 - Parent Menu item
    property name="parent"  cfc="BaseMenuItem" fieldtype="many-to-one" fkcolumn="FK_parentID" lazy="true";
    // O2M - Child Menu Item
    property name="children" singularName="child" fieldtype="one-to-many" type="array" lazy="extra" batchsize="25" cfc="BaseMenuItem" fkcolumn="FK_parentID" inverse="true" cascade="all-delete-orphan";
    
    /************************************** CONSTRUCTOR *********************************************/

    /**
    * constructor
    */
    BaseMenuItem function init(){
        return this;
    }

    /************************************** PUBLIC *********************************************/

    /**
     * Get a flat representation of this menu item
     */
    public struct function getMemento(){
        var pList = menuItemService.getPropertyNames();
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
        // add contentType
        result[ "menuType" ] = getMenuType();
        // set empty children
        result[ "children" ] = [];
        // remove parent...we'll rationalize the relationships via "children"
        structDelete( result, "parent" );
        // Children
        if( hasChild() ){
            result[ "children" ] = [];
            for( var thisChild in variables.children ){
                arrayAppend( result[ "children" ], thisChild.getMemento() );    
            }
        }
        return result;
    }

    /**
     * Get a handy, formatted string of attributes that are applicable for the current menu item
     */
    public string function getAttributesAsString() {
        var str = "";
        var title = !isNull( getTitle() ) ? getTitle() : "";
        var cls   = !isNull( getCls() ) ? getCls() : "";
        var data  = !isNull( getData() ) ? getData() : "";
        // handle title
        if( len( title ) ) {
            str &= ' title="#HTMLEditFormat( title )#"';
        }
        // handle cls
        if( len( cls ) ) {
            str &= ' class="#HTMLEditFormat( cls )#"';
        }
        // handle data
        if( len( data ) && isJSON( data ) ) {
            // deserialize so we can handle as object
            var pairs = deserializeJSON( data );
            // append all data attributes
            if( isStruct( pairs ) ) {
                for( dataKey in pairs ){
                    if( isSimplevalue( pairs[ dataKey ] ) && len( pairs[ dataKey ] ) ){
                        str &= ' data-#lcase( dataKey )#="#HTMLEditFormat( pairs[ datakey ] )#"';
                    }
                }
            }
        }
        return str;
    }

    /**
     * Available precheck to determine display-ability of menu item
     * @options.hint Additional arguments to be used in the method
     */
    public boolean function canDisplay( required struct options={} ) {
        return getActive();
    }
}