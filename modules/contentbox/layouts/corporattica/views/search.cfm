﻿<cfoutput>

	<!--- ContentBoxEvent --->
	#cb.event("cbui_prePageDisplay")#

	<!--- top gap --->
	<div class="post-top-gap"></div>

	<!--- search Results --->
	<div>
		<h2>Search Results</h2>

		<!--- Search Form --->
		#html.startForm(name="searchForm",action=cb.linkContentSearch())#
			#html.textField(name="q",size="55",value=htmlEditFormat( cb.getSearchTerm() ))#
			#html.submitButton(name="searchSubmitButton",value="Search")#
		#html.endForm()#

		<br/>

		<!--- Search Results --->
		#cb.getSearchResultsContent()#

		<!--- Search paging --->
		#cb.quickSearchPaging()#
	</div>

	<!--- ContentBoxEvent --->
	#cb.event("cbui_postPageDisplay")#

</cfoutput>