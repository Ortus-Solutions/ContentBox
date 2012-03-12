<cfoutput>
	

	
<!--- Main Content Goes Here --->
<div class="span9">
	<!--- top gap --->
	<div class="post-top-gap"></div>
	
	<!--- ContentBoxEvent --->
	#cb.event("cbui_preIndexDisplay")#
	
	<!--- Are we filtering by category? --->
	<cfif len(rc.category)>
		<div class="buttonBar">
			<button class="button2" onclick="return to('#cb.linkHome()#')" title="Remove filter and view all entries">Remove Filter</button>
		</div>
		<div class="infoBar">
			Category Filtering: '#rc.category#'
		</div>
		<br/>
	</cfif>
	
	<!--- Are we searching --->
	<cfif len(rc.q)>
		<div class="buttonBar">
			<button class="button2" onclick="return to('#cb.linkHome()#')" title="Clear search and view all entries">Clear Search</button>
		</div>
		<div class="infoBar">
			Searching by: '#rc.q#'
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
	<cfif prc.entriesCount>
		<div class="contentBar">#cb.quickPaging()#</div>
	</cfif>
	
	<!--- ContentBoxEvent --->
	#cb.event("cbui_postIndexDisplay")#
	
</div> 

	<!--- SideBar: That's right, I can render any layout views by using quickView() or coldbo'x render methods --->
<div class="span3">
	<div class="well" style="padding-top: 8px; padding-right: 0px; padding-bottom: 8px; padding-left: 0px; ">
	#cb.quickView(view='sidebar')#
	</div> 	
</div> 	

<!--- Separator --->
<div class="clr"></div>
</cfoutput>