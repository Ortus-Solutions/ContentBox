/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
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
