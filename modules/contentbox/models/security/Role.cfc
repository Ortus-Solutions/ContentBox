/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A cool Role entity
*/
component 	persistent="true" 
			entityName="cbRole" 
			table="cb_role" 
			extends="contentbox.models.BaseEntity"
			cachename="cbRole" 
			cacheuse="read-write"{
	
	/* *********************************************************************
	**							DI									
	********************************************************************* */

	property name="permissionService" 	inject="permissionService@cb" persistent="false";
	
	/* *********************************************************************
	**							PROPERTIES									
	********************************************************************* */

	property 	name="roleID" 
				fieldtype="id" 
				generator="native" 
				setter="false" 
				params="{ allocationSize = 1, sequence = 'roleID_seq' }";
	
	property 	name="role" 
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
			  	fkcolumn="FK_roleID" 
			  	linktable="cb_rolePermissions" 
			  	inversejoincolumn="FK_permissionID"; 
	
	/* *********************************************************************
	**							CALUCLATED FIELDS									
	********************************************************************* */

	property 	name="numberOfPermissions" 
				formula="select count(*) from cb_rolePermissions as rolePermissions where rolePermissions.FK_roleID=roleID";
	
	property 	name="numberOfAuthors" 	
				formula="select count(*) from cb_author as author where author.FK_roleID=roleID";
	
	/* *********************************************************************
	**							NON PERSISTED PROPERTIES									
	********************************************************************* */

	property name="permissionList" 	persistent="false";

	/* *********************************************************************
	**							PK + CONSTRAINTS							
	********************************************************************* */

	this.pk = "roleID";

	this.constraints = {
		"role"	 			= { required = true, size = "1..255" },
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
	* Get the role name, same as getRole()
	*/
	string function getName(){
		return variables.role;
	}
	
	/**
	* Check for permission
	* @slug.hint The permission slug or list of slugs to validate the role has. If it's a list then they are ORed together
	*/
	boolean function checkPermission(required slug){
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
	Role function clearPermissions(){
		permissions = [];
		return this;
	}
	
	/**
	* Override the setPermissions
	*/
	Role function setPermissions(required array permissions){
		if( hasPermission() ){
			variables.permissions.clear();
			variables.permissions.addAll( arguments.permissions );
		}
		else{
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
		var pList = listToArray( "role,description" );
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