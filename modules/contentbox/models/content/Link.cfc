/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A link content type model
 */
component
	persistent        ="true"
	entityname        ="cbLink"
	table             ="cb_link"
	batchsize         ="25"
	cachename         ="cbLink"
	cacheuse          ="read-write"
	extends           ="BaseContent"
	joinColumn        ="contentID"
	discriminatorValue="Link"
{

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name   ="url"
		column ="url"
		notnull="true"
		default=""
		length ="8000";

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
		appendToMemento( [ "url" ], "defaultIncludes" );
		appendToMemento(
			[
				"excerpt",
				"allowComments",
				"passwordProtection",
				"HTMLKeywords",
				"HTMLDescription",
				"HTMLTitle"
			],
			"defaultExcludes"
		);

		super.init();

		variables.categories      = [];
		variables.customFields    = [];
		variables.renderedContent = "";
		variables.renderedExcerpt = "";
		variables.createdDate     = now();
		variables.contentType     = "Link";

		return this;
	}

}
