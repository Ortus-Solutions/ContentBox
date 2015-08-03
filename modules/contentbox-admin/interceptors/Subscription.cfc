/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License" );
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
* Comment Notification interceptor
*/
component extends="coldbox.system.Interceptor" accessors="true"{

    // DI
    property name="commentService"  inject="id:commentService@cb";
    property name="subscriberService"  inject="id:subscriberService@cb";
    property name="commentSubscriptionService"  inject="id:commentSubscriptionService@cb";

    /**
    * Configure
    */
    function configure(){}

    public void function cbui_onCommentPost( required any event, required struct interceptData ) {
        var content = interceptData.content;
        var comment = interceptData.comment;
        var subscribe = interceptData.subscribe;
        var moderated = interceptData.moderationResults.moderated;

        // now process existing subscriptions
        if( !moderated ) {
            commentService.sendSubscriptionNotifications( comment );
        }
        // if author has elected to subscribe to comments, do it
        if( subscribe ) {
            var criteria = { subscriberEmail=comment.getAuthorEmail() };
            var subscriber = subscriberService.findWhere( criteria=criteria );
            var exists = false;
            
            if( isNull( subscriber ) ) {
                subscriber = subscriberService.new( criteria );
            }
            var args = {
                relatedContent = comment.getRelatedContent(),
                subscriber = subscriber,
                type = "Comment"

            };
            if( subscriber.isLoaded() ) {
                exists = !isNull( commentSubscriptionService.findWhere( criteria=args ) );
            }

            if( !exists ) {
                var subscription = commentSubscriptionService.new( args );
                subscriber.addSubscription( subscription );
                subscriberService.save( subscriber );
            }
        }
    }

    public void function cbadmin_onCommentStatusUpdate( required any event, required struct interceptData ) {
        var commentIds = listToArray( arguments.interceptData.commentID );
        for( var commentId in commentIds ) {
            var comment = commentService.get( commentId );
            if( comment.getIsApproved() ) {
                commentService.sendSubscriptionNotifications( comment );
            }
        }
    }
}