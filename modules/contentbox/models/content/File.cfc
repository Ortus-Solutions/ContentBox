/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A link content type model
 */
component
	persistent        ="true"
	entityname        ="cbFile"
	table             ="cb_file"
	batchsize         ="25"
	cachename         ="cbFile"
	cacheuse          ="read-write"
	extends           ="BaseContent"
	joinColumn        ="contentID"
	discriminatorValue="File"
{

	/**
	 * Used when building automated menus
	 */
	property
		name   ="showInMenu"
		column ="showInMenu"
		notnull="true"
		ormtype="boolean"
		default="true"
		index  ="idx_showInMenu";

	/**
	 * constructor
	 */
	function init(){
		super.init();

		variables.categories      = [];
		variables.customFields    = [];
		variables.renderedContent = "";
		variables.renderedExcerpt = "";
		variables.createdDate     = now();
		variables.contentType     = "File";

		return this;
	}

}
