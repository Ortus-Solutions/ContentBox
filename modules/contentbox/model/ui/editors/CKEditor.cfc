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
* Simple textarea editor
*/
component implements="modules.contentbox.model.ui.editors.IEditor" accessors="true" singleton{

	// The static JSON for our default toolbar
	property name="TOOLBAR_JSON";
	// The extra plugins we have created for CKEditor
	property name="extraPlugins";
	
	// DI
	property name="log" inject="logbox:logger:{this}";

	/**
	* Constructor
	* @coldbox.inject coldbox
	*/
	function init(required coldbox){
		
		// register dependencies
		variables.interceptorService = arguments.coldbox.getInterceptorService();
		variables.requestService	 = arguments.coldbox.getRequestService();
		variables.coldbox 			 = arguments.coldbox;
		
		// Store admin entry point and base URL settings
		ADMIN_ENTRYPOINT = arguments.coldbox.getSetting( "modules" )[ "contentbox-admin" ].entryPoint;
		HTML_BASE_URL	 = arguments.coldbox.getSetting( "htmlBaseURL" );
		
		// Toolbar definition
		savecontent variable="TOOLBAR_JSON"{
			writeOutput('[
		    { "name": "document",    "items" : [ "Source","-","Maximize","ShowBlocks" ] },
		    { "name": "clipboard",   "items" : [ "Cut","Copy","Paste","PasteText","PasteFromWord","-","Undo","Redo" ] },
		    { "name": "editing",     "items" : [ "Find","Replace","-","SpellChecker", "Scayt" ] },
		    { "name": "forms",       "items" : [ "Form", "Checkbox", "Radio", "TextField", "Textarea", "Select", "Button","HiddenField" ] },
		    "/",
			{ "name": "basicstyles", "items" : [ "Bold","Italic","Underline","Strike","Subscript","Superscript","-","RemoveFormat" ] },
		    { "name": "paragraph",   "items" : [ "NumberedList","BulletedList","-","Outdent","Indent","-","Blockquote","CreateDiv","-","JustifyLeft","JustifyCenter","JustifyRight","JustifyBlock","-","BidiLtr","BidiRtl" ] },
		    { "name": "links",       "items" : [ "Link","Unlink","Anchor" ] },
		    "/",
		    { "name": "styles",      "items" : [ "Styles","Format" ] },
		    { "name": "colors",      "items" : [ "TextColor","BGColor" ] },
			{ "name": "insert",      "items" : [ "Image","Flash","Table","HorizontalRule","Smiley","SpecialChar" ] },
		    { "name": "contentbox",  "items" : [ "cbIpsumLorem","cbWidgets","cbCustomHTML","cbLinks","cbEntryLinks", "cbPreview" ] }
		    ]');
		};
		savecontent variable="TOOLBAR_EXCERPT_JSON"{
			writeOutput('[
		    { "name": "document",    "items" : [ "Source","ShowBlocks" ] },
		    { "name": "basicstyles", "items" : [ "Bold","Italic","Underline","Strike","Subscript","Superscript"] },
		    { "name": "paragraph",   "items" : [ "NumberedList","BulletedList","-","Outdent","Indent","CreateDiv"] },
		    { "name": "links",       "items" : [ "Link","Unlink","Anchor" ] },
		    { "name": "insert",      "items" : [ "Image","Flash","Table","HorizontalRule","Smiley","SpecialChar" ] },
		    { "name": "contentbox",  "items" : [ "cbIpsumLorem","cbWidgets","cbCustomHTML","cbLinks","cbEntryLinks", "cbPreview" ] }
		    ]');
		};
		
		// Register our extra plugins
		extraPlugins = "cbWidgets,cbLinks,cbEntryLinks,cbCustomHTML,cbPreview,cbIpsumLorem";
		
		// Register our events
		interceptorService.appendInterceptionPoints("cbadmin_ckeditorToolbar,cbadmin_ckeditorExtraPlugins");
		
		return this;
	}

	/**
	* Get the internal name of an editor
	*/
	function getName(){
		return "ckeditor";
	}
	
	/**
	* Get the display name of an editor
	*/
	function getDisplayName(){
		return "CKEditor";
	};
	
	/**
	* Startup the editor(s) on a page
	*/
	function startup(){
		// prepare toolbar announcement on startup
		var iData = { toolbar = deserializeJSON( TOOLBAR_JSON ), excerptToolbar = deserializeJSON( TOOLBAR_EXCERPT_JSON ) };
		// Announce the editor toolbar is about to be processed
		interceptorService.processState("cbadmin_ckeditorToolbar", iData);
		// Load extra plugins according to our version
		var iData2 = { extraPlugins = listToArray( extraPlugins) };
		// Announce extra plugins to see if user implements more.
		interceptorService.processState("cbadmin_ckeditorExtraPlugins", iData2);
		
		// Now prepare our JavaScript and load it. No need to send assets to the head as CKEditor comes pre-bundled
		return compileJS(iData, iData2);
	}
	
	/**
	* This is fired once editor javascript loads, you can use this to return back functions, asset calls, etc. 
	* return the appropriate JavaScript
	*/
	function loadAssets(){
		var js = "";
		
		savecontent variable="js"{
			writeOutput("
			function checkIsDirty(){
				return $content.ckeditorGet().checkDirty();
			}
			");
		}
		
		return js;
	};
	
	
	private function compileJS(iData, iData2){
		var js = "";
		var event = requestService.getContext();
		var cbAdminEntryPoint = event.getValue(name="cbAdminEntryPoint", private=true);
		
		// CK Editor Integration Handlers
		var xehCKFileBrowserURL			= "#cbAdminEntryPoint#/ckfilebrowser/";
		var xehCKFileBrowserURLImage	= "#cbAdminEntryPoint#/ckfilebrowser/";
		var xehCKFileBrowserURLFlash	= "#cbAdminEntryPoint#/ckfilebrowser/";
		
		// Determine Extra Plugins code
		var extraPlugins = "";
		if( arrayLen( arguments.iData2.extraPlugins ) ){
			extraPlugins = "extraPlugins : '#arrayToList( iData2.extraPlugins )#',";
		}
		
		/**
		 We build the compiled JS with the knowledge of some inline variables we have context to
		 $excerpt - The excerpt jquery object
		 $content - The content jquery object
		 withExcerpt - an argument telling us if an excerpt is available to render or not
		*/
		
		savecontent variable="js"{
			writeOutput("
			// toolbar Configuration
			var ckToolbar = $.parseJSON( '#serializeJSON( arguments.iData.toolbar )#' );
			var ckExcerptToolbar = $.parseJSON( '#serializeJSON( arguments.iData.excerptToolbar )#' );
			
			// Activate ckeditor on content object
			$content.ckeditor( function(){}, {
					#extraPlugins#
					toolbar: ckToolbar,
					height:300,
					filebrowserBrowseUrl : '#event.buildLink( xehCKFileBrowserURL )#',
					filebrowserImageBrowseUrl : '#event.buildLink( xehCKFileBrowserURLIMage )#',
					filebrowserFlashBrowseUrl : '#event.buildLink( xehCKFileBrowserURLFlash )#',
					baseHref : '#HTML_BASE_URL#/'
				} );
				
			// Active Excerpts
			if (withExcerpt) {
				$excerpt.ckeditor(function(){}, {
					toolbar: ckExcerptToolbar,
					height: 175,
					filebrowserBrowseUrl: '#event.buildLink( xehCKFileBrowserURL )#',
					baseHref: '#HTML_BASE_URL#/'
				});
			}
			");
		}
		
		return js;
	}


	/**
	* Shutdown the editor(s) on a page
	*/
	function shutdown(){
		
	}

} 