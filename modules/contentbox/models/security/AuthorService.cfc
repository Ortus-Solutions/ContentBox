/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Service to handle user operations.
 */
component
	extends  ="cborm.models.VirtualEntityService"
	accessors="true"
	singleton
{

	// DI
	property name="bCrypt" inject="BCrypt@BCrypt";
	property name="dateUtil" inject="DateUtil@cb";
	property name="CBHelper" inject="CBHelper@cb";
	property name="mailService" inject="mailService@cbmailservices";
	property name="permissionService" inject="permissionService@cb";
	property name="permissionGroupService" inject="permissionGroupService@cb";
	property name="renderer" inject="coldbox:renderer";
	property name="requestService" inject="coldbox:requestService";
	property name="roleService" inject="roleService@cb";
	property name="settingService" inject="provider:settingService@cb";
	property name="securityService" inject="provider:securityService@cb";
	property name="siteService" inject="provider:siteService@cb";

	/**
	 * Constructor
	 */
	AuthorService function init(){
		// init it
		super.init( entityName = "cbAuthor" );

		return this;
	}

	/**
	 * Get the total number of pages an author has created
	 *
	 * @authorId The author id to report on
	 */
	numeric function getTotalPages( required authorId ){
		return executeQuery(
			query: "
				SELECT count(*)
				FROM cbContent content join content.creator creator
				WHERE creator.authorID = :authorId AND
				content.contentType = 'Page'
			",
			params: { "authorId" : arguments.authorId },
			unique: true
		);
	}

	/**
	 * Get the total number of entries an author has created
	 *
	 * @authorId The author id to report on
	 */
	numeric function getTotalEntries( required authorId ){
		return executeQuery(
			query: "
				SELECT count(*)
				FROM cbContent content join content.creator creator
				WHERE creator.authorID = :authorId AND
				content.contentType = 'Entry'
			",
			params: { "authorId" : arguments.authorId },
			unique: true
		);
	}

	/**
	 * Get the total number of content store items an author has created
	 *
	 * @authorId The author id to report on
	 */
	numeric function getTotalContentStoreItems( required authorId ){
		return executeQuery(
			query: "
				SELECT count(*)
				FROM cbContent content join content.creator creator
				WHERE creator.authorID = :authorId AND
				content.contentType = 'ContentStore'
			",
			params: { "authorId" : arguments.authorId },
			unique: true
		);
	}

	/**
	 * Get the total number of content items an author has created
	 *
	 * @authorId The author id to report on
	 */
	numeric function getTotalContent( required authorId ){
		return executeQuery(
			query: "
				SELECT count(*)
				FROM cbContent content join content.creator creator
				WHERE creator.authorID = :authorId
			",
			params: { "authorId" : arguments.authorId },
			unique: true
		);
	}

	/**
	 * Get a status report of authors in the system.
	 */
	function getStatusReport(){
		var c       = newCriteria();
		var results = {
			"active"              : 0,
			"deactivated"         : 0,
			"2FactorAuthEnabled"  : 0,
			"2FactorAuthDisabled" : 0
		};

		var statusReport = c
			.withProjections( count: "isActive:authors", groupProperty: "isActive" )
			.asStruct()
			.list();

		for ( var row in statusReport ) {
			if ( row.get( "isActive" ) ) {
				results.active = row.get( "authors" );
			} else {
				results.deactivated = row.get( "authors" );
			}
		}

		var twoFactorAuthReport = c
			.withProjections( count: "is2FactorAuth:authors", groupProperty: "is2FactorAuth" )
			.asStruct()
			.list();

		for ( var row in twoFactorAuthReport ) {
			if ( row.get( "is2FactorAuth" ) ) {
				results[ "2FactorAuthEnabled" ] = row.get( "authors" );
			} else {
				results[ "2FactorAuthDisabled" ] = row.get( "authors" );
			}
		}

		return results;
	}

	/**
	 * Delete an author from the system
	 *
	 * @author The author to delete
	 */
	function deleteAuthor( required author ){
		transaction {
			// Clear out relationships
			arguments.author.clearPermissions();

			// send for deletion
			super.delete( arguments.author );
		}
		return this;
	}

	/**
	 * This function will encrypt an incoming target string using bcrypt and compare it with another bcrypt string
	 *
	 * @incoming Incoming string
	 * @target Target check
	 *
	 * @return true if they match
	 */
	boolean function isSameHash( required incoming, required target ){
		return variables.bcrypt.checkPassword( arguments.incoming, arguments.target );
	}

	/**
	 * Create a new author in ContentBox and sends them their email confirmations.
	 *
	 * @author The target author object to create
	 *
	 * @return The created author
	 */
	Author function createNewAuthor( required author ){
		transaction {
			// Save it
			this.save( arguments.author );

			// Send Account Creation
			var mailResults = sendNewUserEmail( arguments.author );
			if ( mailResults.error ) {
				variables.logger.error(
					"Error sending author created email for #arguments.author.getFullName()#",
					mailResults.errorArray
				);
			}
		}

		return arguments.author;
	}

	/**
	 * Save an author with extra pizazz!
	 * @author The author object
	 * @passwordChange Are we changing the password
	 *
	 * @return Author
	 */
	Author function save( required author, boolean passwordChange = false ){
		// bcrypt password if new author
		if ( !arguments.author.isLoaded() OR arguments.passwordChange ) {
			// bcrypt the incoming password
			arguments.author.setPassword(
				variables.bcrypt.hashPassword( arguments.author.getPassword() )
			);
		}

		// save the author
		return super.save( arguments.author );
	}

	/**
	 * Author search by many criteria.
	 *
	 * @searchTerm		 	Search in firstname, lastname and email fields
	 * @isActive  		 	Search with active bit
	 * @role      		 	Apply a role filter
	 * @max       		 	The max returned objects
	 * @offset    		 	The offset for pagination
	 * @asQuery   		 	Query or objects
	 * @sortOrder 		 	The sort order to apply
	 * @permissionGroups 	Single or list of permissiong groups to search on
	 * @twoFactorAuth 		Two factor auth or any
	 *
	 * @return {authors:array, count:numeric}
	 */
	function search(
		string searchTerm = "",
		string isActive,
		string role,
		numeric max      = 0,
		numeric offset   = 0,
		boolean asQuery  = false,
		string sortOrder = "lastName",
		string permissionGroups,
		string twoFactorAuth
	){
		var results = { "count" : 0, "authors" : [] };
		var c       = newCriteria();

		// Search
		if ( len( arguments.searchTerm ) ) {
			c.$or(
				c.restrictions.like( "firstName", "%#arguments.searchTerm#%" ),
				c.restrictions.like( "lastName", "%#arguments.searchTerm#%" ),
				c.restrictions.like( "email", "%#arguments.searchTerm#%" )
			);
		}

		// isActive filter
		if ( structKeyExists( arguments, "isActive" ) AND arguments.isActive NEQ "any" ) {
			c.isEq( "isActive", javacast( "boolean", arguments.isActive ) );
		}

		// twoFactorAuth filter
		if ( structKeyExists( arguments, "twoFactorAuth" ) AND arguments.twoFactorAuth NEQ "any" ) {
			c.isEq( "is2FactorAuth", javacast( "boolean", arguments.twoFactorAuth ) );
		}

		// role filter
		if ( structKeyExists( arguments, "role" ) AND arguments.role NEQ "any" ) {
			c.createAlias( "role", "role" ).isEq( "role.roleID", arguments.role );
		}

		// permission groups filter
		if ( structKeyExists( arguments, "permissionGroups" ) AND arguments.permissionGroups NEQ "any" ) {
			c.createAlias( "permissionGroups", "permissionGroups" )
				.isIn(
					"permissionGroups.permissionGroupID",
					listToArray( arguments.permissionGroups )
				);
		}

		// run criteria query and projections count
		results.count   = c.count( "authorID" );
		results.authors = c
			.resultTransformer( c.DISTINCT_ROOT_ENTITY )
			.list(
				offset    = arguments.offset,
				max       = arguments.max,
				sortOrder = arguments.sortOrder,
				asQuery   = arguments.asQuery
			);


		return results;
	}

	/**
	 * Get an author by username which is active and not deleted
	 *
	 * @username The username to verify the user with
	 *
	 * @throws EntityNotFound
	 */
	Author function retrieveUserByUsername( required username ){
		var oAuthor = newCriteria()
			.isEq( "username", arguments.username )
			.isTrue( "isActive" )
			.isFalse( "isDeleted" )
			.get();

		if ( isNull( oAuthor ) ) {
			throw(
				type    = "EntityNotFound",
				message = "Author not found with username (#encodeForHTML( arguments.username )#)"
			);
		}
		return oAuthor;
	}

	/**
	 * Get an author by id which is active and not deleted
	 *
	 * @id The unique Id
	 *
	 * @throws EntityNotFound
	 */
	Author function retrieveUserById( required id ){
		var oAuthor = newCriteria()
			.isEq( "authorID", arguments.id )
			.isTrue( "isActive" )
			.isFalse( "isDeleted" )
			.get();

		if ( isNull( oAuthor ) ) {
			throw(
				type    = "EntityNotFound",
				message = "Author not found with id (#encodeForHTML( arguments.id )#)"
			);
		}
		return oAuthor;
	}

	/**
	 * Username checks for authors
	 *
	 * @username The username to check if it exists already
	 */
	boolean function usernameFound( required username ){
		var args = { "username" : arguments.username };
		return ( countWhere( argumentCollection = args ) GT 0 );
	}

	/**
	 * Email checks for authors
	 *
	 * @email The email to check if it exists already
	 */
	boolean function emailFound( required email ){
		var args = { "email" : arguments.email };
		return ( countWhere( argumentCollection = args ) GT 0 );
	}

	/**
	 * Get all data prepared for export
	 */
	array function getAllForExport(){
		return getAll().map( function( thisItem ){
			return arguments.thisItem.getMemento(
				includes: "permissions,permissionGroups,isPasswordReset,is2FactorAuth"
			);
		} );
	}

	/**
	 * Import data from a ContentBox JSON file. Returns the import log
	 */
	string function importFromFile( required importFile, boolean override = false ){
		var data      = fileRead( arguments.importFile );
		var importLog = createObject( "java", "java.lang.StringBuilder" ).init(
			"Starting import with override = #arguments.override#...<br>"
		);

		if ( !isJSON( data ) ) {
			throw(
				message = "Cannot import file as the contents is not JSON",
				type    = "InvalidImportFormat"
			);
		}

		// deserialize packet: Should be array of { settingID, name, value }
		return importFromData(
			deserializeJSON( data ),
			arguments.override,
			importLog
		);
	}

	/**
	 * Import data from an array of structures of authors or just one structure of author
	 */
	string function importFromData(
		required importData,
		boolean override = false,
		importLog
	){
		var allUsers = [];

		// if struct, inflate into an array
		if ( isStruct( arguments.importData ) ) {
			arguments.importData = [ arguments.importData ];
		}

		// iterate and import
		for ( var thisUser in arguments.importData ) {
			// Get new or persisted
			var oUser = this.findByUsername( thisUser.username );
			oUser     = ( isNull( oUser ) ? new () : oUser );

			// date cleanups, just in case.
			var badDateRegex      = " -\d{4}$";
			thisUser.createdDate  = reReplace( thisUser.createdDate, badDateRegex, "" );
			thisUser.lastLogin    = reReplace( thisUser.lastLogin, badDateRegex, "" );
			thisUser.modifiedDate = reReplace( thisUser.modifiedDate, badDateRegex, "" );
			// Epoch to Local
			thisUser.createdDate  = dateUtil.epochToLocal( thisUser.createdDate );
			thisUser.lastLogin    = dateUtil.epochToLocal( thisUser.lastLogin );
			thisUser.createdDate  = dateUtil.epochToLocal( thisUser.modifiedDate );

			// populate content from data
			getBeanPopulator().populateFromStruct(
				target               = oUser,
				memento              = thisUser,
				exclude              = "role,authorID,permissions",
				composeRelationships = false
			);

			// A-LA-CARTE PERMISSIONS
			if ( arrayLen( thisUser.permissions ) ) {
				// Create permissions that don't exist first
				var allPermissions = [];
				for ( var thisPermission in thisUser.permissions ) {
					var oPerm = permissionService.findByPermission( thisPermission.permission );
					oPerm     = (
						isNull( oPerm ) ? getBeanPopulator().populateFromStruct(
							target  = permissionService.new(),
							memento = thisPermission,
							exclude = "permissionID"
						) : oPerm
					);
					// save oPerm if new only
					if ( !oPerm.isLoaded() ) {
						permissionService.save( entity = oPerm );
					}
					// append to add.
					arrayAppend( allPermissions, oPerm );
				}
				// detach permissions and re-attach
				oUser.setPermissions( allPermissions );
			}

			// Group Permissions
			if ( arrayLen( thisUser.permissiongroups ) ) {
				// Create group permissions that don't exist first
				var allGroups = [];
				for ( var thisGroup in thisUser.permissiongroups ) {
					var oGroup = permissionGroupService.findByName( thisGroup.name );
					oGroup     = (
						isNull( oGroup ) ? getBeanPopulator().populateFromStruct(
							target  = permissionGroupService.new(),
							memento = thisGroup,
							exclude = "permissionGroupID,permissions"
						) : oGroup
					);
					// save oGroup if new only
					if ( !oGroup.isLoaded() ) {
						permissionGroupService.save( entity = oGroup );
					}
					// append to add.
					arrayAppend( allGroups, oPerm );
				}
				// attach the new permissions
				oUser.setPermissionGroups( allGroups );
			}

			// ROLE
			var oRole = roleService.findByRole( thisUser.role.role );
			if ( !isNull( oRole ) ) {
				oUser.setRole( oRole );
				arguments.importLog.append( "User role found and linked: #thisUser.role.role#<br>" );
			} else {
				arguments.importLog.append(
					"User role not found (#thisUser.role.role#) for #thisUser.username#, creating it...<br>"
				);
				roleService.importFromData(
					importData = thisUser.role,
					override   = arguments.override,
					importLog  = arguments.importLog
				);
				oUser.setRole( roleService.findByRole( thisUser.role.role ) );
			}

			// if new or persisted with override then save.
			if ( !oUser.isLoaded() ) {
				arguments.importLog.append( "New user imported: #thisUser.username#<br>" );
				arrayAppend( allUsers, oUser );
			} else if ( oUser.isLoaded() and arguments.override ) {
				arguments.importLog.append( "Persisted user overriden: #thisUser.username#<br>" );
				arrayAppend( allUsers, oUser );
			} else {
				arguments.importLog.append( "Skipping persisted user: #thisUser.username#<br>" );
			}
		}
		// end import loop

		// Save them?
		if ( arrayLen( allUsers ) ) {
			saveAll( allUsers );
			arguments.importLog.append( "Saved all imported and overriden users!" );
		} else {
			arguments.importLog.append(
				"No users imported as none where found or able to be overriden from the import file."
			);
		}

		return arguments.importLog.toString();
	}

	/**
	 * Sends a new author their reminder to reset their password and log in to their account
	 *
	 * @author The author to send the reminder to
	 *
	 * @return struct of { error:boolean, errorArray:array }
	 */
	struct function sendNewUserEmail( required Author author ){
		var token       = variables.securityService.generateResetToken( arguments.author );
		var settings    = variables.settingService.getAllSettings();
		var defaultSite = variables.siteService.getDefaultSite();
		var adminUrl    = variables.requestService
			.getContext()
			.buildLink( to: "/cbadmin", ssl: settings.cb_admin_ssl );

		// get mail payload
		var bodyTokens = {
			name        : arguments.author.getFullName(),
			email       : arguments.author.getEmail(),
			username    : arguments.author.getUsername(),
			linkTimeout : settings.cb_security_password_reset_expiration,
			linkToken   : adminUrl & "/security/verifyReset?token=#token#",
			resetLink   : adminUrl & "/security/lostPassword",
			siteName    : defaultSite.getName(),
			issuedBy    : "",
			issuedEmail : ""
		};

		// Build email out
		var mail = variables.mailservice.newMail(
			to         = arguments.author.getEmail(),
			from       = settings.cb_site_outgoingEmail,
			subject    = "#defaultSite.getName()# Account was created for you",
			bodyTokens = bodyTokens,
			type       = "html",
			server     = settings.cb_site_mail_server,
			username   = settings.cb_site_mail_username,
			password   = settings.cb_site_mail_password,
			port       = settings.cb_site_mail_smtp,
			useTLS     = settings.cb_site_mail_tls,
			useSSL     = settings.cb_site_mail_ssl
		);

		mail.setBody(
			variables.renderer.renderLayout(
				layout = "/contentbox/email_templates/layouts/email",
				view   = "/contentbox/email_templates/author_welcome"
			)
		);

		// send it out
		return variables.mailService.send( mail );
	}

}
