<cfoutput>
<!--- ContentBoxEvent --->
#cb.event("cbui_BeforeSideBar")#

<h2>#cb.siteName()#</h2>
<div class="bg"></div>
<p>#cb.siteDescription()#</p>
<br/>

<!--- Page Navigation --->
<cfif cb.isPageView() AND cb.getCurrentPage().getNumberOfChildren()>
<h2>Sub Pages</h2>
<div class="bg"></div>
#cb.subPageMenu(page=cb.getCurrentPage(),type="ul")#
<br/>
</cfif>

<!--- Meta --->
#cb.widget("Meta",{titleLevel="2"})#

<br/>
<h2>Recent Pages</h2>
<div class="bg"></div>
#cb.widget('RecentPages')#
<br/>

<h2>Content Search</h2>
<div class="bg"></div>
#cb.widget("SearchForm",{label=""})#
<br/>

<!--- ContentBoxEvent --->
#cb.event("cbui_afterSideBar")#
</cfoutput>