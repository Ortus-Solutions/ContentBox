/**
 * ********************************************************************************
 * Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ********************************************************************************
 * The Base handler for ALL contentbox admin handlers.
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

}
