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
* Service to handle auhtor operations.
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" accessors="true" singleton{
	
	// User hashing type
	property name="hashType";
	
	/**
	* Constructor
	*/
	AuthorService function init(){
		// init it
		super.init(entityName="cbAuthor");
	    setHashType( "SHA-256" );
	    
		return this;
	}
	
	/**
	* Save an author with extra pizazz!
	*/
	function saveAuthor(author,passwordChange=false){
		// hash password if new author
		if( !arguments.author.isLoaded() OR arguments.passwordChange ){
			arguments.author.setPassword( hash(arguments.author.getPassword(), getHashType()) );
		}
		// save the author
		save( author );
	}
	
	/**
	* Author search by name, email or username
	*/
	function search(criteria){
		var params = {criteria="%#arguments.criteria#%"};
		var r = executeQuery(query="from cbAuthor where firstName like :criteria OR lastName like :criteria OR email like :criteria",params=params,asQuery=false);
		return r;
	}
	
	/**
	* Username checks for authors
	*/
	boolean function usernameFound(required username){
		var args = {"username" = arguments.username};
		return ( countWhere(argumentCollection=args) GT 0 );
	}

}