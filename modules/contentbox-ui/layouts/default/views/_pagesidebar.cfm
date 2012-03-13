<cfoutput>
<!--- ContentBoxEvent --->
#cb.event("cbui_BeforeSideBar")#

<!--- Page Navigation --->
<cfif cb.isPageView() AND cb.getCurrentPage().getNumberOfChildren()>
<h4>Sub Pages</h4>
<div class="bg"></div>
#cb.subPageMenu(page=cb.getCurrentPage(),type="ul")#
</cfif>

<h4>Description</h4>
<div class="bg"></div>
<p>#cb.siteDescription()#</p>

#cb.widget("Meta",{titleLevel="4"})#

<h4>Recent Pages</h4>
<div class="bg"></div>
#cb.widget('RecentPages')#

<h4>Content Search</h4>
<div class="bg"></div>
#cb.widget("SearchForm")#
<br/>

<!--- ContentBoxEvent --->
#cb.event("cbui_afterSideBar")#
</cfoutput>