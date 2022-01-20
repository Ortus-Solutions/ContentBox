/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * This is the ContentBox Security Service needed for security to be implemented in ContentBox
 */
interface {

	/**
	 * Validates if a user can access an event. Called via the cbSecurity module.
	 *
	 * @rule       The security rule being tested for
	 * @controller The ColdBox controller calling the validation
	 */
	boolean function validateSecurity( struct rule, securedValue, any controller );

	/**
	 * Get an author from session, or returns a new empty author entity
	 */
	Author function getAuthorSession();

	/**
	 * Logs in a user into persistence storages for tracking purposes
	 */
	ISecurityService function login( required Author author );

	/**
	 * Delete author session
	 */
	ISecurityService function logout();

	/**
	 * Authenticate an author via ContentBox credentials. If the user is not valid an InvalidCredentials is thrown. Required for JWT services
	 *
	 * The usage of the LogThemIn boolean flag is essential for two-factor authentication, where a user is authenticated
	 * but not yet validated by a two-factor mechanism.  Thus, the default is to ONLY authenticate but not log them in yet.
	 *
	 * For our RESTFul API, we can do an authenticate and login at the same time.
	 *
	 * @username  The username to validate
	 * @password  The password to validate
	 * @logThemIn If true, we will log them in automatically, else it will be the caller's job to do so via the `login()` method.
	 *
	 * @return User : The logged in user object
	 *
	 * @throws InvalidCredentials
	 */
	Author function authenticate(
		required username,
		required password,
		boolean logThemIn = false
	);

	/**
	 * Send password reminder for an author
	 */
	struct function sendPasswordReminder(
		required Author author,
		boolean adminIssued = false,
		Author issuer
	);

	/**
	 * Resets a user's password.
	 *
	 * @return {error:boolean, messages:string}
	 */
	struct function resetUserPassword(
		required token,
		required Author author,
		required password
	);

	/**
	 * Check to authorize a user to view a content entry or page
	 */
	boolean function authorizeContent( required content, required password );

	/**
	 * Checks Whether a content entry or page is protected and user has credentials for it
	 */
	boolean function isContentViewable( required content );

}
