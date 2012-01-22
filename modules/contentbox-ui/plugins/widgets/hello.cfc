/**
* Say hello widget
*/
component extends="contentbox.model.ui.BaseWidget"{
	
	function init(controller){
		// super init
		super.init(controller);
		
		// Widget Properties
		setPluginName("hello");
		setPluginVersion("1.0");
		setPluginDescription("Say hello widget");
		setPluginAuthor("Luis Majano");
		setPluginAuthorURL("http://luismajano.com");
		//setForgeBoxSlug("");
		
		return this;
	}
	
	/**
	* Render the widget out
	*/
	any function renderIt(){
		return "I am a cool widget";
	}
	
}
