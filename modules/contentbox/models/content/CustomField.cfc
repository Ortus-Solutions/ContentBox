/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I am a custom field metadata that can be attached to base content in contentbox
*/
component persistent="true" entityname="cbCustomField" table="cb_customfield" cachename="cbCustomField" cacheuse="read-write"{

	// Properties
	property name="customFieldID" fieldtype="id" generator="native" setter="false"  params="{ allocationSize = 1, sequence = 'customFieldID_seq' }";
	property name="key"			notnull="true"  ormtype="string" 	length="255";
	property name="value"    	notnull="true"  ormtype="text" 		length="8000";

	// M20 -> Content loaded as a proxy
	property name="relatedContent" notnull="false" cfc="contentbox.models.content.BaseContent" fieldtype="many-to-one" fkcolumn="FK_contentID" lazy="true" index="idx_contentCustomFields";

	/* ----------------------------------------- PUBLIC -----------------------------------------  */

	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getCustomFieldID() );
	}
	
	/**
	* Get memento representation
	*/
	function getMemento(){
		var pList = listToArray( "customFieldID,key,value" );
		var result = {};
		
		for(var thisProp in pList ){
			if( structKeyExists( variables, thisProp ) ){
				result[ thisProp ] = variables[ thisProp ];	
			}
			else{
				result[ thisProp ] = "";
			}	
		}
		
		return result;
	}

}