/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage Comment subscriptions
 */
component extends="baseHandler" {

	// Dependencies
	property name="commentSubscriptionService" inject="commentSubscriptionService@contentbox";
	property name="subscriberService" inject="subscriberService@contentbox";

	// pre handler
	function preHandler( event, action, eventArguments, rc, prc ){
		// Tab control
		prc.tabComments = true;
	}

	// index
	function index( event, rc, prc ){
		prc.maxCommentSubscriptions = 4;
		// queries for view
		prc.topCommentSubscriptions = commentSubscriptionService.getGroupedSubscriptions(
			max = prc.maxCommentSubscriptions
		);
		prc.commentSubscriptions     = commentSubscriptionService.getGroupedSubscriptions();
		prc.commentSubscriptionCount = commentSubscriptionService.getGroupedSubscriptionCount();
		prc.uniqueSubscriberCount    = subscriberService.getUniqueSubscriberCount();

		// tab
		prc.tabComments_subscribers = true;

		// view
		event.setView( "subscribers/index" );
	}

}
