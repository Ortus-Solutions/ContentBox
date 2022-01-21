/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A widget that executes any internal ColdBox event and return its results
 */
component extends="contentbox.models.ui.BaseWidget" singleton {

	Viewlet function init(){
		// Widget Properties
		setName( "Viewlet" );
		setVersion( "1.0" );
		setDescription( "A widget that executes any internal ColdBox event and return its results" );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "https://www.ortussolutions.com" );
		setCategory( "ColdBox" );
		setIcon( "file-text" );

		return this;
	}

	/**
	 * Execute an internal coldbox event viewlet
	 *
	 * @event.hint      The ColdBox event to execute
	 * @private.hint    Private event or not
	 * @args.hint       Event arguments to pass to the viewlet execution, this should be a comma delimitted list of name value pairs. Ex: widget=true,name=Test
	 * @title.hint      The title to show before the dropdown or list, defaults to H2
	 * @titleLevel.hint The H{level} to use, by default we use H2
	 */
	any function renderIt(
		required string event,
		boolean private   = false,
		string args       = "",
		string title      = "",
		string titleLevel = "2"
	){
		var rString        = "";
		var eventArguments = {};

		// Inflate args
		if ( len( arguments.args ) ) {
			var aString = listToArray( arguments.args, "," );
			for ( var key in aString ) {
				eventArguments[ listFirst( key, "=" ) ] = getToken( key, 2, "=" );
			}
		}

		// generate recent comments
		saveContent variable="rString" {
			// title
			if ( len( arguments.title ) ) {
				writeOutput(
					"<h#arguments.titlelevel#>#arguments.title#</h#arguments.titlelevel#>
"
				);
			}
			// execute it
			try {
				writeOutput(
					runEvent(
						event          = arguments.event,
						eventArguments = eventArguments,
						private        = arguments.private
					)
				);
			} catch ( Any e ) {
				writeOutput( "Error executing viewlet: #arguments.event#(#arguments.args.toString()#). #e.message#" );
				log.error( "Error executing viewlet: #arguments.event#(#arguments.args.toString()#)", e );
			}
		}

		return rString;
	}

}
