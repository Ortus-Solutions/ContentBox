<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Actions
		</div>
		<div class="body">
		
			#html.startForm(name="apiForm")#
			#html.startFieldSet(legend="API Chooser: ")#
				<p>Select the API to view: </p>
				#html.select(name="apislug",options="Model,Plugins,Widgets",selectedValue=rc.apislug)#
			#html.endFieldSet()#
			#html.endform()#
		
			<div class="actionBar">
				<a href="#event.buildLink(prc.xehAPIDocs&"/index/apislug/#rc.apislug#/?_cfcviewer_package=#rc._cfcviewer_package#&print=true")#" target="_blank">
					<button name="print" class="button"><img src="#prc.cbRoot#/includes/images/print.png" alt="print" border="0"> Print</button>
				</a>
			</div>
			
		</div>
	</div>	
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column" id="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/help.png" alt="settings" />
			ContentBox API Docs
		</div>
		<!--- Body --->
		<div class="body">	
		
		<!--- messageBox --->
		#getPlugin("MessageBox").renderit()#
		
		<!--- Renderit --->
		#prc.cfcViewer.renderit()#
		</div>
	</div>
</div>		
</cfoutput>