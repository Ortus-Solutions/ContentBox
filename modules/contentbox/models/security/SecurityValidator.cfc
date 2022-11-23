/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * This is our security validator that works with CBSecurity in order to validate
 * rules and annotations.
 */
component singleton threadsafe extends="cbsecurity.models.validators.CBAuthValidator"{

	// Dependencies
	property name="securityService" inject="securityService@contentbox";

	/**
	 * This function is called once an incoming event matches a security rule.
	 * You will receive the security rule that matched and an instance of the
	 * ColdBox controller.
	 *
	 * You must return a struct with three keys:
	 * - allow:boolean True, user can continue access, false, invalid access actions will ensue
	 * - type:string(authentication|authorization) The type of block that ocurred.  Either an authentication or an authorization issue.
	 * - messages:string Info/debug messages
	 *
	 * @return { allow:boolean, type:string(authentication|authorization), messages:string }
	 */
	struct function ruleValidator( required rule, required controller ){
		return validateSecurity( rule: arguments.rule, securedValue : arguments.rule.permissions, controller: arguments.controller );
	}

	/**
	 * This function is called once access to a handler/action is detected.
	 * You will receive the secured annotation value and an instance of the ColdBox Controller
	 *
	 * You must return a struct with three keys:
	 * - allow:boolean True, user can continue access, false, invalid access actions will ensue
	 * - type:string(authentication|authorization) The type of block that ocurred.  Either an authentication or an authorization issue.
	 * - messages:string Info/debug messages
	 *
	 * @return { allow:boolean, type:string(authentication|authorization), messages:string }
	 */
	struct function annotationValidator( required securedValue, required controller ){
		return validateSecurity( securedValue: arguments.securedValue, controller: arguments.controller );
	}

	/**
	 * Validates if a user can access an event. Called via the cbSecurity module.
	 *
	 * @rule       The security rule being tested for
	 * @securedValue The annotation secured value or the rule.permissions
	 * @controller The ColdBox controller calling the validation
	 *
	 * @return Validation struct of: { allow:boolean, type:(authentication|authorization), messages }
	 */
	struct function validateSecurity( struct rule, securedValue="", any controller ){
		var results = super.validateSecurity( arguments.securedValue );

		// If we are allowing, then continue to test the ContentBox roles
		if( results.allow ){
			// Get the currently logged in user, if any
			var oAuthor = variables.securityService.getAuthorSession();

			// Check if the rule requires roles
			if ( !isNull( arguments.rule ) && len( arguments.rule.roles ) ) {
				results.allow = false;
				results.type  = "authorization";
				for( var thisRole in arguments.rule.roles.listToArray() ){
					if( oAuthor.getRoleName() eq thisRole ){
						results.allow = true;
						break;
					}
				}
			}
		}

		// If the rule has a message, then set a messagebox
		if (
			!results.allow &&
			!isNull( arguments.rule ) &&
			!isNull( arguments.rule.message ) &&
			len( arguments.rule.message )
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
