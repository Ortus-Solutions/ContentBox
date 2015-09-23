<cfoutput>
	<!--- ContentBoxEvent --->
	#cb.event("cbui_BeforeSideBar")#
	
	<div class="sidebar-nav">
		<ul>
			#cb.subPageMenu( page=cb.getCurrentPage(), type="li" )#
		</ul>
	</div>

	<!--- ContentBoxEvent --->
	#cb.event("cbui_afterSideBar")#
</cfoutput>