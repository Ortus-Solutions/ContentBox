<cfoutput>
<!--- BlogBoxEvent --->
#bb.event("bbui_BeforeSideBar")#

<!--- Page Navigation --->
<h2>Sub Pages</h2>
#bb.subPageMenu(type="ul")#

<br/>

<!--- BlogBoxEvent --->
#bb.event("bbui_afterSideBar")#
</cfoutput>