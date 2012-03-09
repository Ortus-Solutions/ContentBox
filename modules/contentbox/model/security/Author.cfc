/**
* I am a author entity
*/
component persistent="true" entityname="cbAuthor" table="cb_author" batchsize="25" cachename="cbAuthor" cacheuse="read-write" {

	// Properties
	property name="authorID" 	fieldtype="id" generator="native" setter="false";
	property name="firstName"	length="100" notnull="true";
	property name="lastName"	length="100" notnull="true";
	property name="email"		length="255" notnull="true" index="idx_email";
	property name="username"	length="100" notnull="true" index="idx_login" unique="true";
	property name="password"	length="100" notnull="true" index="idx_login";
	property name="isActive" 	ormtype="boolean"   notnull="true" default="false" dbdefault="0" index="idx_login,idx_active";
	property name="lastLogin" 	ormtype="timestamp" notnull="false";
	property name="createdDate" ormtype="timestamp" notnull="true" update="false";

	// O2M -> Entries
	property name="entries" singularName="entry" type="array" fieldtype="one-to-many" cfc="contentbox.model.content.Entry"
			 fkcolumn="FK_authorID" inverse="true" lazy="extra" cascade="save-update" batchsize="10" orderby="publishedDate DESC";

	// O2M -> Pages
	property name="pages" singularName="page" type="array" fieldtype="one-to-many" cfc="contentbox.model.content.Page"
			 fkcolumn="FK_authorID" inverse="true" lazy="extra" cascade="save-update" batchsize="10" orderby="publishedDate DESC";

	// M20 -> Role
	property name="role" notnull="true" fieldtype="many-to-one" cfc="contentbox.model.security.Role" fkcolumn="FK_roleID" lazy="true";

	// M2M -> A-la-carte Author Permissions
	property name="permissions" singularName="permission" fieldtype="many-to-many" type="array" lazy="extra"
			 cfc="contentbox.model.security.Permission" cascade="all"
			 fkcolumn="FK_authorID" linktable="cb_authorPermissions" inversejoincolumn="FK_permissionID" orderby="permission";

	// Calculated properties
	property name="numberOfEntries" formula="select count(*) from cb_content as content where content.FK_authorID=authorID and content.contentType='entry'" ;
	property name="numberOfPages" 	formula="select count(*) from cb_content as content where content.FK_authorID=authorID and content.contentType='page'" ;

	// Non-persisted properties
	property name="loggedIn"		persistent="false" default="false" type="boolean";
	property name="permissionList" 	persistent="false";

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
		setPermissionList( '' );
		setLoggedIn( false );
		return this;
	}

	/**
	* Check for permission
	*/
	boolean function checkPermission(required slug){
		// cache list
		if( !len( permissionList ) AND hasPermission() ){
			var q = entityToQuery( getPermissions() );
			permissionList = valueList( q.permission );
		}
		// checks via role and local
		if( getRole().checkPermission( arguments.slug ) OR listFindNoCase(permissionList, arguments.slug) ){
			return true;
		}

		return false;
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
		if( !len(firstName) ){ arrayAppend(errors, "First Name is required"); }
		if( !len(lastName) ){ arrayAppend(errors, "Last Name is required"); }
		if( !len(email) ){ arrayAppend(errors, "Email is required"); }
		if( !len(username) ){ arrayAppend(errors, "Username is required"); }

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