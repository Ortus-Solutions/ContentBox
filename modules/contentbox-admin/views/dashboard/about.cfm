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
				<img src="#prc.cbroot#/includes/images/ContentBox_125.gif" alt="logo"/><br/><br/>
			</div>
			
			<p>
				<strong>ContentBox</strong> is a modular content platform developed by <a href="http://www.ortussolutions.com">Ortus Solutions</a> and 
				based on the popular <a href="http://www.coldbox.org">ColdBox Platform</a> development framework.
				ContentBox is a professional open source project with tons of services, training, customizations and more.
			</p>
			
			<!--- authors --->
			<table name="settings" id="settings" class="tablesorter" width="98%">
				<thead>
					<tr>
						<th>Module</th>	
						<th width="100" class="center">Version</th>
					</tr>
				</thead>
				
				<tbody>
					<tr>
						<th>ContentBox Core</th>
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
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
});
</script>
</cfoutput>