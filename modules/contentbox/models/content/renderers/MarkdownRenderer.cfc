/**
 * Copyright 2009 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
 * ---
 * This interceptor listens to ContentBox content renderings and it will
 * translate content within ContentBox from Markdown to HTML
 *
 * @author Luis Majano
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="cb" inject="id:CBHelper@contentbox";
	property name="markdown" inject="Processor@cbmarkdown";

	// MARKUP EDITOR
	variables.MARKDOWN_EDITOR = "Markdown";

	/**
	 * Execute on content translations for pages and blog entries
	 */
	void function cb_onContentRendering( any event, struct data ){
		// If no markup, then maybe a direct convent version conversion.
		if ( !structKeyExists( arguments.data.content, "getMarkup" ) ) {
			return;
		}
		var thisMarkup = arguments.data.content.getMarkup();

		// Markdown
		if ( !isNull( thisMarkup ) and thisMarkup eq variables.MARKDOWN_EDITOR ) {
			// convert markup to HTML
			var results = variables.markdown.toHTML( arguments.data.builder.toString() );
			// Replace builder with new content
			arguments.data.builder.replace(
				javacast( "int", 0 ),
				arguments.data.builder.length(),
				results
			);
		} else if ( log.canDebug() ) {
			log.debug( "Skipping Markdown translation as content markup is #arguments.data.content.getMarkup()#" );
		}
	}

}
