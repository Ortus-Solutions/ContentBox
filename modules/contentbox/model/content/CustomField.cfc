/**
* I am a custom field metadata that can be attached to base content in contentbox
*/
component persistent="true" entityname="cbCustomField" table="cb_customfield"{
	
	// Properties
	property name="customFieldID" fieldtype="id" generator="native" setter="false";
	property name="key"			notnull="true"  ormtype="string" 	length="255";
	property name="value"    	notnull="true"  ormtype="text" 		length="8000";
	
	// M20 -> Content loaded as a proxy
	property name="relatedContent" notnull="false" cfc="contentbox.model.content.BaseContent" fieldtype="many-to-one" fkcolumn="FK_contentID" lazy="true" index="idx_contentCustomFields";
	
	/* ----------------------------------------- PUBLIC -----------------------------------------  */
	
	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getCustomFieldID() );
	}
	
}