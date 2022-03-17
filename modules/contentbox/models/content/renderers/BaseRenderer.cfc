/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Our base content renderer
 */
component accessors="true" {

	// DI
	property name="cb" inject="id:CBHelper@contentbox";
	property name="log" inject="logbox:logger:{this}";

	/**
	 * Base Configure
	 */
	void function configure(){
	}

	/**
	 * Replace values of `indexOf` operations on the incoming string builder with a targeted replaceWith
	 *
	 * @builder     The Java string builder
	 * @indexOf     The string to search for
	 * @replaceWith The string to replace with
	 *
	 * @return The string builder.
	 */
	function multiStringReplace(
		required builder,
		required indexOf,
		required replaceWith
	){
		var rLocation = arguments.builder.indexOf( arguments.indexOf );
		var rLen      = len( arguments.indexOf );

		// Loop findings of same instances to replace
		while ( rLocation gt -1 ) {
			// Replace it
			arguments.builder.replace(
				javacast( "int", rLocation ),
				javacast( "int", rLocation + rLen ),
				arguments.replaceWith
			);
			// look again
			rLocation = arguments.builder.indexOf( arguments.indexOf, javacast( "int", rLocation ) );
		}

		return arguments.builder;
	}

}
