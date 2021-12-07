/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Handles subscriptions
 */
component {

	// DI
	property name="subscriberService" inject="subscriberService@contentbox";
	property name="subscriptionService" inject="id:subscriptionService@contentbox";
	property name="messagebox" inject="messagebox@cbmessagebox";
	property name="CBHelper" inject="id:CBHelper@contentbox";

	/**
	 * Remove subscriptions
	 */
	function removeSubscriptions( event, rc, prc ){
		event.paramValue( "keysToRemove", "" ).paramValue( "subscriberToken", "" );

		// check to make sure that at least one subscription AND subscriber token are found
		if ( len( rc.keysToRemove ) && len( rc.subscriberToken ) ) {
			// try to find subscriber by token
			var oSubscriber = subscriberService.findWhere( criteria = { "subscriberToken" : rc.subscriberToken } );
			if ( !isNull( oSubscriber ) ) {
				var targets = listToArray( rc.keysToRemove );
				// loop over remove targets
				for ( var i = 1; i <= arrayLen( targets ); i++ ) {
					subscriptionService.deleteWhere( subscriptionToken = targets[ i ] );
				}
				messagebox.info( "Your subscriptions were successfully updated!" );
				relocate( "__subscriptions/#rc.subscriberToken#" );
			} else {
				messagebox.error( "Sorry, the subscriber token sent is not valid!" );
			}
		} else {
			messagebox.warn( "Sorry, we couldn't complete your request. Please try again." );
		}

		relocate( URL = CBHelper.linkHome() );
	}

	/**
	 * Display Subscriptions
	 */
	function subscriptions( event, rc, prc ){
		event.paramValue( "subscriberToken", "" );
		if ( len( rc.subscriberToken ) ) {
			// get subscriber
			prc.oSubscriber = subscriberService.findWhere( criteria = { "subscriberToken" : rc.subscriberToken } );
			if ( !isNull( prc.oSubscriber ) ) {
				prc.subscriptions = prc.oSubscriber.getSubscriptionsByContentType();
			} else {
				prc.oSubscriber   = subscriberService.new();
				prc.subscriptions = {};
				messagebox.error( "The subscriber token you sent does not exist in our system!" );
			}
		}
		event
			.setLayout( name = "#prc.cbTheme#/layouts/pages", module = "contentbox" )
			.setView( view = "subscription/subscriptions" );
	}

	/**
	 * Unsubscribe from comment notifications
	 */
	function unsubscribe( event, rc, prc ){
		var criteria      = { subscriptionToken : rc.subscriptionToken };
		var oSubscription = subscriptionService.findWhere( criteria = criteria );

		// if we find a match...
		if ( !isNull( oSubscription ) ) {
			var subscriber = oSubscription.getSubscriber();
			// delete it
			// subscriptionService.delete( oSubscription );
			messagebox.warn( "You have been succssfully unsubscribed!" );
			// see if subscriber has others; if so, we can provide a handy link to managing their other subs
			prc.subscriberToken = subscriber.getSubscriberToken();
			prc.subscriptions   = subscriber.getSubscriptionsByContentType();
		} else {
			messagebox.warn( "Sorry, your request could not be completed." );
		}

		relocate( "__subscriptions/#prc.subscriberToken#" );
	}

}
