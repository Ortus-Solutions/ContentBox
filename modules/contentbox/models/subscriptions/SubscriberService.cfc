/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Subscriber service for contentbox
*/
component extends="cborm.models.VirtualEntityService" singleton {
    /**
    * Constructor
    */
    SubscriberService function init(){
        // init it
        super.init( entityName="cbSubscriber", useQueryCaching=true );

        return this;
    }

    public numeric function getUniqueSubscriberCount() {
        var c = newCriteria();
            c.withProjections( countDistinct="email" );
        return c.count();
    }
}
