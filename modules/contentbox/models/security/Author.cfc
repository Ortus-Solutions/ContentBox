/**
* I am a author entity
*/
component persistent="true" entityname="cbAuthor" table="cb_author" batchsize="25" cachename="cbAuthor" cacheuse="read-write" {

	// DI
	property name="authorService"		inject="authorService@cb" persistent="false";

	// Properties
	property name="authorID" 	fieldtype="id" generator="native" setter="false";
	property name="firstName"	length="100" notnull="true";
	property name="lastName"	length="100" notnull="true";
	property name="email"		length="255" notnull="true" index="idx_email";
	property name="username"	length="100" notnull="true" index="idx_login" unique="true";
	property name="password"	length="100" notnull="true" index="idx_login";
	property name="isActive" 	ormtype="boolean"   notnull="true" default="false" index="idx_login,idx_active";
	property name="lastLogin" 	ormtype="timestamp" notnull="false";
	property name="createdDate" ormtype="timestamp" notnull="true" update="false";
	property name="biography"   ormtype="text" 		notnull="false" length="8000" default="";
	// Preferences are stored as JSON
	property name="preferences" ormtype="text" 		notnull="false" length="8000" default="";
	
	// O2M -> Entries
	property name="entries" singularName="entry" type="array" fieldtype="one-to-many" cfc="contentbox.models.content.Entry"
			 fkcolumn="FK_authorID" inverse="true" lazy="extra" cascade="save-update" batchsize="10" orderby="publishedDate DESC";

	// O2M -> Pages
	property name="pages" singularName="page" type="array" fieldtype="one-to-many" cfc="contentbox.models.content.Page"
			 fkcolumn="FK_authorID" inverse="true" lazy="extra" cascade="save-update" batchsize="10" orderby="publishedDate DESC";

	// M20 -> Role
	property name="role" notnull="true" fieldtype="many-to-one" cfc="contentbox.models.security.Role" fkcolumn="FK_roleID" lazy="true";

	// M2M -> A-la-carte Author Permissions
	property name="permissions" singularName="permission" fieldtype="many-to-many" type="array" lazy="extra"
			 cfc="contentbox.models.security.Permission" cascade="all"
			 fkcolumn="FK_authorID" linktable="cb_authorPermissions" inversejoincolumn="FK_permissionID" orderby="permission";

	// Calculated properties
	property name="numberOfEntries" formula="select count(*) from cb_content as content where content.FK_authorID=authorID and content.contentType='entry'" ;
	property name="numberOfPages" 	formula="select count(*) from cb_content as content where content.FK_authorID=authorID and content.contentType='page'" ;

	// Non-persisted properties
	property name="loggedIn"		persistent="false" default="false" type="boolean";
	property name="permissionList" 	persistent="false";
	
	// Validation Constraints
	this.constraints ={
		"firstName" = {required=true, size="1..100"},
		"lastName" 	= {required=true, size="1..100"},
		"email" 	= {required=true, size="1..255", type="email"},
		"username" 	= {required=true, size="1..100", unique="true"},
		"password"	= {required=true, size="1..100"}
	};

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
		setPreferences( {} );
		variables.isActive = true;
		
		return this;
	}

	/**
	* Check for permission
	* @slug.hint The permission slug or list of slugs to validate the user has. If it's a list then they are ORed together
	*/
	boolean function checkPermission(required slug){
		// cache list
		if( !len( permissionList ) AND hasPermission() ){
			var q = entityToQuery( getPermissions() );
			permissionList = valueList( q.permission );
		}
		// checks via role and local
		if( getRole().checkPermission( arguments.slug ) OR inPermissionList( arguments.slug ) ){
			return true;
		}

		return false;
	}
	
	/**
	* Verify that a passed in list of perms the user can use 
	*/
	public function inPermissionList( required list ){
		var aList = listToArray( arguments.list );
		var isFound = false;
		
		for( var thisPerm in aList ){
			if( listFindNoCase( permissionList, trim( thisPerm ) ) ){
				isFound = true;
				break;
			}
		}
		
		return isFound;
	}
	
	/**
	* Clear all permissions
	*/
	Author function clearPermissions(){
		permissions = [];
		return this;
	}
	
	/**
	* Override the setPermissions
	*/
	Author function setPermissions(required array permissions){
		if( hasPermission() ){
			variables.permissions.clear();
			variables.permissions.addAll( arguments.permissions );
		}
		else{
			variables.permissions = arguments.permissions;
		}
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
			return dateFormat( lastLogin, "mm/dd/yyyy" ) & " " & timeFormat(lastLogin, "hh:mm:ss tt" );
		}

		return "Never";
	}

	/**
	* Get formatted createdDate
	*/
	string function getDisplayCreatedDate(){
		var createdDate = getCreatedDate();
		if( isNull( createdDate ) ){ return ""; }
		return dateFormat( createdDate, "mm/dd/yyyy" ) & " " & timeFormat(createdDate, "hh:mm:ss tt" );
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
		return ( len( getAuthorID() ) ? true : false );
	}
	
	/**
	* Get a flat representation of this entry
	*/
	function getMemento(){
		var pList = authorService.getPropertyNames();
		var result = {};
		
		// Do simple properties only
		for(var x=1; x lte arrayLen( pList ); x++ ){
			if( structKeyExists( variables, pList[ x ] ) ){
				if( isSimpleValue( variables[ pList[ x ] ] ) ){
					result[ pList[ x ] ] = variables[ pList[ x ] ];	
				}
			}
			else{
				result[ pList[ x ] ] = "";
			}
		}

		// Do Role Relationship
		if( hasRole() ){
			result[ "role" ] = getRole().getMemento();
		}
		
		// Permissions
		if( hasPermission() ){
			result[ "permissions" ] = [];
			for( var thisPerm in variables.permissions ){
				arrayAppend( result[ "permissions" ], thisPerm.getMemento() );
			}
		}
		else{
			result[ "permissions" ] = [];
		}
		
		return result;
	}
	
	/************************************** PREFERENCE FUNCTIONS *********************************************/
	
	/**
	* Store a preferences structure or JSON data in the user prefernces
	* @preferences.hint A struct of data or a JSON packet to store
	*/
	Author function setPreferences(required any preferences){
		lock name="user.#getAuthorID()#.preferences" type="exclusive" throwontimeout="true" timeout="5"{
			if( isStruct( arguments.preferences ) ){
				arguments.preferences = serializeJSON( arguments.preferences );
			}
			// store as JSON
			variables.preferences = arguments.preferences;
		}
		return this;
	}
	
	/**
	* Get all user preferences in inflated format
	*/
	struct function getAllPreferences(){
		lock name="user.#getAuthorID()#.preferences" type="readonly" throwontimeout="true" timeout="5"{
			return ( !isNull( preferences ) AND isJSON( preferences ) ? deserializeJSON( preferences ) : structnew() );
		}
	}
	
	/**
	* Get a preference, you can pass a default value if preference does not exist
	*/
	any function getPreference(required name, defaultValue){
		// get preference
		lock name="user.#getAuthorID()#.preferences" type="readonly" throwontimeout="true" timeout="5"{
			var allPreferences = getAllPreferences();
			if( structKeyExists( allPreferences, arguments.name ) ){
				return allPreferences[ arguments.name ];
			}
		}
		// default values
		if( structKeyExists( arguments, "defaultValue" ) ){
			return arguments.defaultValue;
		}
		// exception
		throw(message="The preference you requested (#arguments.name#) does not exist",
			  type="User.PreferenceNotFound",
			  detail="Valid preferences are #structKeyList( allPreferences )#" );
	}
	
	/**
	* Set a preference in the user preferences
	*/
	Author function setPreference(required name, required value){
		var allPreferences = getAllPreferences();
		allPreferences[ arguments.name ] = arguments.value;
		// store in lock mode
		return setPreferences( allPreferences );
	}
	
}