<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	
	<!--- Info Box --->
	<div class="small_box expose">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/info.png" alt="info" width="24" height="24" />Components Installed
		</div>
		<div class="body">
			<table name="settings" id="settings" class="tablesorter" width="98%">
				<thead>
					<tr>
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
	<div class="small_box expose">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/info.png" alt="info" width="24" height="24" />Need Help?
		</div>
		<div class="body">
			<a href="http://www.ortussolutions.com" target="_blank" title="The Gurus behind ColdBox and ContentBox">
			<div class="center"><img src="#prc.cbroot#/includes/images/ortus-top-logo.png" alt="Ortus Solutions" border="0" /></a><br/></div>
			
			<p><strong>Ortus Solutions</strong> is the company behind anything ColdBox and ContentBox. Need professional support, architecture analysis,
			code reviews, custom development or anything ColdFusion, ColdBox, ContentBox related? 
			<a href="mailto:help@ortussolutions.com">Contact us</a>, we are here
			to help!</p>
		</div>
	</div>	
	
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/ortus_circle_small.gif" alt="ortus" width="30" height="30" title="Ortus Solutions, Corp" />
			Auto Updates
		</div>
		<!--- Body --->
		<div class="body" id="mainBody">
			
			#getPlugin("MessageBox").renderit()#
			
			<p>You can patch ContentBox in order to receive the latest bugfixes and enhancements from here.  We do encourage you
			to make backups when doing auto-udpates.</p>
			
			
			<!--- Accordion Snapshots --->
			<div id="accordion">
				<!--- Check For Updates --->
				<h2> 
					<img src="#prc.cbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" /> 
					<img src="#prc.cbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" /> 
					<img src="#prc.cbroot#/includes/images/world.png" alt="info" /> Check For Updates </h2>
				<div class="pane">
					<!--- Update Form --->
					#html.startForm(name="updateCheckForm",novalidate="novalidate")#
						<p>Select your update channel so we can check if there are any new releases available for you.</p>
						
						#html.radioButton(name="channel",id="stable",value=prc.updateSlugStable,checked="false",checked=true)#
						<label for="stable" class="inline">Stable Release</label> : Official ContentBox releases.
						<br/>
						
						#html.radioButton(name="channel",id="beta",value=prc.updateSlugBeta,checked="false")#
						<label for="beta" class="inline">Bleeding Edge Release</label> : Beta releases can be done at your own risk as it is still in development.
						
						<br/><br/>
						#html.button(value="Check For Updates",class="buttonred",onclick="return checkForUpdates()")#
					#html.endForm()#	
				</div>
				<!--- Apply By Download --->
				<h2> 
					<img src="#prc.cbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" /> 
					<img src="#prc.cbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" /> 
					<img src="#prc.cbroot#/includes/images/download.png" alt="info" /> Download Update </h2>
				<div class="pane">
					<!--- Update Form --->
					#html.startForm(name="updateNowForm",action=prc.xehInstallUpdate,novalidate="novalidate")#
						<p>You can apply an update by selecting the download URL of the update archive.</p>
						
						#html.inputfield(type="url",required="required",name="downloadURL",label="Download URL:", class="textfield",size="75")#
						
						<br/><br/>
						#html.submitButton(value="Install Update",class="buttonred")#
					#html.endForm()#	
				</div>
				<!--- Apply By Upload --->
				<h2> 
					<img src="#prc.cbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" /> 
					<img src="#prc.cbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" /> 
					<img src="#prc.cbroot#/includes/images/upload.png" alt="info" /> Upload Update </h2>
				<div class="pane">
					<!--- Upload Form --->
					#html.startForm(name="uploadNowForm",action=prc.xehUploadUpdate,multipart=true,novalidate="novalidate")#
						<p>You can also apply an update by uploading the update archive.</p>
						
						#html.fileField(name="filePatch",label="Upload Patch: ", class="textfield",required="required", size="50")#	
						
						<br/><br/>
						#html.submitButton(value="Upload & Install Update",class="buttonred")#
					#html.endForm()#	
				</div>
			</div>
			<!--End Accordion-->	
			
			
			<!--- Logs --->
			<cfif len(prc.installLog)>
				<hr/>
				<h3>Installation Log</h3>
				<div class="consoleLog">#prc.installLog#</div>
				#html.button(value="Clear Log",class="button2",onclick="to ('#event.buildLink(prc.xehAutoUpdater)#/index/clearlogs/true')")#
			</cfif>
			
		</div>	
	</div>
</div>
</cfoutput>