/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A cool Role entity
 */
component
	persistent="true"
	entityName="cbRole"
	table     ="cb_role"
	extends   ="contentbox.models.BaseEntity"
	cachename ="cbRole"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **							DI
	 ********************************************************************* */

	property
		name      ="permissionService"
		inject    ="provider:permissionService@contentbox"
		persistent="false";

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name     ="roleID"
		column   ="roleID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		ormtype  ="string"
		update   ="false";

	property
		name   ="role"
		column ="role"
		ormtype="string"
		notnull="true"
		length ="255"
		unique ="true"
		default=""
		index  ="idx_roleName";

	property
		name   ="description"
		column ="description"
		ormtype="string"
		notnull="false"
		default=""
		length ="500";

	/* *********************************************************************
	 **							RELATIONSHIPS
	 ********************************************************************* */

	// M2M -> Permissions
	property
		name             ="permissions"
		singularName     ="permission"
		fieldtype        ="many-to-many"
		type             ="array"
		lazy             ="true"
		orderby          ="permission"
		cascade          ="save-update"
		cacheuse         ="read-write"
		cfc              ="contentbox.models.security.Permission"
		fkcolumn         ="FK_roleID"
		linktable        ="cb_rolePermissions"
		inversejoincolumn="FK_permissionID";

	/* *********************************************************************
	 **							CALUCLATED FIELDS
	 ********************************************************************* */

	property
		name   ="numberOfPermissions"
		formula="select count(*) from cb_rolePermissions as rolePermissions where rolePermissions.FK_roleID=roleID";

	property name="numberOfAuthors" formula="select count(*) from cb_author as author where author.FK_roleID=roleID";

	/* *********************************************************************
	 **							NON PERSISTED PROPERTIES
	 ********************************************************************* */

	property name="permissionList" persistent="false";

	/* *********************************************************************
	 **							PK + CONSTRAINTS + MEMENTO
	 ********************************************************************* */

	this.pk = "roleID";

	this.memento = {
		defaultIncludes : [ "role", "description" ],
		defaultExcludes : [ "permissionList" ]
	};

	this.constraints = {
		"role" : {
			required  : true,
			size      : "1..255",
			validator : "UniqueValidator@cborm"
		},
		"description" : { required : false, size : "1..500" }
	};

	/* *********************************************************************
	 **							PUBLIC FUNCTIONS
	 ********************************************************************* */

	// Constructor
	function init(){
		variables.permissions    = [];
		variables.permissionList = "";
		super.init();

		return this;
	}

	/**
	 * Get the role name, same as getRole()
	 */
	string function getName(){
		return variables.role;
	}

	/**
	 * Check for permission
	 *
	 * @slug.hint The permission slug or list of slugs to validate the role has. If it's a list then they are ORed together
	 */
	boolean function checkPermission( required slug ){
		// cache list
		if ( !len( permissionList ) AND hasPermission() ) {
			var q          = entityToQuery( getPermissions() );
			permissionList = valueList( q.permission );
		}

		// Do verification checks
		var aList   = listToArray( arguments.slug );
		var isFound = false;

		for ( var thisPerm in aList ) {
			if ( listFindNoCase( permissionList, trim( thisPerm ) ) ) {
				isFound = true;
				break;
			}
		}

		return isFound;
	}

	/**
	 * Clear all permissions
	 */
	Role function clearPermissions(){
		permissions = [];
		return this;
	}

	/**
	 * Override the setPermissions
	 */
	Role function setPermissions( required array permissions ){
		if ( hasPermission() ) {
			variables.permissions.clear();
			variables.permissions.addAll( arguments.permissions );
		} else {
			variables.permissions = arguments.permissions;
		}
		return this;
	}

}
