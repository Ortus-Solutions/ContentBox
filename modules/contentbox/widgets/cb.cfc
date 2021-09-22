/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A proxy to our ContentBox Helper Object
 */
component extends="contentbox.models.ui.BaseWidget" singleton {

	/**
	 * Constructor
	 */
	cb function init(){
		// Widget Properties
		setName( "CBHelper" );
		setVersion( "1.0" );
		setDescription( "A proxy to our CBHelper object" );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "https://www.ortussolutions.com" );
		setIcon( "wrench" );
		setCategory( "Utilities" );
		return this;
	}

	/**
	 * Shows the CB Helper Motto
	 */
	any function renderIt(){
		return "CBHelper Rocks!";
	}

	/**
	 * Proxy into the CB Helper
	 */
	any function onMissingMethod( missingMethodName, missingMethodArguments ){
		return invoke(
			variables.cb,
			missingMethodName,
			missingMethodArguments
		);
	}

}
