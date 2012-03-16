/**
* A cool basic widget that shows our blog categories
*/
component extends="contentbox.model.ui.BaseWidget" singleton{

	Categories function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setPluginName("Categories");
		setPluginVersion("1.0");
		setPluginDescription("A cool basic widget that shows our blog categories");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("www.ortussolutions.com");

		return this;
	}

	/**
	* Show the blog categories
	* @dropdown.hint Display as a dropdown or a list, default is list
	* @showPostCount.hint Show post counts or not, default is true
	* @title.hint The title to show before the dropdown or list, defaults to H2
	* @titleLevel.hint The H{level} to use, by default we use H2
	*/
	any function renderIt(boolean dropdown=false,boolean showPostCount=true,string title="",string titleLevel="2"){
		var categories 		= categoryService.list(sortOrder="category",asQuery=false);
		var rString			= "";

		// generate recent comments
		saveContent variable="rString"{
			// title
			if( len(arguments.title) ){ writeOutput("<h#arguments.titleLevel#>#arguments.title#</h#arguments.titleLevel#>"); }
			// Build Type
			if( arguments.dropdown ){
				writeoutput(buildDropDown(categories,arguments.showPostCount));
			}
			else{
				writeoutput(buildList(categories,arguments.showPostCount));
			}
		}

		return rString;
	}

	private function buildDropDown(categories,showPostCount){
		var rString = "";
		// generate recent comments
		saveContent variable="rString"{
			writeOutput('<select name="categories" id="categories" onchange="window.location=this.value")><option value="##">Select Category</option>');
			// iterate and create
			for(var x=1; x lte arrayLen( arguments.categories ); x++){
				writeOutput('<option value="#cb.linkCategory(arguments.categories[x])#">#arguments.categories[x].getCategory()#');
				if( arguments.showPostCount ){ writeOutput(" (#arguments.categories[x].getNumberOfEntries()#)"); }
				writeOutput('</option>');
			}
			// close ul
			writeOutput("</select>");
		}
		return rString;
	}

	private function buildList(categories,showPostCount){
		var rString = "";
		// generate recent comments
		saveContent variable="rString"{
			writeOutput('<ul id="categories">');
			// iterate and create
			for(var x=1; x lte arrayLen( arguments.categories ); x++){
				writeOutput('<li class="categories"><a href="#cb.linkCategory(arguments.categories[x])#">#arguments.categories[x].getCategory()#');
				if( arguments.showPostCount ){ writeOutput(" (#arguments.categories[x].getNumberOfEntries()#)"); }
				writeOutput('</a></li>');
			}
			// close ul
			writeOutput("</ul>");
		}
		return rString;
	}

}
