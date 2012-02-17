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
The official ContentBox Search Results Object
*/
component accessors="true"{

	property name="results" 		type="any" 		hint="The search results in query or array or whatever format";
	property name="total"			type="numeric"  hint="The total number of records found";
	property name="searchTime"  	type="numeric" 	hint="The amount of time it took for the search in milliseconds";
	property name="searchTerm"  	type="string" 	hint="The search term used";
	property name="error"			type="boolean"	hint="Mark if the search results produce an error or not";
	property name="errorMessages" 	type="array" 	hint="An array of error messagse if any";
	property name="metadata"		type="struct"	hint="Any metadata structure you wish to store";
	
	SearchResults function init(){
		results = [];
		searchTime = 0;
		total = 0;
		metadata = {};
		error = false;
		errorMessages = [];
		searchTerm = "";
		
		return this;
	}
	
	SearchResults function populate(required struct memento){
		for(var key in memento){
			if( structKeyExists(variables,key) ){
				variables[key] = memento[key];
			}
		}
		return this;
	}
	
	struct function getMemento(){
		var r = {
			results = results,
			searchTime = searchTime,
			total = total,
			metadata = metadata,
			error = error,
			errorMessages = errorMessages,
			searchTerm = searchTerm
		};
		return r;
	}
}