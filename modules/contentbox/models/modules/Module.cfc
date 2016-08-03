/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I am a ContentBox Module
*/
component 	persistent="true" 
			entityname="cbModule" 
			table="cb_module" 
			extends="contentbox.models.BaseEntity"
			cachename="cbModule"
			cacheuse="read-write"{

	/* *********************************************************************
	**							PROPERTIES									
	********************************************************************* */

	property 	name="moduleID" 
				fieldtype="id" 
				generator="native" 
				setter="false" 
				params="{ allocationSize = 1, sequence = 'moduleID_seq' }";

	property 	name="name"  			
				notnull="true" 
				length="255" 
				index="idx_moduleName";

	property 	name="title"  			
				notnull="false" 
				length="255" 
				default="";

	property 	name="version"			
				notnull="false" 
				length="255" 
				default="0";

	property 	name="entryPoint" 		
				notnull="false" 
				length="255" 
				default="" 
				index="idx_entryPoint";

	property 	name="author" 			
				notnull="false" 
				length="255" 
				default="";

	property 	name="webURL" 			
				notnull="false" 
				length="500" 
				default="";

	property 	name="forgeBoxSlug" 	
				notnull="false" 
				length="255" 
				default="";

	property 	name="description"		
				notnull="false" 
				ormtype="text" 
				length="8000"
				default="";

	property 	name="isActive"			
				notnull="true" 
				ormtype="boolean" 
				default="false" 
				index="idx_activeModule";

	/* *********************************************************************
	**							PK + CONSTRAINTS									
	********************************************************************* */

	this.pk = "moduleID";

	this.constraints = {
		"name"	 				= { required = true, size = "1..255" },
		"title"	 				= { required = true, size = "1..255" },
		"version"				= { required = false, size = "1..255" },
		"entryPoint"			= { required = false, size = "1..255" },
		"author"				= { required = false, size = "1..255" },
		"webURL"				= { required = false, size = "1..500" },
		"forgeBoxSlug"			= { required = false, size = "1..255" }
	};

	/* *********************************************************************
	**							PUBLIC FUNCTIONS									
	********************************************************************* */

	/**
	* Constructor
	*/
	function init(){
		variables.isActive = false;
		super.init();
		return this;
	}

	/**
	* Get memento representation
	* @excludes Property excludes
	*/
	function getMemento( excludes="" ){
		var pList 	= listToArray( "name,title,version,entryPoint,author,webURL,forgeBoxSlug,description,isActive" );
		var result 	= getBaseMemento( properties=pList, excludes=arguments.excludes );
		
		return result;
	}

}