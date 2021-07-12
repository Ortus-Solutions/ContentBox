/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A cool Permission entity
 */
component
	persistent="true"
	entityName="cbPermission"
	table     ="cb_permission"
	extends   ="contentbox.models.BaseEntity"
	cachename ="cbPermission"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name     ="permissionID"
		column   ="permissionID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		ormtype  ="string"
		update   ="false";

	property
		name   ="permission"
		column ="permission"
		ormtype="string"
		notnull="true"
		length ="255"
		unique ="true"
		default=""
		index  ="idx_permissionName";

	property
		name   ="description"
		column ="description"
		ormtype="string"
		notnull="false"
		default=""
		length ="500";

	/* *********************************************************************
	 **							CALCULATED FIELDS
	 ********************************************************************* */

	property
		name   ="numberOfPermissionGroups"
		formula="select count(*) from cb_groupPermissions as gp where gp.FK_permissionID=permissionID";

	property
		name   ="numberOfRoles"
		formula="select count(*) from cb_rolePermissions as rolePermissions
						where rolePermissions.FK_permissionID=permissionID";

	property
		name   ="numberOfGroups"
		formula="select count(*) from cb_groupPermissions as groupPermissions
						where groupPermissions.FK_permissionID=permissionID";

	/* *********************************************************************
	 **							PK + CONSTRAINTS + MEMENTO
	 ********************************************************************* */

	this.pk = "permissionID";

	this.memento = {
		defaultIncludes : [ "permission", "description" ],
		defaultExcludes : [ "" ]
	};

	this.constraints = {
		"permission" : {
			required  : true,
			size      : "1..255",
			validator : "UniqueValidator@cborm"
		},
		"description" : { required : false, size : "1..500" }
	};

	/* *********************************************************************
	 **							PUBLIC FUNCITONS
	 ********************************************************************* */

	/**
	 * Constructor
	 */
	function init(){
		super.init();
		return this;
	}

}
