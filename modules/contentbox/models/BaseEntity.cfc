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
		name      ="createdDate"
		column    ="createdDate"
		type      ="date"
		ormtype   ="timestamp"
		notnull   ="true"
		update    ="false"
		persistent="true";

	property
		name      ="modifiedDate"
		column    ="modifiedDate"
		type      ="date"
		ormtype   ="timestamp"
		notnull   ="true"
		persistent=true;

	property
		name      ="isDeleted"
		column    ="isDeleted"
		ormtype   ="boolean"
		notnull   ="true"
		default   ="false"
		persistent="true";

}
