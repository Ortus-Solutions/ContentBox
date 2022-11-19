component {

	function configure(){
		/**
		 * --------------------------------------------------------------------------
		 * ColdBox ORM
		 * --------------------------------------------------------------------------
		 * ColdBox cborm configurations https://forgebox.io/view/cborm
		 */
		return {
			injection : {
				// enable entity injection via WireBox
				enabled : true,
				// Which entities to include in DI ONLY, if empty include all entities
				include : "",
				// Which entities to exclude from DI, if empty, none are excluded
				exclude : ""
			},
			resources : {
				// Enable the ORM Resource Event Loader
				eventLoader  : true,
				// Prefix to use on all the registered pre/post{Entity}{Action} events
				eventPrefix  : "cb_",
				// Pagination max rows
				maxRows      : 25,
				// Pagination max row limit: 0 = no limit
				maxRowsLimit : 500
			}
		};
	}

}
