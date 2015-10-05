/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I am a system setting
*/
component persistent="true" entityname="cbSetting" table="cb_setting" cachename="cbSetting" cacheuse="read-write" {

	// PROPERTIES
	property name="settingID" fieldtype="id" generator="native" setter="false"  params="{ allocationSize = 1, sequence = 'settingID_seq' }";
	property name="name"  notnull="true" length="100";
	property name="value" notnull="true" ormtype="text";

	/************************************** PUBLIC *********************************************/

}