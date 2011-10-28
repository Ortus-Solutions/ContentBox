/**
* This widget creates a simple ContentBox search form
*/
component extends="contentbox.model.ui.BaseWidget" singleton{
	
	SearchForm function init(controller){
		// super init
		super.init(controller);
		
		// Widget Properties
		setPluginName("SearchForm");
		setPluginVersion("1.0");
		setPluginDescription("This widget creates a simple ContentBox search form");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("www.ortussolutions.com");
		setForgeBoxSlug("cbwidget-searchform");
		
		return this;
	}
	
	/**
	* This widget creates a simple ContentBox search form
	* @label The label to use, defaults to 'Search for:'
	* @title The title to show before the dropdown or list, defaults to H2
	* @titleLevel The H{level} to use, by default we use H2
	*/
	any function renderIt(label="Search for",title="",titleLevel="2"){
		var rString	= "";
		
		// generate recent comments
		saveContent variable="rString"{
			writeOutput('
			#html.startForm(name="searchForm",action=cb.linkSearch())#
				#html.textField(name="q",label=arguments.label)#
				#html.submitButton(name="searchSubmitButton",value="Search")#
			#html.endForm()#
			');
		}
		
		return rString;
	}
	
}
