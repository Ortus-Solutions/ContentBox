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
The official ContentBox Search Service
*/
component accessors="true"{
	// DI
	property name="wirebox"					inject="wirebox";
	property name="settingService"			inject="id:settingService@cb";
	
	SearchService function init(){
		return this;
	}
	
	/**
	* Return the actual ContentBox configured search adapter
	*/
	ISearchAdapter function getSearchAdapter(){
		var searchAdapter = settingService.getSetting( "cb_search_adapter" );
		return wirebox.getInstance( searchAdapter );
	}
	
}