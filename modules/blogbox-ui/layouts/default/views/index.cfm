<cfoutput>
<!--- Main Content Goes Here --->
<div class="left">
	<!--- top gap --->
	<div class="post-top-gap"></div>
	
	<!--- BlogBoxEvent --->
	#bb.event("bbui_preIndexDisplay")#
	
	<!--- Are we filtering by category? --->
	<cfif len(rc.category)>
		<div class="buttonBar">
			<button class="button2" onclick="return to('#bb.linkHome()#')" title="Remove filter and view all entries">Remove Filter</button>
		</div>
		<div class="infoBar">
			Category Filtering: '#rc.category#'
		</div>
		<br/>
	</cfif>
	
	<!--- Are we searching --->
	<cfif len(rc.q)>
		<div class="buttonBar">
			<button class="button2" onclick="return to('#bb.linkHome()#')" title="Clear search and view all entries">Clear Search</button>
		</div>
		<div class="infoBar">
			Searching by: '#rc.q#'
		</div>
		<br/>
	</cfif>
	
	<!--- 
		Display Entries using BlogBox collection template rendering
		The default convention for the template is "entry.cfm" you can change it via the quickEntries() 'template' argument.
		I could have done it manually, but why?
	 --->
	#bb.quickEntries()#
		
	<!--- Paging via BlogBox via quick HTML, again I could have done it manually, but why? --->
	<cfif prc.entriesCount>
		<div class="contentBar">#bb.quickPaging()#</div>
	</cfif>
	
	<!--- BlogBoxEvent --->
	#bb.event("bbui_postIndexDisplay")#
	
</div> 

<!--- SideBar: That's right, I can render any layout views by using quickView() or coldbo'x render methods --->
<div class="right">#bb.quickView(view='sidebar')#</div> 	

<!--- Separator --->
<div class="clr"></div>
</cfoutput>