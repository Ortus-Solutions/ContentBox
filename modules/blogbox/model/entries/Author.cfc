/**
* I am a author entity
*/
component persistent="true" entityname="bbAuthor" table="bb_author"{
	
	// Properties
	property name="authorID" 	fieldtype="id" generator="native" setter="false";
	property name="firstName"	length="100" notnull="true";
	property name="lastName"	length="100" notnull="true";
	property name="email"		length="255" notnull="true";
	property name="userName"	length="100" notnull="true";
	property name="password"	length="100" notnull="true";
	property name="isActive" 	notnull="true"  ormtype="boolean" default="false";
	property name="lastLogin" 	ormtype="date"  notnull="false";
	property name="createdDate" notnull="true"  ormtype="date" update="false";
	property name="updatedDate" notnull="true"  ormtype="timestamp" sqltype="timestamp" insert="false" update="false";
	
	// Non-persisted properties
	property name="loggedIn"	persistent="false" default="false" type="boolean";
	
	// O2M -> Entries
	property name="entries" singularName="entry" type="array" fieldtype="one-to-many" 
			 cfc="blogbox.model.entries.Entry" fkcolumn="FK_userID" inverse="true" lazy="true" cascade="all-delete-orphan";
	
	/* ----------------------------------------- ORM EVENTS -----------------------------------------  */
	
	/*
	* In built event handler method, which is called if you set ormsettings.eventhandler = true in Application.cfc
	*/
	public void function preInsert(){
		setCreatedDate( now() );
		setUpdatedDate( now() );
	}
	
	/* ----------------------------------------- PUBLIC -----------------------------------------  */
	
	/**
	* Constructor
	*/
	function init(){
		setLoggedIn( false );
		return this;
	}

	/**
	* Logged in
	*/
	function isLoggedIn(){
		return getLoggedIn();
	}
	
	/**
	* Get formatted lastLogin
	*/
	string function getDisplayLastLogin(){
		var lastLogin = getLastLogin();
		
		if(  NOT isNull(lastLogin) ){
			return dateFormat( lastLogin, "mm/dd/yyy" ) & " " & timeFormat(lastLogin, "hh:mm:ss tt");
		}
		
		return "Never";
	}
	
	/**
	* Get formatted createdDate
	*/
	string function getDisplayCreatedDate(){
		var createdDate = getCreatedDate();
		return dateFormat( createdDate, "mm/dd/yyy" ) & " " & timeFormat(createdDate, "hh:mm:ss tt");
	}
	
	/**
	* Get formatted updatedDate
	*/
	string function getDisplayUpdatedDate(){
		var updatedDate = getUpdatedDate();
		return dateFormat( updatedDate, "mm/dd/yyy" ) & " " & timeFormat(updatedDate, "hh:mm:ss tt");
	}
	
	/**
	* Retrieve full name
	*/
	string function getName(){
		return getFirstName() & " " & getLastName();
	}
	
}