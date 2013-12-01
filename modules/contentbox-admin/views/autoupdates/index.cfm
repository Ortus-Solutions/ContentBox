<cfoutput>
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-bolt icon-large"></i> 
				Auto Updates
			</div>
			<!--- Body --->
			<div class="body" id="mainBody">
				
				#getPlugin("MessageBox").renderit()#
				
				<p>You can patch ContentBox in order to receive the latest bugfixes and enhancements from here.  We do encourage you
				to make backups when doing auto-udpates.</p>
				
				<!---Begin Accordion--->
				<div id="accordion" class="accordion">
				    <!---Begin Check--->
				    <div class="accordion-group">
                    	<div class="accordion-heading">
                      		<a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##check">
                        		<i class="icon-globe icon-large"></i> Check For Updates
                      		</a>
                    	</div>
                    	<div id="check" class="accordion-body collapse in">
                      		<div class="accordion-inner">
        						<!--- Update Form --->
        						#html.startForm(name="updateCheckForm",novalidate="novalidate")#
        							<p>Select your update channel so we can check if there are any new releases available for you.</p>
        							
        							#html.radioButton(name="channel",id="stable",value=prc.updateSlugStable,checked="false",checked=true)#
        							<label for="stable" class="inline">Stable Release</label> : Official ContentBox releases.
        							<br/>
        							
        							#html.radioButton(name="channel",id="beta",value=prc.updateSlugBeta,checked="false")#
        							<label for="beta" class="inline">Bleeding Edge Release</label> : Beta releases can be done at your own risk as it is still in development.
        							
        							<br/><br/>
        							#html.button(value="Check For Updates",class="btn btn-danger",onclick="return checkForUpdates()")#
        						#html.endForm()#	
                      		</div>
                    	</div>
                  	</div>
                    <!---End Check--->
					
					<!---Begin Download--->
				    <div class="accordion-group">
                    	<div class="accordion-heading">
                      		<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##download">
                        		<i class="icon-download icon-large"></i> Download Update
                      		</a>
                    	</div>
                    	<div id="download" class="accordion-body collapse">
                      		<div class="accordion-inner">
        						<!--- Update Form --->
        						#html.startForm(name="updateNowForm",action=prc.xehInstallUpdate,novalidate="novalidate",class="form-vertical")#
        							<p>You can apply an update by selecting the download URL of the update archive.</p>
        							
        							#html.inputfield(type="url",required="required",name="downloadURL",label="Download URL:", class="textfield",size="75",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
        							#html.submitButton(value="Install Update", class="btn btn-danger")#   
        						#html.endForm()#	
                      		</div>
                    	</div>
                  	</div>
                    <!---End Download--->
						
					<!---Begin Upload--->
				    <div class="accordion-group">
                    	<div class="accordion-heading">
                      		<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##upload">
                        		<i class="icon-upload icon-large"></i> Upload Update
                      		</a>
                    	</div>
                    	<div id="upload" class="accordion-body collapse">
                      		<div class="accordion-inner">
        						<!--- Upload Form --->
        						#html.startForm(name="uploadNowForm",action=prc.xehUploadUpdate,multipart=true,novalidate="novalidate",class="form-vertical")#
        							<p>You can also apply an update by uploading the update archive.</p>
                                    #getMyPlugin( plugin="BootstrapFileUpload", module="contentbox" ).renderIt( 
                                        name="filePatch", 
                                        label="Upload Patch:",
                                        required=true
                                    )#
        							#html.submitButton(value="Upload & Install Update",class="btn btn-danger")#
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
					<h3>Installation Log</h3>
					<div class="consoleLog">#prc.installLog#</div>
					#html.button(value="Clear Log",class="btn btn-primary",onclick="to ('#event.buildLink(prc.xehAutoUpdater)#/index/clearlogs/true')")#
				</cfif>
				
			</div>	
		</div>
	</div>
	
	<!--- main sidebar --->
	<div class="span3" id="main-sidebar">
		<div class="small_box">
			<div class="header">
				<i class="icon-info-sign"></i> Components Installed
			</div>
			<div class="body">
				<table name="settings" id="settings" class="table table-striped table-hover" width="98%">
					<thead>
						<tr class="info">
							<th>Module</th>	
							<th width="100" class="center">Version</th>
						</tr>
					</thead>
					
					<tbody>
						<tr>
							<th>
								ContentBox Core <br/>
								(Codename: <a href="#getModuleSettings("contentbox").settings.codenameLink#" target="_blank">#getModuleSettings("contentbox").settings.codename#</a>)
							</th>
							<th class="center">v.#getModuleSettings('contentbox').version#</th>
						</tr>
						<tr>
							<th>ContentBox Admin</th>
							<th class="center">v.#getModuleSettings('contentbox-admin').version#</th>
						</tr>
						<tr>
							<th>ContentBox UI</th>
							<th class="center">v.#getModuleSettings('contentbox-ui').version#</th>
						</tr>
						<tr>
							<th>ColdBox Platform</th>
							<th class="center">v.#getSetting("Version",1)#</th>
						</tr>
					</tbody>
				</table>
			</div>
		</div>	
		
		<!--- Info Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-medkit"></i> Need Help?
			</div>
			<div class="body">
				<!--- need help --->
				#renderView(view="_tags/needhelp", module="contentbox-admin")#
			</div>
		</div>	
	</div>
</div>
</cfoutput>