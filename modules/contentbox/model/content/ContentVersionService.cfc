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
* Content version services
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{

	/**
	* Constructor
	*/
	ContentVersionService function init(){
		// init it
		super.init(entityName="cbContentVersion");

		return this;
	}

	struct function findRelatedVersions(required contentID,max=0, offset=0, asQuery=false){
		var results = {};

		// Find it
		var c = newCriteria()
			.isEq("relatedContent.contentID", javaCast("int",arguments.contentID));

		// run criteria query and projections count
		results.count 		= c.count();
		results.versions 	= c.list(offset=arguments.offset,max=arguments.max,sortOrder="version DESC",asQuery=false);

		return results;
	}



}