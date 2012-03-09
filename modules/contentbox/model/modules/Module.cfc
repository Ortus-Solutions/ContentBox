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
* I am a ContentBox Module
*/
component persistent="true" entityname="cbModule" table="cb_module" cachename="cbModule" cacheuse="read-write" {

	// PROPERTIES
	property name="moduleID" fieldtype="id" generator="native" setter="false";
	property name="name"  			notnull="true" length="255" index="idx_moduleName";
	property name="title"  			notnull="false" length="255" default="";
	property name="version"			notnull="false" length="255" default="0";
	property name="entryPoint" 		notnull="false" length="255" default="" index="idx_entryPoint";
	property name="author" 			notnull="false" length="255" default="";
	property name="webURL" 			notnull="false" length="500" default="";
	property name="forgeBoxSlug" 	notnull="false" length="255" default="";
	property name="description"		notnull="false"  ormtype="text" length="8000" default="";
	property name="isActive"		notnull="true"  ormtype="boolean" default="false" dbdefault="0" index="idx_active";

	/************************************** PUBLIC *********************************************/

	/**
	* Check for updates
	*/
	boolean function checkForUpdates(){

	}

	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getModuleID() );
	}
}