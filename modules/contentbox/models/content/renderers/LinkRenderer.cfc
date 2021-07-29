/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A content renderer that transforms _page:XX_ and _entry:XX_ into page and entry links
 */
component accessors="true" extends="BaseRenderer" {

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
	 * Determine slug from incoming string
	 *
	 * @tagString The tag string
	 */
	private function determineSlug( required tagString ){
		var slug = reReplaceNoCase(
			arguments.tagString,
			"(page|entry|pagessl|entryssl)\:\[",
			""
		);
		return reReplaceNoCase( slug, "\]$", "" );
	}

	/**
	 * Translate content
	 *
	 * @builder java.lang.StringBuilder that contains all the content to manipulate
	 * @content The content object that requested translation
	 */
	private function translateContent( required builder, required content ){
		// our mustaches pattern
		var regex       = "(page|pagessl|entry|entryssl|root)\:\[[^\]]*]";
		// match contentbox links in our incoming builder and build our targets array and len
		var targets     = reMatchNoCase( regex, builder.toString() );
		var targetLen   = arrayLen( targets );
		var tagString   = "";
		var linkContent = "";

		// Loop over found links
		for ( var x = 1; x lte targetLen; x++ ) {
			tagString = targets[ x ];

			// convert quotes to standards
			tagString = replace( tagString, "&##34;", """", "all" );
			tagString = replace( tagString, "&##39;", "'", "all" );
			tagString = replace( tagString, "&quot;", "'", "all" );

			try {
				var linkType = getToken( tagString, 1, ":" );
				switch ( linkType ) {
					case "page": {
						linkContent = cb.linkPage( page = determineSlug( tagString ) );
						break;
					}
					case "pagessl": {
						linkContent = cb.linkPage( page = determineSlug( tagString ), ssl = true );
						break;
					}
					case "entry": {
						linkContent = cb.linkEntry( entry = determineSlug( tagString ) );
						break;
					}
					case "entryssl": {
						linkContent = cb.linkEntry( entry = determineSlug( tagString ), ssl = true );
						break;
					}
					case "root": {
						linkContent = cb.themeRoot();
						break;
					}
				}
			} catch ( Any e ) {
				linkContent = "Error translating link: #e.message# #e.detail#";
				log.error( "Error translating link on target: #targets[ x ]#", e );
			}

			// PROCESS REPLACING
			multiStringReplace(
				builder     = arguments.builder,
				indexOf     = targets[ x ],
				replaceWith = linkContent
			);
		}
	}

}
