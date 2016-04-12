/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A class to track stats for content
*/
component persistent="true" entityname="cbStats" table="cb_stats" batchsize="25" cachename="cbStats" cacheuse="read-write" {

	// Properties
	property 	name="statsID" 
				fieldtype="id" 
				generator="native" 
				setter="false"
				params="{ allocationSize = 1, sequence = 'statsID_seq' }";
	
	property 	name="hits" 
				notnull="false" 
				ormtype="long" 
				default="0";
	
	// O2O -> Content
	property 	name="relatedContent" 
				notnull="true" 
				cfc="contentbox.models.content.BaseContent" 
				fieldtype="one-to-one" 
				fkcolumn="FK_contentID" 
				lazy="true" 
				fetch="join";

	/************************************** CONSTRUCTOR *********************************************/

	/**
	* constructor
	*/
	function init(){
		return this;
	}

	/************************************** PUBLIC *********************************************/

	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( variables.statsID );
	}

	/**
	* Get memento representation
	*/
	function getMemento(){
		var pList = listToArray( "statsID,hits" );
		var result = {};
		
		for( var thisProp in pList ){
			result[ thisProp ] = variables[ thisProp ];	
		}
		
		return result;
	}

}