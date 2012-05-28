<cfoutput>
<!--- ContentBoxEvent --->
#cb.event("cbui_preIndexDisplay")#

<!--- SideBar --->
<div id="sidebar">#cb.quickView(view='_sidebar')#</div>

<!--- content --->
<div id="text" >
	
	<!--- Are we filtering by category? --->
	<cfif cb.categoryFilterExists()>
		<div class="buttonBar">
			<button class="button2" onclick="return to('#cb.linkHome()#')" title="Remove filter and view all entries">Remove Filter</button>
		</div>
		<div class="infoBar">
			Category Filtering: '#cb.getCategoryFilter()#'
		</div>
		<br/>
	</cfif>
	
	<!--- Are we searching --->
	<cfif cb.searchTermExists()>
		<div class="buttonBar">
			<button class="button2" onclick="return to('#cb.linkHome()#')" title="Clear search and view all entries">Clear Search</button>
		</div>
		<div class="infoBar">
			Searching by: '#cb.getSearchTerm()#'
		</div>
		<br/>
	</cfif>
	
	<!--- 
		Display Entries using ContentBox collection template rendering
		The default convention for the template is "entry.cfm" you can change it via the quickEntries() 'template' argument.
		I could have done it manually, but why?
	 --->
	#cb.quickEntries()#
	
	<!--- Paging via ContentBox via quick HTML, again I could have done it manually, but why? --->
	<div class="contentBar">#cb.quickPaging()#</div>
	
</div>
<!--- ContentBoxEvent --->
#cb.event("cbui_postIndexDisplay")#	
</cfoutput>