<!---
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
*/
--->
<cfoutput>

	<!--- index top gap --->
	<div class="post-top-gap"></div>

	<!--- ContentBoxEvent --->
	#cb.event("cbui_preIndexDisplay")#

	<!--- Are we filtering by category? --->
	<cfif cb.categoryFilterExists()>
		<div class="buttonBar">
			<button class="button2" onclick="return to('#cb.linkBlog()#')" title="Remove filter and view all entries">Remove Filter</button>
		</div>
		<div class="infoBar">
			Category Filtering: '#cb.getCategoryFilter()#'
		</div>
		<br/>
	</cfif>

	<!--- Are we searching --->
	<cfif cb.searchTermExists()>
		<div class="buttonBar">
			<button class="button2" onclick="return to('#cb.linkBlog()#')" title="Clear search and view all entries">Clear Search</button>
		</div>
		<div class="infoBar">
			Searching by: '#cb.getSearchTerm()#'
		</div>
		<br/>
	</cfif>

	<!---
		Display Entries using ContentBox collection template rendering
		The default convention for the template is "templates/entry.cfm" you can change it via the quickEntries() 'template' argument.
		I could have done it manually, but why?
	 --->
	#cb.quickEntries()#

	<!--- Paging via ContentBox via quick HTML, again I could have done it manually, but why? --->
	<div class="contentBar">#cb.quickPaging()#</div>

	<!--- ContentBoxEvent --->
	#cb.event("cbui_postIndexDisplay")#

</cfoutput>