/**
* I am a author entity
*/
component persistent="true" entityname="bbAuthor" table="bb_author" batchsize="10"{

	// Properties
	property name="authorID" 	fieldtype="id" generator="native" setter="false";
	property name="firstName"	length="100" notnull="true";
	property name="lastName"	length="100" notnull="true";
	property name="email"		length="255" notnull="true" index="idx_email";
	property name="userName"	length="100" notnull="true" index="idx_login" ;
	property name="password"	length="100" notnull="true" index="idx_login";
	property name="isActive" 	ormtype="boolean"   notnull="true" default="false" index="idx_login,idx_active";
	property name="lastLogin" 	ormtype="timestamp" notnull="false";
	property name="createdDate" ormtype="timestamp" notnull="true" update="false";

	// Non-persisted properties
	property name="loggedIn"	persistent="false" default="false" type="boolean";

	// O2M -> Entries
	property name="entries" singularName="entry" type="array" fieldtype="one-to-many" cfc="blogbox.model.entries.Entry"
			 fkcolumn="FK_authorID" inverse="true" lazy="extra" cascade="all-delete-orphan" batchsize="10" orderby="publishedDate DESC";

	// Calculated properties
	property name="numberOfEntries" formula="select count(*) from bb_entry entry where entry.FK_authorID=authorID" ;

	/* ----------------------------------------- ORM EVENTS -----------------------------------------  */

	/*
	* In built event handler method, which is called if you set ormsettings.eventhandler = true in Application.cfc
	*/
	public void function preInsert(){
		setCreatedDate( now() );
	}

	/* ----------------------------------------- PUBLIC -----------------------------------------  */

	/**
	* Constructor
	*/
	function init(){
		setLoggedIn( false );
		return this;
	}

	/*
	* Validate entry, returns an array of error or no messages
	*/
	array function validate(){
		var errors = [];

		// limits
		firstName 	= left(firstName,100);
		lastName 	= left(lastName,100);
		email 		= left(email,255);
		username 	= left(username,100);
		password 	= left(password,100);

		// Required
		if( len(firstName) ){ arrayAppend(errors, "First Name is required"); }
		if( len(lastName) ){ arrayAppend(errors, "Last Name is required"); }
		if( len(email) ){ arrayAppend(errors, "Email is required"); }
		if( len(username) ){ arrayAppend(errors, "Username is required"); }

		return errors;
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
	* Retrieve full name
	*/
	string function getName(){
		return getFirstName() & " " & getLastName();
	}

	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getAuthorID() );
	}
}