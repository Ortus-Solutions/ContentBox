﻿<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<div class="small_box">
		<div class="header">
			<i class="icon-cogs"></i> Actions
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
					<button name="print" class="button"><i class="icon-print icon-large"></i> Print</button>
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
			<i class="icon-book icon-large"></i>
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