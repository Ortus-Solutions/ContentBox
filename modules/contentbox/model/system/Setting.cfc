/**
* I am a system setting
*/
component persistent="true" entityname="cbSetting" table="cb_setting"{
	
	// PROPERTIES
	property name="settingID" fieldtype="id" generator="native" setter="false";
	property name="name"  notnull="true" length="100";
	property name="value" notnull="true" ormtype="text";
	
	/************************************** PUBLIC *********************************************/
	
}