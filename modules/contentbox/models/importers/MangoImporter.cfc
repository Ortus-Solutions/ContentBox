/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Import a mango database into contentbox
 */
component implements="contentbox.models.importers.ICBImporter" {

	// DI
	property name="categoryService" inject="id:categoryService@contentbox";
	property name="entryService" inject="id:entryService@contentbox";
	property name="pageService" inject="id:pageService@contentbox";
	property name="authorService" inject="id:authorService@contentbox";
	property name="roleService" inject="id:roleService@contentbox";
	property name="commentService" inject="id:commentService@contentbox";
	property name="customFieldService" inject="id:customFieldService@contentbox";
	property name="log" inject="logbox:logger:{this}";
	property name="htmlHelper" inject="HTMLHelper@coldbox";
	property name="bCrypt" inject="BCrypt@BCrypt";


	/**
	 * Constructor
	 */
	MangoImporter function init(){
		return this;
	}

	/**
	 * Import from mango blog, returns the string console.
	 */
	function execute(
		required dsn,
		dsnUsername     = "",
		dsnPassword     = "",
		defaultPassword = "",
		required roleID,
		tableprefix = ""
	){
		var authorMap   = {};
		var catMap      = {};
		var entryMap    = {};
		var pageMap     = {};
		var slugMap     = {};
		var pageSlugMap = {};

		log.info( "Starting import process: #arguments.toString()#" );

		try {
			/************************************** CATEGORIES *********************************************/

			var q = new Query(
				datasource = arguments.dsn,
				username   = arguments.dsnUsername,
				password   = arguments.dsnPassword,
				sql        = "select * from #arguments.tablePrefix#category"
			).execute().getResult();
			for ( var x = 1; x lte q.recordcount; x++ ) {
				var props  = { category : q.title[ x ], slug : q.name[ x ] };
				var cat    = categoryService.new( properties = props );
				var exists = categoryService.findAllBySlug( q.name[ x ] );

				if ( arrayLen( exists ) ) {
					cat = exists[ 1 ];
				} else {
					entitySave( cat );
				}

				log.info( "Imported category: #props.category#" );
				catMap[ q.id[ x ] ] = cat.getCategoryID();
			}
			log.info( "Categories imported successfully!" );

			/************************************** AUTHORS *********************************************/

			log.info( "Starting to import Authors...." );
			// Get the default role
			var defaultRole = roleService.get( arguments.roleID );
			// Import Authors
			var q           = new Query(
				datasource = arguments.dsn,
				username   = arguments.dsnUsername,
				password   = arguments.dsnPassword,
				sql        = "select * from #arguments.tablePrefix#author"
			).execute().getResult();
			for ( var x = 1; x lte q.recordcount; x++ ) {
				var props = {
					email     : q.email[ x ],
					username  : q.username[ x ],
					password  : bcrypt.hashPassword( defaultPassword ),
					isActive  : 1,
					firstName : listFirst( q.name[ x ], " " ),
					lastName  : trim( replaceNoCase( q.name[ x ], listFirst( q.name[ x ], " " ), "" ) )
				};
				var author = authorService.new( properties = props );
				author.setRole( defaultRole );
				// duplicate usernames
				if ( authorService.usernameFound( props.username ) ) {
					author.setUsername( props.username & "-#left( hash( now() ), 5 )#" );
				}

				entitySave( author );
				log.info( "Imported author: #props.firstName# #props.lastName#" );
				authorMap[ q.id[ x ] ] = author.getAuthorID();
			}
			log.info( "Authors imported successfully!" );

			/************************************** PAGES *********************************************/
			log.info( "Starting to import Pages...." );
			// Import Pages
			var qPages = new Query(
				datasource = arguments.dsn,
				username   = arguments.dsnUsername,
				password   = arguments.dsnPassword,
				sql        = "select me.*, mp.parent_page_id, mp.hierarchy, mp.sort_order
									from #arguments.tablePrefix#entry me, #arguments.tablePrefix#page mp
									where me.id = mp.id
									order by mp.hierarchy"
			).execute().getResult();
			for ( var x = 1; x lte qPages.recordcount; x++ ) {
				// Get properties
				var published = true;
				if ( qPages.status[ x ] neq "published" ) {
					published = false;
				}
				var props = {
					title         : qPages.title[ x ],
					slug          : qPages.name[ x ],
					content       : qPages.content[ x ],
					excerpt       : qPages.excerpt[ x ],
					publishedDate : qPages.last_modified[ x ],
					createdDate   : qPages.last_modified[ x ],
					isPublished   : published,
					allowComments : qPages.comments_allowed[ x ],
					order         : qPages.sort_order[ x ],
					layout        : "pages"
				};

				// slug checks
				if ( !len( trim( props.slug ) ) ) {
					props.slug = htmlHelper.slugify( props.title );
				}
				// check if slug already in map
				if ( structKeyExists( pageSlugMap, props.slug ) ) {
					// unique it
					props.slug &= "-" & left( hash( now() ), 5 );
				}
				pageSlugMap[ props.slug ] = "found";

				var page = pageService.new( properties = props );
				// Add content versionized!
				page.addNewContentVersion(
					content   = props.content,
					changelog = "Imported content",
					author    = authorService.get( authorMap[ qPages.author_id[ x ] ] )
				);
				page.setCreator( authorService.get( authorMap[ qPages.author_id[ x ] ] ) );
				// Custom Fields
				log.info( "Starting to import Page Custom Fields...." );
				var qCustomFields = new Query(
					datasource = arguments.dsn,
					username   = arguments.dsnUsername,
					password   = arguments.dsnPassword,
					sql        = "select * from #arguments.tablePrefix#entry_custom_field as cf where cf.entry_id = '#qPages.id[ x ]#'"
				).execute().getResult();
				for ( var y = 1; y lte qCustomFields.recordcount; y++ ) {
					var props = {
						key   : qCustomFields.name[ y ],
						value : qCustomFields.field_value[ y ]
					};
					var thisCustomField = customFieldService.new( properties = props );
					page.addCustomField( thisCustomField );
					thisCustomField.setRelatedContent( page );
				}

				// Save page and store in reference map
				pageMap[ qPages.id[ x ] ] = page;
				entitySave( page );

				log.info( "Starting to import Page Comments...." );
				// Import page comments
				var qComments = new Query(
					datasource = arguments.dsn,
					username   = arguments.dsnUsername,
					password   = arguments.dsnPassword,
					sql        = "select * from #arguments.tablePrefix#comment as mc where mc.entry_id = '#qPages.id[ x ]#'"
				).execute().getResult();
				for ( var y = 1; y lte qComments.recordcount; y++ ) {
					var props = {
						content     : qComments.content[ y ],
						author      : qComments.creator_name[ y ],
						authorIP    : "127.0.0.1",
						authorEmail : qComments.creator_email[ y ],
						authorURL   : qComments.creator_url[ y ],
						createdDate : qComments.created_on[ y ],
						isApproved  : qComments.approved[ y ]
					};
					var comment = commentService.new( properties = props );
					comment.setRelatedContent( page );
					entitySave( comment );
					log.info( "Page Comment imported: #props.authorEmail#" );
				}
				log.info( "Comments imported successfully!" );

				// Hierarchies
				if ( len( qPages.parent_page_id[ x ] ) ) {
					// relate to page
					page.setParent( pageMap[ qPages.parent_page_id[ x ] ] );
				}

				log.info( "Page imported: #props.title#" );
			}

			/************************************** ENTRIES *********************************************/

			log.info( "Starting to import Entries...." );
			// Import Entries
			var q = new Query(
				datasource = arguments.dsn,
				username   = arguments.dsnUsername,
				password   = arguments.dsnPassword,
				sql        = "select me.*
								from #arguments.tablePrefix#entry me
								where me.id NOT IN(
									select id from #arguments.tablePrefix#page
								)
								order by last_modified asc"
			).execute().getResult();
			for ( var x = 1; x lte q.recordcount; x++ ) {
				var published = true;
				if ( q.status[ x ] neq "published" ) {
					published = false;
				}
				var props = {
					title         : q.title[ x ],
					slug          : q.name[ x ],
					content       : q.content[ x ],
					excerpt       : q.excerpt[ x ],
					publishedDate : q.last_modified[ x ],
					createdDate   : q.last_modified[ x ],
					isPublished   : published,
					allowComments : q.comments_allowed[ x ]
				};

				// slug checks
				if ( !len( trim( props.slug ) ) ) {
					props.slug = htmlHelper.slugify( props.title );
				}
				// check if slug already in map
				if ( structKeyExists( SlugMap, props.slug ) ) {
					// unique it
					props.slug &= "-" & left( hash( now() ), 5 );
				}
				SlugMap[ props.slug ] = "found";

				var entry = entryService.new( properties = props );
				// Add content versionized!
				entry.addNewContentVersion(
					content   = props.content,
					changelog = "Imported content",
					author    = authorService.get( authorMap[ q.author_id[ x ] ] )
				);
				entry.setCreator( authorService.get( authorMap[ q.author_id[ x ] ] ) );
				// entry categories
				var qCategories = new Query(
					datasource = arguments.dsn,
					username   = arguments.dsnUsername,
					password   = arguments.dsnPassword,
					sql        = "select * from #arguments.tablePrefix#post_category as mp where mp.post_id = '#q.id[ x ]#'"
				).execute().getResult();
				var aCategories = [];
				for ( var y = 1; y lte qCategories.recordcount; y++ ) {
					arrayAppend( aCategories, categoryService.get( catMap[ qCategories.category_id[ y ] ] ) );
				}
				entry.setCategories( aCategories );

				// Custom Fields
				var qCustomFields = new Query(
					datasource = arguments.dsn,
					username   = arguments.dsnUsername,
					password   = arguments.dsnPassword,
					sql        = "select * from #arguments.tablePrefix#entry_custom_field as cf where cf.entry_id = '#q.id[ x ]#'"
				).execute().getResult();
				for ( var y = 1; y lte qCustomFields.recordcount; y++ ) {
					var props = {
						key   : qCustomFields.name[ y ],
						value : qCustomFields.field_value[ y ]
					};
					var thisCustomField = customFieldService.new( properties = props );
					entry.addCustomField( thisCustomField );
					thisCustomField.setRelatedContent( entry );
				}

				// Save entity
				entitySave( entry );

				log.info( "Starting to import Entry Comments...." );
				// Import page comments
				var qComments = new Query(
					datasource = arguments.dsn,
					username   = arguments.dsnUsername,
					password   = arguments.dsnPassword,
					sql        = "select * from #arguments.tablePrefix#comment as mc where mc.entry_id = '#q.id[ x ]#'"
				).execute().getResult();
				for ( var y = 1; y lte qComments.recordcount; y++ ) {
					var props = {
						content     : qComments.content[ y ],
						author      : qComments.creator_name[ y ],
						authorIP    : "127.0.0.1",
						authorEmail : qComments.creator_email[ y ],
						authorURL   : qComments.creator_url[ y ],
						createdDate : qComments.created_on[ y ],
						isApproved  : qComments.approved[ y ]
					};
					var comment = commentService.new( properties = props );
					comment.setRelatedContent( entry );
					entitySave( comment );
					log.info( "Entry Comment imported: #props.authorEmail#" );
				}
				log.info( "Comments imported successfully!" );

				log.info( "Entry imported: #entry.getTitle()#" );
			}
			log.info( "Entries imported successfully!" );
		}
		// end of try
		catch ( any e ) {
			log.error( "Error importing blog: #e.message# #e.detail#", e );
			rethrow;
		}

		// Commit All entities
		transaction action="commit" {
		}
	}

}
