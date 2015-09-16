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
	* Verify if an author has valid credentials in our system.
	*/
	boolean function authenticate( required username, required password );
	
	/**
	* Send password reminder for an author
	*/
	ISecurityService function sendPasswordReminder( required Author author );
	
	/**
	* Check to authorize a user to view a content entry or page
	*/
	boolean function authorizeContent( required content, required password );
	
	/**
	* Checks Whether a content entry or page is protected and user has credentials for it
	*/
	boolean function isContentViewable( required content );
	
}
