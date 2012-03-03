/**
* A proxy to our ContentBox Helper Object
*/
component extends="contentbox.model.ui.BaseWidget" singleton{

	cb function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setPluginName("CBHelper");
		setPluginVersion("1.0");
		setPluginDescription("A proxy to our CBHelper object");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("www.ortussolutions.com");

		return this;
	}

	/**
	* Shows the CB Helper Motto
	*/
	any function renderIt(){
		return "CBHelper Rocks!";
	}

	/**
	* Proxy into the CB Helper
	*/
	any function onMissingMethod(missingMethodName,missingMethodArguments){
		return evaluate("variables.cb.#missingMethodName#(argumentCollection=arguments.missingMethodArguments)");
	}


}
