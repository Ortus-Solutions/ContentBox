/**
 * Update a v4 Installation to v5.0.0
 */
component {

	function init(){
		variables.util = shell.getUtil();
		variables.root = getCWD();
		variables.tempFolder = variables.root & "__temp";

		variables.targetVersion = "5.0.0-beta-snapshot";

		directoryCreate( variables.tempFolder );

		return this;
	}

	/**
	 * Run the updater
	 */
	function run(){

		print.blueLine( "This task will update your ContentBox 4 installation to a ContentBox 5 installation." )
			.blueLine( "Please make a backup of your source and your database now. " )
			.line()
			.redLine( "Here are some caveats with the updater:")
			.redLine( "- This updater will replace your Application.cfc with a new version. Make sure you update it if you had previous customizations." )
			.line()
			.toConsole();

		var ready = ask(
			"Are you ready to continue (yes/no)?"
		);

		if ( listFindNoCase( "n,no", ready ) ) {
			print.blueLine( "Bye Bye!" );
			return;
		}

		// Update ColdBox
		print.blueLine( "Uninstalling current version of ColdBox..." ).toConsole();
		command( "uninstall coldbox" ).run();
		print.blueLine( "Installing latest version of ColdBox 6..." ).toConsole();
		command( "install coldbox@^6.0.0 --save" ).run();
		print.line()
			.greenLine( "√ ColdBox Updated!" )
			.toConsole();

		// Update ContentBox
		print.blueLine( "Uninstalling current version of ContentBox..." ).toConsole();
		command( "uninstall contentbox" ).run();
		print.blueLine( "Installing ContentBox v5.0.0" ).toConsole();
		command( "install contentbox@#variables.targetVersion# --save" ).run();
		print.line()
			.greenLine( "√ ContentBox v5 Installed!" )
			.toConsole();

		// install contentbox-site so we can copy over new assets
		command( "install contentbox-site@#variables.targetVersion#" )
			.inWorkingDirectory( variables.tempFolder )
			.run()

		// Remove temp folder
		directoryDelete( variables.tempFolder, true );

		// Run Migrations
		print.blueLine( "ContentBox Upgraded, running DB Migrations..." ).toConsole();
		command( "migrate up" ).run();

		// Final Comment
		print.boldRedLine(
			"√ Eureka!  You are now ready to startup your engines and run ContentBox v5.0.0!"
		)
		.toConsole();
	}

}
