<cfoutput>
<!--- ContentBoxEvent --->
#cb.event("cbui_BeforeSideBar")#

<div class="news">
	<h4>#cb.siteName()#</h4>
	<div class="bg"></div>
	<p>#cb.siteDescription()#</p>
	<br/>
</div>

<!--- Page Navigation --->
<cfif cb.isPageView() AND cb.getCurrentPage().getNumberOfChildren()>
<div class="news">
<h4>Sub Pages</h4>
<div class="bg"></div>
#cb.subPageMenu(page=cb.getCurrentPage(),type="ul")#
</div>
</cfif>

<div class="news">
<h4>Content Search</h4>
<div class="bg"></div>
#cb.widget("SearchForm",{label=""})#
<br/>
</div>

<!--- ContentBoxEvent --->
#cb.event("cbui_afterSideBar")#
</cfoutput>