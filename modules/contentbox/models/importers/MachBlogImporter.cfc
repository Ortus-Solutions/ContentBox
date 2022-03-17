/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Import a MachBlog database into contentbox
 */
component implements="ICBImporter" {

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
	MachBlogImporter function init(){
		return this;
	}

	/**
	 * Import from MachBlog, returns the string console.
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
		var baseDate    = createDate( 1970, 1, 1 );

		log.info( "Starting import process: #arguments.toString()#" );

		try {
			/************************************** CATEGORIES *********************************************/

			var q = new Query(
				datasource = arguments.dsn,
				username   = arguments.dsnUsername,
				password   = arguments.dsnPassword,
				sql        = "select * from #arguments.tablePrefix#machblog_category"
			).execute().getResult();
			for ( var x = 1; x lte q.recordcount; x++ ) {
				var props = {
					category : q.category_name[ x ],
					slug     : htmlHelper.slugify( q.category_name[ x ] )
				};
				var cat = categoryService.new( properties = props );
				entitySave( cat );
				log.info( "Imported category: #props.category#" );
				catMap[ q.category_id[ x ] ] = cat.getCategoryID();
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
				sql        = "select * from #arguments.tablePrefix#machblog_user"
			).execute().getResult();
			for ( var x = 1; x lte q.recordcount; x++ ) {
				var props = {
					email     : q.email[ x ],
					username  : q.email[ x ],
					password  : bcrypt.hashPassword( defaultPassword ),
					isActive  : q.is_active[ x ],
					firstName : q.first_name[ x ],
					lastName  : q.last_name[ x ]
				};
				var author = authorService.new( properties = props );
				author.setRole( defaultRole );
				// duplicate usernames
				if ( authorService.usernameFound( props.username ) ) {
					author.setUsername( props.username & "-#left( hash( now() ), 5 )#" );
				}

				entitySave( author );
				log.info( "Imported author: #props.firstName# #props.lastName#" );
				authorMap[ q.user_id[ x ] ] = author.getAuthorID();
			}
			log.info( "Authors imported successfully!" );

			/************************************** PAGES *********************************************/
			// NO PAGE SUPPORT IN MACHBLOG

			/************************************** ENTRIES *********************************************/

			log.info( "Starting to import Entries...." );
			// Import Entries
			var q = new Query(
				datasource = arguments.dsn,
				username   = arguments.dsnUsername,
				password   = arguments.dsnPassword,
				sql        = "select * from #arguments.tablePrefix#machblog_entry order by dt_modified asc"
			).execute().getResult();

			for ( var x = 1; x lte q.recordcount; x++ ) {
				var published = true;
				if ( !q.is_active[ x ] ) {
					published = false;
				}
				var props = {
					title         : q.title[ x ],
					slug          : htmlHelper.slugify( q.title[ x ] ),
					content       : q.body[ x ] & q.more_body[ x ],
					excerpt       : q.body[ x ],
					publishedDate : dateAdd( "s", q.dt_posted[ x ] / 1000, baseDate ),
					createdDate   : dateAdd( "s", q.dt_created[ x ] / 1000, baseDate ),
					isPublished   : published,
					allowComments : q.allow_comments[ x ]
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
					author    = authorService.get( authorMap[ q.created_by_id[ x ] ] )
				);
				entry.setCreator( authorService.get( authorMap[ q.created_by_id[ x ] ] ) );
				// entry categories
				var qCategories = new Query(
					datasource = arguments.dsn,
					username   = arguments.dsnUsername,
					password   = arguments.dsnPassword,
					sql        = "select * from #arguments.tablePrefix#machblog_entry_category as category where category.entry_id = '#q.entry_id[ x ]#'"
				).execute().getResult();
				var aCategories = [];
				for ( var y = 1; y lte qCategories.recordcount; y++ ) {
					arrayAppend( aCategories, categoryService.get( catMap[ qCategories.category_id[ y ] ] ) );
				}
				entry.setCategories( aCategories );

				// Custom Fields
				// NO CUSTOM FIELD SUPPORT IN MACHBLOG

				// Save entity
				entitySave( entry );

				log.info( "Starting to import Entry Comments...." );
				// Import page comments
				var qComments = new Query(
					datasource = arguments.dsn,
					username   = arguments.dsnUsername,
					password   = arguments.dsnPassword,
					sql        = "select * from #arguments.tablePrefix#machblog_comment as comment where comment.entry_id = '#q.entry_id[ x ]#' order by dt_created asc"
				).execute().getResult();
				for ( var y = 1; y lte qComments.recordcount; y++ ) {
					var props = {
						content     : qComments.comment[ y ],
						author      : qComments.name[ y ],
						authorIP    : qComments.ip_created[ y ],
						authorEmail : qComments.email[ y ],
						authorURL   : qComments.url[ y ],
						createdDate : dateAdd(
							"s",
							qComments.dt_created[ y ] / 1000,
							baseDate
						),
						isApproved : qComments.is_active[ y ]
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
