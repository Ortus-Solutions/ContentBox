<cfoutput>
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
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

	<!--- main sidebar --->
	<div class="span3" id="main-sidebar">
		<div class="small_box">
			<div class="header">
				<i class="icon-cogs"></i> Actions
			</div>
			<div class="body">
			
				#html.startForm(name="apiForm")#
				#html.startFieldSet(legend="API Chooser: ")#
					<p>Select the API to view: </p>
					#html.select(name="apislug",options="Model,Plugins,Widgets",selectedValue=rc.apislug, class="input-block-level")#
				#html.endFieldSet()#
				#html.endform()#
			
				<div class="actionBar">
					<a href="#event.buildLink(prc.xehAPIDocs&"/index/apislug/#rc.apislug#/?_cfcviewer_package=#rc._cfcviewer_package#&print=true")#" target="_blank">
						<button name="print" class="btn"><i class="icon-print icon-large"></i> Print</button>
					</a>
				</div>
				
			</div>
		</div>	
	</div>
</div>
</cfoutput>