/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* This entity groups permissions for logical groupings
*/
component 	persistent="true"
			entityName="cbPermissionGroup"
			table="cb_permissionGroup"
			extends="contentbox.models.BaseEntity"
			cachename="cbPermissionGroup"
			cacheuse="read-write"{

	/* *********************************************************************
	**							DI
	********************************************************************* */



	/* *********************************************************************
	**							PROPERTIES
	********************************************************************* */

	property 	name="permissionGroupID"
				fieldtype="id"
				generator="native"
				setter="false"
				params="{ allocationSize = 1, sequence = 'permissionGroupID_seq' }";

	property 	name="name"
				ormtype="string"
				notnull="true"
				length="255"
				unique="true"
				default="";

	property 	name="description"
				ormtype="string"
				notnull="false"
				default=""
				length="500";

	/* *********************************************************************
	**							RELATIONSHIPS
	********************************************************************* */

	// M2M -> Permissions
	property	name="permissions"
				singularName="permission"
				fieldtype="many-to-many"
				type="array"
				lazy="extra"
				orderby="permission"
				cascade="all"
				cacheuse="read-write"
			  	cfc="contentbox.models.security.Permission"
			  	fkcolumn="FK_permissionGroupID"
			  	linktable="cb_groupPermissions"
			  	inversejoincolumn="FK_permissionID";

	/* *********************************************************************
	**							CALCULATED FIELDS
	********************************************************************* */

	property 	name="numberOfPermissions"
				formula="select count(*) from cb_groupPermissions as groupPermissions
						 where groupPermissions.FK_permissionGroupID = permissionGroupID";

	/* *********************************************************************
	**							NON PERSISTED PROPERTIES
	********************************************************************* */

	property name="permissionList" 	persistent="false";

	/* *********************************************************************
	**							PK + CONSTRAINTS
	********************************************************************* */

	this.pk = "permissionGroupID";

	this.constraints = {
		"name"	 			= { required = true, size = "1..255" },
		"description"		= { required = false, size = "1..500" }
	};

	/* *********************************************************************
	**							PUBLIC FUNCTIONS
	********************************************************************* */

	// Constructor
	function init(){
		permissions 	= [];
		permissionList	= '';
		super.init();

		return this;
	}

	/**
	* Check for permission
	* @slug The permission slug or list of slugs to validate the role has. If it's a list then they are ORed together
	*/
	boolean function checkPermission( required slug ){
		// cache list
		if( !len( permissionList ) AND hasPermission() ){
			var q = entityToQuery( getPermissions() );
			permissionList = valueList( q.permission );
		}

		// Do verification checks
		var aList = listToArray( arguments.slug );
		var isFound = false;

		for( var thisPerm in aList ){
			if( listFindNoCase( permissionList, trim( thisPerm ) ) ){
				isFound = true;
				break;
			}
		}

		return isFound;
	}

	/**
	* Clear all permissions
	*/
	PermissionGroup function clearPermissions(){
		permissions = [];
		return this;
	}

	/**
	* Override the setPermissions
	*/
	PermissionGroup function setPermissions( required array permissions ){
		if( hasPermission() ){
			variables.permissions.clear();
			variables.permissions.addAll( arguments.permissions );
		} else {
			variables.permissions = arguments.permissions;
		}
		return this;
	}

	/**
	* Get memento representation
	* @excludes Exclude properties
	* @showPermissions Show permissions or not
	*/
	function getMemento( excludes="", boolean showPermissions=true ){
		var pList = listToArray( "name,description" );
		var result 	= getBaseMemento( properties=pList, excludes=arguments.excludes );

		// Do Permissions
		if( arguments.showPermissions && hasPermission() ){
			result[ "permissions" ]= [];
			for( var thisPerm in variables.permissions ){
				arrayAppend( result[ "permissions" ], thisPerm.getMemento() );
			}
		} else if( arguments.showPermissions ){
			result[ "permissions" ] = [];
		}

		return result;
	}

}