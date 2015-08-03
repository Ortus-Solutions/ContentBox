/**
* A content renderer that transforms {{{}}} into widget executions
*/
component accessors="true"{

	// DI
	property name="widgetService" inject="id:widgetService@cb";
	property name="log"			  inject="logbox:logger:{this}";

	void function configure(){}

	/**
	* Execute on content translations for pages and blog entries
	*/
	void function cb_onContentRendering( event, struct interceptData ){
		translateContent( builder=arguments.interceptData.builder, content=arguments.interceptData.content );
	}
	
	/**
    * Executes custom parsing rules on content
    * @builder {java.lang.StringBuilder}
    * @content {String}
    */
	private function translateContent( required builder, content ){
		parseTagWidgets( argumentCollection=arguments );
		parseTripleMustacheWidgets( argumentCollection=arguments );
	}
	
	/**
    * Parses content to find <widget>...</widget> tags, and renders the associated widget
    * @builder {java.lang.StringBuilder}
    */
	private void function parseTagWidgets( required builder ) {
		// widget tag syntax
		var regex   = "<widget\b[^>]*>(.*?)</widget>";
		// match widgets in our incoming builder and build our targets array and len
		var targets 	= reMatch( regex, builder.toString() );
		var targetLen 	= arrayLen( targets );
		var isModuleWidget = false;
		var attributes = "";
		// Loop over found mustaches {{{Widget}}}
		for( var x=1; x lte targetLen; x++ ){
			attributes = xmlParse( targets[ x ] ).widget.XmlAttributes;
			try{
				widgetName = attributes.widgetname;
				widgetType = attributes.widgettype;
				widgetUDF = structKeyExists( attributes, "widgetUDF" ) ? attributes.widgetUDF : "renderIt";
				isModuleWidget = widgetType=="Module";
				isLayoutWidget = widgetType=="Layout";
				// Detect direct method call
				if( find( ".", widgetName) ){
					widgetContent = evaluate( "widgetService.getWidget( '#getToken(widgetName,1,"." )#' ).#getToken(widgetName,2,"." )#(argumentCollection=attributes)" );
				}
				else{
					if( isModuleWidget ) {
						// Render out the module widget
						widgetContent = evaluate( 'widgetService.getWidget( name=widgetName, type="module" ).#widgetUDF#( argumentCollection=attributes )' );
					}
					else {
						if( isLayoutWidget ) {
							// Render out the layout widget
							widgetContent = evaluate( 'widgetService.getWidget( name=widgetName, type="layout" ).#widgetUDF#( argumentCollection=attributes )' );
						}
						else {
							// Render out the core widget
							widgetContent = evaluate( 'widgetService.getWidget( widgetName ).#widgetUDF#( argumentCollection=attributes )' );
						}
					}
				}
			}
			catch( Any e ){
				widgetContent = "Error translating widget: #e.message# #e.detail#";
				log.error( "Error translating widget on target: #targets[ x ]#", e);
			}
			// PROCESS REPLACING
			
			// get location of target
			var rLocation 	= builder.indexOf( targets[ x ] );
			var rLen 		= len( targets[ x ] );
			// Loop findings of same {{{}}} instances to replace
			while( rLocation gt -1 ){
				// Replace it
				builder.replace( javaCast( "int", rLocation), JavaCast( "int", rLocation+rLen), widgetContent);
				// look again
				rLocation = builder.indexOf( targets[ x ], javaCast( "int", rLocation) );
			}
		}
	}
	
	/**
    * Parses content to find {{{...}}} syntax, and renders the associated widget
    * @builder {java.lang.StringBuilder}
    */
	private void function parseTripleMustacheWidgets( required builder ) {
		// our mustaches pattern
		var regex 		= "\{\{\{[^\}]*\}\}\}";
		// match widgets in our incoming builder and build our targets array and len
		var targets 	= reMatch( regex, builder.toString() );
		var targetLen 	= arrayLen( targets );
		var tagString	= "";
		var widgetContent	= "";
		var isModuleWidget = false;
		var moduleName = "";
		// Loop over found mustaches {{{Widget}}}
		for(var x=1; x lte targetLen; x++){
			// convert mustache to tag
			tagString = replace(targets[ x ],"{{{","<" );
			tagString = replace(tagString,"}}}","/>" );
			// convert quotes to standards
			tagString = replace(tagString,"&##34;",'"',"all" );
			tagString = replace(tagString,"&##39;","'","all" );
			tagString = replace(tagString,"&quot;","'","all" );

			try{
				// Parse : separator from method to first argument
				if( reFindNoCase( "\<[^\>\=\:\s]+\:",tagString) ){
					tagString = replace(tagString,":"," " );
				}
				// Parse arguments separated by commas
				tagString = replace(tagString,"',","' ","all" );
				tagString = replace(tagString,'",', '" ',"all" );
				isModuleWidget = findNoCase( "@", tagString ) ? true : false;
				isLayoutWidget = findNoCase( "~", tagString ) ? true : false;
				if( isModuleWidget ) {
					var startPos = find( "@", tagString )+1;
					var endPos = find( " ", tagString, 1 );
					moduleName = mid( tagString, startPos, endPos-startPos );
					tagString = reReplace( tagString, "@.* ", " ", "one" );
				}
				if( isLayoutWidget ) {
					tagString = reReplace( tagString, "~", "", "one" );
				}
				// Parse it now as XML
				var tagXML 		= xmlParse( tagString );
				var widgetName 	= tagXML.XMLRoot.XMLName;
				var widgetArgs  = {};
				// Create Arg Collection From Attributes, if any
				if( structKeyExists( tagXML[ widgetName ], "XMLAttributes" ) ){
					for(key in tagXML[ widgetName ].XMLAttributes){
						widgetArgs[key] = trim( tagXML[ widgetName ].XMLAttributes[ key ] );
					}
				}
				// set default UDF, if doesn't exist
				if( !structKeyExists( widgetArgs, "udf" ) ) {
					widgetArgs[ "widgetUDF" ] = "renderIt";
				}
				// Detect direct method call
				if( find( ".", widgetName) ){
					widgetContent = evaluate( "widgetService.getWidget( '#getToken(widgetName,1,"." )#' ).#getToken(widgetName,2,"." )#(argumentCollection=widgetArgs)" );
				}
				else{
					if( isModuleWidget ) {
						// Render out the module widget
						widgetContent = evaluate( 'widgetService.getWidget( name=widgetName & "@" & moduleName, type="module" ).#widgetArgs.widgetUDF#( argumentCollection=widgetArgs )' );
					}
					else {
						if( isLayoutWidget ) {
							// Render out the layout widget
							widgetContent = evaluate( 'widgetService.getWidget( name=widgetName, type="layout" ).#widgetArgs.widgetUDF#(argumentCollection=widgetArgs)' );
						}
						else {
							// Render out the core widget
							widgetContent = evaluate( 'widgetService.getWidget( widgetName ).#widgetArgs.widgetUDF#(argumentCollection=widgetArgs)' );
						}
					}
				}
			}
			catch(Any e){
				widgetContent = "Error translating widget: #e.message# #e.detail#";
				log.error( "Error translating widget on target: #targets[ x ]#", e);
			}
			// PROCESS REPLACING
			
			// null checks
			if( isNull( widgetContent ) ){ widgetContent = "null!"; }
			
			// get location of target
			var rLocation 	= builder.indexOf( targets[ x ] );
			var rLen 		= len( targets[ x ] );
			// Loop findings of same {{{}}} instances to replace
			while( rLocation gt -1 ){
				// Replace it
				builder.replace( javaCast( "int", rLocation), JavaCast( "int", rLocation+rLen), widgetContent);
				// look again
				rLocation = builder.indexOf( targets[ x ], javaCast( "int", rLocation) );
			}
		}
	}
}