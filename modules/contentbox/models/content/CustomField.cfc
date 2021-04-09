/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I am a custom field metadata that can be attached to base content in contentbox
*/
component 	persistent="true"
			entityname="cbCustomField"
			table="cb_customfield"
			extends="contentbox.models.BaseEntity"
			cachename="cbCustomField"
			cacheuse="read-write"{

	/* *********************************************************************
	**							PROPERTIES
	********************************************************************* */

	property 	name="key"
				notnull="true"
				ormtype="string"
				length="255";

	property 	name="value"
				notnull="true"
				ormtype="text"
				length="8000";

	/* *********************************************************************
	**							RELATIONSHIPS
	********************************************************************* */

	// M20 -> Content loaded as a proxy
	property 	name="relatedContent"
				notnull="false"
				cfc="contentbox.models.content.BaseContent"
				fieldtype="many-to-one"
				fkcolumn="FK_contentID"
				lazy="true"
				index="idx_contentCustomFields";

	/* *********************************************************************
	**							CONSTRAINTS
	********************************************************************* */

	this.constraints = {
		"key" = { required = true, size = "1..255"},
		"value" = { required = true }
	};

	/* *********************************************************************
	**							PUBLIC FUNCTIONS
	********************************************************************* */

	/**
	* Get memento representation
	*/
	function getMemento( excludes="" ){
		var pList 	= listToArray( "key,value" );
		var result 	= getBaseMemento( properties=pList, excludes=arguments.excludes );

		return result;
	}

}