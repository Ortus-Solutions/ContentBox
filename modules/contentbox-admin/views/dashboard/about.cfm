<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	
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
			About ContentBox
		</div>
		<!--- Body --->
		<div class="body" id="mainBody">
			
			<!--- Logo --->
			<div class="center">
				<img src="#prc.cbroot#/includes/images/ContentBox_300.png" alt="logo"/><br/>
				v.#getModuleSettings('contentbox').version# <br/>
				(Codename: <a href="#getModuleSettings("contentbox").settings.codenameLink#" target="_blank">#getModuleSettings("contentbox").settings.codename#</a>)
				<br/><br/>
			</div>
			
			<p>
				<strong>ContentBox</strong> is a modular content platform developed by <a href="http://www.ortussolutions.com">Ortus Solutions</a> and 
				based on the popular <a href="http://www.coldbox.org">ColdBox Platform</a> development framework.
				ContentBox is a professional open source project with tons of services, training, customizations and more.
			</p>
			
			<h2 class="border_grey">Links</h2>
			<ul class="bulleted_list">
				<li>Source Code: <a href="https://github.com/Ortus-Solutions/ContentBox" target="_blank">https://github.com/Ortus-Solutions/ContentBox</a></li>
				<li>Code Tracker: <a href="http://coldbox.assembla.com/spaces/contentbox/" target="_blank">http://coldbox.assembla.com/spaces/contentbox/</a></li>
				<li>Submit Bugs/Enhancements: <a href="http://coldbox.assembla.com/spaces/contentbox/support/tickets" target="_blank">http://coldbox.assembla.com/spaces/contentbox/support/tickets</a></li>
				<li>Professional Services: <a href="http://www.ortussolutions.com" target="_blank">http://www.ortussolutions.com</a></li>
				<li>ColdBox Platform: <a href="http://www.coldbox.org" target="_blank">http://www.coldbox.org</a></li>
			</ul>
			
			<h2 class="border_grey">Components</h2>
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
</div>
</cfoutput>