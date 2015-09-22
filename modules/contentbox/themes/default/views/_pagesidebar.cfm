<cfoutput>
<!--- ContentBoxEvent --->
#cb.event("cbui_BeforeSideBar")#

	<div class="sidebar-nav">
		<ul>
			#cb.subPageMenu(page=prc.page.getParent(),type="li")#
		</ul>
	</div>

<!--- ContentBoxEvent --->
#cb.event("cbui_afterSideBar")#
</cfoutput>