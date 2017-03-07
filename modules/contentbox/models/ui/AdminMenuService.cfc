/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
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
	* This holds the support menu structure
	*/
	property name="supportMenu"		type="array";
	/**
	* This holds the utils menu structure
	*/
	property name="utilsMenu"		type="array";
	/**
	* This holds the profile menu structure
	*/
	property name="profileMenu"		type="array";
	/**
	* This is a reference map of the headerMenu array
	*/
	property name="headerMenuMap"	type="struct";
	
	/**
	* Injected Avatar
	*/
	property name="avatar"			type="any" inject="Avatar@cb";
	 
	// Top Menu Slugs
	this.DASHBOARD 		= "dashboard";
	this.CONTENT 		= "content";
	this.COMMENTS		= "comments";
	this.LOOK_FEEL		= "lookAndFeel";
	this.MODULES		= "modules";
	this.USERS			= "users";
	this.TOOLS			= "tools";
	this.SYSTEM			= "system";
	this.STATS			= "stats";
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
		// init header menu array
		variables.supportMenu = [];
		// init header menu array
		variables.utilsMenu = [];
		// init header menu array
		variables.profileMenu = [];
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
	 * Build LI attributes
	 * @event The event context 
	 * @menu The menu struct
	 */
	function buildLIAttributes( required any event, required any menu ) {
        var attributes = {
            "class" = "#menu.class#",
            "data-name" = "#menu.name#"
        };
        if( structKeyExists( menu, "id" ) && len( menu.id ) ) {
    		attributes[ "id" ] = menu.id;
    	}
        if( event.getValue( name='tab#menu.name#', defaultValue=false, private=true ) ) {
            listAppend( attributes.class, "active", " " );
        }
        return createAttributeList( attributes );
    }

    /**
     * Build Item Attributes
     * @event The event context 
	 * @menu The menu struct
	 * @structDefaults The struct defaults for the item
     */
    function buildItemAttributes( required any event, required any menu, structDefaults={} ) {
    	var attributes = {
    		"class" = structKeyExists( structDefaults, "class" ) ? structDefaults.class : ""
    	};
    	if( len( arguments.menu.itemClass ) ) {
    		attributes.class &= " #arguments.menu.itemClass#";
    	}
    	if( len( arguments.menu.itemId ) ) {
    		attributes[ "id" ] = arguments.menu.itemId;
    	}
    	if( structKeyExists( menu, "subMenu" ) && arrayLen( arguments.menu.subMenu ) ) {
    		attributes[ "data-toggle" ] = "dropdown";
    	}	
    	if( arguments.menu.itemType=="a" ) {
    		attributes[ "href" ] = "#( isCustomFunction( arguments.menu.href ) ? arguments.menu.href( arguments.menu, arguments.event ) : arguments.menu.href )#";
    	}
    	if( arguments.menu.itemType=="button" ) {
    		attributes[ "onclick" ] = "#( isCustomFunction( arguments.menu.href ) ? arguments.menu.href( arguments.menu, arguments.event ) : arguments.menu.href )#";
    	}
    	if( len( arguments.menu.title ) ) {
    		attributes[ "title" ] = "#arguments.menu.title#";
    	}
    	if( arguments.menu.itemType=="a" && len( arguments.menu.target ) ) {
    		attributes[ "target" ] = "#arguments.menu.target#";
    	}
    	var attributeList = createAttributeList( attributes );
    	if( structKeyExists( menu, "data" ) && structCount( arguments.menu.data ) ) {
    		attributeList &= " " & parseADataAttributes( arguments.menu.data );
    	}
    	return attributeList;
	}

	/**
	 * Create the attribute list
	 * @attributes The struct of attributes to build the list from
	 */
    function createAttributeList( required struct attributes ) {
        var attributeList = "";
        for( var key in arguments.attributes ) {
            attributeList &= '#key#="#attributes[ key ]#"';
        }
        return attributeList;
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
		var xehAdminAction		= "/#this.ADMIN_ENTRYPOINT#/dashboard/reload";

		// Register About Menu
		addHeaderMenu( 
			name="about", 
			label='<i class="fa fa-info"></i>', 
			permissions="SYSTEM_TAB", 
			class="dropdown settings", 
			itemType="button", 
			itemClass="btn btn-default options toggle", 
			href="javascript:void(0)",
			data={ placement = "right" },
			title="About ContentBox"
		)
		.addHeaderSubMenu( 
			name="support", 
			label='<i class="fa fa-ambulance"></i> Professional Support', 
			href="http://www.ortussolutions.com/services/support", 
			target="_blank" 
		)
		.addHeaderSubMenu( 
			name="docs", 
			label='<i class="fa fa-book"></i> Documentation', 
			href="http://contentbox.ortusbooks.com", 
			target="_blank" 
		)
		.addHeaderSubMenu( 
			name="forums", 
			label='<i class="fa fa-envelope"></i> Support Forums', 
			href="https://groups.google.com/forum/?fromgroups##!forum/contentbox", 
			target="_blank" 
		)
		.addHeaderSubMenu( 
			name="twitter", 
			label='<i class="fa fa-twitter"></i> Twitter', 
			href="https://www.twitter.com/gocontentbox", 
			target="_blank" 
		)
		.addHeaderSubMenu( 
			name="facebook", 
			label='<i class="fa fa-facebook"></i> Facebook', 
			href="https://www.facebook.com/gocontentbox", 
			target="_blank" 
		)
		.addHeaderSubMenu( 
			name="updates", 
			label='<i class="fa fa-download"></i> Check for Updates', 
			href=variables.buildLink,
			href_to=xehAutoUpdates
		)
		.addHeaderSubMenu( 
			name="buildid", 
			label='ContentBox v.#variables.moduleConfig.version# <br /><span class="label label-warning">(Codename: #variables.moduleConfig.settings.codename#)</span>', 
			href=variables.buildLink,
			href_to=xehAbout,
			class="last"
		);

		// Register Profile Menu
		addHeaderMenu( 
			name="profile", 
			label=variables.buildProfileLabel, 
			class="dropdown settings" 
		)
		.addHeaderSubMenu( 
			name="myprofile", 
			title="ctrl+shift+A", 
			label="<i class='fa fa-camera'></i> My Profile", 
			href=variables.buildLink,
			href_to=xehMyProfile,
			data={ keybinding="ctrl+shift+a" } 
		)
		.addHeaderSubMenu( 
			name="logout", 
			title="ctrl+shift+L", 
			label="<i class='fa fa-power-off'></i> Logout", 
			href=variables.buildLink,
			href_to=xehDoLogout,
			data={ keybinding="ctrl+shift+l" } 
		);
		// Register modules reload menu
		addHeaderMenu( 
			name="utils", 
			label='<i class="fa fa-cog"></i>', 
			class="dropdown settings", 
			itemType="button", 
			itemClass="btn btn-default options toggle", 
			permissions="RELOAD_MODULES",
			data={ placement = "right" },
			title="Admin Actions"
		)
		.addHeaderSubMenu( 
			name="rsscache", 
			label="Clear RSS Caches", 
			href="javascript:adminAction( 'rss-purge', '#event.buildLink(xehAdminAction)#' )" 
		)
		.addHeaderSubMenu( 
			name="contentpurge", 
			label="Clear Content Caches", 
			href="javascript:adminAction( 'content-purge', '#event.buildLink(xehAdminAction)#' )" 
		)
		.addHeaderSubMenu( 
			name="app", 
			label="Reload Application", 
			href="javascript:adminAction( 'app', '#event.buildLink(xehAdminAction)#' )" 
		)
		.addHeaderSubMenu( 
			name="orm", 
			label="Reload ORM", 
			href="javascript:adminAction( 'orm', '#event.buildLink(xehAdminAction)#' )" 
		)
		.addHeaderSubMenu( 
			name="contentboxadmin", 
			label="Reload Admin Module", 
			href="javascript:adminAction( 'contentbox-admin', '#event.buildLink(xehAdminAction)#' )" 
		)
		.addHeaderSubMenu( 
			name="contentboxui", 
			label="Reload Site Module", 
			href="javascript:adminAction( 'contentbox-ui', '#event.buildLink(xehAdminAction)#' )" 
		);
		return this;
	}

	/**
	 * Dynamic href's due to cgi host or site changes.
	 * This expects a menu.href_to to exist.
	 * @menu The menu info
	 * @event The request context
	 */
	function buildLink( required menu, required event ){
		if( structKeyExists( arguments.menu, "href_to" ) ){
			return arguments.event.buildLink( arguments.menu.href_to );
		}
		return 'NO_HREF_TO_OR_JS';
	}

	/**
	* Dynamic menu label
	*/
	function buildProfileLabel(){
		var event 	= requestService.getContext();
		var prc		= event.getCollection( private=true );
		
		savecontent variable="profileLabel" {
			writeOutput( '#prc.oAuthor.getName()# <b class="caret"></b>' );
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
		prc.xehThemes		= "#this.ADMIN_ENTRYPOINT#.themes";
		prc.xehactiveTheme	= "#this.ADMIN_ENTRYPOINT#.themes.active";
		prc.xehWidgets		= "#this.ADMIN_ENTRYPOINT#.widgets";
		prc.xehGlobalHTML	= "#this.ADMIN_ENTRYPOINT#.globalHTML";

		// Modules
		prc.xehModules 		= "#this.ADMIN_ENTRYPOINT#.modules";

		// Authors Tab
		prc.xehAuthors			= "#this.ADMIN_ENTRYPOINT#.authors";
		prc.xehAuthorEditor		= "#this.ADMIN_ENTRYPOINT#.authors.editor";
		prc.xehPermissions		= "#this.ADMIN_ENTRYPOINT#.permissions";
		prc.xehRoles			= "#this.ADMIN_ENTRYPOINT#.roles";

		// Tools
		prc.xehToolsImport		= "#this.ADMIN_ENTRYPOINT#.tools.importer";
		prc.xehToolsExport		= "#this.ADMIN_ENTRYPOINT#.tools.exporter";

		// System
		prc.xehSettings			= "#this.ADMIN_ENTRYPOINT#.settings";
		prc.xehSecurityRules	= "#this.ADMIN_ENTRYPOINT#.securityrules";
		prc.xehRawSettings		= "#this.ADMIN_ENTRYPOINT#.settings.raw";
		prc.xehAuthLogs			= "#this.ADMIN_ENTRYPOINT#.settings.authLogs";
		prc.xehAutoUpdater	    = "#this.ADMIN_ENTRYPOINT#.autoupdates";
		
		// Stats
		prc.xehSubscribers		= "#this.ADMIN_ENTRYPOINT#.subscribers";

		// Dashboard
		addTopMenu( name=this.DASHBOARD, label="<i class='fa fa-dashboard'></i> Dashboard" )
			.addSubMenu( name="home", label="Home", href=variables.buildLink, href_to=prc.xehDashboard )
			.addSubMenu( name="about", label="About", href=variables.buildLink, href_to=prc.xehAbout );

		// Content
		addTopMenu( name=this.CONTENT, label="<i class='fa fa-pencil'></i> Content" )
			.addSubMenu( topMenu=this.CONTENT,name="Blog", label="Blog", href=variables.buildLink, href_to=prc.xehEntries, permissions="ENTRIES_ADMIN,ENTRIES_EDITOR" )
			.addSubMenu( name="Categories", label="Categories", href=variables.buildLink, href_to=prc.xehCategories, permissions="CATEGORIES_ADMIN" )
			.addSubMenu( name="contentStore", label="Content Store", href=variables.buildLink, href_to=prc.xehContentStore, permissions="CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )
			.addSubMenu( name="mediaManager", label="Media Manager", href=variables.buildLink, href_to=prc.xehMediaManager, permissions="MEDIAMANAGER_ADMIN" )
			.addSubMenu( name="menu", label="Menu Manager", href=variables.buildLink, href_to=prc.xehMenuManager, permissions="MENUS_ADMIN" )
			.addSubMenu( name="Pages", label="Sitemap", href=variables.buildLink, href_to=prc.xehPages, permissions="PAGES_ADMIN,PAGES_EDITOR" );

		// Comments
		addTopMenu( name=this.COMMENTS, label="<i class='fa fa-comment'></i> Comments" )
			.addSubMenu( name="Inbox", label="Inbox", href=variables.buildLink, href_to=prc.xehComments, permissions="COMMENTS_ADMIN" )
			.addSubMenu( name="Settings", label="Settings", href=variables.buildLink, href_to=prc.xehCommentsettings, permissions="COMMENTS_ADMIN" );

		// Look and Feel
		addTopMenu( name=this.LOOK_FEEL, label="<i class='fa fa-tint'></i> Look & Feel" )
			.addSubMenu( name="activetheme", label="Active Theme", href=variables.buildLink, href_to=prc.xehActiveTheme, permissions="THEME_ADMIN" )
			.addSubMenu( name="globalHTML", label="Global HTML", href=variables.buildLink, href_to=prc.xehGlobalHTML, permissions="GLOBALHTML_ADMIN" )
			.addSubMenu( name="Themes", label="Themes", href=variables.buildLink, href_to=prc.xehThemes, permissions="THEME_ADMIN" )
			.addSubMenu( name="Widgets", label="Widgets", href=variables.buildLink, href_to=prc.xehWidgets, permissions="WIDGET_ADMIN" );

		// Modules
		addTopMenu( name=this.MODULES, label="<i class='fa fa-bolt'></i> Modules", permissions="MODULES_ADMIN" )
			.addSubMenu( name="Manage", label="Manage", href=variables.buildLink, href_to=prc.xehModules );

		// User
		addTopMenu( name=this.USERS, label="<i class='fa fa-user'></i> Users" )
			.addSubMenu( name="Manage", label="Manage", href=variables.buildLink, href_to=prc.xehAuthors, permissions="AUTHOR_ADMIN" )
			.addSubMenu( name="Permissions", label="Permissions", href=variables.buildLink, href_to=prc.xehPermissions, permissions="PERMISSIONS_ADMIN" )
			.addSubMenu( name="Roles", label="Roles", href=variables.buildLink, href_to=prc.xehRoles, permissions="ROLES_ADMIN" );

		// Tools
		addTopMenu( name=this.TOOLS, label="<i class='fa fa-wrench'></i> Tools" )
			.addSubMenu( name="Import", label="Import", href=variables.buildLink, href_to=prc.xehToolsImport, permissions="TOOLS_IMPORT" )
			.addSubMenu( name="Export", label="Export", href=variables.buildLink, href_to=prc.xehToolsExport, permissions="TOOLS_EXPORT" );

		// SYSTEM
		addTopMenu( name=this.SYSTEM, label="<i class='fa fa-briefcase'></i> System", permissions="SYSTEM_TAB" )
			.addSubMenu( name="AuthLogs", label="Auth Logs", href=variables.buildLink, href_to=prc.xehAuthLogs, permissions="SYSTEM_AUTH_LOGS" )
			.addSubMenu( name="GeekSettings", label="Geek Settings", href=variables.buildLink, href_to=prc.xehRawSettings, permissions="SYSTEM_RAW_SETTINGS" )
			.addSubMenu( name="Settings", label="Settings", href=variables.buildLink, href_to=prc.xehSettings, data={ "keybinding"="ctrl+shift+c" }, title="ctrl+shift+C" )
			.addSubMenu( name="SecurityRules", label="Security Rules", href=variables.buildLink, href_to=prc.xehSecurityRules, permissions="SECURITYRULES_ADMIN" )
			.addSubMenu( name="updates", label="Updates", href=variables.buildLink, href_to=prc.xehAutoUpdater, permissions="SYSTEM_UPDATES" );
		
		// STATS
		addTopMenu( name=this.STATS, label="<i class='fa fa-bar-chart-o'></i> Stats" )
			.addSubMenu( name="Subscribers", label="Subscribers", href=variables.buildLink, href_to=prc.xehSubscribers, title="View Subscribers" );

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
	* @class.hint A CSS class list to append to the element
	* @id.hint An id to apply to the element
	* @itemType.hint The type of element to create (e.g., a tag, button, etc.)
	* @itemClass.hint A CSS class list to append to the element
	* @itemId.hint An id to apply to the item element
	*/
	AdminMenuService function addTopMenu( required name, required label, title="", href="##", target="", permissions="", data=structNew(), class="", id="", itemType="a", itemClass="", itemId=""  ){
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
	* @class.hint A CSS class list to append to the element
	* @id.hint An id to apply to the element
	* @itemType.hint The type of element to create (e.g., a tag, button, etc.)
	* @itemClass.hint A CSS class list to append to the element
	* @itemId.hint An id to apply to the item element
	*/
	AdminMenuService function addHeaderMenu( required name, required label, title="", href="javascript:void( null )", target="", permissions="", data=structNew(), class="", id="", itemType="a", itemClass="", itemId="" ){
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
	* @class.hint A CSS class list to append to the element
	* @id.hint An id to apply to the element
	* @itemType.hint The type of element to create (e.g., a tag, button, etc.)
	* @itemClass.hint A CSS class list to append to the element
	* @itemId.hint An id to apply to the item element
	*/
	AdminMenuService function addSubMenu(topMenu, required name, required label, title="", href="##", target="", permissions="", data=structNew(), class="", id="", itemType="a", itemClass="", itemId="" ){
		// Check if thisTopMenu set?
		if( !len(thisTopMenu) AND !structKeyExists(arguments,"topMenu" ) ){ throw( "No top menu passed or concatenated with" ); }
		// check this pointer
		if( len(thisTopMenu) AND !structKeyExists(arguments,"topMenu" )){ arguments.topmenu = thisTopMenu; }
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
	* @class.hint A CSS class list to append to the element
	* @id.hint An id to apply to the element
	* @itemType.hint The type of element to create (e.g., a tag, button, etc.)
	* @itemClass.hint A CSS class list to append to the element
	* @itemId.hint An id to apply to the item element
	*/
	AdminMenuService function addHeaderSubMenu( headerMenu, required name, required label, title="", href="##", target="", permissions="", data=structNew(), class="", iid="", itemType="a", itemClass="", itemId="" ){
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

	any function generateSupportMenu() {
		var event 		= requestService.getContext();
		var prc			= event.getCollection( private=true );
		var genMenu 	= "";
		var thisMenu 	= variables.headerMenuMap[ "about" ];

		savecontent variable="genMenu"{
			include "templates/subNav.cfm";
		}

		// return it
		return genMenu;
	}

	any function generateUtilsMenu() {
		var event 		= requestService.getContext();
		var prc			= event.getCollection( private=true );
		var genMenu 	= "";
		var thisMenu 	= variables.headerMenuMap[ "utils" ];

		savecontent variable="genMenu"{
			include "templates/subNav.cfm";
		}

		// return it
		return genMenu;
	}

	any function generateProfileMenu() {
		var event 		= requestService.getContext();
		var prc			= event.getCollection( private=true );
		var genMenu 	= "";
		var thisMenu 	= variables.headerMenuMap[ "profile" ];

		savecontent variable="genMenu"{
			include "templates/subNav.cfm";
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
