/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * This is the base class for all persistent entities
 */
component
	mappedsuperclass="true"
	accessors       ="true"
	extends         ="BaseEntityMethods"
{

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */
	property
		name     ="id"
		fieldtype="id"
		generator="uuid"
		setter   ="false";

	property
		name   ="createdDate"
		type   ="date"
		ormtype="timestamp"
		notnull="true"
		update ="false";

	property
		name   ="modifiedDate"
		type   ="date"
		ormtype="timestamp"
		notnull="true";

	property
		name     ="isDeleted"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="false"
		dbdefault="false";

}
