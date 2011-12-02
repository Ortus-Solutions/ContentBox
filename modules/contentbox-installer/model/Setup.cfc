/**
* A setup representation object
*/
component accessors="true" {

	// Properties
	property name="firstName";	property name="lastName";	property name="email";	property name="username";	property name="password";	property name="populateData";	property name="siteName";	property name="siteEmail";	property name="siteOutgoingEmail";	property name="siteTagLine";	property name="siteDescription";	property name="siteKeywords";	
	
	// Constructor
	function init(){
		setSiteKeywords('');
		setSiteDescription('');
		return this;
	}
	
	function getUserData(){
		var results = {
			firstname = firstname,
			lastName = lastName,
			email = email,
			username = username,
			password = password
		};
		return results;
	}
	
}
