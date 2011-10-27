<cfoutput>
<!--- ContentBoxEvent --->
#cb.event("cbui_BeforeSideBar")#

<!--- Page Navigation --->
<h4>Sub Pages</h4>
<div class="bg"></div>
#cb.subPageMenu(type="ul")#

<h4>Description</h4>
<div class="bg"></div>
<p>#cb.siteDescription()#</p>

<h4>Recent Pages</h4>
<div class="bg"></div>
#cb.widget('RecentPages')#

<h4>Blog Entries Search</h4>
<div class="bg"></div>
#cb.widget("SearchForm")#
<br/>

<!--- ContentBoxEvent --->
#cb.event("cbui_afterSideBar")#
</cfoutput>