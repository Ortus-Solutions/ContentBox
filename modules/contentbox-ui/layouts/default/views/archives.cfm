<cfoutput>
<!--- top gap --->
<div class="post-top-gap"></div>

<!--- ContentBoxEvent --->
#cb.event("cbui_preArchivesDisplay")#

<!--- Title --->
<h1>Blog Archives - #cb.getCurrentEntriesCount()# Record(s)</h1>

<!--- Archives --->
<cfif cb.getYearFilter() NEQ 0>
	<div class="buttonBar">
		<button class="button2" onclick="return to('#cb.linkHome()#')" title="Remove filter and view all entries">Remove Filter</button>
	</div>
	<div class="infoBar">
		Year: '#cb.getYearFilter()#'
		<cfif cb.getMonthFilter() NEQ 0>- Month: '#cb.getMonthFilter()#'</cfif>
		<cfif cb.getDayFilter() NEQ 0>- Day: '#cb.getMonthFilter()#'</cfif>
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

<!--- ContentBoxEvent --->
#cb.event("cbui_postArchivesDisplay")#
</cfoutput>