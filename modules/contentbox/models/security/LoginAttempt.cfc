/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Store logins from admin attempts. Depending on system settings, users can be blocked via this entity
 */
component
	persistent="true"
	table     ="cb_loginAttempts"
	entityName="cbLoginAttempt"
	extends   ="contentbox.models.BaseEntity"
	cachename ="loginAttempt"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	/**
	 * Primary key
	 */
	property
		name     ="loginAttemptsID"
		column   ="loginAttemptsID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		ormtype  ="string"
		update   ="false";

	/**
	 * The username attempt value
	 */
	property
		name   ="value"
		column ="value"
		notnull="true"
		default=""
		length ="255"
		index  ="idx_values";
	/**
	 * How many attempts in the system
	 */
	property
		name   ="attempts"
		column ="attempts"
		ormtype="integer"
		notnull="true"
		default="0";
	/**
	 * Tracks the last successful login IP address
	 */
	property
		name   ="lastLoginSuccessIP"
		column ="lastLoginSuccessIP"
		notnull="false"
		length ="100";
	/**
	 * Verifies if tracking is blocked or not
	 */
	property
		name      ="isBlocked"
		column    ="isBlocked"
		persistent="false"
		default   ="false"
		type      ="boolean";

	/* *********************************************************************
	 **							PK+CONSTRAINTS
	 ********************************************************************* */

	this.pk = "loginAttemptsID";

	this.memento = {
		defaultIncludes : [
			"value",
			"attempts",
			"lastLoginSuccessIP",
			"isBlocked"
		],
		defaultExcludes : [ "" ]
	};

	/* *********************************************************************
	 **							PUBLIC FUNCTIONS
	 ********************************************************************* */

	/**
	 * Constructor
	 */
	function init(){
		variables.createdDate = now();
		variables.attempts    = 0;
		variables.isBlocked   = false;

		super.init();

		return this;
	}

}
