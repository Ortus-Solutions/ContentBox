component {

	function seed( schema, query ){
		var admin = {
			roleID       : createUUID(),
			isDeleted    : 0,
			createdDate  : now(),
			modifiedDate : now(),
			role         : "Administrator",
			description  : "A ContentBox Administrator"
		};
		var editor = {
			roleID       : createUUID(),
			isDeleted    : 0,
			createdDate  : now(),
			modifiedDate : now(),
			role         : "Editor",
			description  : "A ContentBox Editor"
		};

		// ADMIN ROLE

		query
			.newQuery()
			.from( "cb_role" )
			.insert( admin );

		var allPerms = query
			.newQuery()
			.from( "cb_permission" )
			.get();

		allPerms.each( ( record ) => {
			query
				.newQuery()
				.from( "cb_rolePermissions" )
				.insert( {
					FK_permissionID : record.permissionID,
					FK_roleID       : admin.roleID
				} );
		} );

		systemOutput( "√ Admin role and permissions created", true );

		// EDITOR ROLE

		query
			.newQuery()
			.from( "cb_role" )
			.insert( editor );

		var editorPerms = [
			"COMMENTS_ADMIN",
			"CONTENTSTORE_EDITOR",
			"PAGES_EDITOR",
			"CATEGORIES_ADMIN",
			"ENTRIES_EDITOR",
			"THEME_ADMIN",
			"GLOBALHTML_ADMIN",
			"MEDIAMANAGER_ADMIN",
			"VERSIONS_ROLLBACK",
			"CONTENTBOX_ADMIN",
			"EDITORS_LINKED_CONTENT",
			"EDITORS_DISPLAY_OPTIONS",
			"EDITORS_RELATED_CONTENT",
			"EDITORS_MODIFIERS",
			"EDITORS_CACHING",
			"EDITORS_CATEGORIES",
			"EDITORS_HTML_ATTRIBUTES",
			"EDITORS_EDITOR_SELECTOR",
			"EDITORS_CUSTOM_FIELDS",
			"GLOBAL_SEARCH",
			"MENUS_ADMIN",
			"EDITORS_FEATURED_IMAGE",
			"EMAIL_TEMPLATE_ADMIN"
		];

		allPerms
			.filter( ( record ) => {
				return editorPerms.contains( record.permission );
			} )
			.each( ( record ) => {
				query
					.newQuery()
					.from( "cb_rolePermissions" )
					.insert( {
						FK_permissionID : record.permissionID,
						FK_roleID       : editor.roleID
					} );
			} );

		systemOutput( "√ Editor role created", true );
		systemOutput( "√ Roles seeded", true );
	}

}
