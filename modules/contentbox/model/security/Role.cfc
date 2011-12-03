/**
* A cool Role entity
*/
component persistent="true" entityName="cbRole" table="cb_role"{

	// Primary Key
	property name="roleID" fieldtype="id" generator="native" setter="false";
	
	// Properties
	property name="role"  		ormtype="string" notnull="true" length="255" unique="true";	property name="description" ormtype="string" notnull="false" default="" length="500";	
	// M2M -> Permissions
	property name="permissions" fieldtype="many-to-many" type="array" lazy="extra"
			 cfc="contentbox.model.security.Permission" cascade="all-delete-orphan" 
			 fkcolumn="FK_roleID" linktable="cb_rolePermissions" inversejoincolumn="FK_permissionID" orderby="permission"; 
	
	// O2M -> Authors
	property name="authors" singularName="author" type="array" fieldtype="one-to-many" cfc="contentbox.model.security.Author"
			 fkcolumn="FK_roleID" inverse="true" lazy="extra" cascade="save-update" batchsize="25" orderby="lastName";
	
	// Constructor
	function init(){
		return this;
	}
}
