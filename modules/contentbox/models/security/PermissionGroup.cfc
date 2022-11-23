/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * This entity groups permissions for logical groupings
 */
component
	persistent="true"
	entityName="cbPermissionGroup"
	table     ="cb_permissionGroup"
	extends   ="contentbox.models.BaseEntity"
	cachename ="cbPermissionGroup"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **							DI
	 ********************************************************************* */



	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name     ="permissionGroupID"
		column   ="permissionGroupID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		update   ="false";

	property
		name   ="name"
		column ="name"
		ormtype="string"
		notnull="true"
		length ="255"
		unique ="true"
		default=""
		index  ="idx_permissionGroupName";

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
		fkcolumn         ="FK_permissionGroupID"
		linktable        ="cb_groupPermissions"
		inversejoincolumn="FK_permissionID";

	// M2M -> Authors
	property
		name             ="authors"
		singularName     ="author"
		fieldtype        ="many-to-many"
		type             ="array"
		lazy             ="true"
		cacheuse         ="read-write"
		cfc              ="contentbox.models.security.Author"
		fkcolumn         ="FK_permissionGroupID"
		linktable        ="cb_authorPermissionGroups"
		inversejoincolumn="FK_authorID";

	/* *********************************************************************
	 **							CALCULATED FIELDS
	 ********************************************************************* */

	property
		name   ="numberOfPermissions"
		formula="select count(*) from cb_groupPermissions as groupPermissions
						 where groupPermissions.FK_permissionGroupID = permissionGroupID";

	property
		name   ="numberOfAuthors"
		formula="select count(*) from cb_authorPermissionGroups as pg where pg.FK_permissionGroupID = permissionGroupID";

	/* *********************************************************************
	 **							NON PERSISTED PROPERTIES
	 ********************************************************************* */

	property name="permissionList" persistent="false";

	/* *********************************************************************
	 **							PK + CONSTRAINTS + MEMENTO
	 ********************************************************************* */

	this.pk = "permissionGroupID";

	this.memento = {
		defaultIncludes : [ "*" ],
		defaultExcludes : [ "authors" ]
	};

	this.constraints = {
		"name" : {
			required  : true,
			size      : "1..255",
			validator : "UniqueValidator@cborm"
		},
		"description" : { required : false, size : "1..500" }
	};

	/* *********************************************************************
	 **							PUBLIC FUNCTIONS
	 ********************************************************************* */

	/**
	 * Constructor
	 */
	function init(){
		variables.permissions    = [];
		variables.authors        = [];
		variables.permissionList = [];
		super.init();

		return this;
	}

	/**
	 * Verify if the permission group has one or more of the passed in permissions
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
	PermissionGroup function clearPermissions(){
		variables.permissions    = [];
		variables.permissionList = [];
		return this;
	}

	/**
	 * Clear all authors
	 */
	PermissionGroup function clearAuthors(){
		variables.authors = [];
		return this;
	}

	/**
	 * Override the setPermissions
	 *
	 * @permissions The permissions array
	 */
	PermissionGroup function setPermissions( required array permissions ){
		if ( hasPermissions() ) {
			variables.permissions.clear();
			variables.permissions.addAll( arguments.permissions );
		} else {
			variables.permissions = arguments.permissions;
		}
		return this;
	}

	/**
	 * Override the setAuthors
	 *
	 * @authors The permissions array
	 */
	PermissionGroup function setAuthors( required array authors ){
		if ( hasAuthor() ) {
			variables.authors.clear();
			variables.authors.addAll( arguments.authors );
		} else {
			variables.authors = arguments.authors;
		}
		return this;
	}

}
