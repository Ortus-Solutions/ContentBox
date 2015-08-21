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
* I am a Comment Subscription Entity
*/
component persistent="true" entityname="cbCommentSubscription" table="cb_commentSubscriptions" extends="BaseSubscription" joinColumn="subscriptionID" cachename="cbCommentSubscription" cacheuse="read-write" {
    // DI Injections
    property name="commentSubscriptionService"inject="commentSubscriptionService@cb" persistent="false";
    // PROPERTIES

    // M20 -> Content loaded as a proxy
    property name="relatedContent" notnull="true" cfc="contentbox.models.content.BaseContent" fieldtype="many-to-one" fkcolumn="FK_contentID" lazy="true" index="idx_contentCommentSubscription" orderBy="Title ASC";

    /************************************** CONSTRUCTOR *********************************************/

    /**
    * constructor
    */
    function init(){
        createdDate = now();
    }

    /************************************** PUBLIC *********************************************/

    public void function preInsert() {
        if( isNull( getSubscriptionToken() ) ) {
            var tkn = getSubscriber().getSubscriberEmail() & getCreatedDate() & getRelatedContent().getContentID();
            setSubscriptionToken( hash( tkn ) );
        }
    }

    public boolean function isExtantSubscription() {
        var criteria = {
            relatedContent = getRelatedContent(),
            subscriber = getSubscriber()
        };
        var extantSubscription = commentSubscriptionService.findWhere( criteria=criteria );
        return isNull( extantSubscription ) ? false : true;
    }
}
