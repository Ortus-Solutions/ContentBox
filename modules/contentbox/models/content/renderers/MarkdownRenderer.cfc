/**
* Copyright 2009 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
* ---
* @author Luis Majano
* This interceptor listens to ContentBox content renderings and it will
* translate content within ContentBox from Markdown to HTML
*/
component extends="coldbox.system.Interceptor"{

	// DI
	property name="cb" 			inject="id:CBHelper@cb";
	property name="markdown"	inject="Processor@cbmarkdown";
	
	// MARKUP EDITOR
	MARKDOWN_EDITOR = "Markdown";
	
	/**
	* Execute on content translations for pages and blog entries
	*/
	void function cb_onContentRendering( any event, struct interceptData ){
		// If no markup, then maybe a direct convent version conversion.
		if( !structKeyExists( arguments.interceptData.content, "getMarkup" ) ){
			return;
		}
		var thisMarkup = arguments.interceptData.content.getMarkup() ;

		// Markdown 
		if( thisMarkup eq MARKDOWN_EDITOR ){
			// convert markup to HTML
			var results = variables.markdown.toHTML( arguments.interceptData.builder.toString() );
			// Replace builder with new content
			arguments.interceptData.builder.replace( javaCast( "int", 0 ), arguments.interceptData.builder.length(), results );
		} else if( log.canDebug() ){
			log.debug( "Skipping Markdown translation as content markup is #arguments.interceptData.content.getMarkup()#");
		}
	}
	
}