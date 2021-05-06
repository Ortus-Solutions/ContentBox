/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Subscriber service for contentbox
 */
component extends="cborm.models.VirtualEntityService" singleton {

	SubscriberService function init(){
		// init it
		super.init( entityName = "cbSubscriber", useQueryCaching = true );

		return this;
	}

	numeric function getUniqueSubscriberCount(){
		return newCriteria().withProjections( countDistinct = "email" ).count();
	}

}
