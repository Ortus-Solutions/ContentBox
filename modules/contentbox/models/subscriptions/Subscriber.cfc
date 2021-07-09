/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * I am a Subscriber Entity
 */
component
	persistent="true"
	entityname="cbSubscriber"
	table     ="cb_subscribers"
	extends   ="contentbox.models.BaseEntity"
	cachename ="cbSubscriber"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **                          PROPERTIES
	 ********************************************************************* */

	property
		name     ="subscriberID"
		column   ="subscriberID"
		fieldtype="id"
		generator="uuid"
		length   ="36"
		ormtype  ="string"
		update   ="false";

	property
		name   ="subscriberEmail"
		column ="subscriberEmail"
		notnull="true"
		length ="255"
		index  ="idx_subscriberEmail";

	property
		name   ="subscriberToken"
		column ="subscriberToken"
		ormtype="string"
		length ="255"
		notnull="true";

	/* *********************************************************************
	 **                          RELATIONSHIPS
	 ********************************************************************* */

	property
		name        ="subscriptions"
		singularName="subscription"
		fieldtype   ="one-to-many"
		type        ="array"
		lazy        ="true"
		batchsize   ="25"
		orderby     ="createdDate"
		cfc         ="contentbox.models.subscriptions.BaseSubscription"
		fkcolumn    ="FK_subscriberID"
		inverse     ="true"
		cascade     ="all-delete-orphan";

	/* *********************************************************************
	 **                          PK + CONSTRAINTS
	 ********************************************************************* */

	this.pk = "subscriberID";

	this.memento = {
		defaultIncludes : [
			"subscriberEmail",
			"subscriptionToken",
			"subscriptionsSnapshot:subscriptions"
		],
		defaultExcludes : []
	};

	this.constraints = {
		"subscriptionToken" : { required : true, size : "1..255" },
		"subscriberEmail"   : { required : true, size : "1..255", type : "email" }
	};

	/* *********************************************************************
	 **                          METHODS
	 ********************************************************************* */

	function init(){
		super.init();
		return this;
	}

	/**
	 * Utility method to get a snapshot of this object
	 */
	struct function getInfoSnapshot(){
		if ( isLoaded() ) {
			return {
				"subscriberID"    : getSubscriberID(),
				"subscriberEmail" : getSubscriberEmail(),
				"subscriberToken" : getSubscriberToken()
			};
		}
		return {};
	}

	/**
	 * Build a snapshot of subscriptions this subscriber has
	 */
	array function getSubscriptionsSnapshot(){
		if ( hasSubscriptions() ) {
			return getSubscriptions().map( function( thisItem ){
				return arguments.thisItem.getMemento( excludes = "subscriber" );
			} );
		}
		return {};
	}

	/**
	 * Before insert create the user subscription token
	 */
	public void function preInsert(){
		super.preInsert();
		if ( isNull( getSubscriberToken() ) ) {
			var tkn = getSubscriberEmail() & getCreatedDate();
			setSubscriberToken( hash( tkn ) );
		}
	}

	/**
	 * Returns a slim representation of subscriptions by type
	 */
	public struct function getSubscriptionsByContentType(){
		var subs = {};
		for ( var subscription in getSubscriptions() ) {
			var contentType = subscription.getType();
			if ( !structKeyExists( subs, contentType ) ) {
				subs[ "#contentType#" ] = [];
			}
			var memento = { "subscriptionToken" : subscription.getSubscriptionToken() };
			switch ( contentType ) {
				case "Comment":
					memento[ "title" ] = subscription.getRelatedContent().getTitle();
					break;
			}
			arrayAppend( subs[ "#contentType#" ], memento );
		}
		return subs;
	}

}
