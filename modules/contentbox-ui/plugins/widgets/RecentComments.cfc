/**
* A cool basic widget that shows N recent comments
*/
component extends="contentbox.model.ui.BaseWidget" singleton{

	RecentComments function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setPluginName("RecentComments");
		setPluginVersion("1.0");
		setPluginDescription("A cool basic widget that shows N recent comments");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("www.ortussolutions.com");

		return this;
	}

	/**
	* Show n recent comments
	* @ma.hint The number of recent comments to show. By default it shows 5
	* @maxChars.hint The maximum character length to show for comment contents
	* @title.hint An optional title to display using an H2 tag.
	* @titleLevel.hint The H{level} to use, by default we use H2
	*/
	any function renderIt(numeric max=5,numeric maxChars=80,string title="",string titleLevel="2"){
		var event 			= getRequestContext();
		var cbSettings 		= event.getValue(name="cbSettings",private=true);
		var commentResults 	= commentService.findApprovedComments(max=arguments.max);
		var rString			= "";

		// iteration cap
		if( commentResults.count lt arguments.max){
			arguments.max = commentResults.count;
		}

		// generate recent comments
		saveContent variable="rString"{
			// title
			if( len(arguments.title) ){ writeOutput("<h#arguments.titleLevel#>#arguments.title#</h#arguments.titleLevel#>"); }
			// UL start
			writeOutput('<ul id="recentComments">');
			// iterate and create
			for(var x=1; x lte arguments.max; x++){
				writeOutput('<li class="recentComments">#commentResults.comments[x].getAuthor()# said
				<a href="#cb.linkComment(commentResults.comments[x])#">#left(commentResults.comments[x].getContent(),arguments.maxChars)#</a></li>');
			}
			// close ul
			writeOutput("</ul>");
		}

		return rString;
	}

}
