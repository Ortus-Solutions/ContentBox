/**
* I am a custom field metadata that can be attached to pages or blog entries
*/
component persistent="true" entityname="cbCustomField" table="cb_customfield"{
	
	// Properties
	property name="customFieldID" fieldtype="id" generator="native" setter="false";
	property name="key"			notnull="true"  ormtype="string" 	length="255";
	property name="value"    	notnull="true"  ormtype="text" 		length="8000";
	
	// M20 -> Entry loaded as a proxy
	property name="entry" notnull="false" cfc="contentbox.model.content.Entry" fieldtype="many-to-one" fkcolumn="FK_entryID" lazy="true" index="idx_entryCustomFields";
	
	// M20 -> Page loaded as a proxy
	property name="page" notnull="false" cfc="contentbox.model.content.Page" fieldtype="many-to-one" fkcolumn="FK_pageID" lazy="true" index="idx_pageCustomFields";
	
	/* ----------------------------------------- PUBLIC -----------------------------------------  */
	
	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getCustomFieldID() );
	}
	
	/**
	* setRelatedContent
	*/
	CustomField function setRelatedContent(content){
		if( arguments.content.getType() eq "entry" ){ setEntry( arguments.content ); }
		else{ setPage( arguments.content ); }
		return this;
	}
	
	
}