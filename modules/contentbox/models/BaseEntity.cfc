/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* This is the base class for all persistent entities
*/
component mappedsuperclass="true" accessors="true"{

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
								
	// PK Pointer			
	this.pk = "PLEASE_SELECT_ONE";

	/* *********************************************************************
	**						PUBLIC FUNCTIONS								
	********************************************************************* */

	/**
	* Constructor
	*/
	BaseEntity function init(){
		variables.isDeleted = false;
		return this;
	}

	/*
	* pre insertion procedures
	*/
	void function preInsert(){
		var now = now();
		setCreatedDate( now );
		setModifiedDate( now );	
	}
	
	/*
	* pre update procedures
	*/
	void function preUpdate( struct oldData ){
		setModifiedDate( now() );
	}

	/**
	* Get formatted createdDate
	*/
	string function getDisplayCreatedDate(){
		var createdDate = getCreatedDate();
		if( isNull( createdDate ) ){ return ""; }
		return dateFormat( createdDate, "dd mmm yyyy" ) & " " & timeFormat(createdDate, "hh:mm tt" );
	}
	
	/**
	* Get formatted modified date
	*/
	string function getDisplayModifiedDate(){
		var modDate = getModifiedDate();
		if( isNull( modDate ) ){ return ""; }
		return dateFormat( modDate, "dd mmm yyyy" ) & " " & timeFormat(modDate, "hh:mm tt" );
	}

	/**
	* Verify if entity is loaded or not
	*/
	boolean function isLoaded(){
		return ( !structKeyExists( variables, this.pk ) OR !len( variables[ this.pk ] ) ? false : true );
	}

	/**
	* Convert and epoch milliseconds into local time object.
	* @epoch The epoch time in milliseconds
	*/
	function epochToLocal( required epoch ) {
		return dateAdd( "l", arguments.epoch, dateConvert( "utc2Local", "January 1 1970 00:00" ) );
	}

	/**
	* Build out property mementos
	* Date/Time objects are produced as UTC milliseconds since January 1, 1970 (Epoch)
	* @properties The array properties to incorporate into the base memento
	* @excludes The properties to exclude from the memento
	*/
	private struct function getBaseMemento( required array properties, excludes="" ){
		var result = {};

		// add in base properties
		arguments.properties.addAll( [ 
			this.pk,
			"createdDate", 
			"modifiedDate", 
			"isDeleted" 
		] );

		// properties
		for( var thisProp in arguments.properties ){
			// If property exists and not excluded and a simple value
			if( structKeyExists( variables, thisProp ) && 
				!listFindNoCase( arguments.excludes, thisProp ) &&
				isSimpleValue( variables[ thisProp ] )
			){
				//ISO 8601 time
				if( isDate( variables[ thisProp ] ) ){
					//result[ thisProp ] = dateFormat( variables[ thisProp ], "yyyy-MM-dd" ) & "T" & timeFormat( variables[ thisProp ], "HH:mm:ss" );	
					result[ thisProp ] = variables[ thisProp ].getTime();
				} else {
					result[ thisProp ] = variables[ thisProp ];	
				}
			} 
			// Else default it
			else if( !listFindNoCase( arguments.excludes, thisProp ) ){
				result[ thisProp ] = "";
			}
		}

		return result;
	}
	
}