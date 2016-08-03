/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A content renderer that transforms {{{}}} into widget executions
*/
component accessors="true" extends="BaseRenderer"{

	// DI
	property name="widgetService" inject="id:widgetService@cb";

	/**
	* Execute on content translations for pages and blog entries
	*/
	void function cb_onContentRendering( event, struct interceptData ){
		translateContent( 
			builder	= arguments.interceptData.builder, 
			content = arguments.interceptData.content, 
			event	= arguments.event 
		);
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
		var regex   		= "<widget\b[^>]*>(.*?)</widget>";
		// match widgets in our incoming builder and build our targets array and len
		var targets 		= reMatchNoCase( regex, builder.toString() );
		var targetLen 		= arrayLen( targets );
		var isModuleWidget 	= false;
		var attributes 		= "";

		// Loop over found mustaches {{{Widget}}}
		for( var x=1; x lte targetLen; x++ ){
			attributes = xmlParse( targets[ x ] ).widget.XmlAttributes;
			try{
				
				widgetName 		= attributes.widgetname;
				widgetType 		= attributes.widgettype;
				widgetUDF 		= structKeyExists( attributes, "widgetUDF" ) ? attributes.widgetUDF : "renderIt";
				isModuleWidget 	= widgetType == "Module";
				isLayoutWidget 	= widgetType == "Layout";
				
				// Detect direct method call
				if( find( ".", widgetName) ){
					widgetContent = evaluate( "widgetService.getWidget( '#getToken(widgetName,1,"." )#' ).#getToken(widgetName,2,"." )#(argumentCollection=attributes)" );
				} else {
					if( isModuleWidget ) {
						// Render out the module widget
						widgetContent = evaluate( 'widgetService.getWidget( name=widgetName, type="module" ).#widgetUDF#( argumentCollection=attributes )' );
					} else {
						if( isLayoutWidget ) {
							// Render out the layout widget
							widgetContent = evaluate( 'widgetService.getWidget( name=widgetName, type="layout" ).#widgetUDF#( argumentCollection=attributes )' );
						} else {
							// Render out the core widget
							widgetContent = evaluate( 'widgetService.getWidget( widgetName ).#widgetUDF#( argumentCollection=attributes )' );
						}
					}
				}
				// Verify null widgetContent
				if( isNull( widgetContent ) ){
					log.warn( "Widget: #widgetName# produce no content in page #arguments.content.getTitle()#", attributes );
					widgetContent = "";
				}
			} catch( Any e ) {
				widgetContent = "Error translating widget: #e.message# #e.detail#";
				log.error( "Error translating widget on target: #targets[ x ]#", e);
			}

			// PROCESS REPLACING
			multiStringReplace( 
				builder 	= arguments.builder,
				indexOf	 	= targets[ x ],
				replaceWith = widgetContent
			);
		}
	}
	
	/**
    * Parses content to find {{{...}}} syntax, and renders the associated widget
    * @builder {java.lang.StringBuilder}
    */
	private void function parseTripleMustacheWidgets( required builder ){
		// Escape values for non-rendering
		multiStringReplace( 
			builder 	= arguments.builder,
			indexOf	 	= "<escape>{{{",
			replaceWith = "<escape>#encodeForHTML( '{{{' )#"
		);

		// our mustaches pattern
		var regex 			= "(?!\<\/escape\>)\{\{\{[^\}]*\}\}\}(?!\<\/escape\>)";
		// match widgets in our incoming builder and build our targets array and len
		var targets 		= reMatch( regex, builder.toString() );
		var targetLen 		= arrayLen( targets );
		var tagString		= "";
		var widgetContent	= "";
		var isModuleWidget 	= false;
		var moduleName 		= "";

		// Loop over found mustaches {{{Widget}}}
		for( var x=1; x lte targetLen; x++ ){
			// convert mustache to tag
			tagString = replace( targets[ x ], "{{{", "<" );
			tagString = replace( tagString, "}}}", "/>" );
			// convert quotes to standards
			tagString = replace( tagString, "&##34;", '"', "all" );
			tagString = replace( tagString, "&##39;", "'", "all" );
			tagString = replace( tagString, "&quot;", "'", "all" );

			try{
				// Parse : separator from method to first argument
				if( reFindNoCase( "\<[^\>\=\:\s]+\:", tagString ) ){
					tagString = replace( tagString, ":", " " );
				}

				// Parse arguments separated by commas
				tagString 		= replace( tagString, "',", "' ", "all" );
				tagString 		= replace( tagString, '",',  '" ', "all" );
				isModuleWidget 	= findNoCase( "@", tagString ) ? true : false;
				isLayoutWidget 	= findNoCase( "~", tagString ) ? true : false;
				
				if( isModuleWidget ) {
					var startPos 	= find( "@", tagString ) + 1;
					// default end is last character of closing tag.
					var endPos 		= find( "/>", tagString );
					var spacePos 	= find( " ", tagString );
					// If we have arguments, then change this to first break position
					if( spacePos > 0 ){
						endPos = spacePos;
					}
					// Get module name now
					moduleName = mid( tagString, startPos, endPos - startPos );
					// clean the tag
					tagString = replacenocase( tagString, "@#moduleName#", "", "one" );
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
				} else {
					if( isModuleWidget ) {
						// Render out the module widget
						widgetContent = evaluate( 'widgetService.getWidget( name=widgetName & "@" & moduleName, type="module" ).#widgetArgs.widgetUDF#( argumentCollection=widgetArgs )' );
					} else {
						if( isLayoutWidget ) {
							// Render out the layout widget
							widgetContent = evaluate( 'widgetService.getWidget( name=widgetName, type="layout" ).#widgetArgs.widgetUDF#(argumentCollection=widgetArgs)' );
						} else {
							// Render out the core widget
							widgetContent = evaluate( 'widgetService.getWidget( widgetName ).#widgetArgs.widgetUDF#(argumentCollection=widgetArgs)' );
						}
					}
				}
			} catch( Any e ) {
				widgetContent = "Error translating widget: #e.message# #e.detail#";
				log.error( "Error translating widget on target: #targets[ x ]#", e);
			}

			// null checks
			if( isNull( widgetContent ) ){ widgetContent = "null!"; }

			// PROCESS REPLACING
			multiStringReplace( 
				builder 	= arguments.builder,
				indexOf	 	= targets[ x ],
				replaceWith = widgetContent
			);

		}
	}
}