/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A content renderer that transforms ${setting} into the actual setting displayed
 * You can also prefix the markup with rc or prc to render from the request contexts as well:
 * ${rc:key} ${prc:key}
 *
 * You can escape this notation by surrounding them with our <escape></escape> tags
 */
component accessors="true" extends="BaseRenderer" {

	// DI
	property name="settingService" inject="settingService@contentbox";
	property name="cbResourceService" inject="resourceService@cbi18n";

	/**
	 * Execute on content translations for pages and blog entries
	 */
	void function cb_onContentRendering( required event, struct data = {} ){
		translateContent(
			builder = arguments.data.builder,
			content = arguments.data.content,
			event   = arguments.event
		);
	}

	/**
	 * Translate the content
	 *
	 * @builder java.lang.StringBuilder that contains all the content to manipulate
	 * @content The content object that requested translation
	 * @event   The ColdBox event
	 */
	private function translateContent(
		required builder,
		required content,
		required event
	){
		// Escape values for non-rendering
		multiStringReplace(
			builder     = arguments.builder,
			indexOf     = "<escape>${",
			replaceWith = "<escape>#encodeForHTML( "${" )#"
		);

		// our mustaches pattern
		var regex       = "(?!\<escape\>)\$\{([^\}])+\}(?!\<\/escape\>)";
		// match contentbox settings: ${setting} except surrounded by escape tags
		var targets     = reMatchNoCase( regex, builder.toString() );
		var targetLen   = arrayLen( targets );
		var thisSetting = "";
		var thisValue   = "";

		// Loop over found variables to build target + settings
		for ( var x = 1; x lte targetLen; x++ ) {
			try {
				// get the setting defined in ${}
				thisSetting = mid( targets[ x ], 3, len( targets[ x ] ) - 3 );

				// Do we have rc or prc prefix?
				if ( reFindNoCase( "^p?rc\:", thisSetting ) ) {
					thisValue = event.getValue(
						name    = listLast( thisSetting, ":" ),
						private = ( listFirst( thisSetting, ":" ) eq "rc" ? false : true )
					);
				}
				// Do we have i18n?
				else if ( reFindNoCase( "^i18n\:", thisSetting ) ) {
					var resource = listLast( thisSetting, ":" );
					var bundle   = "default";
					// check for resource@bundle convention:
					if ( find( "@", resource ) ) {
						bundle   = listLast( resource, "@" );
						resource = listFirst( resource, "@" );
					}
					thisValue = variables.cbResourceService.getResource( resource = resource, bundle = bundle );
				}
				// Normal Setting
				else {
					thisValue = settingService.getSetting(
						name         = thisSetting,
						defaultValue = "${Setting: #thisSetting# not found}"
					);
				}
			} catch ( Any e ) {
				thisValue = "Error translating setting on target #thisSetting#: #e.message# #e.detail#";
				log.error( "Error translating setting on target: #thisSetting#", e );
			}

			// PROCESS REPLACING
			multiStringReplace(
				builder     = arguments.builder,
				indexOf     = targets[ x ],
				replaceWith = thisValue
			);
		}
	}

}
