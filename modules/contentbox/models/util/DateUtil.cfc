/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Static date utility object
 */
component singleton {

	/**
	 * Return now() in UTC
	 */
	function nowUTC(){
		return toUTC( now() );
	}

	/**
	 * Conver the incoming date time to UTC using the dateTimeFormat() method
	 *
	 * @see      https://cfdocs.org/datetimeformat
	 * @dateTime The date time object/string to convert
	 */
	function toUTC( required dateTime ){
		return dateTimeFormat(
			arguments.dateTime,
			"yyyy-mm-dd'T'HH:mm:ssZ",
			"UTC"
		);
	}

	/**
	 * Convert epoch milliseconds into local time object.
	 *
	 * @epoch The epoch time in milliseconds
	 *
	 * @return ColdFusion date/time equivalent
	 */
	function epochToLocal( epoch ){
		if ( !len( arguments.epoch ) || !isNumeric( arguments.epoch ) ) {
			return arguments.epoch;
		}
		return dateAdd(
			"l",
			arguments.epoch,
			dateConvert( "utc2Local", "January 1 1970 00:00" )
		);
	}

}
