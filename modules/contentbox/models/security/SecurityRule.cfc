/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A cool SecurityRule entity
 */
component
	persistent="true"
	table     ="cb_securityRule"
	entityName="cbSecurityRule"
	extends   ="contentbox.models.BaseEntity"
	cachename ="cbSecurityRule"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name     ="ruleID"
		column   ="ruleID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		ormtype  ="string"
		update   ="false";

	property
		name   ="whitelist"
		column ="whitelist"
		ormtype="string"
		notnull="false"
		default=""
		length ="255";

	property
		name   ="securelist"
		column ="securelist"
		ormtype="string"
		notnull="true"
		default=""
		length ="255";

	property
		name     ="match"
		column   ="match"
		ormtype  ="string"
		notnull  ="false"
		default  ="event"
		dbdefault="'event'"
		length   ="50";

	property
		name   ="roles"
		column ="roles"
		ormtype="string"
		notnull="false"
		default=""
		length ="255";

	property
		name   ="permissions"
		column ="permissions"
		ormtype="string"
		notnull="false"
		default=""
		length ="500";

	property
		name   ="redirect"
		column ="redirect"
		ormtype="string"
		notnull="false"
		default=""
		length ="500";

	property
		name   ="overrideEvent"
		column ="overrideEvent"
		ormtype="string"
		notnull="false"
		default=""
		length ="500";

	property
		name   ="useSSL"
		column ="useSSL"
		ormtype="boolean"
		notnull="false"
		default="false";

	property
		name     ="action"
		column   ="action"
		ormtype  ="string"
		notnull  ="false"
		default  ="redirect"
		dbdefault="'redirect'"
		length   ="50";

	property
		name   ="module"
		column ="module"
		ormtype="string"
		notnull="false"
		default=""
		length ="500";

	property
		name   ="order"
		column ="order"
		ormtype="integer"
		notnull="true"
		default="0";

	property
		name   ="message"
		column ="message"
		ormtype="string"
		notnull="false"
		default=""
		length ="255";

	property
		name     ="messageType"
		column   ="messageType"
		ormtype  ="string"
		notnull  ="false"
		default  ="info"
		dbdefault="'info'"
		length   ="50";

	/* *********************************************************************
	 **							PK + CONSTRAINTS
	 ********************************************************************* */

	this.pk = "ruleID";

	this.memento = {
		defaultIncludes : [
			"action",
			"match",
			"message",
			"messageType",
			"module",
			"order",
			"overrideEvent",
			"permissions",
			"redirect",
			"roles",
			"securelist",
			"useSSL",
			"whitelist"
		],
		defaultExcludes : [ "" ]
	};

	this.constraints = {
		"whitelist"  : { required : false, size : "1..255" },
		"securelist" : { required : true, size : "1..255" },
		"match"      : {
			required : false,
			size     : "1..50",
			regex    : "^(event|url)$"
		},
		"roles"         : { required : false, size : "1..255" },
		"permissions"   : { required : false, size : "1..500" },
		"redirect"      : { required : false, size : "1..500" },
		"overrideEvent" : { required : false, size : "1..500" },
		"useSSL"        : { required : false, type : "boolean" },
		"action"        : {
			required : false,
			size     : "1..50",
			regex    : "^(redirect|override)$"
		},
		"module"      : { required : false, size : "1..255" },
		"order"       : { required : false, type : "numeric" },
		"message"     : { required : false, size : "1..255" },
		"messageType" : { required : false, size : "1..50" }
	};

	/* *********************************************************************
	 **							PUBLIC FUNCTIONS
	 ********************************************************************* */

	// Constructor
	function init(){
		variables.match         = "event";
		variables.action        = "redirect";
		variables.useSSL        = false;
		variables.order         = 0;
		variables.messageType   = "info";
		variables.overrideEvent = "";
		variables.module        = "";

		super.init();

		return this;
	}

}
