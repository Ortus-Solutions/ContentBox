/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Service to handle menu operations.
 */
component
	extends  ="cborm.models.VirtualEntityService"
	accessors="true"
	singleton
{

	// DI
	property name="renderer" inject="coldbox:renderer";
	property name="menuItemService" inject="menuItemService@contentbox";
	property name="dateUtil" inject="DateUtil@contentbox";

	/**
	 * Constructor
	 */
	MenuService function init(){
		// init it
		super.init( entityName = "cbMenu" );
		return this;
	}

	/**
	 * Save a menu and do necessary updates
	 *
	 * @menu         The menu to save or update
	 * @originalSlug If an original slug is passed, then we need to update hierarchy slugs.
	 *
	 * @return The saved menu
	 */
	function save( required menu, string originalSlug = "" ){
		return super.save( arguments.menu );
	}

	/**
	 * Menu search using different filters and return options
	 *
	 * @searchTerm Search in firstname, lastname and email fields
	 * @max        The max returned objects
	 * @offset     The offset for pagination
	 * @asQuery    Query or objects
	 * @sortOrder  The sort order to apply
	 * @siteID     The site to filter on
	 */
	function search(
		string searchTerm = "",
		numeric max       = 0,
		numeric offset    = 0,
		boolean asQuery   = false,
		string sortOrder  = "title",
		string siteID     = ""
	){
		var results = {};
		var c       = newCriteria();

		// Search
		if ( len( arguments.searchTerm ) ) {
			c.$or(
				c.restrictions.like( "title", "%#arguments.searchTerm#%" ),
				c.restrictions.like( "slug", "%#arguments.searchTerm#%" )
			);
		}

		// Site Filter
		if ( len( arguments.siteID ) ) {
			c.isEq( "site.siteID", arguments.siteID );
		}

		// run criteria query and projections count
		results.count = c.count( "menuID" );
		results.menus = c.list(
			offset    = arguments.offset,
			max       = arguments.max,
			sortOrder = arguments.sortOrder,
			asQuery   = arguments.asQuery
		);

		return results;
	}

	/**
	 * Find a menu object by slug, if not found it returns a new menu object
	 *
	 * @slug   The slug to search
	 * @siteID The site this slug is on
	 *
	 * @return The menu found or a new menu blank
	 */
	function findBySlug( required any slug, string siteID = "" ){
		// By criteria now
		var menu = newCriteria()
			.isEq( "slug", arguments.slug )
			.when( len( arguments.siteID ), function( c ){
				c.isEq( "site.siteID", siteID );
			} )
			.get();
		// return accordingly
		return ( isNull( menu ) ? new () : menu );
	}

	/**
	 * Get all data prepared for export
	 *
	 * @site The site to export from
	 */
	array function getAllForExport( required site ){
		return findAllWhere( { site : arguments.site } ).map( function( thisItem ){
			return thisItem.getMemento( profile: "export" );
		} );
	}

	/**
	 * Returns an array of slugs of all the content objects in the system.
	 *
	 * @siteID Filter by site
	 */
	array function getAllSlugs( string siteID = "" ){
		return newCriteria()
			.when( len( arguments.siteID ), function( c ){
				c.isEq( "site.siteID", siteID );
			} )
			.withProjections( property = "slug" )
			.list( sortOrder = "slug asc" );
	}

	/**
	 * Import data from a ContentBox JSON file. Returns the import log
	 *
	 * @importFile The json file to import
	 * @override   Override content if found in the database, defaults to false
	 *
	 * @return The console log of the import
	 *
	 * @throws InvalidImportFormat
	 */
	string function importFromFile( required importFile, boolean override = false ){
		var data      = fileRead( arguments.importFile );
		var importLog = createObject( "java", "java.lang.StringBuilder" ).init(
			"Starting import with override = #arguments.override#...<br>"
		);

		if ( !isJSON( data ) ) {
			throw( message = "Cannot import file as the contents is not JSON", type = "InvalidImportFormat" );
		}
		// deserialize packet: Should be array of { settingID, name, value }
		return importFromData(
			deserializeJSON( data ),
			arguments.override,
			importLog
		);
	}

	/**
	 * Import data from an array of structures or a single structure of data
	 *
	 * @importData A struct or array of data to import
	 * @override   Override content if found in the database, defaults to false
	 * @importLog  The import log buffer
	 * @site       If passed, we use this specific site, else we discover it via content data
	 *
	 * @return The console log of the import
	 */
	string function importFromData(
		required importData,
		boolean override = false,
		required importLog,
		site
	){
		var siteService = getWireBox().getInstance( "siteService@contentbox" );

		// if struct, inflate into an array
		if ( isStruct( arguments.importData ) ) {
			arguments.importData = [ arguments.importData ];
		}

		// Setup logging function
		var logThis = function( message ){
			variables.logger.info( arguments.message );
			importLog.append( arguments.message & "<br>" );
		};

		transaction {
			// iterate and import
			for ( var thisMenu in arguments.importData ) {
				// Determine Site if not passed from import data
				if ( isNull( arguments.site ) ) {
					logThis( "+ Site not sent via arguments, inflating from menu data (#thisMenu.site.slug#)" );
					arguments.site = siteService.getBySlugOrFail( thisMenu.site.slug );
				}

				logThis( "+ Importing menu (#thisMenu.slug#) to site (#arguments.site.getSlug()#)" );

				// Get new or persisted from site by slug
				var oMenu = findWhere( { "slug" : thisMenu.slug, "site" : arguments.site } );
				if ( isNull( oMenu ) ) {
					logThis( "+ New menu (#thisMenu.slug#) to import" );
					oMenu = this.new();
				} else {
					logThis( "+ Persisted menu (#thisMenu.slug#) to import" );
				}

				// Can we override
				if ( oMenu.isLoaded() && !arguments.override ) {
					logThis(
						"!! Skipped persisted menu (#thisMenu.slug#) to site (#arguments.site.getSlug()#) due to override being false"
					);
					continue;
				}

				// Link the site
				oMenu.setSite( arguments.site );
				arguments.site.addMenu( oMenu );

				// populate content from data
				getBeanPopulator().populateFromStruct(
					target               = oMenu,
					memento              = thisMenu,
					composeRelationships = false,
					exclude              = "menuID,menuItems,site"
				);

				// Compose Menu Items
				if ( arrayLen( thisMenu.menuItems ) ) {
					oMenu.populateMenuItems( thisMenu.menuItems );
				}

				entitySave( oMenu );
				logThis( "+ Imported menu (#thisMenu.slug#) to site (#arguments.site.getSlug()#)" );
			}
			// end import loop

			// Save them?
			if ( !arrayLen( arguments.importData ) ) {
				logThis( "No menus imported as none where found or able to be overriden from the import file." );
			}
		}
		// end for transaction

		return arguments.importLog.toString();
	}

	/**
	 * Builds editable menu for interface
	 *
	 * @menu       the menu to parse
	 * @menuString build-up string for menu content
	 * @inChild    flag for whether the content item is being evaluated as itself, or as a child of another item
	 */
	public String function buildEditableMenu(
		required array menu,
		required string menuString = "",
		boolean inChild            = false
	){
		// loop over menu items
		for ( var item in arguments.menu ) {
			var providerContent = "";
			var skipItem        = false;

			// if item has a parent, and it's being evaluated on the same level as its parent, skip it
			if ( item.hasParent() && !inChild ) {
				skipItem = true;
			}

			// build out the item
			if ( !skipItem ) {
				arguments.menuString &= "<li id=""key_#item.getMenuItemID()#"" class=""dd-item dd3-item"" data-id=""#item.getMenuItemID()#"">";

				// render default menu item
				var args            = { menuItem : item, provider : item.getProvider() };
				savecontent variable="providerContent" {
					writeOutput(
						variables.renderer.renderView(
							view   = "menus/provider",
							module = "contentbox-admin",
							args   = args
						)
					);
				};
				menuString &= providerContent;

				// if this item has children, recursively call this method to build them out too
				if ( item.hasChild() ) {
					menuString &= "<ol class=""dd-list"">";
					menuString &= buildEditableMenu( menu = item.getChildren(), inChild = true );
					menuString &= "</ol>";
				}

				menuString &= "</li>";
			}
		}

		return menuString;
	}

	/**
	 * Verify an incoming slug is unique or not
	 *
	 * @slug   The slug to search for uniqueness
	 * @menuID Limit the search to the passed menuID usually for updates
	 * @siteID The site to filter on
	 */
	function isSlugUnique(
		required any slug,
		any menuID    = "",
		string siteID = ""
	){
		return newCriteria()
			.isEq( "slug", arguments.slug )
			.when( len( arguments.siteID ), function( c ){
				c.isEq( "site.siteID", siteID );
			} )
			.when( len( arguments.menuID ), function( c ){
				c.ne( "menuID", menuID );
			} )
			.count() > 0 ? false : true;
	}

	/**
	 * Get a unique slug hash
	 *
	 * @slug The slug to make unique
	 */
	private function getUniqueSlugHash( required string slug ){
		return "#arguments.slug#-#lCase( left( hash( now() ), 5 ) )#";
	}

}
