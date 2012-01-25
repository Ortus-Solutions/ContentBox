/**
* Manage the system's email templates for admin purposes
*/
component accessors="true" singleton{
	
	// Dependecnies
	property name="moduleSettings"		inject="coldbox:setting:modules";
	property name="log"					inject="logbox:logger:{this}";
	
	// Local properties
	property name="templatesPath" type="string";
	
	EmailTemplateService function init(){
		templatesPath = '';
		return this;
	}
	
	/**
	* onDIComplete
	*/
	function onDIComplete(){
		setTemplatesPath( moduleSettings["contentbox"].path & "/views/email_templates" );
	}
	
	/**
	* Check if template exists
	*/
	boolean function templateExists(required string name){
		return fileExists( getTemplatesPath() & "/#arguments.name#" );
	}

	/**
	* Get template code
	*/
	string function getTemplateCode(required string name){
		var templatePath = getTemplatesPath() & "/#arguments.name#";
		return fileRead( templatePath );
	}
	
	/**
	* Save template code
	*/
	EmailTemplateService function saveTemplateCode(required string name, required string code){
		var templatePath = getTemplatesPath() & "/#arguments.name#";
		fileWrite( templatePath, arguments.code );
		return this;
	}
	
	/**
	* Get installed templates
	*/
	query function getTemplates(){
		var templates = directoryList(getTemplatesPath(),false,"query","*.cfm","name asc");
		return templates;
	}
	
}