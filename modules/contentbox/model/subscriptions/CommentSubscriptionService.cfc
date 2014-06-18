/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
* Comment Subsciption service for contentbox
*/
component extends="SubscriptionService" singleton {
    /**
    * Constructor
    */
    CommentSubscriptionService function init(){
        // init it
        super.init( entityName="cbCommentSubscription",useQueryCaching=true );
        return this;
    }

    public array function getGroupedSubscriptions( required numeric max=0 ) {
        if( !arguments.max ) {
            var sortOrder = "title ASC";
            var groupProperty = "content.title:title,relatedContent";
            var countAlias = "subscriberCount";
        }
        else {
            var sortOrder="value DESC";
            var groupProperty = "content.title:label";
            var countAlias = "value";
        }
        
        var c = newCriteria();
            c.createAlias( "relatedContent", "content" )
             .withProjections( groupProperty=groupProperty, count="subscriber:#countAlias#" )
             .resultTransformer( c.ALIAS_TO_ENTITY_MAP );

        return c.list( asQuery=false, sortOrder=sortOrder, max=arguments.max );
    }

    public numeric function getGroupedSubscriptionCount() {
        var c = newCriteria();
        return c.count();
    }
}
