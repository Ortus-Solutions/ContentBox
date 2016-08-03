/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Service to handle user operations.
*/
component extends="cborm.models.VirtualEntityService" accessors="true" singleton{
	
	// DI
	property name="populator" 			inject="wirebox:populator";
	property name="permissionService"	inject="permissionService@cb";
	property name="roleService"			inject="roleService@cb";
	property name="bCrypt"				inject="BCrypt@BCrypt";
	property name="dateUtil"			inject="DateUtil@cb";
	
	/**
	* Constructor
	*/
	AuthorService function init(){
		// init it
		super.init( entityName="cbAuthor" );
	    
		return this;
	}
	
	/**
	* Save an author with extra pizazz!
	* @author The author object
	* @passwordChange Are we changing the password
	* @transaactional Auto transactions
	*/
	function saveAuthor( required author, boolean passwordChange=false, boolean transactional=true ){
		// hash password if new author
		if( !arguments.author.isLoaded() OR arguments.passwordChange ){
			// bcrypt the incoming password
			arguments.author.setPassword( variables.bcrypt.hashPassword( arguments.author.getPassword() ) );
		}
		// save the author
		save( entity=author, transactional=arguments.transactional );
	}
	
	/**
	* Author search by name, email or username
	* @searchTerm.hint Search in firstname, lastname and email fields
	* @isActive.hint Search with active bit
	* @role.hint Apply a role filter
	* @max.hint The max returned objects
	* @offset.hint The offset for pagination
	* @asQuery.hint Query or objects
	* @sortOrder.hint The sort order to apply
	*/
	function search(
		string searchTerm="", 
		string isActive,
		string role,
		numeric max=0, 
		numeric offset=0, 
		boolean asQuery=false, 
		string sortOrder="lastName"
	){
		var results = {};
		var c = newCriteria();
		
		// Search
		if( len( arguments.searchTerm ) ){
			c.$or( c.restrictions.like( "firstName","%#arguments.searchTerm#%" ),
				   c.restrictions.like( "lastName", "%#arguments.searchTerm#%" ),
				   c.restrictions.like( "email", "%#arguments.searchTerm#%" ) );
		}

		// isActive filter
		if( structKeyExists( arguments, "isActive" ) AND arguments.isActive NEQ "any" ){
			c.eq( "isActive", javaCast( "boolean", arguments.isActive ) );
		}

		// role filter
		if( structKeyExists( arguments, "role" ) AND arguments.role NEQ "any" ){
			c.createAlias( "role", "role" )
				.isEq( "role.roleID", javaCast( "int", arguments.role ) );
		}

		// run criteria query and projections count
		results.count = c.count( "authorID" );
		results.authors = c.resultTransformer( c.DISTINCT_ROOT_ENTITY )
			.list( offset=arguments.offset, max=arguments.max, sortOrder=arguments.sortOrder, asQuery=arguments.asQuery );
	
		
		
		return results;
	}
	
	/**
	* Username checks for authors
	*/
	boolean function usernameFound(required username){
		var args = {"username" = arguments.username};
		return ( countWhere(argumentCollection=args) GT 0 );
	}
	
	/**
	* Get all data prepared for export
	*/
	array function getAllForExport(){
		var result = [];
		var data = getAll();
		
		for( var thisItem in data ){
			arrayAppend( result, thisItem.getMemento() );	
		}
		
		return result;
	}
	
	/**
	* Import data from a ContentBox JSON file. Returns the import log
	*/
	string function importFromFile(required importFile, boolean override=false){
		var data 		= fileRead( arguments.importFile );
		var importLog 	= createObject( "java", "java.lang.StringBuilder" ).init( "Starting import with override = #arguments.override#...<br>" );
		
		if( !isJSON( data ) ){
			throw(message="Cannot import file as the contents is not JSON", type="InvalidImportFormat" );
		}
		
		// deserialize packet: Should be array of { settingID, name, value }
		return	importFromData( deserializeJSON( data ), arguments.override, importLog );
	}
	
	/**
	* Import data from an array of structures of authors or just one structure of author 
	*/
	string function importFromData(required importData, boolean override=false, importLog){
		var allUsers 		= [];
		
		// if struct, inflate into an array
		if( isStruct( arguments.importData ) ){
			arguments.importData = [ arguments.importData ];
		}
		
		// iterate and import
		for( var thisUser in arguments.importData ){
			// Get new or persisted
			var oUser = this.findByUsername( thisUser.username );
			oUser = ( isNull( oUser ) ? new() : oUser );
			
			// date cleanups, just in case.
			var badDateRegex  	= " -\d{4}$";
			thisUser.createdDate 	= reReplace( thisUser.createdDate, badDateRegex, "" );
			thisUser.lastLogin 		= reReplace( thisUser.lastLogin, badDateRegex, "" );
			thisUser.modifiedDate 	= reReplace( thisUser.modifiedDate, badDateRegex, "" );
			// Epoch to Local
			thisUser.createdDate 	= dateUtil.epochToLocal( thisUser.createdDate );
			thisUser.lastLogin 		= dateUtil.epochToLocal( thisUser.lastLogin );
			thisUser.createdDate 	= dateUtil.epochToLocal( thisUser.modifiedDate );
			
			// populate content from data
			populator.populateFromStruct( target=oUser, memento=thisUser, exclude="role,authorID,permissions", composeRelationships=false );
			
			// A-LA-CARTE PERMISSIONS
			if( arrayLen( thisUser.permissions ) ){
				// Create permissions that don't exist first
				var allPermissions = [];
				for( var thisPermission in thisUser.permissions ){
					var oPerm = permissionService.findByPermission( thisPermission.permission );
					oPerm = ( isNull( oPerm ) ? populator.populateFromStruct( target=permissionService.new(), memento=thisPermission, exclude="permissionID" ) : oPerm );	
					// save oPerm if new only
					if( !oPerm.isLoaded() ){ permissionService.save( entity=oPerm ); }
					// append to add.
					arrayAppend( allPermissions, oPerm );
				}
				// detach permissions and re-attach
				oUser.setPermissions( allPermissions );
			}
			
			// ROLE
			var oRole = roleService.findByRole( thisUser.role.role );
			if( !isNull( oRole ) ){
				oUser.setRole( oRole );
				arguments.importLog.append( "User role found and linked: #thisUser.role.role#<br>" );
			}	
			else{
				arguments.importLog.append( "User role not found (#thisUser.role.role#) for #thisUser.username#, creating it...<br>" );
				roleService.importFromData( importData=thisUser.role, override=arguments.override, importLog=arguments.importLog );
				oUser.setRole( roleService.findByRole( thisUser.role.role ) );
			}
			
			// if new or persisted with override then save.
			if( !oUser.isLoaded() ){
				arguments.importLog.append( "New user imported: #thisUser.username#<br>" );
				arrayAppend( allUsers, oUser );
			}
			else if( oUser.isLoaded() and arguments.override ){
				arguments.importLog.append( "Persisted user overriden: #thisUser.username#<br>" );
				arrayAppend( allUsers, oUser );
			}
			else{
				arguments.importLog.append( "Skipping persisted user: #thisUser.username#<br>" );
			}
		} // end import loop

		// Save them?
		if( arrayLen( allUsers ) ){
			saveAll( allUsers );
			arguments.importLog.append( "Saved all imported and overriden users!" );
		}
		else{
			arguments.importLog.append( "No users imported as none where found or able to be overriden from the import file." );
		}
		
		return arguments.importLog.toString(); 
	}

}