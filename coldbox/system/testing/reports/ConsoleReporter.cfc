/**
********************************************************************************
Copyright 2005-2009 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
* A text reporter
*/ 
component{

	function init(){ 
		variables.out = createObject("Java", "java.lang.System").out;
		return this; 
	}

	/**
	* Get the name of the reporter
	*/
	function getName(){
		return "Console";
	}

	/**
	* Do the reporting thing here using the incoming test results
	* The report should return back in whatever format they desire and should set any
	* Specifc browser types if needed.
	* @results.hint The instance of the TestBox TestResult object to build a report on
	* @testbox.hint The TestBox core object
	* @options.hint A structure of options this reporter needs to build the report with
	*/
	any function runReport( 
		required coldbox.system.testing.TestResult results,
		required coldbox.system.testing.TestBox testbox,
		struct options={}
	){
		// content type
		getPageContext().getResponse().setContentType( "text/plain" );
		// bundle stats
		bundleStats = arguments.results.getBundleStats();
		
		// prepare the report
		savecontent variable="local.report"{
			include "assets/text.cfm";
		}

		// send to console
		variables.out.printLn( local.report );

		return "Report Sent To Console";
	}
	
}