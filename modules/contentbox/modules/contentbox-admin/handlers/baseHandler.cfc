/**
 * ********************************************************************************
 * Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ********************************************************************************
 * The Base handler for ALL ContentBox admin handlers.
 */
component extends="coldbox.system.RestHandler" {

	/**
	 * --------------------------------------------------------------------------
	 * Global Dependencies
	 * --------------------------------------------------------------------------
	 */

	property name="siteService" inject="siteService@contentbox";
	property name="settingService" inject="settingService@contentbox";
	property name="CBHelper" inject="CBHelper@contentbox";
	property name="cbMessagebox" inject="messagebox@cbmessagebox";
	property name="paginator" inject="Paging@contentbox";

	/**
	 * Get the max number of rows to retrieve according to contentbox settings
	 * or an override argument
	 *
	 * @return The max rows to return for pagination
	 */
	private numeric function getMaxRows( maxRows ){
		var results = isNull( arguments.maxRows ) ? variables.settingService.getSetting( "cb_paging_maxrows" ) : arguments.maxRows;
		return val( results );
	}

	/**
	 * Calculate the starting record offset for the incoming page and maxrows per page
	 *
	 * @page    The page to pagination on
	 * @maxRows Max rows per page override or use global setting
	 *
	 * @return The page start offset
	 */
	private numeric function getPageOffset( page = 1, maxRows ){
		var thisMaxRows = getMaxRows( argumentCollection = arguments );
		return ( arguments.page * thisMaxRows - thisMaxRows );
	}

}
