/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* This is an abstract class that represents base entity methods.
* We created this due to the stupid bug in ACF 9-2016, where the mapped super class is not respected in table inheritance
*/
component mappedsuperclass="true"{

	// PK Pointer
	this.pk = "PLEASE_SELECT_ONE";
	// Constraints Default
	this.constraints = {};

	/* *********************************************************************
	**						PUBLIC FUNCTIONS
	********************************************************************* */

	/**
	* Constructor
	*/
	function init(){
		variables.ORMUtil = new cborm.models.util.ORMUtilFactory().getORMUtil();

		var uuidLib = createobject("java", "java.util.UUID");

		var keyColumn = getKey();

		variables[ keyColumn ] = uuidLib.randomUUID().toString();

		variables.isLoaded = false;
		variables.isDeleted = false;
		return this;
	}

	void function postLoad(){
		variables.isLoaded = true;
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
		return variables.isLoaded;
	}

	/**
	* Build out property mementos
	* Date/Time objects are produced as UTC milliseconds since January 1, 1970 (Epoch)
	* @properties The array properties to incorporate into the base memento
	* @excludes The properties to exclude from the memento
	*/
	private struct function getBaseMemento( required array properties, excludes="" ){
		var result 	= {};
		var pList 	= [
			this.pk,
			"createdDate",
			"modifiedDate",
			"isDeleted"
		];

		// add in base properties
		arrayAppend( arguments.properties, pList, true );

		// properties
		for( var thisProp in arguments.properties ){
			// If property exists and not excluded and a simple value
			if( structKeyExists( variables, thisProp ) &&
				!listFindNoCase( arguments.excludes, thisProp ) &&
				isSimpleValue( variables[ thisProp ] )
			){
				// Formatted Date/Time
				if( isDate( variables[ thisProp ] ) ){
					result[ thisProp ] = dateFormat( variables[ thisProp ], "medium" ) & " " & timeFormat( variables[ thisProp ], "full" );
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

	/**
	 * Returns the key (id field) of a given entity, either simple or composite keys.
	 * If the key is a simple pk then it will return a string, if it is a composite key then it returns an array.
	 * If the key cannot be identified then a blank string is returned.
	 *
	 * @entity The entity name or entity object
	 *
	 * @return string or array
	 */
	any function getKey(){
		var md = getMetadata( this );

		var hibernateMD = variables.ORMUtil.getEntityMetadata(
			entityName = md.keyExists( "entityName" ) ? md.entityName : listLast( md.name, "." ),
			datasource = variables.ORMUtil.getEntityDatasource( this, variables.ORMUtil.getDefaultDatasource() )
		);

		// Is this a simple key?
		if ( hibernateMD.hasIdentifierProperty() ) {
			return hibernateMD.getIdentifierPropertyName();
		}

		// Composite Keys?
		if ( hibernateMD.getIdentifierType().isComponentType() ) {
			// Do conversion to CF Array instead of java array, just in case
			return listToArray( arrayToList( hibernateMD.getIdentifierType().getPropertyNames() ) );
		}

		return "";
	}

}