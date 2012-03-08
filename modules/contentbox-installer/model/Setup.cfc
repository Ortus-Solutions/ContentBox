/**
* A setup representation object
*/
component accessors="true" {

	// Properties
	property name="firstName";	property name="lastName";	property name="email";	property name="username";	property name="password";	property name="populateData";	property name="siteName";	property name="siteEmail";	property name="siteOutgoingEmail";	property name="siteTagLine";	property name="siteDescription";	property name="siteKeywords";
	property name="fullrewrite";
	// mail settings
	property name="cb_site_mail_server";
	property name="cb_site_mail_username";
	property name="cb_site_mail_password";
	property name="cb_site_mail_smtp";
	property name="cb_site_mail_tls";
	property name="cb_site_mail_ssl";

	// Constructor
	function init(){
		siteKeywords = "";
		siteDescription = "";
		fullRewrite = true;
		cb_site_mail_server = "";
		cb_site_mail_username = "";
		cb_site_mail_password = "";
		cb_site_mail_smtp = "25";
		cb_site_mail_tls = "false";
		cb_site_mail_ssl = "false";

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

	function getUniqueHash(){
		return hash( variables.toString(), "MD5" );
	}
}
