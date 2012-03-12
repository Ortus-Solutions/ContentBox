<cfoutput>
<!--- ContentBoxEvent --->
#cb.event("cbui_BeforeSideBar")#

<!--- Page Navigation --->
<cfif prc.page.getNumberOfChildren()>
<li class="nav-header">Sub Pages</li>
<div class="bg"></div>
#cb.subPageMenu(page=prc.page.getParent(),type="ul")#
</cfif>

<h4>Description</h4>
<div class="bg"></div>
<p>#cb.siteDescription()#</p>

#cb.widget("Meta",{titleLevel="4"})#

<li class="nav-header">Recent Pages</li>
<div class="bg"></div>
#cb.widget('RecentPages')#


<li class="nav-header">Blog Entries Search</li>
<div class="bg"></div>
#cb.widget("SearchForm")#
<br/>

<!--- ContentBoxEvent --->
#cb.event("cbui_afterSideBar")#
</cfoutput>