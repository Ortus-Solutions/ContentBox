<cfoutput>
<!--- BlogBoxEvent --->
#bb.event("bbui_BeforeSideBar")#

<!--- Page Navigation --->
<h4>Sub Pages</h4>
<div class="bg"></div>
#bb.subPageMenu(type="ul")#

<h4>Description</h4>
<div class="bg"></div>
<p>#bb.siteDescription()#</p>

<h4>Recent Pages</h4>
<div class="bg"></div>
#bb.widget('RecentPages')#

<h4>Blog Entries Search</h4>
<div class="bg"></div>
#bb.widget("SearchForm")#
<br/>

<!--- BlogBoxEvent --->
#bb.event("bbui_afterSideBar")#
</cfoutput>