/**
 * Update a v5 Installation to v6
 */
component {

	function init(){
		variables.util = shell.getUtil();
		variables.cwd = getCWD();
		variables.tempFolder = variables.cwd & "__temp";

		variables.targetVersion = "6";

		if( directoryExists( variables.tempFolder ) ){
			directoryDelete( variables.tempFolder, true );
		}
		directoryCreate( variables.tempFolder );

		// Directory copy excludes
		variables.excludes = [
			".tmp",
			".DS_Store",
			".git"
		];

		return this;
	}

	/**
	 * Run the updater
	 */
	function run( version ){
		// Override the incoming version if needed
		if( !isNull( arguments.version ) ){
			variables.targetVersion = arguments.version;
		}

		print.blueLine( "This task will update your ContentBox 5 installation to a ContentBox 6 installation." )
			.blueLine( "Please make a backup of your source and your database now. " )
			.line()
			.redLine( "Here are some files that will be overwritten by the updater. We will create .bak files for you.")
			.redLine( "Make sure you copy back your customizations to your new files:")
			.redLine( "- Application.cfc" )
			.redLine( "- config/Coldbox.cfc")
			.line()
			.toConsole();

		var ready = ask(
			"Are you ready to continue (yes/no)?"
		);

		if ( listFindNoCase( "n,no", ready ) ) {
			print.blueLine( "Bye Bye!" );
			return;
		}

		// Install ContentBox
		print.blueLine( "Downloading ContentBox v#variables.targetVersion# assets to __temp folder..." ).toConsole();
		command( "install contentbox-site@#variables.targetVersion#" )
			.inWorkingDirectory( variables.tempFolder )
			.run();
		print.greenLine( "√ ContentBox assets downloaded!" ).toConsole();

		// Update ColdBox
		print.blueLine( "Uninstalling current version of ColdBox..." ).toConsole();
		command( "uninstall coldbox" ).run();
		print.blueLine( "Installing latest version of ColdBox 7..." ).toConsole();
		command( "install coldbox@^7.0.0 --save" ).run();
		print.greenLine( "√ ColdBox Updated!" ).toConsole();

		// Update ContentBox
		print.blueLine( "Uninstalling current version of the ContentBox module..." ).toConsole();
		command( "uninstall contentbox" ).run();
		print.blueLine( "Installing ContentBox v#variables.targetVersion#" ).toConsole();
		command( "install contentbox@#variables.targetVersion# --save" ).run();
		print.greenLine( "√ ContentBox v#variables.targetVersion# Installed!" ).toConsole();

		// ContentBox Bin directory installation
		print.blueLine( "Moving new ContentBox bin folder to root..." ).toConsole();
		if( !directoryExists( variables.cwd & "bin" ) ){
			directoryCreate( variables.cwd & "bin" );
		};
		copy( variables.tempFolder & "/bin", variables.cwd & "bin" );
		print.greenLine( "√ ContentBox bin folder installed!" ).toConsole();

		// New ColdBox 7 Modules Folder
		print.blueLine( "Moving new ColdBox config modules folder to config..." ).toConsole();
		if( !directoryExists( variables.cwd & "config/modules" ) ){
			directoryCreate( variables.cwd & "config/modules" );
		};
		copy( variables.tempFolder & "/config/modules", variables.cwd & "config/modules" );
		print.greenLine( "√ ColdBox config modules folder installed!" ).toConsole();

		// Copy over new files
		replaceNewSiteFiles();

		// Remove temp folder
		directoryDelete( variables.tempFolder, true );

		// Run Migrations
		print.blueLine( "Migrating your database to version: #variables.targetVersion#..." ).toConsole();
		command( "run-script contentbox:migrate:up" ).run();
		print.greenLine( "√ Database migrated!" ).toConsole();

		// Final Comment
		print.boldRedLine(
			"√ Eureka!  You are now ready to startup your engines and run ContentBox v#variables.targetVersion#!"
		)
		.toConsole();
	}

	function replaceNewSiteFiles(){
		print.blueLine( "Starting to deploy new files..." ).line().toConsole();

		var files = [
			".cfconfig.json",
			"server.json",
			"Application.cfc",
			"readme.md",
			"config/Coldbox.cfc"
		].each( ( thisFile ) => {
			if( fileExists( variables.cwd & thisFile ) ){
				print.blueLine( "Backing up #thisFile#..." ).toConsole();
				fileCopy(
					variables.cwd & thisFile,
					variables.cwd & thisFile & ".bak"
				);
			}

			print.blueLine( "Installing new #thisFile#..." ).toConsole();
			fileCopy(
				variables.tempFolder & "/" & thisFile,
				variables.cwd & thisFile
			);
			print.greenLine( "√ New #thisFile# Installed!" ).toConsole();
		} );

		print.line().greenLine( "√ New files deployed!" ).line().toConsole();
	}

	/**
     * DirectoryCopy is broken in lucee
     */
    private function copy( src, target, recurse=true ){
        // process paths with excludes
        directoryList( src, false, "path", function( path ){
            var isExcluded = false;
            variables.excludes.each( function( item ){
                if( path.replaceNoCase( variables.cwd, "", "all" ).findNoCase( item ) ){
                    isExcluded = true;
                }
            } );
            return !isExcluded;
        }).each( function( item ){
            // Copy to target
            if( fileExists( item ) ){
                print.blueLine( "Copying #item#" ).toConsole();
                fileCopy( item, target );
            } else {
                print.greenLine( "Copying directory #item#" ).toConsole();
                directoryCopy( item, target & "/" & item.replace( src, "" ), true );
            }
        } );
    }
}
