<cfoutput>
<div class="row">
	<div class="col-md-12">
		<h1 class="h1"><i class="fa fa-bolt"></i> #$r( "autoUpdates.title@admin" )#</h1>
	</div>
</div>
<div class="row">
	<div class="col-md-8">
		<div class="panel panel-default">
			<div class="panel-body">
				#getModel( "messagebox@cbMessagebox" ).renderit()#
				
				<p>#$r( "autoUpdates.body@admin" )#</p>
				<!---Begin Accordion--->
				<div id="accordion" class="panel-group accordion">
					<!---Begin Check--->
					<div class="panel panel-default">
						<div class="panel-heading">
							<a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##check">
								<i class="fa fa-globe fa-lg"></i> #$r( "autoUpdates.checkUpdates.head@admin" )#
							</a>
						</div>
						<div id="check" class="panel-collapse collapse in">
							<div class="panel-body">
								
								<!--- Update Form --->
								#html.startForm( name="updateCheckForm", novalidate="novalidate" )#

									<p>#$r( "autoUpdates.checkUpdates.info@admin" )#</p>
									
									#html.radioButton(
										name    = "channel",
										id      = "stable",
										value   = prc.updateSlugStable,
										checked = "false",
										checked = true
									)#
									<label for="stable" class="inline">#$r( "autoUpdates.checkUpdates.stable.title@admin" )#</label> : #$r( "autoUpdates.checkUpdates.stable.info@admin" )#
									<br/>
									
									#html.radioButton(
										name 	= "channel",
										id 		= "beta",
										value 	= prc.updateSlugBeta,
										checked = "false" 
									)#
									<label for="beta" class="inline">#$r( "autoUpdates.checkUpdates.bleeding.title@admin" )#</label> : #$r( "autoUpdates.checkUpdates.bleeding.info@admin" )#
									
									<p>&nbsp;</p>
									
									#html.button(
										name 	= "btnUpdates",
										value 	= $r( "autoUpdates.checkUpdates.button@admin" ),
										class 	= "btn btn-danger",
										onclick = "return checkForUpdates()"
									)#
								#html.endForm()#    
							</div>
						</div>
					</div>
					<!---End Check--->
					
					<!---Begin Download--->
					<div class="panel panel-default">
						<div class="panel-heading">
							<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##download">
								<i class="fa fa-download fa-lg"></i> #$r( "autoUpdates.downloadUpdate.title@admin" )#
							</a>
						</div>
						<div id="download" class="panel-collapse collapse">
							<div class="panel-body">
								<!--- Update Form --->
								#html.startForm(
									name="updateNowForm",
									action=prc.xehInstallUpdate,
									novalidate="novalidate",
									class="form-vertical"
								)#

									<p>
										#$r( "autoUpdates.downloadUpdate.info@admin" )#
										<a href="https://www.ortussolutions.com/products/contentbox##tab_patches" target="_blank">https://www.ortussolutions.com/products/contentbox##tab_patches</a>
									</p>
									
									#html.inputfield(
										type="url",
										required="required",
										name="downloadURL",
										label="Download URL:", 
										class="form-control",
										size="75",
										wrapper="div class=controls",
										labelClass="control-label",
										groupWrapper="div class=form-group"
									)#
									#html.submitButton( value=$r( "autoUpdates.downloadUpdate.button@admin" ), class="btn btn-danger" )#
								#html.endForm()#    
							</div>
						</div>
					</div>
					<!---End Download--->
						
					<!---Begin Upload--->
					<div class="panel panel-default">
						<div class="panel-heading">
							<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##upload">
								<i class="fa fa-upload fa-lg"></i> #$r( "autoUpdates.uploadUpdate.title@admin" )#
							</a>
						</div>
						<div id="upload" class="panel-collapse collapse">
							<div class="panel-body">
								<!--- Upload Form --->
								#html.startForm(
									name="uploadNowForm",
									action=prc.xehUploadUpdate,
									multipart=true,
									novalidate="novalidate",
									class="form-vertical"
								)#
									<p>#$r( "autoUpdates.uploadUpdate.info@admin" )#</p>
									#getModel( "BootstrapFileUpload@contentbox-admin" ).renderIt( 
										name    = "filePatch", 
										label   = "Upload Patch:",
										required= true
									)#
									#html.submitButton(value="#$r( "autoUpdates.uploadUpdate.button@admin" )#",class="btn btn-danger" )#
								#html.endForm()#    
							</div>
						</div>
					</div>
					<!---End Check--->
				</div>
				<!---End Accordion--->  
				
				<!--- Logs --->
				<cfif len(prc.installLog)>
					<hr/>
					<h3>#$r( "autoUpdates.installationLog@admin" )#</h3>
					<div class="consoleLog">#prc.installLog#</div>
					#html.button(value="#$r( "autoUpdates.installationLog.button@admin" )#",class="btn btn-primary",onclick="to ('#event.buildLink(prc.xehAutoUpdater)#/index/clearlogs/true')" )#
				</cfif>
			</div>
		</div>
	</div>
	<div class="col-md-4">
		<div class="panel panel-primary">
			<div class="panel-heading">
				<h3 class="panel-title"><i class="fa fa-info-circle"></i> #$r( "autoUpdates.componentsInstalled.title@admin" )#</h3>
			</div>
			<div class="panel-body">
				<table name="settings" id="settings" class="table table-striped table-hover table-condensed" width="98%">
					<thead>
						<tr>
							<th>#$r( "autoUpdates.componentsInstalled.table.head1@admin" )#</th> 
							<th width="100" class="text-center">#$r( "autoUpdates.componentsInstalled.table.head2@admin" )#</th>
						</tr>
					</thead>
					
					<tbody>
						<tr>
							<th>
								ContentBox Core <br/>
								(Codename: <a href="#getModuleSettings( "contentbox" ).codenameLink#" target="_blank">#getModuleSettings( "contentbox" ).codename#</a>)
							</th>
							<th class="text-center">v.#getModuleConfig('contentbox').version#</th>
						</tr>
						<tr>
							<th>ContentBox Admin</th>
							<th class="text-center">v.#getModuleConfig('contentbox-admin').version#</th>
						</tr>
						<tr>
							<th>ContentBox UI</th>
							<th class="text-center">v.#getModuleConfig('contentbox-ui').version#</th>
						</tr>
						<tr>
							<th>ColdBox Platform</th>
							<th class="text-center">v.#getSetting( "Version",1)#</th>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div class="panel panel-primary">
			<div class="panel-heading">
				<h3 class="panel-title"><i class="fa fa-medkit"></i> #$r( "autoUpdates.needHelp@admin" )#</h3>
			</div>
			<div class="panel-body">
				<!--- need help --->
				#renderView(view="_tags/needhelp", module="contentbox-admin" )#
			</div>
		</div>
	</div>
</div>
</cfoutput>