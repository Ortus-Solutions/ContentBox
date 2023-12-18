component {

	function configure(){
		/**
		 * --------------------------------------------------------------------------
		 * Mementifier Settings
		 * --------------------------------------------------------------------------
		 * Mementifier settings: https://forgebox.io/view/mementifier
		 */
		return {
			// Turn on to use the ISO8601 date/time formatting on all processed date/time properites, else use the masks
			iso8601Format     : true,
			// The default date mask to use for date properties
			dateMask          : "yyyy-MM-dd",
			// The default time mask to use for date properties
			timeMask          : "HH:mm: ss",
			// Enable orm auto default includes: If true and an object doesn't have any `memento` struct defined
			// this module will create it with all properties and relationships it can find for the target entity
			// leveraging the cborm module.
			ormAutoIncludes   : true,
			// The default value for relationships/getters which return null
			nullDefaultValue  : "",
			// Don't check for getters before invoking them
			trustedGetters    : false,
			// If not empty, convert all date/times to the specific timezone
			convertToTimezone : "UTC"
		};
	}

}
