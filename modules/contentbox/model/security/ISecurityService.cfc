/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
* This is the ContentBox Security Service needed for security to be implemented in ContentBox
*/
interface{

	/**
	* User validator via security interceptor
	*/
	boolean function userValidator(required struct rule,any messagebox,any controller);
	
	/**
	* Get an author from session, or returns a new empty author entity
	*/
	Author function getAuthorSession();
	
	/**
	* Set a new author in session
	*/
	ISecurityService function setAuthorSession(required Author author);

	/**
	* Delete author session
	*/
	ISecurityService function logout();

	/**
	* Verify if an author has valid credentials in our system.
	*/
	boolean function authenticate(required username, required password);
	
	/**
	* Send password reminder for an author
	*/
	ISecurityService function sendPasswordReminder(required Author author);
	
	/**
	* Check to authorize a user to view a content entry or page
	*/
	boolean function authorizeContent(required content,required password);
	
	/**
	* Checks Whether a content entry or page is protected and user has credentials for it
	*/
	boolean function isContentViewable(required content);
	
}
