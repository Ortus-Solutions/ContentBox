/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Comment Subsciption service for contentbox
 */
component extends="SubscriptionService" singleton {

	function init(){
		super.init( entityName = "cbCommentSubscription", useQueryCaching = true );
		return this;
	}

	/**
	 * Get grouped subscription data
	 *
	 * @max The max records to return
	 *
	 * @return Array of properties: title, relatedContent, subscriberCount or label, value
	 */
	array function getGroupedSubscriptions( required numeric max = 0 ){
		if ( !arguments.max ) {
			var sortOrder     = "title ASC";
			var groupProperty = "content.title:title,relatedContent";
			var countAlias    = "subscriberCount";
		} else {
			var sortOrder     = "value DESC";
			var groupProperty = "content.title:label";
			var countAlias    = "value";
		}

		return newCriteria()
			.joinTo( "relatedContent", "content" )
			.withProjections( groupProperty = groupProperty, count = "subscriber:#countAlias#" )
			.asStruct()
			.list( sortOrder = sortOrder, max = arguments.max );
	}

	/**
	 * Get the count of total comment subscriptions
	 */
	public numeric function getGroupedSubscriptionCount(){
		return newCriteria().count();
	}

}
