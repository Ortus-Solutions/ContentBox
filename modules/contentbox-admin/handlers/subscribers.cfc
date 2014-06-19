/**
* Manage subscriptions
*/
component extends="baseHandler"{

    // Dependencies
    property name="commentSubscriptionService"      inject="id:commentSubscriptionService@cb";
    property name="subscriberService"               inject="id:subscriberService@cb";
    
    // pre handler
    function preHandler( event, action, eventArguments, rc, prc ){
        // Tab control
        prc.tabStats = true;
    }

    // index
    function index( required any event, required struct rc, required struct prc ){
        prc.maxCommentSubscriptions = 4;
        // queries for view
        prc.topCommentSubscriptions = commentSubscriptionService.getGroupedSubscriptions( max=prc.maxCommentSubscriptions );
        prc.commentSubscriptions = commentSubscriptionService.getGroupedSubscriptions();
        prc.commentSubscriptionCount = commentSubscriptionService.getGroupedSubscriptionCount();
        prc.uniqueSubscriberCount = subscriberService.getUniqueSubscriberCount();
        prc.cssAppendList = "../js/morris.js/morris";
        prc.jsAppendList  = "morris.js/raphael-min,morris.js/morris.min";
        // view
        event.setView( "subscribers/index" );
    }
}