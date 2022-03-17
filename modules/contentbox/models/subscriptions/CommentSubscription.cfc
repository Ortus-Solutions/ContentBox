/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * I am a Comment Subscription Entity
 */
component
	persistent="true"
	entityname="cbCommentSubscription"
	table     ="cb_commentSubscriptions"
	extends   ="BaseSubscription"
	joinColumn="subscriptionID"
	cachename ="cbCommentSubscription"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **                          DI
	 ********************************************************************* */

	property
		name      ="commentSubscriptionService"
		inject    ="provider:commentSubscriptionService@contentbox"
		persistent="false";

	/* *********************************************************************
	 **                          RELATIONSHIPS
	 ********************************************************************* */

	// M20 -> Content loaded as a proxy
	property
		name     ="relatedContent"
		notnull  ="true"
		cfc      ="contentbox.models.content.BaseContent"
		fieldtype="many-to-one"
		fkcolumn ="FK_contentID"
		lazy     ="true"
		fetch    ="join"
		orderBy  ="Title ASC";

	/* *********************************************************************
	 **                          METHODS
	 ********************************************************************* */

	function init(){
		super.init();
		appendToMemento( [ "relatedContentSnapshot:relatedContent" ], "defaultIncludes" );
		return this;
	}

	/**
	 * Build a snapshot of the related content
	 */
	struct function getRelatedContentSnapshot(){
		if ( hasRelatedContent() ) {
			return getRelatedContent().getInfoSnapshot();
		}
		return {};
	}

	/**
	 * Before insertion verify if we have a token, else generate one.
	 */
	public void function preInsert(){
		super.preInsert();

		if ( isNull( getSubscriptionToken() ) ) {
			var tkn = getSubscriber().getSubscriberEmail() & getCreatedDate() & getRelatedContent().getContentID();
			setSubscriptionToken( hash( tkn ) );
		}
	}

	public boolean function isExtantSubscription(){
		var extantSubscription = variables.commentSubscriptionService.findWhere( {
			relatedContent : getRelatedContent(),
			subscriber     : getSubscriber()
		} );
		return isNull( extantSubscription ) ? false : true;
	}

}
