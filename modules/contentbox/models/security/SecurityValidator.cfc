/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * This is our security validator that works with CBSecurity in order to validate
 * rules and annotations.
 */
component singleton {

	// Dependencies
	property name="securityService" inject="securityService@contentbox";

	SecurityValidator function init(){
		return this;
	}

	/**
	 * This function is called once an incoming event matches a security rule.
	 * You will receive the security rule that matched and an instance of the
	 * ColdBox controller.
	 *
	 * You must return a struct with two keys:
	 * - allow:boolean True, user can continue access, false, invalid access actions will ensue
	 * - type:string(authentication|authorization) The type of block that ocurred.  Either an authentication or an authorization issue.
	 * - messages:string Info/debug messages
	 *
	 * @return { allow:boolean, type:authentication|authorization, messages:string }
	 */
	struct function ruleValidator( required rule, required controller ){
		return validateSecurity( rule: arguments.rule, controller: arguments.controller );
	}

	/**
	 * This function is called once access to a handler/action is detected.
	 * You will receive the secured annotation value and an instance of the ColdBox Controller
	 *
	 * You must return a struct with two keys:
	 * - allow:boolean True, user can continue access, false, invalid access actions will ensue
	 * - type:string(authentication|authorization) The type of block that ocurred.  Either an authentication or an authorization issue.
	 * - messages:string Info/debug messages
	 *
	 * @return { allow:boolean, type:authentication|authorization, messages:string }
	 */
	struct function annotationValidator( required securedValue, required controller ){
		return validateSecurity( securedValue: arguments.securedValue, controller: arguments.controller );
	}

	/**
	 * Validates if a user can access an event. Called via the cbSecurity module.
	 *
	 * @rule       The security rule being tested for
	 * @controller The ColdBox controller calling the validation
	 *
	 * @return Validation struct of: { allow:boolean, type:(authentication|authorization), messages }
	 */
	struct function validateSecurity( struct rule, securedValue, any controller ){
		var results = {
			"allow"    : false,
			"type"     : "authentication",
			"messages" : ""
		};
		// Get the currently logged in user, if any
		var author = variables.securityService.getAuthorSession();

		// First check if user has been authenticated.
		if ( author.isLoaded() AND author.isLoggedIn() ) {
			// Check if the rule requires roles
			if ( !isNull( arguments.rule ) && len( arguments.rule.roles ) ) {
				for ( var x = 1; x lte listLen( arguments.rule.roles ); x++ ) {
					if ( listGetAt( arguments.rule.roles, x ) eq author.getRoleName() ) {
						results.allow = true;
						results.type  = "authorization";
						break;
					}
				}
			}

			// Check if the rule requires permissions
			if ( !isNull( arguments.rule ) && len( arguments.rule.permissions ) ) {
				for ( var y = 1; y lte listLen( arguments.rule.permissions ); y++ ) {
					if ( author.checkPermission( listGetAt( arguments.rule.permissions, y ) ) ) {
						results.allow = true;
						results.type  = "authorization";
						break;
					}
				}
			}

			// Check if the secured annotations is set
			if ( !isNull( arguments.securedValue ) && len( arguments.securedValue ) ) {
				for ( var y = 1; y lte listLen( arguments.securedValue ); y++ ) {
					if ( author.checkPermission( listGetAt( arguments.securedValue, y ) ) ) {
						results.allow = true;
						results.type  = "authorization";
						break;
					}
				}
			}

			results.allow = true;
		}

		// If the rule has a message, then set a messagebox
		if (
			!results.allow &&
			!isNull( arguments.rule ) &&
			structKeyExists( rule, "message" ) &&
			len( rule.message )
		) {
			arguments.controller
				.getWireBox()
				.getInstance( "messagebox@cbmessagebox" )
				.setMessage(
					type   : ( structKeyExists( rule, "messageType" ) && len( rule.messageType ) ? rule.messageType : "info" ),
					message: rule.message
				);
		}

		return results;
	}

}
