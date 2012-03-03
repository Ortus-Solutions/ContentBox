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

		return this;
	}

	/**
	* This widget creates a simple ContentBox search form
	* @type.hint The type of search form: content or blog, default is content
	* @label.hint The label to use, defaults to 'Search for:'
	* @title.hint The title to show before the dropdown or list, defaults to H2
	* @titleLevel.hint The H{level} to use, by default we use H2
	*/
	any function renderIt(string type="content", string label="Search for",string title="",string titleLevel="2"){
		var rString	= "";

		// Check type
		if( !reFindNoCase("^(content|blog)$",arguments.type) ){
			throw(message="Invalid type for search form",detail="Valid types are: content or blog",type="InvalidSearchType");
		}
		// Action
		var action = cb.linkContentSearch();
		if( arguments.type eq "blog" ){
			action = cb.linkSearch();
		}

		// generate recent comments
		saveContent variable="rString"{
			writeOutput('
			#html.startForm(name="searchForm",action=action)#
				#html.textField(name="q",label=arguments.label)#
				#html.submitButton(name="searchSubmitButton",value="Search")#
			#html.endForm()#
			');
		}

		return rString;
	}

}
