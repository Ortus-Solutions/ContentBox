<cfsetting showDebugOutput="false">
<!--- Executes all tests in the 'specs' folder with simple reporter by default --->
<cfparam name="url.reporter" 			default="simple">
<cfparam name="url.directory" 			default="tests.specs.contentbox-web">
<cfparam name="url.recurse" 			default="true" type="boolean">
<cfparam name="url.bundles" 			default="">
<cfparam name="url.labels" 				default="">
<cfparam name="url.excludes" 			default="">
<cfparam name="url.reportpath" 			default="#expandPath( "/tests/results" )#">
<cfparam name="url.propertiesFilename" 	default="TEST.properties">
<cfparam name="url.propertiesSummary" 	default="false" type="boolean">
<cfparam name="url.editor" 				default="vscode">
<cfparam name="url.bundlesPattern" 		default="*Spec*.cfc|*Test*.cfc|*Spec*.bx|*Test*.bx">

<!--- Streaming mode: streams results via Server-Sent Events (SSE) for real-time progress --->
<cfparam name="url.streaming"						default="false" type="boolean">
<cfparam name="url.dryRun"							default="false" type="boolean">

<!--- Code Coverage requires FusionReactor --->
<cfparam name="url.coverageEnabled"					default="false">
<cfparam name="url.coveragePathToCapture"			default="#expandPath( '/root' )#">
<cfparam name="url.coverageWhitelist"				default="">
<cfparam name="url.coverageBlacklist"				default="/testbox,/coldbox,/tests,/modules,Application.cfc,/index.cfm,Application.bx,/index.bxm">
<!---<cfparam name="url.coverageBrowserOutputDir"		default="#expandPath( '/tests/results/coverageReport' )#">--->
<!---<cfparam name="url.coverageSonarQubeXMLOutputPath"	default="#expandPath( '/tests/results/SonarQubeCoverage.xml' )#">--->
<!--- Enable batched code coverage reporter, useful for large test bundles which require spreading over multiple testbox run commands. --->
<!--- <cfparam name="url.isBatched"						default="false"> --->

<!--- Include the appropriate runner based on streaming mode --->
<cfif url.streaming && !url.dryRun>
	<!--- Stream results in real-time via SSE --->
	<cfinclude template="/testbox/system/runners/StreamingRunner.cfm">
<cfelse>
	<!--- Traditional batch results --->
	<cfinclude template="/testbox/system/runners/HTMLRunner.cfm">
</cfif>
