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
* Simple textarea editor
*/
component implements="contentbox.models.ui.editors.IEditor" singleton{

	property name="log" inject="logbox:logger:{this}";

	function init(){
		return this;
	}

	/**
	* Get the internal name of an editor
	*/
	function getName(){
		return "textarea";
	}
	
	/**
	* Get the display name of an editor
	*/
	function getDisplayName(){
		return "Textarea";
	};
	
	/**
	* This is fired once editor javascript loads, you can use this to return back functions, asset calls, etc. 
	* return the appropriate JavaScript
	*/
	function loadAssets(){
		var js = "";
		
		savecontent variable="js"{
			writeOutput( "
			function checkIsDirty(){
				return false;
			}
			function getEditorContent(){
				return $('##content').val();
			}
			function getEditorExcerpt(){
				return $('##excerpt').val();
			}
			function updateEditorContent(){
				// not needed
			}
			function updateExcerptContent(){
				// not needed
			}
			function insertEditorContent( editorName, content ){
				// not used yet
			}
			" );
		}
		
		return js;
	};
	
	/**
	* Startup the editor(s) on a page
	*/
	function startup(){
		log.info( getName() & " editor started up." );
	}
	
	/**
	* Shutdown the editor(s) on a page
	*/
	function shutdown(){
		log.info( getName() & " editor shutdown." );
	}


} 