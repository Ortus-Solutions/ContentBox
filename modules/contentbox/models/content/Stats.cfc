/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A class to track stats for content
*/
component 	persistent="true" 
			entityname="cbStats" 
			table="cb_stats" 
			batchsize="25" 
			extends="contentbox.models.BaseEntity"
			cachename="cbStats" 
			cacheuse="read-write" {

	/* *********************************************************************
	**							PROPERTIES									
	********************************************************************* */

	property 	name="statsID" 
				fieldtype="id" 
				generator="native" 
				setter="false"
				params="{ allocationSize = 1, sequence = 'statsID_seq' }";
	
	property 	name="hits" 
				notnull="false" 
				ormtype="long" 
				default="0";
	
	/* *********************************************************************
	**							RELATIONSHIPS									
	********************************************************************* */

	// O2O -> Content
	property 	name="relatedContent" 
				notnull="true" 
				cfc="contentbox.models.content.BaseContent" 
				fieldtype="one-to-one" 
				fkcolumn="FK_contentID" 
				lazy="true" 
				fetch="join";

	/* *********************************************************************
	**							PK + CONSTRAINTS									
	********************************************************************* */

	this.pk = "statsID";

	this.constraints = {
		"hits"	= { required = false, type="numeric" }
	};

	/* *********************************************************************
	**							CONSTRUCTOR									
	********************************************************************* */

	/**
	* constructor
	*/
	function init(){
		super.init();
		return this;
	}

	/* *********************************************************************
	**							PUBLIC FUNCTIONS									
	********************************************************************* */

	/**
	* Get memento representation
	*/
	function getMemento( excludes="" ){
		var pList 	= listToArray( "hits" );
		var result 	= getBaseMemento( properties=pList, excludes=arguments.excludes );
		
		return result;
	}

}