/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License" );
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
* Service to handle menu items.
*/
component extends="cborm.models.VirtualEntityService" accessors="true" singleton{  
    
    // DI
    property name="wirebox" inject="wirebox";
    
    /**
    * The providers struct holder
    */
    property name="providers" type="struct";  

    /**
    * Constructor
    */
    MenuItemService function init(){
        // init it
        super.init( entityName="cbMenuItem" );
        variables.providers = {};

        return this;
    }

    /**
    * Runs after constructor to complete DI
    */
    function onDIComplete(){
        registerProvider( type="URL",       providerPath="contentbox.models.menu.providers.URLProvider" );
        registerProvider( type="Content",   providerPath="contentbox.models.menu.providers.ContentProvider" );
        registerProvider( type="JS",        providerPath="contentbox.models.menu.providers.JSProvider" );
        registerProvider( type="Media",     providerPath="contentbox.models.menu.providers.MediaProvider" );
        registerProvider( type="SubMenu",   providerPath="contentbox.models.menu.providers.SubMenuProvider" );
        registerProvider( type="Free",      providerPath="contentbox.models.menu.providers.FreeProvider" );
    }

    /**
     * Registers a provider with the service
     * @type.hint The type of provider
     * @providerPath.hint Logical path for getting instance of provider
     */
    public MenuItemService function registerProvider( required string type, required string providerPath ) {
        variables.providers[ arguments.type ] = wirebox.getInstance( arguments.providerPath );
        return this;
    }

    /**
     * Unregisters a provider with the service
     * @type.hint The type of provider
     */
    public MenuItemService function unRegisterProvider( required string type ) {
        structDelete( variables.providers, arguments.type );
        return this;
    }

    /**
     * Retrieves a registered provider
     * @type.hint The type of provider
     */
    public any function getProvider( required string type ) {
        return variables.providers[ arguments.type ];
    }

}