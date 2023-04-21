/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Content version services
 */
component extends="cborm.models.VirtualEntityService" singleton {

	/**
	 * Constructor
	 */
	CustomFieldService function init(){
		// init it
		super.init( entityName = "cbContentVersion" );

		return this;
	}

}
