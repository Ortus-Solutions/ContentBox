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
component accessors="true" singleton{

	// The structure that keeps the menus
	property name="menu"			type="array";
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


	/**
	* Constructor
	* @requestService.inject coldbox:requestService
	*/
	AdminMenuService function init(required requestService){
		// init menu
		menu = [];
		// top menu pointer
		thisTopMenu = "";
		// store request service
		variables.requestService = arguments.requestService;
		// Build out the default menu
		createDefaultMenu();

		return this;
	}

	AdminMenuService function createDefaultMenu(){
		var event 	= requestService.getContext();
		var prc		= event.getCollection(private=true);

		// Dashboard
		addTopMenu(name=this.DASHBOARD,label="Dashboard")
			.addSubMenu(name="home",label="Home",href="#event.buildLink(prc.xehDashboard)#")
			.addSubMenu(name="profile",label="My Profile",href="#event.buildLink(linkto=prc.xehAuthorEditor,querystring="authorID="&prc.oAuthor.getAuthorID())#")
			.addSubMenu(name="About",label="About",href="#event.buildLink(prc.xehAbout)#")
			.addSubMenu(name="Updates",label="Updates",href="#event.buildLink(prc.xehAutoUpdater)#",permissions="SYSTEM_UPDATES");

		// Content
		addTopMenu(name=this.CONTENT,label="Content")
			.addSubMenu(name="Pages",label="Pages",href="#event.buildLink(prc.xehPages)#",title="Manage Site Pages")
			.addSubMenu(name="Categories",label="Categories",href="#event.buildLink(prc.xehCategories)#",title="Manage Content Categories")
			.addSubMenu(name="customHTML",label="Custom HTML",href="#event.buildLink(prc.xehCustomHTML)#",title="Manage Custom HTML Content Pieces")
			.addSubMenu(name="mediaManager",label="Media Manager",href="#event.buildLink(prc.xehMediaManager)#",title="Manage ContentBox Media",permisions="MEDIAMANAGER_ADMIN");
		// Blog Disabled
		if( !prc.cbSettings.cb_site_disable_blog ){
			addSubMenu(topMenu=this.CONTENT,name="Blog",label="Blog",href="#event.buildLink(prc.xehEntries)#",title="Manage Blog Entries");
		}

		// Comments
		addTopMenu(name=this.COMMENTS,label="Comments")
			.addSubMenu(name="Inbox",label="Inbox",href="#event.buildLink(prc.xehComments)#",title="View All Incoming Comments")
			.addSubMenu(name="Settings",label="Settings",href="#event.buildLink(prc.xehCommentsettings)#",title="Configure the ContentBox Commenting System");

		// Look and Feel
		addTopMenu(name=this.LOOK_FEEL,label="Look & Feel")
			.addSubMenu(name="Layouts",label="Layouts",href="#event.buildLink(prc.xehLayouts)#",title="Manage Site Layouts")
			.addSubMenu(name="Widgets",label="Widgets",href="#event.buildLink(prc.xehWidgets)#",title="Manager your UI widgets")
			.addSubMenu(name="globalHTML",label="Global HTML",href="#event.buildLink(prc.xehGlobalHTML)#",title="Easy global HTML for your layouts");

		// Modules
		addTopMenu(name=this.MODULES,label="Modules")
			.addSubMenu(name="Manage",label="Manage",href="#event.buildLink(prc.xehModules)#",title="Manage Modules");

		// User
		addTopMenu(name=this.USERS,label="Users")
			.addSubMenu(name="Manage",label="Manage",href="#event.buildLink(prc.xehAuthors)#",title="Manage Site Users")
			.addSubMenu(name="Permissions",label="Permissions",href="#event.buildLink(prc.xehPermissions)#",title="Manage ContentBox Security Permissions",permissions="PERMISSIONS_ADMIN")
			.addSubMenu(name="Roles",label="Roles",href="#event.buildLink(prc.xehRoles)#",title="Manage ContentBox Security Roles",permissions="ROLES_ADMIN");

		// Tools
		addTopMenu(name=this.TOOLS,label="Tools")
			.addSubMenu(name="Import",label="Import",href="#event.buildLink(prc.xehToolsImport)#",title="Import your database from other systems",permissions="TOOLS_IMPORT")
			.addSubMenu(name="APIDocs",label="API Docs",href="#event.buildLink(prc.xehApiDocs)#",title="Inspect your ContentBox API");

		// SYSTEM
		addTopMenu(name=this.SYSTEM,label="System",permissions="SYSTEM_TAB")
			.addSubMenu(name="Settings",label="Settings",href="#event.buildLink(prc.xehSettings)#",title="Manage ContentBox Global Configuration")
			.addSubMenu(name="SecurityRules",label="Security Rules",href="#event.buildLink(prc.xehSecurityRules)#",title="Manage ContentBox Security Rules")
			.addSubMenu(name="EmailTemplates",label="Email Templates",href="#event.buildLink(prc.xehRoles)#",title="Manage ContentBox Email Templates",permissions="EMAIL_TEMPLATE_ADMIN")
			.addSubMenu(name="GeekSettings",label="Geek Settings",href="#event.buildLink(prc.xehRawSettings)#",title="Manage The Raw Settings Geek Style",permissions="SYSTEM_RAW_SETTINGS");

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
	AdminMenuService function addTopMenu(required name, required label, title="", href="", target="", permissions=""){
		thisTopMenu = arguments.name;


		return this;
	}

	/**
	* Add a sub level menu
	* @topMenu.hint The top menu name to add this sub level menu to or if concatenated then it uses that one.
	* @name.hint The unique name for this sub level menu
	* @label.hint The label for the menu item
	* @title.hint The optional title element
	* @href.hint The href, if any to locate when clicked
	* @target.hint The target to execute the link in, default is same page.
	* @permissions.hint The list of permissions needed to view this menu
	*/
	AdminMenuService function addSubMenu(topMenu, required name, required label, title="", href="", target="", permissions=""){
		// Check if thisTopMenu set?
		if( !len(thisTopMenu) AND !structKeyExists(arguments,"topMenu") ){ throw("No top menu passed or concatenated with"); }
		// check this
		if( len(thisTopMenu) AND !structKeyExists(arguments,"topMenu")){ arguments.topmenu = thisTopMenu; }

		return this;
	}

}
