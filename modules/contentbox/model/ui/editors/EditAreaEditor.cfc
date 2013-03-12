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
component implements="contentbox.model.ui.editors.IEditor" accessors="true" singleton{

	// DI
	property name="log" 	inject="logbox:logger:{this}";
	property name="html" 	inject="coldbox:plugin:HTMLHelper";

	/**
	* Constructor
	* @coldbox.inject coldbox
	*/
	function init(required coldbox){
		
		// register dependencies
		variables.coldbox 	= arguments.coldbox;
		requestService		= arguments.coldbox.getRequestService();
		
		// Store admin entry point and base URL settings
		ADMIN_ENTRYPOINT = arguments.coldbox.getSetting( "modules" )[ "contentbox-admin" ].entryPoint;
		
		return this;
	}

	/**
	* Get the internal name of an editor
	*/
	function getName(){
		return "editarea";
	}
	
	/**
	* Get the display name of an editor
	*/
	function getDisplayName(){
		return "EditArea";
	};
	
	/**
	* Startup the editor(s) on a page
	*/
	function startup(){
		var js = "";
		
		// We build the compiled JS with the knowledge of some inline variables we have context to
		// $excerpt - The excerpt jquery object
		// $content - The content jquery object
		// withExcerpt - an argument telling us if an excerpt is available to render or not
		savecontent variable="js"{
			writeOutput("
			// load editable area
			editAreaLoader.init({
				id : 'content',
				syntax: 'html',
				start_highlight: true,
				allow_resize : true,
				allow_toggle : true,
				word_wrap : true,
				plugins : 'charmap',
				language: 'en',
				toolbar: 'charmap, search, go_to_line, fullscreen, |, undo, redo, |, select_font,|, syntax_selection,|, change_smooth_selection, highlight, reset_highlight, word_wrap, |, help'
			});
			if( withExcerpt ){
				editAreaLoader.init({
					id : 'excerpt',
					syntax: 'html',
					start_highlight: true,
					allow_resize : true,
					allow_toggle : true,
					word_wrap : true,
					plugins : 'charmap',
					language: 'en',
					toolbar: 'charmap, search, go_to_line, fullscreen, |, undo, redo, |, select_font,|, syntax_selection,|, change_smooth_selection, highlight, reset_highlight, word_wrap, |, help'
				});
			}
			");
		}
		
		return js;
	}
	
	/**
	* This is fired once editor javascript loads, you can use this to return back functions, asset calls, etc. 
	* return the appropriate JavaScript
	*/
	function loadAssets(){
		var js = "";
		var event = requestService.getContext();
		var cbRoot = event.getValue(name="cbRoot", private=true);
		
		// Loaad JS assets
		html.addAsset("#cbRoot#/includes/editarea/edit_area_full.js");
		
		// Required JS Functions
		savecontent variable="js"{
			writeOutput("
			function checkIsDirty(){
				return false;
			}
			function getEditorContent(){
				return editAreaLoader.getValue('content');
			}
			");
		}
		
		return js;
	};

	/**
	* Shutdown the editor(s) on a page
	*/
	function shutdown(){
		
	}

} 