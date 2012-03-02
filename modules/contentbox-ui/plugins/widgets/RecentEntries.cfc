/**
* A cool basic widget that shows N recent entries
*/
component extends="contentbox.model.ui.BaseWidget" singleton{

	RecentEntries function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setPluginName("RecentEntries");
		setPluginVersion("1.0");
		setPluginDescription("A cool basic widget that shows N recent entries");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("www.ortussolutions.com");

		return this;
	}

	/**
	* Show n recent entries
	* @max.hint The number of recent comments to show. By default it shows 5
	* @title.hint An optional title to display using an H2 tag.
	* @titleLevel.hint The H{level} to use, by default we use H2
	* @category.hint The category slug to filter on
	* @searchTerm.hint The search term to filter on
	*/
	any function renderIt(numeric max=5,title="",string titleLevel="2",string category="",string searchTerm=""){
		var event 			= getRequestContext();
		var cbSettings 		= event.getValue(name="cbSettings",private=true);
		var entryResults 	= entryService.findPublishedEntries(max=arguments.max,
											   					category=arguments.category,
											   				 	searchTerm=arguments.searchTerm);
		var rString			= "";

		// iteration cap
		if( entryResults.count lt arguments.max){
			arguments.max = entryResults.count;
		}

		// generate recent comments
		saveContent variable="rString"{
			// title
			if( len(arguments.title) ){ writeOutput("<h#arguments.titleLevel#>#arguments.title#</h#arguments.titleLevel#>"); }
			// UL start
			writeOutput('<ul id="recentEntries">');
			// iterate and create
			for(var x=1; x lte arguments.max; x++){
				writeOutput('<li class="recentEntries"><a href="#cb.linkEntry(entryResults.entries[x])#">#entryResults.entries[x].getTitle()#</a></li>');
			}
			// close ul
			writeOutput("</ul>");
		}

		return rString;
	}

}
