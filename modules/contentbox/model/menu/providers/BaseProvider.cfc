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
 * Base Provider
 */
component accessors=true {
    property name="name" type="string";
    property name="entityName" type="string";
    property name="type" type="string";
    property name="iconCls" type="string";
    property name="description" type="string";
    property name="renderer" inject="provider:ColdBoxRenderer";

    /**
     * Gets the name of the menu item provider
     */
    public string function getName() {
        return name;
    }

    /**
     * Gets the entityName for the menu item provider
     */
    public string function getEntityName() {
        return entityName;
    }

    /**
     * Gets the name of the menu item provider
     */
    public string function getType() {
        return type;
    }

    /**
     * Gets the iconCls of the menu item provider
     */
    public string function getIconCls() {
        return iconCls;
    }

    /**
     * Gets the description of the menu item provider
     */
    public string function getDescription() {
        return description;
    }
}