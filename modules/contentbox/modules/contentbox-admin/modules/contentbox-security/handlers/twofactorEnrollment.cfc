/**
 * Enroll Authors in two factor authentication methods
 */
component extends="baseHandler" {

	/**
	 * Executes before all handler actions
	 */
	any function preHandler( event, rc, prc, action, eventArguments ){
		super.preHandler( argumentCollection = arguments );

		// Param In Arguments
		event
			.paramValue( "authorID", 0 )
			.paramValue( "relocationURL", "" )
			.paramValue( "rememberMe", false );

		// Detect In arguments from eventarguments incorporation
		var inArgs = [ "authorID", "relocationURL", "rememberMe" ];
		for ( var thisArg in inArgs ) {
			if ( eventArguments.keyExists( thisArg ) ) {
				rc[ thisArg ] = eventArguments[ thisArg ];
			}
		}

		// Get Author to enroll
		prc.oAuthor = variables.authorService.get( id = rc.authorID );

		// Validate Author
		if ( !prc.oAuthor.isLoaded() ) {
			messagebox.warn( cb.r( "twofactor.invalidAuthor@security" ) );
			relocate( "#prc.cbAdminEntryPoint#/security/login" );
			return;
		}
	}

	/**
	 * Force Enrollment Form
	 */
	function forceEnrollment( event, rc, prc ){
		// If not relocation URL set, default to editor
		if ( !rc.relocationURL.len() ) {
			rc.relocationURL = event.buildLink(
				"#prc.cbAdminEntryPoint#/authors/editor/authorID/#prc.oCurrentAuthor.getAuthorID()###twofactor"
			);
		}
		prc.xehEnroll         = "#prc.cbAdminEntryPoint#.security.twofactorEnrollment.process";
		prc.twoFactorProvider = twoFactorService.getDefaultProviderObject();
		event.setView( "twofactor/forceEnrollment" );
	}


	/**
	 * Process an enrollment for a user.
	 */
	any function process( event, rc, prc ){
		// Given a logged in user, make sure they are the same
		if (
			prc.oCurrentAuthor.isLoaded() &&
			prc.oCurrentAuthor.getAuthorID() != prc.oAuthor.getAuthorID()
		) {
			messagebox.warn( cb.r( "twofactor.illegalAuthorEnrollment@security" ) );
			relocate( "#prc.cbAdminEntryPoint#.dashboard" );
			return;
		}

		// Save Provider Preferences
		var allPreferences = {};
		for ( var key in rc ) {
			if ( reFindNoCase( "^preference\.", key ) ) {
				allPreferences[ listLast( key, "." ) ] = rc[ key ];
			}
		}
		prc.oAuthor.setPreferences( allPreferences );
		variables.authorService.save( prc.oAuthor );

		// Flash data needed for two factor checks
		flash.put(
			"authorData",
			{
				authorID     : prc.oAuthor.getAuthorID(),
				rememberMe   : rc.rememberMe,
				securedURL   : rc.relocationURL,
				isEnrollment : true
			}
		);

		// Send challenge
		var twoFactorResults = twoFactorService.sendChallenge( prc.oAuthor );
		// Verify error, if so, log it and setup a messagebox
		if ( twoFactorResults.error ) {
			log.error( twoFactorResults.messages );
			messagebox.error( cb.r( "twofactor.error@security" ) );
		}

		// Relocate to two factor auth presenter
		relocate( event = "#prc.cbAdminEntryPoint#.security.twofactor" );
	}


	/**
	 * Un-enroll an author from two factor authentication
	 */
	function unenroll( event, rc, prc ){
		prc.oAuthor.setIs2FactorAuth( false );
		variables.authorService.save( prc.oAuthor );
		messagebox.info( cb.r( "twofactor.unenrollment@security" ) );
		relocate( "#prc.cbAdminEntryPoint#/authors/editor/authorID/#rc.authorID###twofactor" );
	}

}
