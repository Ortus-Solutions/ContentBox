/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * I am a ContentBox User/Author entity
 */
component
	persistent="true"
	entityname="cbAuthor"
	table     ="cb_author"
	batchsize ="25"
	extends   ="contentbox.models.BaseEntity"
	cachename ="cbAuthor"
	cacheuse  ="read-write"
{

	/* *********************************************************************
	 **							DI
	 ********************************************************************* */

	property
		name      ="authorService"
		inject    ="authorService@cb"
		persistent="false";

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	property
		name     ="authorID"
		fieldtype="id"
		generator="assigned"
		setter   ="false";

	property
		name   ="firstName"
		length ="100"
		notnull="true"
		default="";

	property
		name   ="lastName"
		length ="100"
		notnull="true"
		default="";

	property
		name   ="email"
		length ="255"
		notnull="true"
		index  ="idx_email"
		default="";

	property
		name   ="username"
		length ="100"
		notnull="true"
		index  ="idx_login"
		unique ="true"
		default="";

	property
		name   ="password"
		length ="100"
		notnull="true"
		index  ="idx_login"
		default="";

	property
		name   ="isActive"
		ormtype="boolean"
		// sqltype  = "smallInt"
		notnull="true"
		default="false"
		index  ="idx_login,idx_activeAuthor";

	property
		name   ="lastLogin"
		ormtype="timestamp"
		notnull="false";

	property
		name   ="biography"
		ormtype="text"
		notnull="false"
		length ="8000"
		default="";

	property
		name   ="preferences"
		ormtype="text"
		notnull="false"
		length ="8000"
		default="";

	property
		name     ="isPasswordReset"
		ormtype  ="boolean"
		// sqltype  = "smallInt"
		notnull  ="true"
		default  ="false"
		dbdefault="false"
		index    ="idx_passwordReset";

	property
		name     ="is2FactorAuth"
		ormtype  ="boolean"
		// sqltype  = "smallInt"
		notnull  ="true"
		default  ="false"
		dbdefault="false"
		index    ="idx_2factorauth";

	/* *********************************************************************
	 **							RELATIONSHIPS
	 ********************************************************************* */

	// O2M -> Entries
	property
		name        ="entries"
		singularName="entry"
		type        ="array"
		fieldtype   ="one-to-many"
		cfc         ="contentbox.models.content.Entry"
		fkcolumn    ="FK_authorID"
		inverse     ="true"
		lazy        ="extra"
		cascade     ="save-update"
		batchsize   ="10"
		orderby     ="publishedDate DESC";

	// O2M -> Pages
	property
		name        ="pages"
		singularName="page"
		type        ="array"
		fieldtype   ="one-to-many"
		cfc         ="contentbox.models.content.Page"
		fkcolumn    ="FK_authorID"
		inverse     ="true"
		lazy        ="extra"
		cascade     ="save-update"
		batchsize   ="10"
		orderby     ="publishedDate DESC";

	// M20 -> Role
	property
		name     ="role"
		notnull  ="true"
		fieldtype="many-to-one"
		cfc      ="contentbox.models.security.Role"
		fkcolumn ="FK_roleID"
		lazy     ="true";

	// M2M -> A-la-carte Author Permissions
	property
		name             ="permissions"
		singularName     ="permission"
		fieldtype        ="many-to-many"
		cascade          ="save-update"
		type             ="array"
		lazy             ="extra"
		cfc              ="contentbox.models.security.Permission"
		fkcolumn         ="FK_authorID"
		linktable        ="cb_authorPermissions"
		inversejoincolumn="FK_permissionID"
		orderby          ="permission";

	// M2M -> A-la-carte Author Permission Groups
	property
		name             ="permissionGroups"
		singularName     ="permissionGroup"
		fieldtype        ="many-to-many"
		type             ="array"
		lazy             ="extra"
		inverse          ="true"
		cfc              ="contentbox.models.security.PermissionGroup"
		cascade          ="save-update"
		fkcolumn         ="FK_authorID"
		linktable        ="cb_authorPermissionGroups"
		inversejoincolumn="FK_permissionGroupID"
		orderby          ="name";

	/* *********************************************************************
	 **							CALCULATED FIELDS
	 ********************************************************************* */

	/* *********************************************************************
	 **							NON PERSISTED PROPERTIES
	 ********************************************************************* */

	// Non-persisted properties
	property
		name      ="loggedIn"
		persistent="false"
		default   ="false"
		type      ="boolean";

	property name="permissionList" persistent="false";

	/* *********************************************************************
	 **							PK + CONSTRAINTS
	 ********************************************************************* */

	this.pk = "authorID";

	this.constraints = {
		"firstName" : { required : true, size : "1..100" },
		"lastName"  : { required : true, size : "1..100" },
		"email"     : { required : true, size : "1..255", type : "email" },
		"username"  : {
			required  : true,
			size      : "1..100",
			validator : "UniqueValidator@cborm"
		},
		"password" : { required : true, size : "1..100" }
	};

	/* *********************************************************************
	 **							PUBLIC FUNCTIONS
	 ********************************************************************* */

	/**
	 * Constructor
	 */
	function init(){
		variables.permissionList   = "";
		variables.loggedIn         = false;
		variables.isActive         = true;
		variables.permissionGroups = [];
		variables.isPasswordReset  = false;
		variables.is2FactorAuth    = false;

		// Setup empty preferences
		setPreferences( {} );

		super.init();

		return this;
	}

	/**
	 * Listen to postLoad's from the ORM
	 */
	function postLoad(){
	}

	/**
	 * Get the total number of content items this author has created
	 */
	numeric function getNumberOfContent(){
		return ( isLoaded() ? variables.authorService.getTotalContent( getAuthorId() ) : 0 );
	}

	/**
	 * Get the total number of entries this author has created
	 */
	numeric function getNumberOfEntries(){
		return ( isLoaded() ? variables.authorService.getTotalEntries( getAuthorId() ) : 0 );
	}

	/**
	 * Get the total number of pages this author has created
	 */
	numeric function getNumberOfPages(){
		return ( isLoaded() ? variables.authorService.getTotalPages( getAuthorId() ) : 0 );
	}

	/**
	 * Get the total number of content store items this author has created
	 */
	numeric function getNumberOfContentStore(){
		return ( isLoaded() ? variables.authorService.getTotalContentStoreItems( getAuthorId() ) : 0 );
	}

	/**
	 * Check for permission
	 * @slug The permission slug or list of slugs to validate the user has. If it's a list then they are ORed together
	 */
	boolean function checkPermission( required slug ){
		// cache permission list
		if ( !len( permissionList ) AND hasPermission() ) {
			var q          = entityToQuery( getPermissions() );
			permissionList = valueList( q.permission );
		}

		// checks via role, then group permissions and then local permissions
		if (
			( hasRole() && getRole().checkPermission( arguments.slug ) )
			OR
			checkGroupPermissions( arguments.slug )
			OR
			inPermissionList( arguments.slug )
		) {
			return true;
		}

		return false;
	}

	/**
	 * This utility function checks if a slug is in any permission group this user belongs to.
	 * @slug The slug to check
	 */
	boolean function checkGroupPermissions( required slug ){
		// If no groups, just return false
		if ( !hasPermissionGroup() ) {
			return false;
		}

		// iterate and check, break if found, short-circuit approach.
		for ( var thisGroup in variables.permissionGroups ) {
			if ( thisGroup.checkPermission( arguments.slug ) ) {
				return true;
			}
		}
		// nada found
		return false;
	}

	/**
	 * Verify that a passed in list of perms the user can use
	 */
	public function inPermissionList( required list ){
		var aList   = listToArray( arguments.list );
		var isFound = false;

		for ( var thisPerm in aList ) {
			if ( listFindNoCase( permissionList, trim( thisPerm ) ) ) {
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
	 * @permissions The permissions array to override
	 */
	Author function setPermissions( required array permissions ){
		if ( hasPermission() ) {
			variables.permissions.clear();
			variables.permissions.addAll( arguments.permissions );
		} else {
			variables.permissions = arguments.permissions;
		}
		return this;
	}

	/**
	 * Shortcut Utlity function to get a list of all the permission groups this user belongs to.
	 */
	string function getPermissionGroupsList( delimiter = "," ){
		if ( hasPermissionGroup() ) {
			var aGroups = [];
			for ( var thisGroup in variables.permissionGroups ) {
				arrayAppend( aGroups, thisGroup.getName() );
			}
			return arrayToList( aGroups, arguments.delimiter );
		}
		return "";
	}

	/**
	 * Add both sides of this relationship: PermissionGroup <-> Author
	 *
	 * @group The permission group to add
	 */
	Author function addPermissionGroup( required group ){
		// Only add if not already there.
		if ( !hasPermissionGroup( arguments.group ) ) {
			arrayAppend( variables.permissionGroups, arguments.group );
			arguments.group.addAuthor( this );
		}
		return this;
	}

	/**
	 * Remove both sides of this relationship: PermissionGroup <-> Author
	 *
	 * @group The permission group to add
	 */
	Author function removePermissionGroup( required group ){
		// Only add if not already there.
		if ( hasPermissionGroup( arguments.group ) ) {
			arrayDelete( variables.permissionGroups, arguments.group );
			arguments.group.removeAuthor( this );
		}
		return this;
	}

	/**
	 * Utility method to verify if an author has been logged in to the system or not.
	 * This method does not account for permissions.  Only for logged in status.
	 */
	function isLoggedIn(){
		return getLoggedIn();
	}

	/**
	 * Get formatted lastLogin
	 */
	string function getDisplayLastLogin(){
		var lastLogin = getLastLogin();

		if ( NOT isNull( lastLogin ) ) {
			return dateFormat( lastLogin, "dd mmm yyyy" ) & " " & timeFormat(
				lastLogin,
				"hh:mm tt"
			);
		}

		return "Never Logged In";
	}

	/**
	 * Retrieve full name
	 */
	string function getName(){
		return getFirstName() & " " & getLastName();
	}

	/**
	 * Get a flat representation of this entry
	 * @excludes 			Exclude properties, by default it does pages and entries
	 * @showRole 			Show Roles
	 * @showPermissions 		Show permissions
	 * @showPermissionGroups Show permission groups
	 */
	function getMemento(
		excludes                     = "pages,entries",
		boolean showRole             = true,
		boolean showPermissions      = true,
		boolean showPermissionGroups = true
	){
		// Do this to convert native Array to CF Array for content properties
		var pList  = listToArray( arrayToList( authorService.getPropertyNames() ) );
		var result = getBaseMemento( properties = pList, excludes = arguments.excludes );

		// Do Role Relationship
		if ( arguments.showRole && hasRole() ) {
			result[ "role" ] = getRole().getMemento();
		}

		// Permissions
		if ( arguments.showPermissions && hasPermission() ) {
			result[ "permissions" ] = [];
			for ( var thisPerm in variables.permissions ) {
				arrayAppend( result[ "permissions" ], thisPerm.getMemento() );
			}
		} else if ( arguments.showPermissions ) {
			result[ "permissions" ] = [];
		}

		// Permission Groups
		if ( arguments.showPermissionGroups && hasPermissionGroup() ) {
			result[ "permissiongroups" ] = [];
			for ( var thisGroup in variables.permissiongroups ) {
				arrayAppend( result[ "permissiongroups" ], thisGroup.getMemento() );
			}
		} else if ( arguments.showPermissionGroups ) {
			result[ "permissiongroups" ] = [];
		}

		return result;
	}

	/************************************** PREFERENCE FUNCTIONS *********************************************/

	/**
	 * Store a preferences structure or JSON data in the user prefernces
	 * @preferences.hint A struct of data or a JSON packet to store
	 */
	Author function setPreferences( required any preferences ){
		lock
			name          ="user.#getAuthorID()#.preferences"
			type          ="exclusive"
			throwontimeout="true"
			timeout       ="5" {
			if ( isStruct( arguments.preferences ) ) {
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
		lock
			name          ="user.#getAuthorID()#.preferences"
			type          ="readonly"
			throwontimeout="true"
			timeout       ="5" {
			return (
				!isNull( preferences ) AND isJSON( preferences ) ? deserializeJSON( preferences ) : structNew()
			);
		}
	}

	/**
	 * Get a preference, you can pass a default value if preference does not exist
	 */
	any function getPreference( required name, defaultValue ){
		// get preference
		lock
			name              ="user.#getAuthorID()#.preferences"
			type              ="readonly"
			throwontimeout    ="true"
			timeout           ="5" {
			var allPreferences= getAllPreferences();
			if ( structKeyExists( allPreferences, arguments.name ) ) {
				return allPreferences[ arguments.name ];
			}
		}
		// default values
		if ( structKeyExists( arguments, "defaultValue" ) ) {
			return arguments.defaultValue;
		}
		// exception
		throw(
			message = "The preference you requested (#arguments.name#) does not exist",
			type    = "User.PreferenceNotFound",
			detail  = "Valid preferences are #structKeyList( allPreferences )#"
		);
	}

	/**
	 * Set a preference in the user preferences
	 */
	Author function setPreference( required name, required value ){
		var allPreferences               = getAllPreferences();
		allPreferences[ arguments.name ] = arguments.value;
		// store in lock mode
		return setPreferences( allPreferences );
	}

}
