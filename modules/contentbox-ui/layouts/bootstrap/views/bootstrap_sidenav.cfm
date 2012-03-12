<cfoutput>
<!--- ContentBoxEvent --->
#cb.event("cbui_BeforeSideBar")#

<!--- Option 1 --->
	<ul class="nav nav-tabs nav-stacked">
		#cb.subPageMenu(page=prc.page.getParent(),type="li")#
	</ul>


<!--- Option 2 --->
<!---<div class="well sidebar-nav">
	<!--- Page Navigation --->
    <ul class="nav nav-list">
      <!---<cfif prc.page.getNumberOfChildren()>---><li class="nav-header">Sub-Menu</li><!---</cfif>--->
	  #cb.subPageMenu(page=prc.page.getParent(),type="li")#
    </ul>
</div>--->
  
<!--- ContentBoxEvent --->
#cb.event("cbui_afterSideBar")#
</cfoutput>