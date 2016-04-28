/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I am a Comment Subscription Entity
*/
component   persistent="true" 
            entityname="cbCommentSubscription" 
            table="cb_commentSubscriptions" 
            extends="BaseSubscription" 
            joinColumn="subscriptionID" 
            cachename="cbCommentSubscription" 
            cacheuse="read-write"{

    /* *********************************************************************
    **                          DI                                  
    ********************************************************************* */

    property name="commentSubscriptionService" inject="commentSubscriptionService@cb" persistent="false";

    /* *********************************************************************
    **                          RELATIONSHIPS                                  
    ********************************************************************* */

    // M20 -> Content loaded as a proxy
    property    name="relatedContent" 
                notnull="true" 
                cfc="contentbox.models.content.BaseContent" 
                fieldtype="many-to-one" 
                fkcolumn="FK_contentID" 
                lazy="true" 
                index="idx_contentCommentSubscription" 
                orderBy="Title ASC";

    /* *********************************************************************
    **                          PUBLIC FUNCTIONS                                  
    ********************************************************************* */

    public void function preInsert(){
        super.preInsert();
        if( isNull( getSubscriptionToken() ) ) {
            var tkn = getSubscriber().getSubscriberEmail() & getCreatedDate() & getRelatedContent().getContentID();
            setSubscriptionToken( hash( tkn ) );
        }
    }

    public boolean function isExtantSubscription(){
        var criteria = {
            relatedContent = getRelatedContent(),
            subscriber = getSubscriber()
        };
        var extantSubscription = commentSubscriptionService.findWhere( criteria=criteria );
        return isNull( extantSubscription ) ? false : true;
    }
}
