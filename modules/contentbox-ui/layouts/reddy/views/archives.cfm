<cfoutput>
<!--- ContentBoxEvent --->
#cb.event("cbui_preArchivesDisplay")#

<!--- SideBar --->
<div id="sidebar">#cb.quickView(view='sidebar')#</div>

<!--- content --->
<div id="text" >
	
	<!--- Title --->
	<h2>Blog Archives - #prc.entriesCount# Record(s)</h2>
	
	<!--- Archives --->
	<cfif rc.year NEQ 0>
		<div class="buttonBar">
			<button class="button2" onclick="return to('#cb.linkHome()#')" title="Remove filter and view all entries">Remove Filter</button>
		</div>
		<div class="infoBar">
			Year: '#rc.year#'
			<cfif rc.month NEQ 0>- Month: '#rc.month#'</cfif>
			<cfif rc.day NEQ 0>- Day: '#rc.day#'</cfif>
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
	
</div>
<!--- ContentBoxEvent --->
#cb.event("cbui_postArchivesDisplay")#	
</cfoutput>