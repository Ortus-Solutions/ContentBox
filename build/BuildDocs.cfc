/**
 * Generate API Docs for ContentBox
 */
component{

	function init(){
		variables.util 		= shell.getUtil();
		variables.root 		= getCWD();
		variables.outputDir = variables.root & "build/build-contentbox/apidocs";

		// Cleanup
		if( directoryExists( variables.outputDir ) ){
			directoryDelete( variables.outputDir, true );
		}

		variables.util
			.addMapping( '/coldbox', 		    '#variables.root#/coldbox' )
			.addMapping( '/contentbox', 		'#variables.root#/modules/contentbox' )
			.addMapping( '/cbadmin', 			'#variables.root#/modules/contentbox/modules/contentbox-admin' )
			.addMapping( '/cborm', 		        '#variables.root#/modules/contentbox/modules/contentbox-deps/modules/cborm' );
	}

	/**
	 * Run this task and produce awesome Docs
	 *
	 * @version The version to add to the title output
	 */
	function run( version="1.0.0" ){
		var sTime = getTickCount();
		print.blueLine( "Generating ContentBox v#arguments.version# CFC Docs..." ).toConsole();

		command( "docbox generate" )
			.params(
				"source" 					= "/contentbox",
				"mapping" 					= "contentbox",
				"strategy-projectTitle"		= 'ContentBox Modular CMS #arguments.version#',
				"strategy-outputdir" 		= variables.outputDir,
				"excludes"					= "contentbox-deps"
			)
			.run();

		print.greenLine( "√ CFC Docs completed in #getTickCount() - sTime#ms and can be found at: #variables.outputDir#" ).toConsole();

		print.blueLine( "Generating ContentBox Swagger json docs..." ).toConsole();
		cfhttp(
			url="http://127.0.0.1:8589/index.cfm/cbswagger/json?debugmode=false&debugpassword=cb",
			resolveurl="true",
			path = variables.outputDir,
			file="contentbox-swagger.json"
		);

		print.greenLine( "√ Swagger JSON docs generated in #getTickCount() - sTime#ms and can be found at: #variables.outputDir#/contentbox-swagger.json" ).toConsole();
	}

}