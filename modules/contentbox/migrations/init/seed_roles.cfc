component{

	function seed( schema, query ){
		var admin = {
			roleID : createUUID(),
			isDeleted : 0,
			createdDate : now(),
			modifiedDate : now(),
			role: "Administrator",
			description: "A ContentBox Administrator"
		};
		var editor = {
			roleID : createUUID(),
			isDeleted : 0,
			createdDate : now(),
			modifiedDate : now(),
			role: "Editor",
			description: "A ContentBox Editor"
		};

		// ADMIN ROLE

		query.newQuery()
			.from( "cb_role")
			.insert( admin );

		var allPerms = query.newQuery()
			.from( "cb_permission" )
			.get();

		allPerms.each( ( record ) => {
			query.newQuery()
				.from( "cb_rolePermissions" )
				.insert( {
					FK_permissionID : record.permissionID,
					FK_roleID : admin.roleID
				} );
		} );

		systemOutput( "√ Admin role and permissions created", true );

		// EDITOR ROLE

		query.newQuery()
			.from( "cb_role")
			.insert( editor );

		var editorPerms = [
			"CATEGORIES_ADMIN",
			"COMMENTS_ADMIN",
			"CONTENTBOX_ADMIN",
			"CONTENTSTORE_EDITOR",
			"EDITORS_CACHING",
			"EDITORS_CATEGORIES",
			"EDITORS_CUSTOM_FIELDS",
			"EDITORS_DISPLAY_OPTIONS",
			"EDITORS_EDITOR_SELECTOR",
			"EDITORS_FEATURED_IMAGE",
			"EDITORS_HTML_ATTRIBUTES",
			"EDITORS_LINKED_CONTENT",
			"EDITORS_MODIFIERS",
			"EDITORS_RELATED_CONTENT",
			"EMAIL_TEMPLATE_ADMIN",
			"ENTRIES_EDITOR",
			"GLOBAL_SEARCH",
			"GLOBALHTML_ADMIN",
			"MEDIAMANAGER_ADMIN",
			"MENUS_ADMIN",
			"PAGES_EDITOR",
			"RELOAD_MODULES",
			"RELOAD_CACHES",
			"THEME_ADMIN",
			"VERSIONS_ROLLBACK"
		];

		allPerms.filter( ( record ) => {
			return editorPerms.contains( record.permission );
		} ).each( ( record ) => {
			query.newQuery()
				.from( "cb_rolePermissions" )
				.insert( {
					FK_permissionID : record.permissionID,
					FK_roleID : editor.roleID
				} );
		} );

		systemOutput( "√ Editor role created", true );
		systemOutput( "√ Roles seeded", true );
	}

}
