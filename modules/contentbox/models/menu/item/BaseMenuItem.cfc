/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Base entity for all subclasses of Menu Items
 */
component
	persistent         ="true"
	entityName         ="cbMenuItem"
	table              ="cb_menuItem"
	extends            ="contentbox.models.BaseEntityMethods"
	cachename          ="cbMenuItem"
	cacheuse           ="read-write"
	discriminatorColumn="menuType"
{

	/* *********************************************************************
	 **                          DI
	 ********************************************************************* */

	property
		name      ="menuItemService"
		inject    ="provider:menuItemService@contentbox"
		persistent="false";

	/* *********************************************************************
	 **							PROPERTIES due to ACF Bug
	 ********************************************************************* */

	property
		name   ="createdDate"
		column ="createdDate"
		type   ="date"
		ormtype="timestamp"
		notnull="true"
		update ="false";

	property
		name   ="modifiedDate"
		column ="modifiedDate"
		type   ="date"
		ormtype="timestamp"
		notnull="true";

	property
		name   ="isDeleted"
		column ="isDeleted"
		ormtype="boolean"
		notnull="true"
		default="false";

	/* *********************************************************************
	 **                          PROPERTIES
	 ********************************************************************* */

	property
		name     ="menuItemID"
		column   ="menuItemID"
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
		default="";

	property
		name   ="label"
		column ="label"
		notnull="false"
		ormtype="string"
		length ="200"
		default="";

	property
		name   ="itemClass"
		column ="itemClass"
		notnull="false"
		ormtype="string"
		length ="200"
		default="";

	property
		name   ="data"
		column ="data"
		notnull="false"
		ormtype="string"
		default="";

	property
		name   ="active"
		column ="active"
		ormtype="boolean"
		default="true";

	property
		name  ="menuType"
		column="menuType"
		insert="false"
		update="false";

	/* *********************************************************************
	 **                          RELATIONSHIPS
	 ********************************************************************* */

	// M20 - Owning menu
	property
		name     ="menu"
		cfc      ="contentbox.models.menu.Menu"
		fieldtype="many-to-one"
		fkcolumn ="FK_menuID"
		lazy     ="true"
		fetch    ="join"
		notnull  ="true";

	// M20 - Parent Menu item
	property
		name     ="parent"
		cfc      ="BaseMenuItem"
		fieldtype="many-to-one"
		fkcolumn ="FK_parentID"
		fetch    ="join"
		lazy     ="true";

	// O2M - Child Menu Item
	property
		name        ="children"
		singularName="child"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="extra"
		cfc         ="BaseMenuItem"
		fkcolumn    ="FK_parentID"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	/* *********************************************************************
	 **                          PK + CONSTRAINTS
	 ********************************************************************* */

	this.pk = "menuItemID";

	this.memento = {
		defaultIncludes : [
			"active",
			"data",
			"itemClass",
			"label",
			"menuType",
			"children",
			"parentSnapshot:parent"
		],
		defaultExcludes : [ "menu", "parent" ]
	};

	this.constraints = {
		"title"     : { required : true, size : "1..200" },
		"label"     : { required : false, size : "1..200" },
		"itemClass" : { required : false, size : "1..200" },
		"data"      : { required : false, size : "1..255" }
	};

	/* *********************************************************************
	 **                          CONSTRUCTOR
	 ********************************************************************* */

	BaseMenuItem function init(){
		variables.active   = true;
		variables.children = [];

		super.init();

		return this;
	}

	/**
	 * Build a parent snapshot
	 */
	struct function getParentSnapshot(){
		return ( hasParent() ? getParent().getInfoSnapshot() : {} );
	}

	/**
	 * Utility method to get a snapshot of this menu item
	 */
	struct function getInfoSnapshot(){
		if ( isLoaded() ) {
			return {
				"menuItemID" : getId(),
				"title"      : getTitle(),
				"active"     : getActive(),
				"menuType"   : getMenuType()
			};
		}
		return {};
	}

	/* *********************************************************************
	 **                          PUBLIC FUNCTIONS
	 ********************************************************************* */

	/**
	 * Get a handy, formatted string of attributes that are applicable for the current menu item
	 */
	public string function getAttributesAsString(){
		var str   = "";
		var title = !isNull( getTitle() ) ? getTitle() : "";
		var cls   = !isNull( getItemClass() ) ? getItemClass() : "";
		var data  = !isNull( getData() ) ? getData() : "";
		// handle title
		if ( len( title ) ) {
			str &= " title=""#htmlEditFormat( title )#""";
		}
		// handle cls
		if ( len( cls ) ) {
			str &= " class=""#htmlEditFormat( cls )#""";
		}
		// handle data
		if ( len( data ) ) {
			// try json first
			if ( isJSON( data ) ) {
				// deserialize so we can handle as object
				var pairs = deserializeJSON( data );
				// append all data attributes
				if ( isStruct( pairs ) ) {
					for ( dataKey in pairs ) {
						if ( isSimpleValue( pairs[ dataKey ] ) && len( pairs[ dataKey ] ) ) {
							str &= " data-#lCase( dataKey )#=""#htmlEditFormat( pairs[ datakey ] )#""";
						}
					}
				}
			}
			// try alternate format
			if ( listLen( data, "," ) ) {
				for ( var item in listToArray( data, "," ) ) {
					var splitVal = listToArray( item, "=" );
					if ( arrayLen( splitVal ) > 1 ) {
						if ( isSimpleValue( splitVal[ 2 ] ) ) {
							str &= " data-#lCase( splitVal[ 1 ] )#=""#htmlEditFormat( splitVal[ 2 ] )#""";
						}
					}
				}
			}
		}
		return str;
	}

	/**
	 * Available precheck to determine display-ability of menu item
	 *
	 * @options.hint Additional arguments to be used in the method
	 */
	public boolean function canDisplay( required struct options = {} ){
		return getActive();
	}

}
