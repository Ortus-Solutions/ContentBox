/**
* This widget creates a simple blogbox search form
*/
component extends="blogbox.model.ui.BaseWidget" singleton{
	
	SearchForm function init(controller){
		// super init
		super.init(controller);
		
		// Widget Properties
		setPluginName("SearchForm");
		setPluginVersion("1.0");
		setPluginDescription("This widget creates a simple blogbox search form");
		setPluginAuthor("Luis Majano");
		setPluginAuthorURL("www.ortussolutions.com");
		setForgeBoxSlug("bbwidget-searchform");
		
		return this;
	}
	
	/**
	* This widget creates a simple blogbox search form
	* @label The label to use, defaults to 'Search for:'
	* @title The title to show before the dropdown or list, defaults to H2
	* @titleLevel The H{level} to use, by default we use H2
	*/
	any function renderIt(label="Search for",title="",titleLevel="2"){
		var rString	= "";
		
		// generate recent comments
		saveContent variable="rString"{
			writeOutput('
			#html.startForm(name="searchForm",action=bb.linkSearch())#
				#html.textField(name="q",label=arguments.label)#
				#html.submitButton(name="searchSubmitButton",value="Search")#
			#html.endForm()#
			');
		}
		
		return rString;
	}
	
}
