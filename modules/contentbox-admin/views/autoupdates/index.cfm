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
			
			<!--- Update Form --->
			#html.startForm(name="updateCheckForm")#
				#html.startFieldSet(legend="<img src='#prc.cbRoot#/includes/images/download_black.png' alt='updates'/> Check For Updates: ")#
					<p>Select your update channel.</p>
					
					#html.radioButton(name="channel",id="stable",value=prc.updateSlugStable,checked="false",checked=true)#
					<label for="stable" class="inline">Stable Release</label> : Official ContentBox releases.
					<br/>
					
					#html.radioButton(name="channel",id="beta",value=prc.updateSlugBeta,checked="false")#
					<label for="beta" class="inline">Bleeding Edge Release</label> : Beta releases can be done at your own risk as it is still in development.
					
					<br/><br/>
					#html.button(value="Check For Updates",class="buttonred",onclick="return checkForUpdates()")#
			
				#html.endFieldSet()#
			#html.endForm()#		
			
			
			<!--- Logs --->
			<cfif len(prc.installLog)>
				<h3>Installation Log</h3>
				<div class="consoleLog">#prc.installLog#</div>
				#html.button(value="Clear Log",class="button2",onclick="to ('#event.buildLink(prc.xehAutoUpdater)#/index/clearlogs/true')")#
			</cfif>
			
		</div>	
	</div>
</div>
</cfoutput>