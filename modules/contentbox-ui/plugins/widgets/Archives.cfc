/**
* A cool basic widget that shows our blog archives
*/
component extends="contentbox.model.ui.BaseWidget" singleton{

	Archives function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setPluginName("Archives");
		setPluginVersion("1.0");
		setPluginDescription("A cool basic widget that shows our blog archives");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("www.ortussolutions.com");

		return this;
	}

	/**
	* Show the blog archives
	* @dropdown.hint Display as a dropdown or a list, default is list
	* @showPostCount.hint Show post counts or not, default is true
	* @title.hint The title to show before the dropdown or list, defaults to H2
	* @titleLevel.hint The H{level} to use, by default we use H2
	*/
	any function renderIt(boolean dropdown=false,boolean showPostCount=true,string title="",string titleLevel="2"){
		var archives 		= entryService.getArchiveReport();
		var rString			= "";

		saveContent variable="rString"{
			// title
			if( len(arguments.title) ){ writeOutput("<h#arguments.titleLevel#>#arguments.title#</h#arguments.titleLevel#>"); }
			// Build Type
			if( arguments.dropdown ){
				writeoutput(buildDropDown(archives,arguments.showPostCount));
			}
			else{
				writeoutput(buildList(archives,arguments.showPostCount));
			}
		}

		return rString;
	}

	private function buildDropDown(archives,showPostCount){
		var rString = "";

		saveContent variable="rString"{
			writeOutput('<select name="archives" id="archives" onchange="window.location=this.value")><option value="##">Select Archive</option>');
			// iterate and create
			for(var x=1; x lte arrayLen( arguments.archives ); x++){
				var thisDate = arguments.archives[x]["year"] & "-" & arguments.archives[x]["month"] & "-1";
				writeOutput('<option value="#cb.linkArchive(year=arguments.archives[x]['year'],month=arguments.archives[x]['month'])#">#dateformat(thisDate,"mmmm yyyy")#');
				if( arguments.showPostCount ){ writeOutput(" (#arguments.archives[x]['count']#)"); }
				writeOutput('</option>');
			}
			// close ul
			writeOutput("</select>");
		}
		return rString;
	}

	private function buildList(archives,showPostCount){
		var rString = "";

		saveContent variable="rString"{
			writeOutput('<ul id="archives">');
			// iterate and create
			for(var x=1; x lte arrayLen( arguments.archives ); x++){
				var thisDate = arguments.archives[x]["year"] & "-" & arguments.archives[x]["month"] & "-1";
				writeOutput('<li class="archives"><a href="#cb.linkArchive(year=arguments.archives[x]['year'],month=arguments.archives[x]['month'])#">#dateFormat(thisDate,"mmmm yyyy")#');
				if( arguments.showPostCount ){ writeOutput(" (#arguments.archives[x]['count']#)"); }
				writeOutput('</a></li>');
			}
			// close ul
			writeOutput("</ul>");
		}
		return rString;
	}

}
