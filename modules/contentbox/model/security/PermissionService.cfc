/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
* Permissions service for contentbox
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	/**
	* Constructor
	*/
	PermissionService function init(){
		// init it
		super.init(entityName="cbPermission");
		
		return this;
	}
	
	/**
	* Delete a Permission which also removes itself from all many-to-many relationships
	*/
	boolean function deletePermission(required permissionID) transactional{
		// We do SQL deletions as those relationships are not bi-directional
		// delete role relationships
		var q = new Query(sql="delete from cb_rolePermissions where FK_permissionID = :permissionID");
		q.addParam(name="permissionID",value=arguments.permissionID,cfsqltype="numeric");
		q.execute();
		// delete user relationships
		var q = new Query(sql="delete from cb_authorPermissions where FK_permissionID = :permissionID");
		q.addParam(name="permissionID",value=arguments.permissionID,cfsqltype="numeric");
		q.execute();
		// delete permission now
		return deleteById( arguments.permissionID );
	}
	
}