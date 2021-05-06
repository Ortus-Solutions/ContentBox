/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * I am an Abstract Subscription Entity
 */
component
	persistent="true"
	entityname="cbSubscription"
	table     ="cb_subscriptions"
	extends   ="contentbox.models.BaseEntityMethods"
	cachename ="cbSubscription"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **                          PROPERTIES again due to ACF Bug
	 ********************************************************************* */

	property
		name   ="createdDate"
		type   ="date"
		ormtype="timestamp"
		notnull="true"
		update ="false";

	property
		name   ="modifiedDate"
		type   ="date"
		ormtype="timestamp"
		notnull="true";

	property
		name     ="isDeleted"
		ormtype  ="boolean"
		notnull  ="true"
		default  ="false"
		dbdefault="false";

	/* *********************************************************************
	 **                          PROPERTIES
	 ********************************************************************* */

	property
		name     ="subscriptionID"
		fieldtype="id"
		generator="uuid"
		setter   ="false"
		update   ="false";

	/**
	 * This token identifies subscribers (emails) to appropriate subscriptions
	 */
	property
		name   ="subscriptionToken"
		ormtype="string"
		length ="255"
		notnull="true";

	/**
	 * The type of subscriptions. Available subscriptions are : comment
	 */
	property
		name   ="type"
		ormtype="string"
		notnull="true";

	/* *********************************************************************
	 **                          RELATIONSHIPS
	 ********************************************************************* */

	// M20 -> Content loaded as a proxy
	property
		name     ="subscriber"
		notnull  ="true"
		cfc      ="contentbox.models.subscriptions.Subscriber"
		fieldtype="many-to-one"
		fkcolumn ="FK_subscriberID"
		lazy     ="true"
		index    ="idx_subscriber"
		inverse  ="true"
		orderBy  ="subscriberEmail";

	/* *********************************************************************
	 **                          PK + CONSTRAINTS
	 ********************************************************************* */

	this.pk = "subscriptionID";

	this.memento = {
		defaultIncludes : [ "subscriptionToken", "type" ],
		defaultExcludes : []
	};

	this.constraints = {
		"subscriptionToken" : { required : true, size : "1..255" },
		"type"              : { required : true, size : "1..255", regex : "^(comment)$" }
	};

	/* *********************************************************************
	 **                          METHODS
	 ********************************************************************* */

	function init(){
		super.init();
		return this;
	}

	/**
	 * Build a snapshot of the subscriber
	 */
	struct function getSubscriberSnapshot(){
		if ( hasSubscriber() ) {
			return getSubscriber().getInfoSnapshot();
		}
		return {};
	}

}
