/**
* Manage system settings
*/
component extends="baseHandler"{

	// Dependencies
	property name="settingsService"		inject="id:settingService@cb";
	property name="htmlService"			inject="id:customHTMLService@cb";
	
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
		rc.content  = htmlService.get( event.getValue("contentID",0) );
		
		// exit handlers
		rc.xehContentSave = "#prc.cbAdminEntryPoint#.customHTML.save";
		rc.xehSlugify	  = "#prc.cbAdminEntryPoint#.customHTML.slugify";
		
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
			htmlService.save( oContent );
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
	
}
