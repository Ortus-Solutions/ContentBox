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

	// Site Settings
	property name="siteName";
	property name="siteTagLine";
	property name="siteDescription";
	property name="siteKeywords";
	property name="populateData";
	property name="createDevSite";

	// Rewrites
	property name="fullrewrite";
	property name="rewrite_engine";

	// mail settings
	property name="siteEmail";
	property name="siteOutgoingEmail";
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
		variables.createDevSite         = true;

		return this;
	}

	/**
	 * Get user data
	 */
	function getUserData(){
		var results = {
			"firstname" : firstname,
			"lastName"  : lastName,
			"email"     : email,
			"username"  : username,
			"password"  : password
		};
		return results;
	}

}
