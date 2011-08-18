<cfoutput>
<!--- BlogBoxEvent --->
#bb.event("bbui_BeforeSideBar")#

<!--- Search Form --->
<h2>Entry Search</h2>
#bb.widget("SearchForm")#

<h2>Recent Pages</h2>
<div class="bg"></div>
#bb.widget('RecentPages')#

<br/>

<!--- BlogBoxEvent --->
#bb.event("bbui_afterSideBar")#
</cfoutput>