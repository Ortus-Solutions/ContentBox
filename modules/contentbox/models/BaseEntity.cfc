/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* This is the base class for all persistent entities
*/
component mappedsuperclass="true" accessors="true" extends="BaseEntityMethods"{

	/* *********************************************************************
	**							PROPERTIES									
	********************************************************************* */

	property 	name="createdDate" 	
				type="date"
				ormtype="timestamp"
				notnull="true"
				update="false"
				index="idx_createDate";

	property 	name="modifiedDate"	
				type="date"
				ormtype="timestamp"
				notnull="true"
				index="idx_modifiedDate";

	property 	name="isDeleted"		
				ormtype="boolean"
				sqltype="bit" 	
				notnull="true" 
				default="false" 
				dbdefault="0" 
				index="idx_deleted";
	
}