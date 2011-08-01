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
	property name="authorURL"		length="255" 	notnull="false";
	property name="createdDate" 	notnull="true"  ormtype="timestamp"	update="false" default="" index="idx_createdDate";
	property name="isApproved" 		notnull="true"  ormtype="boolean" 	default="false" dbdefault="false" index="idx_publishedComment,idx_approved";
	
	// M20 -> Entry loaded as a proxy
	property name="entry" cfc="blogbox.model.entries.Entry" fieldtype="many-to-one" fkcolumn="FK_entryID" lazy="true" index="idx_publishedComment";
	
	/* ----------------------------------------- ORM EVENTS -----------------------------------------  */
	
	/*
	* In built event handler method, which is called if you set ormsettings.eventhandler = true in Application.cfc
	*/
	public void function preInsert(){
		setCreatedDate( now() );
	}
	
	/************************************** PUBLIC *********************************************/
	
	/**
	* Get formatted createdDate
	*/
	string function getDisplayCreatedDate(){
		var createdDate = getCreatedDate();
		return dateFormat( createdDate, "mm/dd/yyy" ) & " " & timeFormat(createdDate, "hh:mm:ss tt");
	}
	
	
	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getCommentID() );
	}
	
	/**
	* Get memento
	*/
	struct function getMemento(){
		var r = {
			author = variables.author,
			authorIP = variables.authorIP,
			authorEmail = variables.authorEmail,
			authorURL = variables.authorURL,
			createdDate = variables.createdDate,
			isApproved = variables.isApproved,
			content = variables.content		
		};
		
		return r;
		
	}
}