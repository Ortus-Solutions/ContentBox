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
		variables.permissionList = [];
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
	 * Verify if the role has one or more of the passed in permissions
	 *
	 * @permission One or a list of permissions to verify
	 */
	boolean function hasPermission( required permission ){
		// cache deconstructed permissions in case it's called many times during a request.
		if ( !arrayLen( variables.permissionList ) AND hasPermissions() ) {
			variables.permissionList = arrayReduce(
				getPermissions(),
				( result, item ) => {
					return result.append( item.getPermission() );
				},
				[]
			);
		}
		// verify
		return arrayWrap( arguments.permission )
			.filter( ( item ) => variables.permissionList.findNoCase( arguments.item ) )
			.len();
	}

	/**
	 * Clear all permissions
	 */
	Role function clearPermissions(){
		variables.permissions    = [];
		variables.permissionList = [];
		return this;
	}

	/**
	 * Override the setPermissions
	 */
	Role function setPermissions( required array permissions ){
		if ( hasPermissions() ) {
			variables.permissions.clear();
			variables.permissions.addAll( arguments.permissions );
		} else {
			variables.permissions = arguments.permissions;
		}
		return this;
	}

}
