/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I am a system setting. A system setting can be core or non-core.  The difference is that core
* settings cannot be deleted from the geek settings UI to prevent caos.  Admins would have
* to remove core settings via the DB only as a precautionary measure.
*/
component persistent="true" entityname="cbSetting" table="cb_setting" cachename="cbSetting" cacheuse="read-write"{

	/* *********************************************************************
	**							PROPERTIES									
	********************************************************************* */

	property 	name="settingID" 
				fieldtype="id" 
				generator="native" 
				setter="false"  
				params="{ allocationSize = 1, sequence = 'settingID_seq' }";

	property 	name="name" 
			 	notnull="true" 
				length="100";

	property 	name="value" 
				notnull="true" 
				ormtype="text";

	property 	name="isCore"		
				ormtype="boolean" 	
				notnull="true" 
				default="false" 
				dbdefault="0" 
				index="idx_core";

	/* *********************************************************************
	**							PUBLIC METHODS									
	********************************************************************* */

	/**
	* Constructor
	*/
	function init(){
		variables.isCore = false;
		
		return this;
	}

}