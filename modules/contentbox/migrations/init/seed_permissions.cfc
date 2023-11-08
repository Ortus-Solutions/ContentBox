component{

	function seed( schema, query ){
		var perms = [
			{
				permission : "AUTHOR_ADMIN",
				description : "Ability to manage authors, default is view only"
			},
			{
				permission : "CATEGORIES_ADMIN",
				description : "Ability to manage categories, default is view only"
			},
			{
				permission : "COMMENTS_ADMIN",
				description : "Ability to manage comments, default is view only"
			},
			{
				permission : "CONTENTBOX_ADMIN",
				description : "Access to the enter the ContentBox administrator console"
			},
			{
				permission : "CONTENTSTORE_ADMIN",
				description : "Ability to manage the content store, default is view only"
			},
			{
				permission : "CONTENTSTORE_EDITOR",
				description : "Ability to create, edit and publish content store elements"
			},
			{
				permission : "EDITORS_CACHING",
				description : "Ability to view the content caching panel"
			},
			{
				permission : "EDITORS_CATEGORIES",
				description : "Ability to view the content categories panel"
			},
			{
				permission : "EDITORS_CUSTOM_FIELDS",
				description : "Ability to manage custom fields in any content editors"
			},
			{
				permission : "EDITORS_DISPLAY_OPTIONS",
				description : "Ability to view the content display options panel"
			},
			{
				permission : "EDITORS_EDITOR_SELECTOR",
				description : "Ability to change the editor to another registered online editor"
			},
			{
				permission : "EDITORS_FEATURED_IMAGE",
				description : "Ability to view the featured image panel"
			},
			{
				permission : "EDITORS_HTML_ATTRIBUTES",
				description : "Ability to view the content HTML attributes panel"
			},
			{
				permission : "EDITORS_LINKED_CONTENT",
				description : "Ability to view the linked content panel"
			},
			{
				permission : "EDITORS_MODIFIERS",
				description : "Ability to view the content modifiers panel"
			},
			{
				permission : "EDITORS_RELATED_CONTENT",
				description : "Ability to view the related content panel"
			},
			{
				permission : "EMAIL_TEMPLATE_ADMIN",
				description : "Ability to admin and preview email templates"
			},
			{
				permission : "ENTRIES_ADMIN",
				description : "Ability to manage blog entries, default is view only"
			},
			{
				permission : "ENTRIES_EDITOR",
				description : "Ability to create, edit and publish blog entries"
			},
			{
				permission : "FORGEBOX_ADMIN",
				description : "Ability to manage ForgeBox installations and connectivity."
			},
			{
				permission : "GLOBAL_SEARCH",
				description : "Ability to do global searches in the ContentBox Admin"
			},
			{
				permission : "GLOBALHTML_ADMIN",
				description : "Ability to manage the system's global HTML content used on layouts"
			},
			{
				permission : "MEDIAMANAGER_ADMIN",
				description : "Ability to manage the system's media manager"
			},
			{
				permission : "MEDIAMANAGER_LIBRARY_SWITCHER",
				description : "Ability to switch media manager libraries for management"
			},
			{
				permission : "MENUS_ADMIN",
				description : "Ability to manage the menu builder"
			},
			{
				permission : "MODULES_ADMIN",
				description : "Ability to manage ContentBox Modules"
			},
			{
				permission : "PAGES_ADMIN",
				description : "Ability to manage content pages, default is view only"
			},
			{
				permission : "PAGES_EDITOR",
				description : "Ability to create, edit and publish pages"
			},
			{
				permission : "PERMISSIONS_ADMIN",
				description : "Ability to manage permissions, default is view only"
			},
			{
				permission : "RELOAD_MODULES",
				description : "Ability to reload modules"
			},
			{
				permission : "ROLES_ADMIN",
				description : "Ability to manage roles, default is view only"
			},
			{
				permission : "SECURITYRULES_ADMIN",
				description : "Ability to manage the system's security rules, default is view only"
			},
			{
				permission : "SITES_ADMIN",
				description : "Ability to manage sites"
			},
			{
				permission : "SYSTEM_AUTH_LOGS",
				description : "Access to the system auth logs"
			},
			{
				permission : "SYSTEM_RAW_SETTINGS",
				description : "Access to the ContentBox raw geek settings panel"
			},
			{
				permission : "SYSTEM_SAVE_CONFIGURATION",
				description : "Ability to update global configuration data"
			},
			{
				permission : "SYSTEM_TAB",
				description : "Access to the ContentBox System tools"
			},
			{
				permission : "SYSTEM_UPDATES",
				description : "Ability to view and apply ContentBox updates"
			},
			{
				permission : "THEME_ADMIN",
				description : "Ability to manage layouts, default is view only"
			},
			{
				permission : "TOOLS_EXPORT",
				description : "Ability to export data from ContentBox"
			},
			{
				permission : "TOOLS_IMPORT",
				description : "Ability to import data into ContentBox"
			},
			{
				permission : "VERSIONS_DELETE",
				description : "Ability to delete past content versions"
			},
			{
				permission : "VERSIONS_ROLLBACK",
				description : "Ability to rollback content versions"
			},
			{
				permission : "WIDGET_ADMIN",
				description : "Ability to manage widgets, default is view only"
			}
		];

		perms = perms.map( ( thisPerm ) => {
			thisPerm.permissionID = createUUID();
			thisPerm.isDeleted = 0;
			thisPerm.createdDate = thisPerm.modifiedDate = now();
			return thisPerm;
		} );

		query.newQuery()
			.from( "cb_permission")
			.insert( perms );

		systemOutput( "√ Permissions seeded", true );
	}

}
