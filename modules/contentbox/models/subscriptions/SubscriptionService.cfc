/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A generic service for Subscription objects
 */
component extends="cborm.models.VirtualEntityService" singleton {

	SubscriptionService function init( entityName = "cbSubscription" ){
		super.init( entityName = arguments.entityName, useQueryCaching = true );
		return this;
	}

}
