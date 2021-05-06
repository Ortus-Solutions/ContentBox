/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Comment Notification interceptor
 */
component extends="coldbox.system.Interceptor" accessors="true" {

	// DI
	property name="commentService" inject="id:commentService@cb";
	property name="subscriberService" inject="id:subscriberService@cb";
	property name="commentSubscriptionService" inject="id:commentSubscriptionService@cb";

	function configure(){
	}

	public void function cbui_onCommentPost( required any event, required struct data ){
		var content   = data.content;
		var comment   = data.comment;
		var subscribe = data.subscribe;
		var moderated = data.moderationResults.moderated;

		// now process existing subscriptions
		if ( !moderated ) {
			variables.commentService.sendSubscriptionNotifications( comment );
		}

		// if author has elected to subscribe to comments, do it
		if ( subscribe ) {
			var criteria   = ;
			var subscriber = variables.subscriberService.findWhere( criteria = criteria );
			var exists     = false;

			if ( isNull( subscriber ) ) {
				subscriber = variables.subscriberService.new( criteria );
			}

			var args = {
				relatedContent : comment.getRelatedContent(),
				subscriber     : subscriber,
				type           : "Comment"
			};

			if ( subscriber.isLoaded() ) {
				exists = !isNull(
					variables.commentSubscriptionService.findWhere( criteria = args )
				);
			}

			if ( !exists ) {
				var subscription = variables.commentSubscriptionService.new( args );
				subscriber.addSubscription( subscription );
				variables.subscriberService.save( subscriber );
			}
		}
	}

	public void function cbadmin_onCommentStatusUpdate( required any event, required struct data ){
		var commentIds = listToArray( arguments.data.commentID );
		for ( var commentId in commentIds ) {
			var comment = variables.commentService.get( commentId );
			if ( comment.getIsApproved() ) {
				variables.commentService.sendSubscriptionNotifications( comment );
			}
		}
	}

}
