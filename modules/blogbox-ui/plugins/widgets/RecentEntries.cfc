/**
* A cool basic widget that shows N recent entries
*/
component extends="blogbox.model.ui.BaseWidget" singleton{
	
	RecentEntries function init(controller){
		// super init
		super.init(controller);
		
		// Widget Properties
		setPluginName("RecentEntries");
		setPluginVersion("1.0");
		setPluginDescription("A cool basic widget that shows N recent entries");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("www.ortussolutions.com");
		setForgeBoxSlug("bbwidget-recententries");
		
		return this;
	}
	
	/**
	* Show n recent entries
	* @max The number of recent comments to show. By default it shows 5
	* @title An optional title to display using an H2 tag.
	* @titleLevel The H{level} to use, by default we use H2
	* @category The category slug to filter on
	* @searchTerm The search term to filter on
	*/
	any function renderIt(numeric max=5,title="",titleLevel="2",category="",searchTerm=""){
		var event 			= getRequestContext();
		var bbSettings 		= event.getValue(name="bbSettings",private=true);
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
				writeOutput('<li class="recentEntries"><a href="#bb.linkEntry(entryResults.entries[x])#">#entryResults.entries[x].getTitle()#</a></li>');
			}
			// close ul
			writeOutput("</ul>");
		}
		
		return rString;
	}
	
}
