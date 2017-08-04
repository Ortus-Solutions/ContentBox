/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* This is the ContentBox Security Service needed for security to be implemented in ContentBox
*/
interface{

	/**
	* User validator via security interceptor
	*/
	boolean function userValidator( required struct rule, any controller );

	/**
	* Get an author from session, or returns a new empty author entity
	*/
	Author function getAuthorSession();

	/**
	* Set a new author in session
	*/
	ISecurityService function setAuthorSession( required Author author );

	/**
	* Delete author session
	*/
	ISecurityService function logout();

	/**
	* Authenticate an author via ContentBox credentials.
	* This method returns a structure containing an indicator if the authentication was valid (`isAuthenticated` and
	* The `author` object which it represents.
	* 
	* @username The username to validate
	* @password The password to validate
	*
	* @return struct:{ isAuthenticated:boolean, author:Author }
	*/
	struct function authenticate( required username, required password );

	/**
	* Send password reminder for an author
	*/
	struct function sendPasswordReminder( required Author author, boolean adminIssued=false, Author issuer );

	/**
	* Resets a user's password.
	*
	* @returns {error:boolean, messages:string}
	*/
	struct function resetUserPassword( required token, required Author author, required password );

	/**
	* Check to authorize a user to view a content entry or page
	*/
	boolean function authorizeContent( required content, required password );

	/**
	* Checks Whether a content entry or page is protected and user has credentials for it
	*/
	boolean function isContentViewable( required content );

}
