/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * This is an abstract class that represents base entity methods.
 * We created this due to the stupid bug in ACF 9-2016, where the mapped super class is not respected in table inheritance
 */
component {

	// PK Pointer
	this.pk          = "PLEASE_SELECT_ONE";
	// Constraints Default
	this.constraints = {};

	/* *********************************************************************
	 **						PUBLIC STATIC VARIABLES
	 ********************************************************************* */

	this.DATE_FORMAT       = "mmm dd, yyyy";
	this.DATE_FORMAT_SHORT = "mmm-dd-yyyy";
	this.TIME_FORMAT       = "HH:mm:ss z";
	this.TIME_FORMAT_SHORT = "hh:mm tt";

	/* *********************************************************************
	 **						PUBLIC FUNCTIONS
	 ********************************************************************* */

	/**
	 * Constructor
	 */
	function init(){
		variables.createdDate  = now();
		variables.modifiedDate = now();
		variables.isDeleted    = false;

		// Incorporate default includes for the base class.
		if ( !isNull( this.memento.defaultIncludes ) && isNull( this.memento.baseIncluded ) ) {
			this.memento.defaultIncludes.append(
				[
					this.pk,
					"createdDate",
					"modifiedDate",
					"isDeleted"
				],
				true
			);
			this.memento.baseIncluded = true;
		}

		return this;
	}

	/**
	 * Append an incoming array of properties to a memento list target
	 *
	 * @collection The array to append
	 * @target The target to append to: defaultIncludes, defaultExcludes, neverInclude, defaults, etc.
	 */
	function appendToMemento( required collection, target = "defaultIncludes" ){
		var filtered = arguments.collection.filter( function( item ){
			!this.memento[ target ].containsNoCase( arguments.item );
		} );
		this.memento[ arguments.target ].append( filtered, true );
		return this;
	}

	/**
	 * Shortcut to get the id of the object using the this.pk
	 *
	 * @return The id of the object or empty value if not loaded
	 */
	function getId(){
		return isLoaded() ? variables[ this.pk ] : "";
	}

	/**
	 * pre insertion procedures
	 */
	void function preInsert(){
		var now                = now();
		variables.createdDate  = now;
		variables.modifiedDate = now;
	}

	/**
	 * pre update procedures
	 */
	void function preUpdate( struct oldData ){
		variables.modifiedDate = now();
	}

	/**
	 * Get formatted createdDate
	 */
	string function getDisplayCreatedDate(
		dateFormat = this.DATE_FORMAT,
		timeFormat = this.TIME_FORMAT_SHORT
	){
		if ( isNull( variables.createdDate ) ) {
			return "";
		}
		return dateFormat( variables.createdDate, arguments.dateFormat ) & " " & timeFormat(
			variables.createdDate,
			arguments.timeFormat
		);
	}

	/**
	 * Get formatted modified date
	 */
	string function getDisplayModifiedDate(
		dateFormat = this.DATE_FORMAT,
		timeFormat = this.TIME_FORMAT_SHORT
	){
		if ( isNull( variables.modifiedDate ) ) {
			return "";
		}
		return dateFormat( variables.modifiedDate, arguments.dateFormat ) & " " & timeFormat(
			variables.modifiedDate,
			arguments.timeFormat
		);
	}

	/**
	 * Verify if entity is loaded or not
	 */
	boolean function isLoaded(){
		return ( !structKeyExists( variables, this.pk ) OR !len( variables[ this.pk ] ) ? false : true );
	}

	/**
	 * Build out property mementos
	 * Date/Time objects are produced as UTC milliseconds since January 1, 1970 (Epoch)
	 *
	 * @properties The array properties to incorporate into the base memento
	 * @excludes The properties to exclude from the memento
	 */
	private struct function getBaseMemento( required array properties, excludes = "" ){
		var result = {};
		var pList  = [
			this.pk,
			"createdDate",
			"modifiedDate",
			"isDeleted"
		];

		// add in base properties
		arrayAppend( arguments.properties, pList, true );

		// properties
		for ( var thisProp in arguments.properties ) {
			// If property exists and not excluded and a simple value
			if (
				structKeyExists( variables, thisProp ) &&
				!listFindNoCase( arguments.excludes, thisProp ) &&
				isSimpleValue( variables[ thisProp ] )
			) {
				// Formatted Date/Time
				if ( isDate( variables[ thisProp ] ) ) {
					result[ thisProp ] = dateFormat( variables[ thisProp ], "medium" ) & " " & timeFormat(
						variables[ thisProp ],
						"full"
					);
				} else {
					result[ thisProp ] = variables[ thisProp ];
				}
			}
			// Else default it
			else if ( !listFindNoCase( arguments.excludes, thisProp ) ) {
				result[ thisProp ] = "";
			}
		}

		return result;
	}

}
