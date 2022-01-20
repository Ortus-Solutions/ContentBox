/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * This is the interface to needed to implement two-factor authentication methods for ContentBox
 */
interface {

	/**
	 * Get the internal name of a provider, used for registration, internal naming and more.
	 */
	function getName();

	/**
	 * Get the display name for the provider.  Used in all UI screens
	 */
	function getDisplayName();

	/**
	 * Returns html to display to the user for required two-factor fields
	 */
	function getAuthorSetupForm( required author );

	/**
	 * Get the display help for the provider.  Used in the UI setup screens for the author
	 */
	function getAuthorSetupHelp( required author );

	/**
	 * Get the verification help for the provider.  Used in the UI verification screen.
	 */
	function getVerificationHelp();

	/**
	 * If true, then ContentBox will set a tracking cookie for the authentication provider user browser.
	 * If the user, logs in and the device is within the trusted timespan, then no two-factor authentication validation will occur.
	 */
	boolean function allowTrustedDevice();

	/**
	 * Send a challenge via the 2 factor auth implementation.
	 * The return must be a struct with an error boolean bit and a messages string
	 *
	 * @author The author to challenge
	 *
	 * @return struct:{ error:boolean, messages=string }
	 */
	struct function sendChallenge( required author );

	/**
	 * Leverage the default provider to verify a challenge for the specific user.
	 * The return is a structure containing an error flag and a messages string.
	 *
	 * @code   The verification code
	 * @author The author to verify challenge
	 *
	 * @return struct:{ error:boolean, messages:string }
	 */
	struct function verifyChallenge( required string code, required author );

	/**
	 * This method is called once a two factor challenge is accepted and valid.
	 * Meaning the user has completed the validation and will be logged in to ContentBox now.
	 *
	 * @code   The verification code
	 * @author The author to verify challenge
	 */
	function finalize( required string code, required author );

}
