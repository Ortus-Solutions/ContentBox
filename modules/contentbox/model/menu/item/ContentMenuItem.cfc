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
* A Content-based Menu Item
*/
component persistent="true" entityName="cbContentMenuItem" table="cb_menuItem" extends="contentbox.model.menu.item.BaseMenuItem" discriminatorValue="Content" {
    // simple content
    property name="contentSlug" notnull="false" ormtype="string" default="";
    // di 
    property name="provider" persistent="false" inject="contentbox.model.menu.providers.ContentProvider";
    property name="contentService" persistent="false" inject="id:contentService@cb";

    /**
     * Get a flat representation of this menu item
     */
    public struct function getMemento(){
        var result = super.getMemento();
        // add our subclasses's properties
        result[ "contentSlug" ] = getContentSlug();
        return result;
    }

    /**
     * Available precheck to determine display-ability of menu item
     * @options.hint Additional arguments to be used in the method
     */
    public boolean function canDisplay( required struct options={} ) {
        var display = super.canDisplay( argumentCollection=arguments );
        if( display ) {
            var content = contentService.findBySlug( getContentSlug() );
            return content.isLoaded() && ( content.isPage() || content.isEntry() ) ? true : false;
        }
        return display;        
    }
}