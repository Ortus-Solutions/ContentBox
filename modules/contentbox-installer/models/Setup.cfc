/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A setup representation object
 */
component accessors="true" {

	// Properties
	property name="firstName";
	property name="lastName";
	property name="email";
	property name="username";
	property name="password";
	property name="populateData";
	property name="siteName";
	property name="siteEmail";
	property name="siteOutgoingEmail";
	property name="siteTagLine";
	property name="siteDescription";
	property name="siteKeywords";
	property name="fullrewrite";
	property name="rewrite_engine";
	// mail settings
	property name="cb_site_mail_server";
	property name="cb_site_mail_username";
	property name="cb_site_mail_password";
	property name="cb_site_mail_smtp";
	property name="cb_site_mail_tls";
	property name="cb_site_mail_ssl";

	/**
	 * Constructor
	 */
	function init(){
		variables.siteKeywords          = "";
		variables.siteDescription       = "";
		variables.cb_site_mail_server   = "";
		variables.cb_site_mail_username = "";
		variables.cb_site_mail_password = "";
		variables.cb_site_mail_smtp     = "25";
		variables.cb_site_mail_tls      = "false";
		variables.cb_site_mail_ssl      = "false";
		variables.populateData          = true;
		variables.fullRewrite           = true;
		variables.rewrite_engine        = "mod_rewrite";

		return this;
	}

	/**
	 * Get user data
	 */
	function getUserData(){
		var results = {
			firstname : firstname,
			lastName  : lastName,
			email     : email,
			username  : username,
			password  : password
		};
		return results;
	}

}
