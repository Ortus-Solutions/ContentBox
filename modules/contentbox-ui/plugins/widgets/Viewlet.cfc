/**
* A widget that executes any internal ColdBox event and return its results
*/
component extends="contentbox.model.ui.BaseWidget" singleton{

	Viewlet function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setPluginName("Viewlet");
		setPluginVersion("1.0");
		setPluginDescription("A widget that executes any internal ColdBox event and return its results");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("www.ortussolutions.com");

		return this;
	}

	/**
	* Execute an internal coldbox event viewlet
	* @event.hint The ColdBox event to execute
	* @private.hint Private event or not
	* @args.hint Event arguments to pass to the viewlet execution
	* @title.hint The title to show before the dropdown or list, defaults to H2
	* @titleLevel.hint The H{level} to use, by default we use H2
	*/
	any function renderIt(required string event,boolean private=false,struct args=structnew(),string title="",string titleLevel="2"){
		var rString			= "";

		// generate recent comments
		saveContent variable="rString"{
			// title
			if( len(arguments.title) ){ writeOutput("<h#arguments.titleLevel#>#arguments.title#</h#arguments.titleLevel#>"); }
			// execute it
			try{
				writeOutput( runEvent(event=arguments.event,eventArguments=arguments.args,private=arguments.private) );
			}
			catch(Any e){
				writeOutput("Error executing viewlet: #arguments.event#(#arguments.args.toString()#). #e.message#");
				log.error("Error executing viewlet: #arguments.event#(#arguments.args.toString()#)",e);
			}
		}

		return rString;
	}

}
