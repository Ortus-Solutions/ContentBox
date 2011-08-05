/**
* I model a custom HTML content piece
*/
component persistent="true" entityname="bbCustomHTML" table="bb_customHTML"{
	
	// PROPERTIES
	property name="contentID" fieldtype="id" generator="native" setter="false";
	property name="title"			notnull="true"  length="200";
	property name="slug"			notnull="true"  length="200" unique="true" index="idx_slug";
	property name="value" 			notnull="true"  ormtype="text" length="8000";
	
	/************************************** PUBLIC *********************************************/
	
}