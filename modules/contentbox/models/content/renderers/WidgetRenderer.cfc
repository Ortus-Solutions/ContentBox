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
		var tagAttributes 	= "";

		// Loop over found mustaches {{{Widget}}}
		for( var x=1; x lte targetLen; x++ ){
			tagAttributes = xmlParse( targets[ x ] ).widget.XmlAttributes;
			try{

				widgetName 		= tagAttributes.widgetname;
				widgetType 		= tagAttributes.widgettype;
				widgetUDF 		= structKeyExists( tagAttributes, "widgetUDF" ) ? tagAttributes.widgetUDF : "renderIt";
				isModuleWidget 	= widgetType == "Module";
				isThemeWidget 	= widgetType == "Theme";

				// Detect direct method call
				if( find( ".", widgetName ) ){
					widgetContent = invoke(
						widgetService.getWidget( '#getToken( widgetName, 1, "." )#' ),
						getToken( widgetName, 2, "." ),
						tagAttributes
					);
				} else {
					if( isModuleWidget ) {
						// Render out the module widget
						widgetContent = invoke(
							widgetService.getWidget( name=widgetName, type="module" ),
							widgetUDF,
							tagAttributes
						);
					} else {
						if( isThemeWidget ) {
							// Render out the theme widget
							widgetContent = invoke(
								widgetService.getWidget( name=widgetName, type="theme" ),
								widgetUDF,
								tagAttributes
							);
						} else {
							// lucee 4.5 split
							if( server.keyExists( "lucee" ) and server.lucee.version.getToken( 1, "." ) == 4 ){
								// Render out the core widget, do it the old way, until lucee 4.5 is not supported
								var thisWidget = widgetService.getWidget( name=widgetName, type=widgetService.discoverWidgetType( widgetName ) );
								widgetContent = thisWidget[ widgetUDF ]( argumentCollection=tagAttributes );
							} else {
								// Render out the core widget
								widgetContent = invoke(
									widgetService.getWidget( name=widgetName, type=widgetService.discoverWidgetType( widgetName ) ),
									widgetUDF,
									tagAttributes
								);
							}
						}
					}
				}
				// Verify null widgetContent
				if( isNull( widgetContent ) ){
					log.warn( "Widget: #widgetName# produce no content in page #arguments.content.getTitle()#", tagAttributes );
					widgetContent = "";
				}
			} catch( Any e ) {
				widgetContent = "Error translating tag widget: #e.message# #e.detail#";
				log.error( "Error translating tag widget on target: #targets[ x ]#", e);
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
				isThemeWidget 	= findNoCase( "~", tagString ) ? true : false;

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

				if( isThemeWidget ) {
					tagString = reReplace( tagString, "~", "", "one" );
				}

				// Parse it now as XML
				var tagXML 		= xmlParse( tagString );
				var widgetName 	= tagXML.XMLRoot.XMLName;
				var widgetArgs  = {};

				// Create Arg Collection From Attributes, if any
				if( structKeyExists( tagXML[ widgetName ], "XMLAttributes" ) ){
					for( var key in tagXML[ widgetName ].XMLAttributes){
						widgetArgs[ key ] = trim( tagXML[ widgetName ].XMLAttributes[ key ] );
					}
				}
				// set default UDF, if doesn't exist
				if( !structKeyExists( widgetArgs, "udf" ) ) {
					widgetArgs[ "widgetUDF" ] = "renderIt";
				}

				// Detect direct method call
				if( find( ".", widgetName) ){
					widgetContent = invoke(
						widgetService.getWidget( '#getToken( widgetName, 1, "." )#' ),
						getToken( widgetName, 2, "." ),
						widgetArgs
					);
				} else {
					if( isModuleWidget ) {
						// Render out the module widget
						widgetContent = invoke(
							widgetService.getWidget( name=widgetName & "@" & moduleName, type="module" ),
							widgetArgs.widgetUDF,
							widgetArgs
						);
					} else {
						if( isThemeWidget ) {
							// Render out the theme widget
							widgetContent = invoke(
								widgetService.getWidget( name=widgetName, type="theme" ),
								widgetArgs.widgetUDF,
								widgetArgs
							);
						} else {
							// Render out the core widget
							widgetContent = invoke(
								widgetService.getWidget( name=widgetName, type=widgetService.discoverWidgetType( widgetName ) ),
								widgetArgs.widgetUDF,
								widgetArgs
							);
						}
					}
				}
			} catch( Any e ) {
				widgetContent = "Error translating markup widget: #e.message# #e.detail# #e.stacktrace#";
				log.error( "Error translating markup widget on target: #targets[ x ]#", e);
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