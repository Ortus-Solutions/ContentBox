<cfoutput>
<!--- ContentBoxEvent --->
#cb.event("cbui_BeforeSideBar")#

<!--- Page Navigation --->
<h2>#cb.linkToParentPage()# Sub Pages</h2>
<div class="bg"></div>
#cb.subPageMenu(type="ul")#

<br/>

<!--- ContentBoxEvent --->
#cb.event("cbui_afterSideBar")#
</cfoutput>