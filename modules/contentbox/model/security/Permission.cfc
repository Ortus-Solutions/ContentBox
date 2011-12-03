/**
* A cool Permission entity
*/
component persistent="true" entityName="cbPermission" table="cb_permision"{

	// Primary Key
	property name="permissionID" fieldtype="id" generator="native" setter="false";
	
	// Properties
	property name="permission"  ormtype="string" notnull="true" length="255" unique="true";	property name="description" ormtype="string" notnull="false" default="" length="500";	
	// M2M -> Role
	property name="roles" fieldtype="many-to-many" type="array" lazy="true"
			 cfc="contentbox.model.security.Role" cascade="all-delete-orphan"  
			 linktable="cb_rolePermissions" fkcolumn="FK_permissionID" inversejoincolumn="FK_roleID" orderby="role";
	
	// Constructor
	function init(){
		return this;
	}
}
