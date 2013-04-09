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
* Manages the admin menu services
*/
component accessors="true" threadSafe singleton{

	// The structure that keeps the menus
	property name="menu"			type="array";
	property name="topMenuMap"		type="struct";
	// The request service
	property name="requestService"	type="any";

	// Register ContentBox Top Menu Slugs
	this.DASHBOARD 		= "dashboard";
	this.CONTENT 		= "content";
	this.COMMENTS		= "comments";
	this.LOOK_FEEL		= "lookAndFeel";
	this.MODULES		= "modules";
	this.USERS			= "users";
	this.TOOLS			= "tools";
	this.SYSTEM			= "system";
	this.ADMIN_ENTRYPOINT = "";

	/**
	* Constructor
	* @requestService.inject coldbox:requestService
	* @coldbox.inject coldbox
	*/
	AdminMenuService function init(required requestService, required coldbox){
		// init menu array
		menu = [];
		// init top menu structure holders
		topMenuMap = {};
		// top menu pointer
		thisTopMenu = "";
		// store request service
		variables.requestService = arguments.requestService;
		// store coldbox
		variables.coldbox = arguments.coldbox;
		// Store admin entry point
		this.ADMIN_ENTRYPOINT = arguments.coldbox.getSetting("modules")["contentbox-admin"].entryPoint;
		// create default top menus
		createDefaultMenu();
		return this;
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
		prc.xehCustomHTML	= "#this.ADMIN_ENTRYPOINT#.customHTML";
		prc.xehMediaManager	= "#this.ADMIN_ENTRYPOINT#.mediamanager";

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
		prc.xehApiDocs		= "#this.ADMIN_ENTRYPOINT#.apidocs";

		// System
		prc.xehSettings			= "#this.ADMIN_ENTRYPOINT#.settings";
		prc.xehSecurityRules	= "#this.ADMIN_ENTRYPOINT#.securityrules";
		prc.xehRawSettings		= "#this.ADMIN_ENTRYPOINT#.settings.raw";
		prc.xehEmailTemplates   = "#this.ADMIN_ENTRYPOINT#.emailtemplates";
		prc.xehAutoUpdater	    = "#this.ADMIN_ENTRYPOINT#.autoupdates";

		// Dashboard
		addTopMenu(name=this.DASHBOARD,label="Dashboard")
			.addSubMenu(name="home",label="Home",href="#event.buildLink(prc.xehDashboard)#")
			.addSubMenu(name="about",label="About",href="#event.buildLink(prc.xehAbout)#")
			.addSubMenu(name="updates",label="Updates",href="#event.buildLink(prc.xehAutoUpdater)#",permissions="SYSTEM_UPDATES");

		// Content
		addTopMenu(name=this.CONTENT,label="Content")
			.addSubMenu(name="Pages",label="Pages",href="#event.buildLink(prc.xehPages)#")
			.addSubMenu(topMenu=this.CONTENT,name="Blog",label="Blog",href="#event.buildLink(prc.xehEntries)#")
			.addSubMenu(name="Categories",label="Categories",href="#event.buildLink(prc.xehCategories)#")
			.addSubMenu(name="customHTML",label="Custom HTML",href="#event.buildLink(prc.xehCustomHTML)#",permissions="CUSTOMHTML_ADMIN")
			.addSubMenu(name="mediaManager",label="Media Manager",href="#event.buildLink(prc.xehMediaManager)#",permissions="MEDIAMANAGER_ADMIN");

		// Comments
		addTopMenu(name=this.COMMENTS,label="Comments")
			.addSubMenu(name="Inbox",label="Inbox",href="#event.buildLink(prc.xehComments)#")
			.addSubMenu(name="Settings",label="Settings",href="#event.buildLink(prc.xehCommentsettings)#",permissions="COMMENTS_ADMIN");

		// Look and Feel
		addTopMenu(name=this.LOOK_FEEL,label="Look & Feel")
			.addSubMenu(name="Layouts",label="Layouts",href="#event.buildLink(prc.xehLayouts)#",permissions="LAYOUT_ADMIN")
			.addSubMenu(name="Widgets",label="Widgets",href="#event.buildLink(prc.xehWidgets)#",permissions="WIDGET_ADMIN")
			.addSubMenu(name="globalHTML",label="Global HTML",href="#event.buildLink(prc.xehGlobalHTML)#",permissions="GLOBALHTML_ADMIN");

		// Modules
		addTopMenu(name=this.MODULES,label="Modules",permissions="MODULES_ADMIN")
			.addSubMenu(name="Manage",label="Manage",href="#event.buildLink(prc.xehModules)#");

		// User
		addTopMenu(name=this.USERS,label="Users")
			.addSubMenu(name="Manage",label="Manage",href="#event.buildLink(prc.xehAuthors)#")
			.addSubMenu(name="Permissions",label="Permissions",href="#event.buildLink(prc.xehPermissions)#", permissions="PERMISSIONS_ADMIN")
			.addSubMenu(name="Roles",label="Roles",href="#event.buildLink(prc.xehRoles)#", permissions="ROLES_ADMIN");

		// Tools
		addTopMenu(name=this.TOOLS,label="Tools")
			.addSubMenu(name="Import",label="Import",href="#event.buildLink(prc.xehToolsImport)#", permissions="TOOLS_IMPORT")
			.addSubMenu(name="APIDocs",label="API Docs",href="#event.buildLink(prc.xehApiDocs)#");

		// SYSTEM
		addTopMenu(name=this.SYSTEM,label="System",permissions="SYSTEM_TAB")
			.addSubMenu(name="Settings",label="Settings",href="#event.buildLink(prc.xehSettings)#")
			.addSubMenu(name="SecurityRules",label="Security Rules",href="#event.buildLink(prc.xehSecurityRules)#", permissions="SECURITYRULES_ADMIN")
			.addSubMenu(name="EmailTemplates",label="Email Templates",href="#event.buildLink(prc.xehEmailTemplates)#", permissions="EMAIL_TEMPLATE_ADMIN")
			.addSubMenu(name="GeekSettings",label="Geek Settings",href="#event.buildLink(prc.xehRawSettings)#", permissions="SYSTEM_RAW_SETTINGS");

		return this;
	}

	/**
	* Build out ContentBox module links
	*/
	function buildModuleLink(required string module, required string linkTo, queryString="", boolean ssl=false){
		var event 	= requestService.getContext();
		return event.buildLink(linkto="#this.ADMIN_ENTRYPOINT#.module.#arguments.module#.#arguments.linkTo#",
							   queryString=arguments.queryString,
							   ssl=arguments.ssl);
	}

	/**
	* Use a top menu
	*/
	AdminMenuService function withTopMenu(required name){
		thisTopMenu = arguments.name;
		return this;
	}

	/**
	* Add top level menus
	* @name.hint The unique name for this top level menu
	* @label.hint The label for the menu item
	* @title.hint The optional title element
	* @href.hint The href, if any to locate when clicked
	* @target.hint The target to execute the link in, default is same page.
	* @permissions.hint The list of permissions needed to view this menu
	*/
	AdminMenuService function addTopMenu(required name, required label, title="", href="##", target="", permissions=""){
		// stash pointer
		thisTopMenu = arguments.name;
		// store new top menu
		topMenuMap[ arguments.name ] = { submenu = [] };
		structAppend( topMenuMap[ arguments.name ], arguments, true );
		// store in menu container
		arrayAppend( menu, topMenuMap[arguments.name] );
		// return it
		return this;
	}

	/**
	* Add a sub level menu
	* @topMenu.hint The optional top menu name to add this sub level menu to or if concatenated then it uses that one.
	* @name.hint The unique name for this sub level menu
	* @label.hint The label for the menu item
	* @title.hint The optional title element
	* @href.hint The href, if any to locate when clicked
	* @target.hint The target to execute the link in, default is same page.
	* @permissions.hint The list of permissions needed to view this menu
	*/
	AdminMenuService function addSubMenu(topMenu, required name, required label, title="", href="##", target="", permissions=""){
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
	* Remove a sub level menu
	* @topMenu.hint The optional top menu name to add this sub level menu to or if concatenated then it uses that one.
	* @name.hint The unique name for this sub level menu
	*/
	AdminMenuService function removeSubMenu(required topMenu, required name){

		for(var x=1; x lte arrayLen( topMenuMap[ arguments.topMenu ].subMenu ); x++){
			if( topMenuMap[ arguments.topMenu ].subMenu[x].name eq arguments.name ){
				arrayDeleteAt( topMenuMap[ arguments.topMenu ].subMenu, x );
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

		for(var x=1; x lte arrayLen( menu ); x++ ){
			if( menu[ x ].name eq arguments.topMenu ){
				arrayDeleteAt( menu, x );
				structDelete( topMenuMap, arguments.topMenu );
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
		var event 	= requestService.getContext();
		var prc		= event.getCollection(private=true);
		var genMenu = "";

		savecontent variable="genMenu"{
			include "templates/bootstrap-adminMenu.cfm";
		}
		// return it
		return genMenu;
	}

}
