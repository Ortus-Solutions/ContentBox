/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Base exporter class
 */
component accessors=true {

	// DI
	property name="log" inject="logbox:logger:{this}";

	/**
	 * Export filename
	 */
	property name="fileName" type="string";

	/**
	 * Human readable name used in the UI
	 */
	property name="displayName" type="string";

	/**
	 * The format of the file to export
	 */
	property name="format" type="string";

	/**
	 * The priority level of the export
	 */
	property name="priority" type="numeric";

	/**
	 * The name of the exporter
	 */
	property name="name" type="string";

	/**
	 * The allowed export formats the exporter defines
	 */
	property name="allowedFormats";


	/**
	 * Constructor
	 */
	function init(){
		setFileName( createUUID() );
		setFormat( "json" );
		setPriority( 1 );

		variables.name           = "";
		variables.allowedFormats = "";

		return this;
	}

	/**
	 * Determines if exporter is valid based on validation criteria
	 */
	boolean function isValid(){
		return !arrayLen( validate() );
	}

}
