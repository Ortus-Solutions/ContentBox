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
* Manage system settings
*/
component extends="baseHandler"{

	// Dependencies
	property name="settingsService"		inject="id:settingService@cb";
	property name="htmlService"			inject="id:customHTMLService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";
	
	// index
	function index(event,rc,prc){
		event.paramValue("search","");
		event.paramValue("page",1);
		
		// Exit Handler
		prc.xehSaveHTML 	= "#prc.cbAdminEntryPoint#.customHTML.save";
		prc.xehRemoveHTML	= "#prc.cbAdminEntryPoint#.customHTML.remove";
		prc.xehEditorHTML	= "#prc.cbAdminEntryPoint#.customHTML.editor";
		
		// prepare paging plugin
		prc.pagingPlugin = getMyPlugin(plugin="Paging",module="contentbox");
		prc.paging 		 = prc.pagingPlugin.getBoundaries();
		prc.pagingLink 	 = event.buildLink('#prc.xehCustomHTML#.page.@page@?');
		
		// Append search to paging link?
		if( len(rc.search) ){ prc.pagingLink&="&search=#rc.search#"; }
		
		// get content pieces
		var entryResults = htmlService.search(search=rc.search,
											  offset=prc.paging.startRow-1,
											  max=prc.cbSettings.cb_paging_maxrows);
		prc.entries 		 = entryResults.entries;
		prc.entriesCount  = entryResults.count;
		
		// tab
		prc.tabContent				= true;
		prc.tabContent_customHTML	= true; 
		
		// view
		event.setView("customHTML/index");
	}
	
	// slugify remotely
	function slugify(event,rc,prc){
		event.renderData(data=getPlugin("HTMLHelper").slugify( rc.slug ),type="plain");
	}
	
	// editor
	function editor(event,rc,prc){
		
		// tab
		prc.tabContent				= true;
		prc.tabContent_customHTML	= true; 
		
		// get new or persisted
		prc.content  = htmlService.get( event.getValue("contentID",0) );
		
		// exit handlers
		prc.xehContentSave 		= "#prc.cbAdminEntryPoint#.customHTML.save";
		prc.xehSlugify	  		= "#prc.cbAdminEntryPoint#.customHTML.slugify";
		
		// view
		event.setView(view="customHTML/editor");
	}
	
	// save html
	function save(event,rc,prc){
		
		// populate and get content
		var oContent = populateModel( htmlService.get(id=rc.contentID) );
		
		// validate it
		var errors = oContent.validate();
		if( !arrayLen(errors) ){
			// announce event
			announceInterception("cbadmin_preCustomHTMLSave",{content=oContent,contentID=rc.contentID});
			// save content
			htmlService.saveCustomHTML( oContent );
			// announce event
			announceInterception("cbadmin_postCustomHTMLSave",{content=oContent});
			// Message
			getPlugin("MessageBox").info("Custom HTML saved! Isn't that majestic!");
		}
		else{
			getPlugin("MessageBox").warn(errorMessages=errors);
		}
		
		// relocate back to editor
		setNextEvent(prc.xehCustomHTML);
	}
	
	// remove
	function remove(event,rc,prc){
		event.paramValue("contentID","");
		event.paramValue("page","1");
		// check for length
		if( len(rc.contentID) ){
			// announce event
			announceInterception("cbadmin_preCustomHTMLRemove",{contentID=rc.contentID});
			// remove using hibernate bulk
			htmlService.deleteByID( listToArray(rc.contentID) );
			// announce event
			announceInterception("cbadmin_postCustomHTMLRemove",{contentID=rc.contentID});
			// message
			getPlugin("MessageBox").info("Custom HTML Content Removed!");
		}
		else{
			getPlugin("MessageBox").warn("No ID selected!");
		}
		setNextEvent(event=prc.xehCustomHTML,queryString="page=#rc.page#");
	}
	
	// editor selector
	function editorSelector(event,rc,prc){
		// paging default
		event.paramValue("page",1);
		
		// exit handlers
		prc.xehEditorSelector	= "#prc.cbAdminEntryPoint#.customHTML.editorSelector";

		// prepare paging plugin
		prc.pagingPlugin 	= getMyPlugin(plugin="Paging",module="contentbox");
		prc.paging 	  		= prc.pagingPlugin.getBoundaries();
		prc.pagingLink 		= "javascript:pagerLink(@page@)";

		// search entries with filters and all
		var htmlResults = htmlService.search(offset=prc.paging.startRow-1,max=prc.cbSettings.cb_paging_maxrows);

		prc.entries 		= htmlResults.entries;
		prc.entriesCount  	= htmlResults.count;
		prc.CBHelper 		= CBHelper;
		
		event.setView(view="customHTML/editorSelector",layout="ajax");
	}
	
}
