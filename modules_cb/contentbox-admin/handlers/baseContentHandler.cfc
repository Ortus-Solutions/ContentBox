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
* The base content handler
*/
component extends="baseHandler"{

	// Dependencies
	property name="authorService"		inject="id:authorService@cb";
	property name="themeService"		inject="id:themeService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";
	property name="categoryService"		inject="id:categoryService@cb";
	property name="editorService"		inject="id:editorService@cb";
	property name="messagebox"			inject="coldbox:plugin:MessageBox";

	// pre handler
	function preHandler( event, action, eventArguments, rc, prc ){
		// Tab control
		prc.tabContent = true;
	}

	/**
	* Get the user's default editor with some logic
	* @author.hint The author object
	*/
	private function getUserDefaultEditor( required author ){
		// get user default editor
		var userEditor = arguments.author.getPreference( "editor", editorService.getDefaultEditor() );

		// verify if editor exists
		if( editorService.hasEditor( userEditor ) ){
			return userEditor;
		}

		// not found, reset prefernce to system default, something is wrong.
		arguments.author.setPreference( "editor", editorService.getDefaultEditor() );
		authorService.save( arguments.author );

		// return default editor
		return editorService.getDefaultEditor();
	}

}