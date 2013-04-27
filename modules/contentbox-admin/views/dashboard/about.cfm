<cfoutput>
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
		<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/ortus_circle_small.gif" alt="ortus" width="30" height="30" title="Ortus Solutions, Corp" style="height:30px" />
			About ContentBox
		</div>
		<!--- Body --->
		<div class="body" id="mainBody">
			
			<div class="hero-unit">
                 <img src="#prc.cbroot#/includes/images/ContentBox_300.png" alt="logo" class="pull-left padding10" /><br/>
			    <h2>ContentBox Modular CMS <span class="label label-warning">#getModuleSettings('contentbox').version#</span></h2>
                <blockquote class="clearfix">
					<strong>ContentBox</strong> is a modular content platform developed by <a href="http://www.ortussolutions.com">Ortus Solutions</a> and 
					based on the popular <a href="http://www.coldbox.org">ColdBox Platform</a> development framework.
					ContentBox is a professional open source project with tons of services, training, customizations and more.
					<small><a href="http://www.gocontentbox.org">www.gocontentbox.org</a></small>
				</blockquote>
			</div>
		
			<div class="page-header">
				<h2>Components</h2>
				</div>
				<table name="settings" id="settings" class="table table-hover table-condensed table-striped table-bordered">
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
	</div>
	
	<!--- Sidebar --->
	<div class="span3" id="main-sidebar">
		<!--- Info Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-medkit"></i> Need Help?
			</div>
			<div class="body">
				<!--- need help --->
				#renderView(view="_tags/needhelp", module="contentbox-admin")#
				
				<h2>Links</h2>
				<ul>
					<li><a href="https://github.com/Ortus-Solutions/ContentBox" target="_blank">Source Code</a></li>
					<li><a href="https://ortussolutions.atlassian.net/browse/CONTENTBOX" target="_blank">Code Tracker</a></li>
					<li><a href="https://ortussolutions.atlassian.net/browse/CONTENTBOX" target="_blank">Submit Bugs/Enhancements</a></li>
					<li><a href="http://www.ortussolutions.com" target="_blank">Professional Services</a></li>
					<li><a href="http://www.coldbox.org" target="_blank">ColdBox Platform</a></li>
				</ul>
			</div>
		</div>	
	</div>
</div>
</cfoutput>