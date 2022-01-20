/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A content renderer that transforms {{{}}} into widget executions
 */
component accessors="true" extends="BaseRenderer" {

	// DI
	property name="widgetService" inject="id:widgetService@contentbox";

	/**
	 * Execute on content translations for pages and blog entries
	 */
	void function cb_onContentRendering( event, struct data ){
		translateContent(
			builder = arguments.data.builder,
			content = arguments.data.content,
			event   = arguments.event
		);
	}

	/**
	 * Executes custom parsing rules on content
	 *
	 * @builder java.lang.StringBuilder that contains all the content to manipulate
	 * @content The content object that requested translation
	 */
	private function translateContent( required builder, content ){
		parseTagWidgets( argumentCollection = arguments );
		parseTripleMustacheWidgets( argumentCollection = arguments );
	}

	/**
	 * Parses content to find <widget>...</widget> tags, and renders the associated widget
	 *
	 * @builder java.lang.StringBuilder that contains all the content to manipulate
	 * @content The content object that requested translation
	 */
	private void function parseTagWidgets( required builder, required content ){
		// widget tag syntax
		var regex     = "<widget\b[^>]*>(.*?)</widget>";
		// match widgets in our incoming builder and build our targets array and len
		var targets   = reMatchNoCase( regex, builder.toString() );
		var targetLen = arrayLen( targets );

		// Loop over found tags
		for ( var x = 1; x lte targetLen; x++ ) {
			var tagAttributes = xmlParse( targets[ x ] ).widget.XmlAttributes;
			try {
				var widgetName     = tagAttributes.widgetname;
				var widgetType     = tagAttributes.widgettype;
				var widgetUDF      = structKeyExists( tagAttributes, "widgetUDF" ) ? tagAttributes.widgetUDF : "renderIt";
				var isModuleWidget = widgetType == "Module";
				var isThemeWidget  = widgetType == "Theme";

				// Widget Executions
				var oWidget       = "";
				var oWidgetMethod = "";
				var widgetContent = "";

				// Detect Widget and Method Calls
				if ( find( ".", widgetName ) ) {
					oWidget       = widgetService.getWidget( "#getToken( widgetName, 1, "." )#" );
					oWidgetMethod = getToken( widgetName, 2, "." );
				} else if ( isModuleWidget ) {
					// Render out the module widget
					oWidget       = widgetService.getWidget( name = widgetName, type = "module" );
					oWidgetMethod = widgetUDF;
				} else if ( isThemeWidget ) {
					// Render out the theme widget
					oWidget       = widgetService.getWidget( name = widgetName, type = "theme" );
					oWidgetMethod = widgetUDF;
				} else {
					oWidget = widgetService.getWidget(
						name = widgetName,
						type = widgetService.discoverWidgetType( widgetName )
					);
					oWidgetMethod = widgetUDF;
				}

				// lucee 4.5 split due to invoke bug
				if ( server.keyExists( "lucee" ) and server.lucee.version.getToken( 1, "." ) == 4 ) {
					widgetContent = evaluate( "oWidget.#oWidgetMethod#( argumentCollection=tagAttributes )" );
				} else {
					// Render out the widgets
					widgetContent = invoke( oWidget, oWidgetMethod, tagAttributes );
				}

				// Verify null widgetContent
				if ( isNull( widgetContent ) ) {
					log.warn(
						"Widget: #widgetName# produce no content in page #arguments.content.getTitle()#",
						tagAttributes
					);
					widgetContent = "";
				}
			} catch ( Any e ) {
				widgetContent = "Error translating tag widget: #e.message#";

				if ( len( e.detail ) ) {
					widgetContent &= "<br><strong>Detail:</strong> #e.detail#";
				}

				if ( log.canDebug() ) {
					widgetContent &= "<br><strong>StackTrace:</strong> <pre>#e.stacktrace#</pre>";
				}

				log.error( "Error translating tag widget on target: #targets[ x ]#", e );
			}

			// PROCESS REPLACING
			multiStringReplace(
				builder     = arguments.builder,
				indexOf     = targets[ x ],
				replaceWith = widgetContent
			);
		}
	}

	/**
	 * Parses content to find {{{...}}} syntax, and renders the associated widget
	 *
	 * @builder java.lang.StringBuilder that contains all the content to manipulate
	 * @content The content object that requested translation
	 */
	private void function parseTripleMustacheWidgets( required builder, required content ){
		// Escape values for non-rendering
		multiStringReplace(
			builder     = arguments.builder,
			indexOf     = "<escape>{{{",
			replaceWith = "<escape>#encodeForHTML( "{{{" )#"
		);

		// our mustaches pattern
		var regex      = "(?!\<\/escape\>)\{\{\{[^\}]*\}\}\}(?!\<\/escape\>)";
		// match widgets in our incoming builder and build our targets array and len
		var targets    = reMatch( regex, builder.toString() );
		var targetLen  = arrayLen( targets );
		var moduleName = "";

		// Loop over found mustaches {{{Widget}}}
		for ( var x = 1; x lte targetLen; x++ ) {
			// convert mustache to tag
			var tagString = replace( targets[ x ], "{{{", "<" );
			tagString     = replace( tagString, "}}}", "/>" );
			// convert quotes to standards
			tagString     = replace( tagString, "&##34;", """", "all" );
			tagString     = replace( tagString, "&##39;", "'", "all" );
			tagString     = replace( tagString, "&quot;", "'", "all" );

			try {
				// Parse : separator from method to first argument
				if ( reFindNoCase( "\<[^\>\=\:\s]+\:", tagString ) ) {
					tagString = replace( tagString, ":", " " );
				}

				// Parse arguments separated by commas
				tagString = replace( tagString, "',", "' ", "all" );
				tagString = replace( tagString, """,", """ ", "all" );

				var isModuleWidget = findNoCase( "@", tagString ) ? true : false;
				var isThemeWidget  = findNoCase( "~", tagString ) ? true : false;

				if ( isModuleWidget ) {
					var startPos = find( "@", tagString ) + 1;
					// default end is last character of closing tag.
					var endPos   = find( "/>", tagString );
					var spacePos = find( " ", tagString );
					// If we have arguments, then change this to first break position
					if ( spacePos > 0 ) {
						endPos = spacePos;
					}
					// Get module name now
					moduleName = mid( tagString, startPos, endPos - startPos );
					// clean the tag
					tagString  = replaceNoCase( tagString, "@#moduleName#", "", "one" );
				}

				if ( isThemeWidget ) {
					tagString = reReplace( tagString, "~", "", "one" );
				}

				// Parse it now as XML
				var tagXML     = xmlParse( tagString );
				var widgetName = tagXML.XMLRoot.XMLName;
				var widgetArgs = {};

				// Create Arg Collection From Attributes, if any
				if ( structKeyExists( tagXML[ widgetName ], "XMLAttributes" ) ) {
					for ( var key in tagXML[ widgetName ].XMLAttributes ) {
						widgetArgs[ key ] = trim( tagXML[ widgetName ].XMLAttributes[ key ] );
					}
				}

				// set default UDF, if doesn't exist
				if ( !structKeyExists( widgetArgs, "udf" ) ) {
					widgetArgs[ "widgetUDF" ] = "renderIt";
				}

				// Widget Executions
				var oWidget       = "";
				var oWidgetMethod = "";
				var widgetContent = "";

				// Detect direct method call
				if ( find( ".", widgetName ) ) {
					oWidget = widgetService.getWidget(
						name = "#getToken( widgetName, 1, "." )#",
						type = widgetService.discoverWidgetType( widgetName )
					);
					oWidgetMethod = getToken( widgetName, 2, "." );
				} else if ( isModuleWidget ) {
					oWidget       = widgetService.getWidget( name = widgetName & "@" & moduleName, type = "module" );
					oWidgetMethod = widgetArgs.widgetUDF;
				} else if ( isThemeWidget ) {
					oWidget       = widgetService.getWidget( name = widgetName, type = "theme" );
					oWidgetMethod = widgetArgs.widgetUDF;
				} else {
					oWidget = widgetService.getWidget(
						name = widgetName,
						type = widgetService.discoverWidgetType( widgetName )
					);
					oWidgetMethod = widgetArgs.widgetUDF;
				}

				// lucee 4.5 split due to invoke bug
				if ( server.keyExists( "lucee" ) and server.lucee.version.getToken( 1, "." ) == 4 ) {
					widgetContent = evaluate( "oWidget.#oWidgetMethod#( argumentCollection=widgetArgs )" );
				} else {
					// Render out the widgets
					widgetContent = invoke( oWidget, oWidgetMethod, widgetArgs );
				}

				// Verify null widgetContent
				if ( isNull( widgetContent ) ) {
					log.warn(
						"Widget: #widgetName# produce no content in page #arguments.content.getTitle()#",
						tagAttributes
					);
					widgetContent = "";
				}
			} catch ( Any e ) {
				widgetContent = "Error translating markup widget: #e.message# #e.detail# #e.stacktrace#";
				log.error( "Error translating markup widget on target: #targets[ x ]#", e );
			}

			// PROCESS REPLACING
			multiStringReplace(
				builder     = arguments.builder,
				indexOf     = targets[ x ],
				replaceWith = widgetContent
			);
		}
	}

}
