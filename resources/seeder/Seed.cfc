/**
 * Task that seeds my database with test data
 */
component {

	property name="packageService" inject="PackageService";
	property name="JSONService"    inject="JSONService";
	property name="qb"             inject="provider:QueryBuilder@qb";

	function init(){
		// Create mockDataCFC mapping: Must be in `modules` folder.
		fileSystemUtil.createMapping(
			"mockdatacfc",
			"#getCWD()#testbox/system/modules/mockdatacfc"
		);
		// create mock data
		variables.mockData   = new mockdatacfc.models.MockData();
		// Bcrypt hash of the word "test"
		variables.bcryptTest = "$2a$12$FE2J7ZLWaI2rSqejAu/84uLy7qlSufQsDsSE1lNNKyA05GG30gr8C";
		return this;
	}

	function onDIComplete(){
		variables.cfmigrationsInfo = getCFMigrationsInfo();
		print.cyanLine(
			"Please wait, connecting to your database: #variables.cfmigrationsInfo.schema#"
		);
		var appSettings         = getApplicationSettings();
		var dataSources         = appSettings.datasources ?: {};
		dataSources[ "seeder" ] = variables.cfmigrationsInfo.connectionInfo

		// Update APP so we can use the datasource in our task
		application action="update" datasources=dataSources;
		application action="update" datasource="seeder";

		print.greenLine( "Connection success!" );
	}

	function run(){
		if (
			!confirm(
				"This seeder will wipe out your entire data and replace it with mock data, are you sure?"
			)
		) {
			print.line().redLine( "Bye Bye!" );
			return;
		}

		try {
			transaction {
				queryExecute( "SET FOREIGN_KEY_CHECKS=0;" );

				/******************** PERMISSIONS ********************/
				print.line().greenLine( "Generating user permissions..." );
				truncate( "cb_permission" );
				var aPerms = deserializeJSON( fileRead( "mockdata/permissions.json" ) );
				qb.from( "cb_permission" ).insert( aPerms );
				print.cyanLine( "   ==> (#aPerms.len()#) User Permissions inserted" );
				return;

				/******************** PROJECT PERMISSIONS ********************/
				print.line().greenLine( "Generating project permissions..." );
				var aProjectPerms = mockData.mock(
					$num           = "10",
					"permissionId" = "uuid",
					"permission"   = "words:1:5",
					"description"  = "sentence",
					"isActive"     = "oneof:1",
					"isProject"    = "oneof:1",
					"createdDate"  = "datetime",
					"updatedDate"  = "datetime"
				);
				qb.from( "permission" ).insert( aProjectPerms );
				print.cyanLine( "   ==> (#aProjectPerms.len()#) Project Permissions inserted" );

				/******************** PERMISSION GROUPS ********************/

				print.line().greenLine( "Generating permission groups..." );
				truncate( "permissionGroup" );
				var aPermGroups = mockData.mock(
					$num                = "5",
					"permissionGroupId" = "uuid",
					"name"              = "words:1:5",
					"description"       = "sentence",
					"isActive"          = "oneof:1",
					"createdDate"       = "datetime",
					"updatedDate"       = "datetime"
				);
				qb.from( "permissionGroup" ).insert( aPermGroups );
				print.cyanLine( "   ==> (#aPermGroups.len()#) Mock Permission Groups inserted" );

				/******************** PERMISSION GROUP PERMISSIONS ********************/

				print.line().greenLine( "Generating permission group permissions..." );
				aPermGroups.each( ( thisGroup ) => {
					print.cyanLine(
						"  ==> Inserting group permissions for group: #thisGroup.name#"
					);
					// Create random permissions on a group
					for ( var x = 1; x lte randRange( 1, aPerms.len() ); x++ ) {
						print.cyanLine( "    ==> Added permission: #aPerms[ x ].permission#" );
						qb.from( "groupPermissions" )
							.insert( {
								"FK_permissionGroupId" : thisGroup[ "permissionGroupId" ],
								"FK_permissionId"      : aPerms[ x ].permissionId
							} );
					}
				} );
				/*****************************************************/

				/******************** ROLES ********************/
				print.line().greenLine( "Generating roles..." );
				truncate( "role" );
				var aRoles = mockData.mock(
					$num          = "5",
					"roleId"      = "uuid",
					"role"        = "words:1:5",
					"description" = "sentence",
					"isActive"    = "oneof:1",
					"isProject"   = "oneof:0",
					"createdDate" = "datetime",
					"updatedDate" = "datetime"
				);
				qb.from( "role" ).insert( aRoles );
				print.cyanLine( "   ==> (#aRoles.len()#) Mock Roles inserted" );

				/******************** PROJECT ROLES ********************/
				print.line().greenLine( "Generating roles..." );
				var aProjectRoles = mockData.mock(
					$num          = "5",
					"roleId"      = "uuid",
					"role"        = "words:1:5",
					"description" = "sentence",
					"isActive"    = "oneof:1",
					"isProject"   = "oneof:1",
					"createdDate" = "datetime",
					"updatedDate" = "datetime"
				);
				qb.from( "role" ).insert( aProjectRoles );
				print.cyanLine( "   ==> (#aProjectRoles.len()#) Project Roles inserted" );

				/******************** ROLE PERMISSIONS ********************/

				print.line().greenLine( "Generating role permissions..." );
				truncate( "rolePermissions" );
				aRoles.each( ( thisRole ) => {
					print.cyanLine( "  ==> Inserting role permissions for role: #thisRole.role#" );
					// Create random permissions on a role
					for ( var x = 1; x lte randRange( 1, aPerms.len() ); x++ ) {
						print.cyanLine( "    ==> Added permission: #aPerms[ x ].permission#" );
						qb.from( "rolePermissions" )
							.insert( {
								"FK_roleId"       : thisRole[ "roleId" ],
								"FK_permissionId" : aPerms[ x ].permissionId
							} );
					}
				} );

				print.line().greenLine( "Generating project role permissions..." );
				aProjectRoles.each( ( thisRole ) => {
					print.cyanLine(
						"  ==> Inserting project role permissions for role: #thisRole.role#"
					);
					// Create random permissions on a role
					for ( var x = 1; x lte randRange( 1, aProjectPerms.len() ); x++ ) {
						print.cyanLine(
							"    ==> Added permission: #aProjectPerms[ x ].permission#"
						);
						qb.from( "rolePermissions" )
							.insert( {
								"FK_roleId"       : thisRole[ "roleId" ],
								"FK_permissionId" : aProjectPerms[ x ].permissionId
							} );
					}
				} );

				/******************** SETTINGS ********************/
				print.line().greenLine( "Generating settings..." );
				truncate( "setting" );
				var aSettings = mockData.mock(
					$num        = "5",
					"settingId" = "uuid",
					"name"      = ( index ) => {
						switch ( arguments.index ) {
							case 1:
								return "timebox_seed_mail";
							case 2:
								return "timebox_seed_notify";
							case 3:
								return "timebox_seed_message";
							case 4:
								return "timebox_seed_on";
							case 5:
								return "timebox_seed_test";
						}
					},
					"value"       = "sentence",
					"isActive"    = "oneof:1",
					"createdDate" = "datetime",
					"updatedDate" = "datetime"
				);
				qb.from( "setting" ).insert( aSettings );
				print.cyanLine( "   ==> (#aSettings.len()#) Mock Settings inserted" );
				/*****************************************************/

				/******************** USERS ********************/
				print.line().greenLine( "Generating users..." );
				truncate( "user" );
				var aUsers = mockData.mock(
					$num       = "50",
					"userId"   = "uuid",
					"userType" = () => {
						var types = [
							"employee",
							"contractor",
							"clientContact"
						];
						return types[ randRange( 1, types.len() ) ];
					},
					"createdDate" = "datetime",
					"updatedDate" = "datetime",
					"isActive"    = "oneof:1",
					"fname"       = "fname",
					"lname"       = "lname",
					"title"       = "words:1:3",
					"email"       = ( index ) => "USER_SEED_#index#@testing.com",
					"password"    = () => "#bcryptTest#",
					"mobilePhone" = "tel",
					"preferences" = () => "{}",
					"FK_roleId"   = "oneof:#aRoles[ randRange( 1, aRoles.len() ) ].roleId#",
					"dob"         = "date",
					"tshirtSize"  = () => {
						var sizes = "XS,S,M,L,XL,XXL,XXXL".listToArray();
						return sizes[ randRange( 1, sizes.len() ) ];
					}
				);
				qb.from( "user" ).insert( aUsers );
				// print.redLine( aUsers );
				print.cyanLine( "   ==> (#aUsers.len()#) Users inserted" );

				// Choose only one manager for now
				var manager  = aUsers.filter( ( item ) => item.userType == "employee" )[ 1 ];
				var aWorkers = aUsers.filter( ( item ) => item.userType == "employee" || item.userType == "contractor" );

				// Create Employees
				truncate( "employee" );
				var aEmployees = aUsers.filter( ( item ) => item.userType == "employee" );
				aEmployees.each( ( thisEmployee ) => {
					var mockData = mockData.mock(
						"$returnType"     = "struct",
						"userId"          = () => thisEmployee.userId,
						"startDate"       = "date",
						"endDate"         = "date",
						"costRate"        = "num:15:75",
						"salary"          = "num:50000:100000",
						"sickTimePerYear" = "num:0:30",
						"ptoPeryear"      = "num:30:80",
						"hasPayroll"      = "oneof:1:0"
					);

					qb.from( "employee" ).insert( mockData );
				} );
				print.cyanLine( "   ==> (#aEmployees.len()#) Employees inserted" );

				// Create Employee Emergency Contacts
				print.line().greenLine( "Generating employee emergency contacts..." );
				truncate( "emergencyContact" );
				aEmployees.each( ( thisEmployee ) => {
					qb.from( "emergencyContact" )
						.insert(
							mockData.mock(
								"$returnType"        : "struct",
								"emergencyContactId" = "uuid",
								"createdDate"        = "datetime",
								"updatedDate"        = "datetime",
								"isActive"           = "oneof:1",
								"fullName"           = "name",
								"relationship"       = "oneof:spouse:brother:sister",
								"email"              = "email",
								"mobilePhone"        = "tel",
								"FK_userId"          = () => thisEmployee.userId
							)
						);
					print.cyanLine( "   ==> Emergency contact for #thisEmployee.email# created" );
				} );

				// Create Contractors
				print.line().greenLine( "Generating Contractors..." );
				truncate( "contractor" );
				var aContractors = aUsers.filter( ( item ) => item.userType == "contractor" );
				aContractors.each( ( thisEmployee ) => {
					qb.from( "contractor" )
						.insert(
							mockData.mock(
								"$returnType"    = "struct",
								"userId"         = () => thisEmployee.userId,
								"startDate"      = "date",
								"endDate"        = "date",
								"costRate"       = "num:15:75",
								"fixedFee"       = "num:0:2500",
								"businessName"   = "words:1:3",
								"contractorType" = "oneof:individual:business"
							)
						);
				} );
				print.cyanLine( "   ==> (#aContractors.len()#) Contractors inserted" );

				/******************** USER NOTES ********************/
				print.line().greenLine( "Generating user notes..." );
				truncate( "userNote" );
				var aUserNotes = mockData.mock(
					$num           = "100",
					"noteId"       = "uuid",
					"createdDate"  = "datetime",
					"updatedDate"  = "datetime",
					"isActive"     = "oneof:1:0",
					"notes"        = "baconlorem",
					"FK_creatorId" = () => aEmployees[ randRange( 1, aEmployees.len() ) ].userId,
					"FK_userId"    = () => aUsers[ randRange( 1, aUsers.len() ) ].userId
				);
				qb.from( "userNote" ).insert( aUserNotes );
				// print.redLine( aUsers );
				print.cyanLine( "   ==> (#aUserNotes.len()#) User Notes inserted" );

				/******************** USER PERMISSIONS ********************/

				// User Permissions
				truncate( "userPermissions" );
				for ( var i = 1; i lte randRange( 1, aWorkers.len() ); i++ ) {
					var aCustomPerms = [];
					for ( var x = 1; x lte randRange( 1, aPerms.len() ); x++ ) {
						aCustomPerms.append( {
							"FK_userId"       : aWorkers[ i ].userId,
							"FK_permissionId" : aPerms[ x ].permissionId
						} );
					}
					qb.from( "userPermissions" ).insert( aCustomPerms );
					print.cyanLine(
						"   ==> (#aCustomPerms.len()#) Mock User A-la-carte permissions inserted for user: #aWorkers[ i ].userId#"
					);
				}

				/******************** USER PERMISSION GROUPS ********************/

				// User Permission Groups
				print.line().greenLine( "Generating user permission groups..." );
				truncate( "userPermissionGroups" );
				for ( var i = 1; i lte randRange( 1, aWorkers.len() ); i++ ) {
					var aCustomPermGroups = [];
					for ( var x = 1; x lte randRange( 1, aPermGroups.len() ); x++ ) {
						aCustomPermGroups.append( {
							"FK_userId"            : aWorkers[ i ].userId,
							"FK_permissionGroupId" : aPermGroups[ x ].permissionGroupId
						} );
					}
					qb.from( "userPermissionGroups" ).insert( aCustomPermGroups );
					print.cyanLine(
						"   ==> (#aCustomPermGroups.len()#) Mock User Group permissions inserted for user: #aWorkers[ i ].userId#"
					);
				}

				/******************** USER TIME OFF REQUESTS ********************/

				// User TimeOff Requests
				print.line().greenLine( "Generating employee timeOff requests..." );
				truncate( "timeOff" );
				var aTimeOff = mockData.mock(
					$num            = "25",
					"timeOffId"     = "uuid",
					"createdDate"   = "datetime",
					"updatedDate"   = "datetime",
					"isActive"      = "oneof:1",
					"requestType"   = "oneof:sick:vacation",
					"startDate"     = "date",
					"endDate"       = "date",
					"hours"         = "num:1:8",
					"employeeNote"  = "lorem",
					"employerNote"  = "lorem",
					"status"        = "oneof:pending:approved:denied",
					"FK_userId"     = () => aEmployees[ randRange( 1, aEmployees.len() ) ].userId,
					"FK_approverId" = () => aEmployees[ randRange( 1, aEmployees.len() ) ].userId
				);
				qb.from( "timeOff" ).insert( aTimeOff );
				// print.redLine( aTimeOff );
				print.cyanLine( "   ==> (#aTimeOff.len()#) Mock TimeOff Requests inserted" );

				/*****************************************************/

				/******************** TASKS ********************/
				print.line().greenLine( "Generating tasks..." );
				truncate( "task" );
				var aTasks = mockData.mock(
					$num          = "50",
					"taskId"      = "uuid",
					"createdDate" = "datetime",
					"updatedDate" = "datetime",
					"isActive"    = "oneof:1",
					"name"        = ( index ) => "TASK_SEED_#arguments.index#",
					"description" = "lorem",
					"rate"        = "num:50:250"
				);
				qb.from( "task" ).insert( aTasks );
				// print.redLine( aTasks );
				print.cyanLine( "   ==> (#aTasks.len()#) Tasks inserted" );
				/*****************************************************/

				/******************** CLIENTS ********************/
				print.line().greenLine( "Generating clients..." );
				truncate( "client" );
				var aClients = mockData.mock(
					$num                 = "50",
					"clientId"           = "uuid",
					"createdDate"        = "datetime",
					"updatedDate"        = "datetime",
					"isActive"           = "oneof:1",
					"name"               = ( index ) => "CLIENT_SEED_#arguments.index#",
					"description"        = "lorem",
					"businessPhone"      = "tel",
					"country"            = () => "United States",
					"address"            = "sentence",
					"city"               = "words:1:3",
					"stateOrProvince"    = "words:1:3",
					"postalCode"         = () => "77375",
					"taxId"              = "ssn",
					"FK_clientManagerId" = "oneof:#aEmployees[ randRange( 1, aEmployees.len() ) ].userId#"
				);
				qb.from( "client" ).insert( aClients );
				// print.redLine( aClients );
				print.cyanLine( "   ==> (#aClients.len()#) Mock Clients inserted" );

				/******************** CLIENT NOTES ********************/
				print.line().greenLine( "Generating client notes..." );
				truncate( "clientNote" );
				var aClientNotes = mockData.mock(
					$num           = "100",
					"noteId"       = "uuid",
					"createdDate"  = "datetime",
					"updatedDate"  = "datetime",
					"isActive"     = "oneof:1:0",
					"notes"        = "baconlorem",
					"FK_creatorId" = () => aEmployees[ randRange( 1, aEmployees.len() ) ].userId,
					"FK_clientId"  = () => aClients[ randRange( 1, aClients.len() ) ].clientId
				);
				qb.from( "clientNote" ).insert( aClientNotes );
				// print.redLine( aUsers );
				print.cyanLine( "   ==> (#aClientNotes.len()#) Client Notes inserted" );

				/******************** CLIENT CONTACTS ********************/

				print.line().greenLine( "Generating some client contacts..." );
				truncate( "clientContact" );
				var aClientContacts = aUsers.filter( ( item ) => item.userType == "clientContact" );
				aClientContacts.each( ( thisContact ) => {
					qb.from( "clientContact" )
						.insert( {
							"userId"          : thisContact.userId,
							"isDecisionMaker" : randRange( 0, 1 ),
							"FK_clientId"     : aClients[ randRange( 1, aClients.len() ) ].clientId
						} );
				} );
				print.cyanLine( "   ==> (#aClientContacts.len()#) Client Contacts inserted" );

				/******************** CLIENT PROJECTS ********************/

				print.line().greenLine( "Generating some projects..." );
				truncate( "project" );
				var aProjects = mockData.mock(
					$num          = "30",
					"projectId"   = "uuid",
					"createdDate" = "datetime",
					"updatedDate" = "datetime",
					"isActive"    = "oneof:1:0",
					"name"        = "words:1:5",
					"description" = "lorem",
					"FK_clientId" = () => aClients[ randRange( 1, aClients.len() ) ].clientId
				);
				qb.from( "project" ).insert( aProjects );
				print.cyanLine( "   ==> (#aProjects.len()#) Mock Projects inserted" );

				/******************** PROJECT NOTES ********************/
				print.line().greenLine( "Generating project notes..." );
				truncate( "projectNote" );
				var aProjectNotes = mockData.mock(
					$num           = "100",
					"noteId"       = "uuid",
					"createdDate"  = "datetime",
					"updatedDate"  = "datetime",
					"isActive"     = "oneof:1:0",
					"notes"        = "baconlorem",
					"FK_creatorId" = () => aEmployees[ randRange( 1, aEmployees.len() ) ].userId,
					"FK_projectId" = () => aProjects[ randRange( 1, aProjects.len() ) ].projectId
				);
				qb.from( "projectNote" ).insert( aProjectNotes );
				print.cyanLine( "   ==> (#aProjectNotes.len()#) Project Notes inserted" );

				/******************** CLIENT PROJECT TASKS ********************/

				print.line().greenLine( "Generating some project tasks..." );
				truncate( "projectTasks" );
				var aProjectTasks = mockData.mock(
					$num           = "15",
					"FK_projectId" = () => aProjects[ randRange( 1, aProjects.len() ) ].projectId,
					"FK_taskId"    = () => aTasks[ randRange( 1, aTasks.len() ) ].taskId
				);
				qb.from( "projectTasks" ).insert( aProjectTasks );
				print.cyanLine(
					"   ==> (#aProjectTasks.len()#) Mock Client Project Tasks inserted"
				);

				/*****************************************************/

				/******************** CLIENT PROJECT TIMELOGS ********************/
				print.line().greenLine( "Generating some project timelogs..." );
				truncate( "timeLog" );
				var aTimeLogs = mockData.mock(
					$num           = "50",
					"timeLogId"    = "uuid",
					"createdDate"  = "datetime",
					"updatedDate"  = "datetime",
					"isActive"     = "oneof:1:0",
					"isBillable"   = "oneof:1:0",
					"isApproved"   = "oneof:1:0",
					"isBilled"     = "oneof:1:0",
					"logDate"      = "date",
					"hours"        = "num:1:8",
					"description"  = "lorem",
					// Random projects
					"FK_projectId" = () => aProjects[ randRange( 1, aProjects.len() ) ].projectId,
					// Random tasks
					"FK_taskId"    = () => aTasks[ randRange( 1, aTasks.len() ) ].taskId,
					// Random Users
					"FK_userId"    = () => aUsers[ randRange( 1, aUsers.len() ) ].userId
				);
				qb.from( "timeLog" ).insert( aTimeLogs );
				print.cyanLine( "   ==> (#aTimeLogs.len()#) Mock Client Project TimeLogs inserted" );

				/******************** CLIENT PROJECT MEMBERSHIPS ********************/
				print.line().greenLine( "Generating some project members..." );
				truncate( "projectMember" );
				var aProjectMembers = mockData.mock(
					$num              = "50",
					"projectMemberId" = "uuid",
					"createdDate"     = "datetime",
					"updatedDate"     = "datetime",
					"isActive"        = "oneof:1:0",
					"title"           = () => {
						var roles = [
							"pm",
							"lead",
							"developer",
							"scrum master"
						];
						return roles[ randRange( 1, roles.len() ) ];
					},
					"billingRate"  = "num:90:185",
					"costRate"     = "num:10:75",
					"hoursPerWeek" = "num:0:40",
					// Random projects
					"FK_projectId" = () => aProjects[ randRange( 1, aProjects.len() ) ].projectId,
					// Random Workers
					"FK_userId"    = () => aWorkers[ randRange( 1, aWorkers.len() ) ].userId,
					// Random Roles
					"Fk_roleId"    = () => aRoles[ randRange( 1, aRoles.len() ) ].roleId
				);
				qb.from( "projectMember" ).insert( aProjectMembers );
				print.cyanLine(
					"   ==> (#aProjectMembers.len()#) Mock Client Project Members inserted"
				);

				/******************** CLIENT PROJECT MEMBERSHIP A-LA-CARTE PERMISSIONS ********************/

				truncate( "projectMemberPermissions" );
				for ( var i = 1; i lte randRange( 1, aProjectMembers.len() ); i++ ) {
					var aCustomPerms = [];
					for ( var x = 1; x lte randRange( 1, aPerms.len() ); x++ ) {
						aCustomPerms.append( {
							"FK_projectMemberId" : aProjectMembers[ i ].projectMemberId,
							"FK_permissionId"    : aPerms[ x ].permissionId
						} );
					}
					qb.from( "projectMemberPermissions" ).insert( aCustomPerms );
					print.cyanLine(
						"   ==> (#aCustomPerms.len()#) Mock Project Membership A-la-carte permissions inserted"
					);
				}

				/*****************************************************/
			}
			// end transaction
		} catch ( any e ) {
			rethrow;
		} finally {
			queryExecute( "SET FOREIGN_KEY_CHECKS=1;" );
		}


		return;
	}

	/************************* PRIVATE METHODS ************************************/

	private function getCFMigrationsInfo(){
		var directory = getCWD();
		// Check and see if box.json exists
		if ( !packageService.isPackage( directory ) ) {
			return error( "File [#packageService.getDescriptorPath( directory )#] does not exist." );
		}

		var boxJSON = packageService.readPackageDescriptor( directory );

		if ( !JSONService.check( boxJSON, "cfmigrations" ) ) {
			return error(
				"There is no `cfmigrations` key in your box.json. Please create one with the necessary values. See https://github.com/elpete/commandbox-migrations"
			);
		}

		return JSONService.show( boxJSON, "cfmigrations" );
	}

	private function truncate( required table ){
		queryExecute( "truncate #arguments.table#" );
	}

}
