component {

	function up( schema, qb ) {
		schema.alter(
				"cb_content",
				( table ) => {
					table.index(
							[ "isPublished", "contentType", "passwordProtection", "FK_siteID", "publishedDate"],
							"idx_content_published_search"
						);
				}
			);

		schema.alter(
				"cb_contentCategories",
				( table ) => {
					table.index(
							[ "FK_categoryID", "FK_contentID"],
							"idx_category_content"
						);
					table.index(
							[ "FK_contentID", "FK_categoryID"],
							"idx_content_category"
						);
				}
			);
	}

	function down( schema, qb ) {
		schema.alter(
				"cb_contentCategories",
				( table ) => {
					table.dropIndex( "idx_content_category" );
					table.dropIndex( "idx_category_content" );
				}
			);

		schema.alter(
				"cb_content",
				( table ) => {
					table.dropIndex( "idx_content_published_search" );
				}
			);
	}

}