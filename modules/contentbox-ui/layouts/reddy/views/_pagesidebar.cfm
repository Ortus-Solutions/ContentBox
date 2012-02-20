<cfoutput>
<!--- ContentBoxEvent --->
#cb.event("cbui_BeforeSideBar")#

<!--- Page Navigation --->
<cfif cb.isPageView()>
<h2>#cb.linkToParentPage()# Sub Pages</h2>
<div class="bg"></div>
#cb.subPageMenu(type="ul")#
</cfif>

<!--- Search Form --->
<h2>Content Search</h2>
#cb.widget(name="SearchForm",args={label=""})#

<!--- Meta --->
#cb.widget("Meta")#

<br/>

<!--- ContentBoxEvent --->
#cb.event("cbui_afterSideBar")#
</cfoutput>