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
	void function cb_onContentRendering(event,struct interceptData){
		translateContent(builder=arguments.interceptData.builder,content=arguments.interceptData.content);
	}

	/**
	* Execute on content translations for custom HTML
	*/
	void function cb_onCustomHTMLRendering(event,struct interceptData){
		translateContent(builder=arguments.interceptData.builder,customHTML=arguments.interceptData.customHTML);
	}

	private function translateContent(required builder, content, customHTML){
		// our mustaches pattern
		var regex 		= "\{\{\{[^\}]*\}\}\}";
		// match widgets in our incoming builder and build our targets array and len
		var targets 	= reMatch( regex, builder.toString() );
		var targetLen 	= arrayLen( targets );
		var tagString	= "";
		var widgetContent	= "";

		// Loop over found mustaches {{{Widget}}}
		for(var x=1; x lte targetLen; x++){

			// convert mustache to tag
			tagString = replace(targets[x],"{{{","<");
			tagString = replace(tagString,"}}}","/>");
			// convert quotes to standards
			tagString = replace(tagString,"&##34;",'"',"all");
			tagString = replace(tagString,"&##39;","'","all");
			tagString = replace(tagString,"&quot;","'","all");

			try{
				// Parse : separator from method to first argument
				if( reFindNoCase("\<[^\>\=\:\s]+\:",tagString) ){
					tagString = replace(tagString,":"," ");
				}
				// Parse arguments separated by commas
				tagString = replace(tagString,"',","' ","all");
				tagString = replace(tagString,'",', '" ',"all");

				// Parse it now as XML
				var tagXML 		= xmlParse( tagString );
				var widgetName 	= tagXML.XMLRoot.XMLName;
				var widgetArgs  = {};

				// Create Arg Collection From Attributes, if any
				if( structKeyExists( tagXML[ widgetName ], "XMLAttributes") ){
					for(key in tagXML[ widgetName ].XMLAttributes){
						widgetArgs[key] = trim( tagXML[ widgetName ].XMLAttributes[ key ] );
					}
				}

				// Detect direct method call
				if( find(".", widgetName) ){
					widgetContent = evaluate("widgetService.getWidget( '#getToken(widgetName,1,".")#' ).#getToken(widgetName,2,".")#(argumentCollection=widgetArgs)");
				}
				else{
					// Render out the widget
					widgetContent = widgetService.getWidget( widgetName ).renderit(argumentCollection=widgetArgs);
				}


			}
			catch(Any e){
				widgetContent = "Error translating widget: #e.message# #e.detail#";
				log.error("Error translating widget on target: #targets[x]#", e);
			}

			// PROCESS REPLACING

			// get location of target
			var rLocation 	= builder.indexOf( targets[x] );
			var rLen 		= len( targets[x] );

			// Loop findings of same {{{}}} instances to replace
			while( rLocation gt -1 ){
				// Replace it
				builder.replace( rLocation, rLocation+rLen, widgetContent);
				// look again
				rLocation = builder.indexOf( targets[x], rLocation );
			}

		}
	}

}
