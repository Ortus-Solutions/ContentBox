/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Core Menu Entity
 */
component
	persistent="true"
	entityName="cbMenu"
	table     ="cb_menu"
	extends   ="contentbox.models.BaseEntity"
	cachename ="cbMenu"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **                          DI
	 ********************************************************************* */

	property
		name      ="menuService"
		inject    ="provider:menuService@contentbox"
		persistent="false";

	property
		name      ="menuItemService"
		inject    ="provider:menuItemService@contentbox"
		persistent="false";

	property
		name      ="ORMService"
		inject    ="provider:entityservice"
		persistent="false";

	/* *********************************************************************
	 **                          PROPERTIES
	 ********************************************************************* */

	property
		name     ="menuID"
		column   ="menuID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		ormtype  ="string"
		update   ="false";

	property
		name   ="title"
		column ="title"
		notnull="true"
		ormtype="string"
		length ="200"
		default=""
		index  ="idx_menutitle";

	property
		name   ="slug"
		column ="slug"
		notnull="true"
		ormtype="string"
		length ="200"
		default=""
		index  ="idx_menuslug";

	property
		name   ="menuClass"
		column ="menuClass"
		ormtype="string"
		length ="160"
		default="";

	property
		name   ="listClass"
		column ="listClass"
		ormtype="string"
		length ="160"
		default="";

	property
		name   ="listType"
		column ="listType"
		ormtype="string"
		length ="20"
		default="ul";

	/* *********************************************************************
	 **                          RELATIONSHIPS
	 ********************************************************************* */

	// M20 -> site loaded as a proxy and fetched immediately
	property
		name     ="site"
		notnull  ="true"
		cfc      ="contentbox.models.system.Site"
		fieldtype="many-to-one"
		fkcolumn ="FK_siteID"
		lazy     ="true"
		fetch    ="join";

	// O2M -> Comments
	property
		name        ="menuItems"
		singularName="menuItem"
		fieldtype   ="one-to-many"
		type        ="array"
		cfc         ="contentbox.models.menu.item.BaseMenuItem"
		fkcolumn    ="FK_menuID"
		cascade     ="all-delete-orphan"
		inverse     ="true"
		lazy        ="extra";

	/* *********************************************************************
	 **                          PK + CONSTRAINTS
	 ********************************************************************* */

	this.pk = "menuID";

	this.memento = {
		defaultIncludes : [
			"listClass",
			"listType",
			"menuClass",
			"slug",
			"title"
		],
		defaultExcludes : [ "site", "menuItems" ],
		profiles        : {
			export : {
				defaultIncludes : [
					"listClass",
					"listType",
					"menuClass",
					"slug",
					"title",
					"menuItems",
					"menuItems.isDeleted",
					"menuItems.parentSnapshot:parent",
					"siteSnapshot:site"
				],
				defaultExcludes : []
			}
		}
	};

	this.constraints = {
		"title"     : { required : true, size : "1..200" },
		"slug"      : { required : true, size : "1..200" },
		"menuClass" : { required : false, size : "1..160" },
		"listClass" : { required : false, size : "1..160" },
		"listType"  : { required : false, size : "1..20" }
	};

	/* *********************************************************************
	 **                          CONSTRUCTOR
	 ********************************************************************* */

	/**
	 * constructor
	 */
	Menu function init(){
		variables.listType  = "ul";
		variables.menuItems = [];

		super.init();

		return this;
	}

	/* *********************************************************************
	 **                          PUBLIC FUNCTIONS
	 ********************************************************************* */

	/**
	 * @Override due to bi-directional relationships
	 */
	Menu function addMenuItem( required menuItem ){
		// add them to the local array
		arrayAppend( variables.menuItems, arguments.menuItem );
		// set the bi-directional relation
		arguments.menuItem.setMenu( this );
		return this;
	}

	/**
	 * @Override due to bi-directional relationships
	 */
	Menu function setMenuItems( required array menuItems ){
		if ( hasMenuItem() ) {
			// manual remove, so hibernate can clear the existing relationships
			variables.menuItems.clear();
			// Add the incoming ones to the same array
			variables.menuItems.addAll( arguments.menuItems );
		} else {
			variables.menuItems = arguments.menuItems;
		}
		return this;
	}

	/**
	 * Creates menu items from raw data objects and attaches them to this menu.
	 *
	 * @rawData The raw data from which to create menu items
	 */
	array function populateMenuItems( required array rawData ){
		variables.menuItems.clear();
		return createMenuItems( arguments.rawData );
	}

	/**
	 * Retrieves root menu items (only items with no parents)
	 */
	array function getRootMenuItems(){
		if ( hasMenuItem() ) {
			return getMenuItems().filter( function( thisItem ){
				return !arguments.thisItem.hasParent();
			} );
		}
		return [];
	}

	/* *********************************************************************
	 **                          PRIVATE FUNCTIONS
	 ********************************************************************* */

	/**
	 * Recursive function to build menu items hierarchy from raw data
	 *
	 * @rawData The raw data definitions for the menu items
	 */
	private array function createMenuItems( required array rawData ){
		var items = [];
		// loop over rawData and create items :)
		for ( var data in arguments.rawData ) {
			var provider = variables.menuItemService.getProvider( data.menuType );
			var entity   = variables.ORMService.new( entityName = provider.getEntityName() );
			var newItem  = variables.menuItemService.populate(
				target  = entity,
				memento = data,
				exclude = "menuItemId,children,parent"
			);
			// Link the item to this menu
			addMenuItem( newItem );

			// populate the children
			if ( !isNull( data.children ) && arrayLen( data.children ) ) {
				var children = createMenuItems( data.children );
				var setter   = [];
				for ( var child in children ) {
					// Link the child to this parent
					child.setParent( newItem );
					arrayAppend( setter, child );
				}
				newItem.setChildren( setter );
			}

			// add to menu
			arrayAppend( items, newItem );
		}

		return items;
	}

	/**
	 * Shortcut to get the site name
	 */
	function getSiteName(){
		return getSite().getName();
	}

	/**
	 * Shortcut to get the site slug
	 */
	function getSiteSlug(){
		return getSite().getSlug();
	}

	/**
	 * Shortcut to get the site id
	 */
	function getSiteId(){
		if ( hasSite() ) {
			return getSite().getsiteID();
		}
		return "";
	}

	/**
	 * Build a site snapshot
	 */
	struct function getSiteSnapshot(){
		return ( hasSite() ? getSite().getInfoSnapshot() : {} );
	}

}
