/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * This is an abstract class that represents base entity methods.
 * We created this due to the stupid bug in ACF 9-2016, where the mapped super class is not respected in table inheritance
 */
component {

	/* *********************************************************************
	 **						GLOBAL DI
	 ********************************************************************* */

	property
		name      ="coldbox"
		inject    ="provider:coldbox"
		persistent="false";

	property
		name      ="cachebox"
		inject    ="provider:cachebox"
		persistent="false";

	property
		name      ="interceptorService"
		inject    ="provider:coldbox:interceptorService"
		persistent="false";

	property
		name      ="wirebox"
		inject    ="wirebox"
		persistent="false";

	/* *********************************************************************
	 **						CONCRETE PROPERTIES
	 ********************************************************************* */

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
		// Calculate name via md
		getEntityName();

		variables.createdDate  = now();
		variables.modifiedDate = now();
		variables.isDeleted    = false;

		if ( isNull( this.memento.baseIncluded ) ) {
			// Incorporate default includes for the base class.
			if ( !isNull( this.memento.defaultIncludes ) ) {
				this.memento.defaultIncludes.append( [ this.pk, "createdDate", "modifiedDate" ], true );
			}
			// Incorporate default excludes for the base class.
			if ( !isNull( this.memento.defaultExcludes ) ) {
				this.memento.defaultExcludes.append( [ "isDeleted" ], true );
			}
			this.memento.baseIncluded = true;
		}

		return this;
	}

	/**
	 * Get the entity name
	 */
	function getEntityName(){
		if ( isNull( variables.entityName ) ) {
			var md               = getMetadata( this );
			variables.entityName = ( md.keyExists( "entityName" ) ? md.entityName : listLast( md.name, "." ) );
		}

		return variables.entityName;
	}

	/**
	 * Append an incoming array of properties to a memento list target
	 *
	 * @collection The array to append
	 * @target     The target to append to: defaultIncludes, defaultExcludes, neverInclude, defaults, etc.
	 */
	function appendToMemento( required collection, target = "defaultIncludes" ){
		var filtered = arguments.collection.filter( function( item ){
			return !arrayContainsNoCase( this.memento[ target ], arguments.item );
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
		var now = now();
		// prevent override of explicit stamps from imports
		if ( isNull( variables.createdDate ) ) {
			variables.createdDate = now;
		}
		if ( isNull( variables.modifiedDate ) ) {
			variables.modifiedDate = now;
		}
	}

	/**
	 * pre update procedures
	 */
	void function preUpdate( struct oldData ){
		variables.modifiedDate = now();
	}

	/**
	 * Get the created date in the default or specific date/time format
	 *
	 * @dateFormat The date format to use, defaulted by ContentBox to mmm dd, yyyy
	 * @timeFormat The time format to use, defaulted by ContentBox to HH:mm:ss z
	 */
	string function getDisplayCreatedDate( dateFormat = this.DATE_FORMAT, timeFormat = this.TIME_FORMAT ){
		if ( isNull( variables.createdDate ) ) {
			return "";
		}
		return dateFormat( variables.createdDate, arguments.dateFormat ) & " " & timeFormat(
			variables.createdDate,
			arguments.timeFormat
		);
	}

	/**
	 * Get the modified date in the default or specific date/time format
	 *
	 * @dateFormat The date format to use, defaulted by ContentBox to mmm dd, yyyy
	 * @timeFormat The time format to use, defaulted by ContentBox to HH:mm:ss z
	 */
	string function getDisplayModifiedDate( dateFormat = this.DATE_FORMAT, timeFormat = this.TIME_FORMAT ){
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
	 * Pass in a helper path and load it into this object as a mixin
	 *
	 * @helper The path to the helper to load.
	 *
	 * @throws ContentHelperNotFoundException - When the passed helper is not found
	 */
	function includeMixin( required helper ){
		// Init the mixin location and caches reference
		var defaultCache     = variables.cachebox.getCache( "default" );
		var mixinLocationKey = hash( variables.coldbox.getAppHash() & arguments.helper );

		var targetLocation = defaultCache.getOrSet(
			// Key
			"contentObjectHelper-#mixinLocationKey#",
			// Producer
			function(){
				var appMapping      = variables.coldbox.getSetting( "AppMapping" );
				var UDFFullPath     = expandPath( helper );
				var UDFRelativePath = expandPath( "/" & appMapping & "/" & helper );

				// Relative Checks First
				if ( fileExists( UDFRelativePath ) ) {
					targetLocation = "/" & appMapping & "/" & helper;
				}
				// checks if no .cfc or .cfm where sent
				else if ( fileExists( UDFRelativePath & ".cfc" ) ) {
					targetLocation = "/" & appMapping & "/" & helper & ".cfc";
				} else if ( fileExists( UDFRelativePath & ".cfm" ) ) {
					targetLocation = "/" & appMapping & "/" & helper & ".cfm";
				} else if ( fileExists( UDFFullPath ) ) {
					targetLocation = "#helper#";
				} else if ( fileExists( UDFFullPath & ".cfc" ) ) {
					targetLocation = "#helper#.cfc";
				} else if ( fileExists( UDFFullPath & ".cfm" ) ) {
					targetLocation = "#helper#.cfm";
				} else {
					throw(
						message = "Error loading content helper: #helper#",
						detail  = "Please make sure you verify the file location.",
						type    = "ContentHelperNotFoundException"
					);
				}
				return targetLocation;
			},
			// Timeout: 1 week
			10080
		);

		// Include the helper
		include targetLocation;

		return this;
	}

}
