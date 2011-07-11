/**
* I am a Comment Entity
*/
component persistent="true" entityname="bbComment" table="bb_comment"{
	
	// PROPERTIES
	property name="commentID" fieldtype="id" generator="native" setter="false";
	property name="content" 		ormtype="text" 	notnull="true";
	property name="author"			length="100" 	notnull="true";
	property name="authorIP"		length="100" 	notnull="true";
	property name="authorEmail"		length="255" 	notnull="true";
	property name="authorURL"		length="500" 	notnull="false";
	property name="createdDate" 	notnull="true"  ormtype="date" 		update="false";
	property name="isApproved" 		notnull="true"  ormtype="boolean" 	default="false";
	
	// M20 -> Entry
	property name="entry" cfc="blogbox.model.entries.Entry" fieldtype="many-to-one" fkcolumn="FK_entryID";
	
	/************************************** PUBLIC *********************************************/
	
	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getCommentID() );
	}
	
}