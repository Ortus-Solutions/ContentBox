<cfoutput>
<!--- BlogBoxEvent --->
#bb.event("bbui_BeforeSideBar")#

<!--- Page Navigation --->
<h2>#bb.linkToParentPage()# Sub Pages</h2>
<div class="bg"></div>
#bb.subPageMenu(type="ul")#

<br/>

<!--- BlogBoxEvent --->
#bb.event("bbui_afterSideBar")#
</cfoutput>