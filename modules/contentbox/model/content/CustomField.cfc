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
* I am a custom field metadata that can be attached to base content in contentbox
*/
component persistent="true" entityname="cbCustomField" table="cb_customfield"{

	// Properties
	property name="customFieldID" fieldtype="id" generator="native" setter="false";
	property name="key"			notnull="true"  ormtype="string" 	length="255";
	property name="value"    	notnull="true"  ormtype="text" 		length="8000";

	// M20 -> Content loaded as a proxy
	property name="relatedContent" notnull="false" cfc="contentbox.model.content.BaseContent" fieldtype="many-to-one" fkcolumn="FK_contentID" lazy="true" index="idx_contentCustomFields";

	/* ----------------------------------------- PUBLIC -----------------------------------------  */

	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getCustomFieldID() );
	}

}