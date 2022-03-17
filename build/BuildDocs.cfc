/**
 * Generate API Docs for ContentBox
 */
component {

	function init(){
		// Setup Directories
		variables.util       = shell.getUtil();
		variables.root       = getCWD();
		variables.buildDir   = variables.root & "build/build-contentbox";
		variables.apidocsDir = variables.buildDir & "/apidocs";
		variables.testsDir   = variables.root & "tests/results";
		variables.exportsDir = variables.root & "artifacts/contentbox";

		// Cleanup directories
		[ variables.apidocsDir, variables.exportsDir ].each( ( thisDir ) => {
			if ( directoryExists( arguments.thisDir ) ) {
				directoryDelete( arguments.thisDir, true );
			}
			// Create it now
			directoryCreate( arguments.thisDir, true );
		} );

		// Create all necessary mappings for this build
		variables.util
			.addMapping( "/coldbox", "#variables.root#/coldbox" )
			.addMapping( "/contentbox", "#variables.root#/modules/contentbox" )
			.addMapping(
				"/cbadmin",
				"#variables.root#/modules/contentbox/modules/contentbox-admin"
			)
			.addMapping(
				"/cborm",
				"#variables.root#/modules/contentbox/modules/contentbox-deps/modules/cborm"
			);
	}

	/**
	 * Run this task and produce awesome Docs
	 *
	 * @version The version to add to the title output
	 */
	function run( version = "1.0.0" ){
		// Prepare exports via passed version
		variables.exportsDir &= "/#arguments.version#";
		if ( !directoryExists( variables.exportsDir ) ) {
			directoryCreate( variables.exportsDir, true );
		}

		// Build API Docs using DocBox
		apiDocs( arguments.version );
		print.greenLine( "Zipping apidocs to #variables.exportsDir#" ).toConsole();
		cfzip(
			action    = "zip",
			file      = "#variables.exportsDir#/contentbox-apidocs-#arguments.version#.zip",
			source    = "#variables.apidocsDir#",
			overwrite = true,
			recurse   = true
		);

		// Build swagger now
		swagger( arguments.version );
	}

	function apiDocs( version = "1.0.0" ){
		var sTime = getTickCount();
		print.blueLine( "Generating ContentBox v#arguments.version# CFC Docs..." ).toConsole();

		command( "docbox generate" )
			.params(
				"source"                = "/contentbox",
				"mapping"               = "contentbox",
				"strategy-projectTitle" = "ContentBox Modular CMS #arguments.version#",
				"strategy-outputdir"    = variables.apidocsDir,
				"excludes"              = "contentbox-deps"
			)
			.run();
		variables.print
			.greenLine(
				"√ CFC Docs completed in #getTickCount() - sTime#ms and can be found at: #variables.apidocsDir#"
			)
			.toConsole();
	}

	/**
	 * Build the swagger docs
	 */
	function swagger( version = "1.0.0" ){
		var sTime = getTickCount();
		variables.print
			.blueLine( "Generating ContentBox #arguments.version# Swagger json docs..." )
			.toConsole();

		// Test if swagger doc in resutls already
		if ( fileExists( variables.testsDir & "/contentbox-swagger.json" ) ) {
			variables.print
				.greenLine( "Swagger docs already created, just doing token replacements..." )
				.toConsole();
			command( "tokenReplace" )
				.params(
					path        = "#variables.testsDir#/contentbox-swagger.json",
					token       = "@version.number@",
					replacement = arguments.version
				)
				.run();
		} else {
			variables.print
				.orangeLine( "Swagger docs not found, recreating..." )
				.toConsole();
			command( "tokenReplace" )
				.params(
					path        = "#variables.root#/config/Coldbox.cfc",
					token       = "@version.number@",
					replacement = arguments.version
				)
				.run();
			cfhttp(
				url  = "http://127.0.0.1:8589/index.cfm/cbswagger?debugmode=false&debugpassword=cb",
				path = variables.testsDir,
				file = "contentbox-swagger.json"
			);
		}

		// Move Rapidoc Viewer
		fileCopy(
			"#variables.root#/build/resources/apidoc.html",
			"#variables.apidocsDir#/apidoc.html"
		);

		// Move Swagger Doc to Exports + Apidocs
		fileCopy(
			"#variables.testsDir#/contentbox-swagger.json",
			"#variables.exportsDir#/contentbox-swagger-#arguments.version#.json"
		);
		fileCopy(
			"#variables.testsDir#/contentbox-swagger.json",
			"#variables.apidocsDir#/contentbox-swagger.json"
		);

		variables.print
			.greenLine(
				"√ Swagger JSON docs generated in #getTickCount() - sTime#ms and can be found at: #variables.apidocsDir#/contentbox-swagger.json"
			)
			.toConsole();
	}

}
