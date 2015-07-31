/**
* A widget that executes the ColdBox MessageBox Plugin to render something out.
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	MessageBox function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setPluginName("MessageBox");
		setPluginVersion("1.0");
		setPluginDescription("A widget that executes the ColdBox MessageBox Plugin to render a nice UI messagebox for info, warning or error messages.");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("http://www.ortussolutions.com");
		setCategory( "ColdBox" );
		setIcon( "question.png" );
		return this;
	}

	/**
	* Execute a MessageBox render message to display awesome ColdBox MessageBoxes
	* @type.hint The MessageBox type to render: info, warning, error
	* @message.hint The message to render
	*/
	any function renderIt(required string type="info",required string message){
		return getPlugin("MessageBox").renderMessage(argumentCollection=arguments);
	}

}
