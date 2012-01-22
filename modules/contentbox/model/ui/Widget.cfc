/**
* I represent a new widget to be created in the ContentBox System
*/
component accessors="true"{
	
	property name="name";
	property name="version";
	property name="description";
	property name="author";
	property name="authorURL";
	
	Widget function init(){
		name = '';
		version = '';
		description='';
		author='';
		authorURL='';
		return this;
	}
	
	/*
	* Validate entry, returns an array of error or no messages
	*/
	array function validate(){
		var errors = [];
		var aRequired = listToArray("name,version,description,author,authorURL");
		
		// Required
		for(var field in aRequired){
			if( !len(variables[field]) ){ arrayAppend(errors, "#field# is required"); }
		}
		
		return errors;
	}
	
}
