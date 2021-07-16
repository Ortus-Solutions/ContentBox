/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage ContentBox users
 */
component extends="baseHandler" {

	// DI
	property name="mailService" inject="mailService@cbmailservices";

	/**
	 * tester
	 */
	function tester( event, rc, prc ){
		event.paramValue( "template", "" );

		var bindingArgs = { "gravatarEmail" : "info@ortussolutions.com" };

		return renderLayout(
			view   = "/contentbox/email_templates/#encodeForHTML( rc.template )#",
			layout = "/contentbox/email_templates/layouts/email",
			args   = bindingArgs
		);
	}

}
