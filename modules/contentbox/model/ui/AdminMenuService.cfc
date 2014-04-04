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
* Manages the admin menu services for the header and top menu
*/
component accessors="true" threadSafe singleton{

	/**
	* This holds the top menu structure
	*/
	property name="topMenu"			type="array";
	/**
	* This is a reference map of the topMenu array
	*/
	property name="topMenuMap"		type="struct";
	/**
	* This holds the header menu structure
	*/
	property name="headerMenu"		type="array";
	/**
	* This is a reference map of the headerMenu array
	*/
	property name="headerMenuMap"	type="struct";
	
	/**
	* Injected Avatar
	*/
	property name="avatar"			type="any" inject="coldbox:myplugin:Avatar@contentbox";
	 
	// Top Menu Slugs
	this.DASHBOARD 		= "dashboard";
	this.CONTENT 		= "content";
	this.COMMENTS		= "comments";
	this.LOOK_FEEL		= "lookAndFeel";
	this.MODULES		= "modules";
	this.USERS			= "users";
	this.TOOLS			= "tools";
	this.SYSTEM			= "system";
	this.ADMIN_ENTRYPOINT = "";

	// Header Menu Slugs
	this.HEADER_ABOUT 	= "about";
	this.HEADER_PROFILE = "profile";

	/**
	* Constructor
	* @requestService.inject coldbox:requestService
	* @coldbox.inject coldbox
	*/
	AdminMenuService function init( required requestService, required coldbox ){
		// init menu array
		variables.topMenu = [];
		// init top menu structure holders
		variables.topMenuMap = {};
		// init header menu array
		variables.headerMenu = [];
		// init profile menu structure
		variables.headerMenuMap = {};
		// top menu pointer
		variables.thisTopMenu = "";
		// header menu pointer
		variables.thisHeaderMenu = "";
		// store request service
		variables.requestService = arguments.requestService;
		// store coldbox
		variables.coldbox = arguments.coldbox;
		// Store admin entry point
		this.ADMIN_ENTRYPOINT = arguments.coldbox.getSetting( "modules" )[ "contentbox-admin" ].entryPoint;
		// store module info
		variables.moduleConfig = arguments.coldbox.getSetting( "modules" )[ "contentbox" ];
		// create default menus
		createHeaderMenu();
		createDefaultMenu();
		
		return this;
	}

	/**
	* Create the default ContentBox header menu contributions
	*/
	AdminMenuService function createHeaderMenu(){
		var event = requestService.getContext();
		
		// Exit Handlers
		var xehMyProfile		= "#this.ADMIN_ENTRYPOINT#.authors.myprofile";
		var xehDoLogout			= "#this.ADMIN_ENTRYPOINT#.security.doLogout";
		var xehAutoUpdates		= "#this.ADMIN_ENTRYPOINT#.autoupdates";
		var xehAbout			= "#this.ADMIN_ENTRYPOINT#.dashboard.about";

		// Register About Menu
		addHeaderMenu( name="about", label='<i class="icon-info-sign"></i> About', permissions="SYSTEM_TAB" )
			.addHeaderSubMenu( name="support", label='<i class="icon-ambulance"></i> Professional Support', href="http://www.gocontentbox.org/services/support", target="_blank" )
			.addHeaderSubMenu( name="docs", label='<i class="icon-book"></i> Documentation', href="http://www.gocontentbox.org/resources/docs", target="_blank" )
			.addHeaderSubMenu( name="forums", label='<i class="icon-envelope"></i> Support Forums', href="https://groups.google.com/forum/?fromgroups##!forum/contentbox", target="_blank" )
			.addHeaderSubMenu( name="divider", class="divider", label="" )
			.addHeaderSubMenu( name="twitter", label='<i class="icon-twitter"></i> Twitter', href="https://www.twitter.com/gocontentbox", target="_blank" )
			.addHeaderSubMenu( name="facebook", label='<i class="icon-facebook"></i> Facebook', href="https://www.facebook.com/gocontentbox", target="_blank" )
			.addHeaderSubMenu( name="google", label='<i class="icon-google-plus"></i> Google+', href="https://plus.google.com/u/0/111231811346031749369", target="_blank" )
			.addHeaderSubMenu( name="divider", class="divider", label="" )
			.addHeaderSubMenu( name="updates", label='<i class="icon-download-alt"></i> Check for Updates', href="#event.buildLink( xehAutoUpdates )#" )
			.addHeaderSubMenu( name="buildid", label='<i class="icon-info-sign"></i> ContentBox v.#variables.moduleConfig.version# <br>
										<span class="label label-warning">(Codename: #variables.moduleConfig.settings.codename#)</span>', href="#event.buildLink( xehAbout )#" );
			
		// Register Profile Menu
		addHeaderMenu( name="profile", 
					   label=variables.buildProfileLabel )
			.addHeaderSubMenu( name="myprofile", title="ctrl+shift+A", 
				     	   	   label="<i class='icon-camera'></i> My Profile", 
				     	   	   href="#event.buildLink( xehMyProfile )#",
					 	   	   data={ keybinding="ctrl+shift+a" } )
			.addHeaderSubMenu( name="logout", title="ctrl+shift+L", 
					 		   label="<i class='icon-off'></i> Logout", 
					 		   href="#event.buildLink( xehDoLogout )#",
					 		   data={ keybinding="ctrl+shift+l" } );

		return this;
	}

	/**
	* Dynamic menu label
	*/
	function buildProfileLabel(){
		var event 	= requestService.getContext();
		var prc		= event.getCollection( private=true );
		
		savecontent variable="profileLabel"{
			writeOutput( '#variables.avatar.renderAvatar( email=prc.oAuthor.getEmail(), size="20" )# #prc.oAuthor.getName()#' );
		}

		return profileLabel;
	}

	/**
	* Create the default ContentBox menu
	*/
	AdminMenuService function createDefaultMenu(){
		var event 	= requestService.getContext();
		var prc 	= {};

		// Global Admin Exit Handlers
		prc.xehDashboard 	= "#this.ADMIN_ENTRYPOINT#.dashboard";
		prc.xehAbout		= "#this.ADMIN_ENTRYPOINT#.dashboard.about";

		// Entries Tab
		prc.xehEntries		= "#this.ADMIN_ENTRYPOINT#.entries";
		prc.xehBlogEditor 	= "#this.ADMIN_ENTRYPOINT#.entries.editor";
		prc.xehCategories	= "#this.ADMIN_ENTRYPOINT#.categories";

		// Content Tab
		prc.xehPages		= "#this.ADMIN_ENTRYPOINT#.pages";
		prc.xehPagesEditor	= "#this.ADMIN_ENTRYPOINT#.pages.editor";
		prc.xehContentStore	= "#this.ADMIN_ENTRYPOINT#.contentstore";
		prc.xehMediaManager	= "#this.ADMIN_ENTRYPOINT#.mediamanager";
		prc.xehMenuManager	= "#this.ADMIN_ENTRYPOINT#.menus";

		// Comments Tab
		prc.xehComments			= "#this.ADMIN_ENTRYPOINT#.comments";
		prc.xehCommentsettings	= "#this.ADMIN_ENTRYPOINT#.comments.settings";

		// Look and Feel Tab
		prc.xehLayouts		= "#this.ADMIN_ENTRYPOINT#.layouts";
		prc.xehWidgets		= "#this.ADMIN_ENTRYPOINT#.widgets";
		prc.xehGlobalHTML	= "#this.ADMIN_ENTRYPOINT#.globalHTML";

		// Modules
		prc.xehModules = "#this.ADMIN_ENTRYPOINT#.modules";

		// Authors Tab
		prc.xehAuthors		= "#this.ADMIN_ENTRYPOINT#.authors";
		prc.xehAuthorEditor	= "#this.ADMIN_ENTRYPOINT#.authors.editor";
		prc.xehPermissions		= "#this.ADMIN_ENTRYPOINT#.permissions";
		prc.xehRoles			= "#this.ADMIN_ENTRYPOINT#.roles";

		// Tools
		prc.xehToolsImport	= "#this.ADMIN_ENTRYPOINT#.tools.importer";
		prc.xehToolsExport	= "#this.ADMIN_ENTRYPOINT#.tools.exporter";
		prc.xehApiDocs		= "#this.ADMIN_ENTRYPOINT#.apidocs";

		// System
		prc.xehSettings			= "#this.ADMIN_ENTRYPOINT#.settings";
		prc.xehSecurityRules	= "#this.ADMIN_ENTRYPOINT#.securityrules";
		prc.xehRawSettings		= "#this.ADMIN_ENTRYPOINT#.settings.raw";
		prc.xehEmailTemplates   = "#this.ADMIN_ENTRYPOINT#.emailtemplates";
		prc.xehAutoUpdater	    = "#this.ADMIN_ENTRYPOINT#.autoupdates";
		
		// Dashboard
		addTopMenu( name=this.DASHBOARD, label="<i class='icon-dashboard icon-large'></i> Dashboard" )
			.addSubMenu( name="home", label="Home", href="#event.buildLink(prc.xehDashboard)#" )
			.addSubMenu( name="about", label="About", href="#event.buildLink(prc.xehAbout)#" )
			.addSubMenu( name="updates", label="Updates", href="#event.buildLink(prc.xehAutoUpdater)#", permissions="SYSTEM_UPDATES" );

		// Content
		addTopMenu( name=this.CONTENT, label="<i class='icon-pencil icon-large'></i> Content" )
			.addSubMenu( name="Pages", label="Pages", href="#event.buildLink(prc.xehPages)#", permissions="PAGES_ADMIN,PAGES_EDITOR" )
			.addSubMenu( topMenu=this.CONTENT,name="Blog", label="Blog", href="#event.buildLink(prc.xehEntries)#", permissions="ENTRIES_ADMIN,ENTRIES_EDITOR" )
			.addSubMenu( name="contentStore", label="Content Store", href="#event.buildLink(prc.xehContentStore)#", permissions="CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )
			.addSubMenu( name="Categories", label="Categories", href="#event.buildLink(prc.xehCategories)#", permissions="CATEGORIES_ADMIN" )
			.addSubMenu( name="mediaManager", label="Media Manager", href="#event.buildLink(prc.xehMediaManager)#", permissions="MEDIAMANAGER_ADMIN" )
			.addSubMenu( name="menu", label="Menu Manager", href="#event.buildLink(prc.xehMenuManager)#", permissions="MENUS_ADMIN" );

		// Comments
		addTopMenu( name=this.COMMENTS, label="<i class='icon-comments icon-large'></i> Comments" )
			.addSubMenu( name="Inbox", label="Inbox", href="#event.buildLink(prc.xehComments)#", permissions="COMMENTS_ADMIN" )
			.addSubMenu( name="Settings", label="Settings", href="#event.buildLink(prc.xehCommentsettings)#", permissions="COMMENTS_ADMIN" );

		// Look and Feel
		addTopMenu( name=this.LOOK_FEEL, label="<i class='icon-tint icon-large'></i> Look & Feel" )
			.addSubMenu( name="Layouts", label="Layouts", href="#event.buildLink(prc.xehLayouts)#", permissions="LAYOUT_ADMIN" )
			.addSubMenu( name="Widgets", label="Widgets", href="#event.buildLink(prc.xehWidgets)#", permissions="WIDGET_ADMIN" )
			.addSubMenu( name="globalHTML", label="Global HTML", href="#event.buildLink(prc.xehGlobalHTML)#", permissions="GLOBALHTML_ADMIN" );

		// Modules
		addTopMenu( name=this.MODULES, label="<i class='icon-bolt icon-large'></i> Modules", permissions="MODULES_ADMIN" )
			.addSubMenu( name="Manage", label="Manage", href="#event.buildLink(prc.xehModules)#" );

		// User
		addTopMenu( name=this.USERS, label="<i class='icon-group icon-large'></i> Users" )
			.addSubMenu( name="Manage", label="Manage", href="#event.buildLink(prc.xehAuthors)#", permissions="AUTHOR_ADMIN" )
			.addSubMenu( name="Permissions", label="Permissions", href="#event.buildLink(prc.xehPermissions)#", permissions="PERMISSIONS_ADMIN" )
			.addSubMenu( name="Roles", label="Roles", href="#event.buildLink(prc.xehRoles)#", permissions="ROLES_ADMIN" );

		// Tools
		addTopMenu( name=this.TOOLS, label="<i class='icon-wrench icon-large'></i> Tools" )
			.addSubMenu( name="Import", label="Import", href="#event.buildLink(prc.xehToolsImport)#", permissions="TOOLS_IMPORT" )
			.addSubMenu( name="Export", label="Export", href="#event.buildLink(prc.xehToolsExport)#", permissions="TOOLS_EXPORT" )
			.addSubMenu( name="APIDocs", label="API Docs", href="#event.buildLink(prc.xehApiDocs)#", permissions="SYSTEM_TAB" );

		// SYSTEM
		addTopMenu( name=this.SYSTEM, label="<i class='icon-briefcase icon-large'></i> System", permissions="SYSTEM_TAB" )
			.addSubMenu( name="Settings", label="Settings", href="#event.buildLink(prc.xehSettings)#", data={ "keybinding"="ctrl+shift+c" }, title="ctrl+shift+C" )
			.addSubMenu( name="SecurityRules", label="Security Rules", href="#event.buildLink(prc.xehSecurityRules)#", permissions="SECURITYRULES_ADMIN" )
			.addSubMenu( name="EmailTemplates", label="Email Templates", href="#event.buildLink(prc.xehEmailTemplates)#", permissions="EMAIL_TEMPLATE_ADMIN" )
			.addSubMenu( name="GeekSettings", label="Geek Settings", href="#event.buildLink(prc.xehRawSettings)#", permissions="SYSTEM_RAW_SETTINGS" );

		return this;
	}

	/**
	* Build out ContentBox module links
	*/
	function buildModuleLink( required string module, required string linkTo, queryString="", boolean ssl=false ){
		var event = requestService.getContext();
		return event.buildLink( linkto="#this.ADMIN_ENTRYPOINT#.module.#arguments.module#.#arguments.linkTo#",
							    queryString=arguments.queryString,
							    ssl=arguments.ssl );
	}

	/**
	* @name.hint The name of the top menu
	*/
	AdminMenuService function withTopMenu( required name ){
		thisTopMenu = arguments.name;
		return this;
	}

	/**
	* Use a header menu
	* @name.hint The name of the header menu
	*/
	AdminMenuService function withHeaderMenu( required name ){
		thisHeaderMenu = arguments.name;
		return this;
	}

	/**
	* Add top level menus
	* @name.hint The unique name for this top level menu
	* @label.hint The label for the menu item, this can be a closure/udf and it will be called at generation
	* @title.hint The optional title element
	* @href.hint The href, if any to locate when clicked, this can be a closure/udf and it will be called at generation
	* @target.hint The target to execute the link in, default is same page.
	* @permissions.hint The list of permissions needed to view this menu
	* @data.hint A structure of data attributes to add to the link
	*/
	AdminMenuService function addTopMenu( required name, required label, title="", href="javascript:null()", target="", permissions="", data=structNew(), class="" ){
		// stash pointer
		variables.thisTopMenu = arguments.name;
		// store new top menu in reference map
		variables.topMenuMap[ arguments.name ] = { submenu = [] };
		structAppend( variables.topMenuMap[ arguments.name ], arguments, true );
		// store in menu container
		arrayAppend( variables.topMenu, variables.topMenuMap[ arguments.name ] );
		// return it
		return this;
	}

	/**
	* Add header top level menu
	* @name.hint The unique name for this header level menu
	* @label.hint The label for the menu item, this can be a closure/udf and it will be called at generation
	* @title.hint The optional title element
	* @href.hint The href, if any to locate when clicked, this can be a closure/udf and it will be called at generation
	* @target.hint The target to execute the link in, default is same page.
	* @permissions.hint The list of permissions needed to view this menu
	* @data.hint A structure of data attributes to add to the link
	*/
	AdminMenuService function addHeaderMenu( required name, required label, title="", href="javascript:null()", target="", permissions="", data=structNew(), class="" ){
		// stash pointer
		variables.thisHeaderMenu = arguments.name;
		// store new top menu in reference map
		variables.headerMenuMap[ arguments.name ] = { submenu = [] };
		structAppend( variables.headerMenuMap[ arguments.name ], arguments, true );
		// store in menu container
		arrayAppend( variables.headerMenu, variables.headerMenuMap[ arguments.name ] );
		// return it
		return this;
	}

	/**
	* Add a sub level menu
	* @topMenu.hint The optional top menu name to add this sub level menu to or if concatenated then it uses that one.
	* @name.hint The unique name for this sub level menu
	* @label.hint The label for the menu item, this can be a closure/udf and it will be called at generation
	* @title.hint The optional title element
	* @href.hint The href, if any to locate when clicked, this can be a closure/udf and it will be called at generation
	* @target.hint The target to execute the link in, default is same page.
	* @permissions.hint The list of permissions needed to view this menu
	* @data.hint A structure of data attributes to add to the link
	*/
	AdminMenuService function addSubMenu(topMenu, required name, required label, title="", href="##", target="", permissions="", data=structNew(), class="" ){
		// Check if thisTopMenu set?
		if( !len(thisTopMenu) AND !structKeyExists(arguments,"topMenu") ){ throw("No top menu passed or concatenated with"); }
		// check this pointer
		if( len(thisTopMenu) AND !structKeyExists(arguments,"topMenu")){ arguments.topmenu = thisTopMenu; }
		// store in top menu
		arrayAppend( topMenuMap[ arguments.topMenu ].submenu, arguments );
		// return
		return this;
	}

	/**
	* Add a sub level header menu
	* @headerMenu.hint The optional header menu name to add this sub level menu to or if concatenated then it uses that one.
	* @name.hint The unique name for this sub level menu
	* @label.hint The label for the menu item
	* @title.hint The optional title element
	* @href.hint The href, if any to locate when clicked
	* @target.hint The target to execute the link in, default is same page.
	* @permissions.hint The list of permissions needed to view this menu
	* @data.hint A structure of data attributes to add to the link
	*/
	AdminMenuService function addHeaderSubMenu( headerMenu, required name, required label, title="", href="##", target="", permissions="", data=structNew(), class="" ){
		// Check if thisTopMenu set?
		if( !len( thisHeaderMenu ) AND !structKeyExists( arguments, "headerMenu" ) ){ throw( "No header menu passed or concatenated with" ); }
		// check this pointer
		if( len( thisHeaderMenu ) AND !structKeyExists( arguments, "headerMenu" )){ arguments.headerMenu = thisHeaderMenu; }
		// store in top menu
		arrayAppend( headerMenuMap[ arguments.headerMenu ].submenu, arguments );
		// return
		return this;
	}

	/**
	* Remove a sub level menu
	* @topMenu.hint The optional top menu name to add this sub level menu to or if concatenated then it uses that one.
	* @name.hint The unique name for this sub level menu
	*/
	AdminMenuService function removeSubMenu( required topMenu, required name ){

		for( var x=1; x lte arrayLen( variables.topMenuMap[ arguments.topMenu ].subMenu ); x++){
			if( variables.topMenuMap[ arguments.topMenu ].subMenu[ x ].name eq arguments.name ){
				arrayDeleteAt( variables.topMenuMap[ arguments.topMenu ].subMenu, x );
				break;
			}
		}

		// return
		return this;
	}

	/**
	* Remove a sub level menu from the header
	* @headerMenu.hint The optional header menu name to remove from
	* @name.hint The sub menu to remove
	*/
	AdminMenuService function removeHeaderSubMenu( required headerMenu, required name ){

		for( var x=1; x lte arrayLen( variables.headerMenuMap[ arguments.headerMenu ].subMenu ); x++){
			if( variables.headerMenuMap[ arguments.headerMenu ].subMenu[ x ].name eq arguments.name ){
				arrayDeleteAt( variables.headerMenuMap[ arguments.headerMenu ].subMenu, x );
				break;
			}
		}

		// return
		return this;
	}

	/**
	* Remove a top level menu
	* @topMenu.hint The optional top menu name to add this sub level menu to or if concatenated then it uses that one.
	*/
	AdminMenuService function removeTopMenu(required topMenu){

		for( var x=1; x lte arrayLen( variables.topMenu ); x++ ){
			if( variables.topMenu[ x ].name eq arguments.topMenu ){
				arrayDeleteAt( variables.topMenu, x );
				structDelete( variables.topMenuMap, arguments.topMenu );
				break;
			}
		}

		// return
		return this;
	}

	/**
	* Remove a header top level menu
	* @headerMenu.hint The header menu unique name to remove
	*/
	AdminMenuService function removeHeaderMenu( required headerMenu ){

		for( var x=1; x lte arrayLen( variables.headerMenu ); x++ ){
			if( variables.headerMenu[ x ].name eq arguments.headerMenu ){
				arrayDeleteAt( variables.headerMenu, x );
				structDelete( variables.headerMenuMap, arguments.headerMenu );
				break;
			}
		}

		// return
		return this;
	}

	/**
	*  Generate menu from cache or newly generated menu
	*/
	any function generateMenu(){
		var event 		= requestService.getContext();
		var prc			= event.getCollection( private=true );
		var genMenu 	= "";
		var thisMenu 	= variables.topMenu;

		savecontent variable="genMenu"{
			include "templates/navAdminMenu.cfm";
		}

		// return it
		return genMenu;
	}

	/**
	* Generate the header menu
	*/
	any function generateHeaderMenu(){
		var event 		= requestService.getContext();
		var prc			= event.getCollection( private=true );
		var genMenu 	= "";
		var thisMenu 	= variables.headerMenu;

		savecontent variable="genMenu"{
			include "templates/nav.cfm";
		}

		// return it
		return genMenu;
	}



	/**
	* Generate a flat representation of data elements
	* @data.hint The data struct
	*/
	string function parseADataAttributes( required struct data ) {
		var dataString = "";

		for( var dataKey in arguments.data ){
			if( isSimplevalue( arguments.data[ dataKey ] ) ){
				dataString &= ' data-#lcase( dataKey )#="#arguments.data[ datakey ]#"';
			}
		}

		return dataString;
	}
}
