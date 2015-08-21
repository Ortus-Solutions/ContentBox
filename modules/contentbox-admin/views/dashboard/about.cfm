<cfoutput>
<div class="row">
	<div class="col-md-12">
		<h1 class="h1"><i class="fa fa-info-circle"></i> About ContentBox</h1>
	</div>
</div>	
<div class="row">
    <div class="col-md-8">
    	<img src="#prc.cbroot#/includes/images/ContentBox_300.png" alt="logo" class="pull-left" style="margin-right: 20px;" />
	    <h2>ContentBox Modular CMS <span class="label label-warning">#getModuleConfig('contentbox').version#</span></h2>
        <blockquote class="clearfix">
			<strong>ContentBox</strong> is a modular content platform developed by <a href="http://www.ortussolutions.com">Ortus Solutions</a> and 
			based on the popular <a href="http://www.coldbox.org">ColdBox Platform</a> development framework.
			ContentBox is a professional open source project with tons of services, training, customizations and more.
			<small><a href="http://www.ortussolutions.com/products/contentbox">www.ortussolutions.com/products/contentbox</a></small>
		</blockquote>
		<div class="panel panel-default">
		    <div class="panel-heading">
		        <h3 class="panel-title">Components</h3>
		    </div>
		    <div class="panel-body">
		    	<table name="settings" id="settings" class="table table-hover table-striped">
					<thead>
						<tr class="info">
							<th>Module</th>	
							<th width="100" class="text-center">Version</th>
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
		<div class="panel panel-default">
		    <div class="panel-heading">
		        <h3 class="panel-title">Keyboard Shortcuts</h3>
		    </div>
		    <div class="panel-body">
		    	<p>ContentBox offers several quick keyboard shortcuts for major functionality.  If you are extending ContentBox you can easily also leverage our shortcut library as well.
				You can add some metadata to <code>(e.g., a tags, input buttons, etc.)</code> that have links or inline JavaScript events that are of interest for keyboard shortcuts. 
				So a tag like so <code>&lt;a href="google.com"/&gt;...&lt;/a&gt;</code> could be adjusted to <code>&lt;a href="google.com" data-keybinding="ctrl+shift+g"/&gt;...&lt;/a&gt;</code>, 
				and a keystroke of <span class="label label-warning">ctrl+shift+g</span> would auto-redirect to the link. It also works for elements that have inline <span class="label label-warning">onclick</span> events defined.
				</p>
				
				<table name="settings" id="settings" class="table table-hover table-striped">
					<thead>
						<tr class="info">
							<th>Action</th>	
							<th width="100" class="text-center">Shortcut</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th>
								CKEditor Insert Widget
							</th>
							<th class="text-center">ctrl+shift+w</th>
						</tr>
						<tr>
							<th>
								CKEditor Insert Custom HTML
							</th>
							<th class="text-center">ctrl+shift+h</th>
						</tr>
						<tr>
							<th>
								CKEditor Link To Page
							</th>
							<th class="text-center">ctrl+shift+p</th>
						</tr>
						<tr>
							<th>
								CKEditor Link To Entry
							</th>
							<th class="text-center">ctrl+shift+b</th>
						</tr>
						<tr>
							<th>
								CKEditor Quick Save
							</th>
							<th class="text-center">ctrl+s</th>
						</tr>
						<tr>
							<th>
								Dashboard
							</th>
							<th class="text-center">ctrl+shift+d</th>
						</tr>
						<tr>
							<th>
								Editors Quick Preview
							</th>
							<th class="text-center">ctrl+p</th>
						</tr>
						<tr>
							<th>
								Log Out
							</th>
							<th class="text-center">ctrl+shift+l</th>
						</tr>
						<tr>
							<th>
								My Profile
							</th>
							<th class="text-center">ctrl+shift+a</th>
						</tr>
						<tr>
							<th>
								New Page
							</th>
							<th class="text-center">ctrl+shift+p</th>
						</tr>
						<tr>
							<th>
								New Post
							</th>
							<th class="text-center">ctrl+shift+b</th>
						</tr>
						<tr>
							<th>
								New Media
							</th>
							<th class="text-center">ctrl+shift+m</th>
						</tr>
						<tr>
							<th>
								New User
							</th>
							<th class="text-center">ctrl+shift+u</th>
						</tr>
						<tr>
							<th>
								Quick Search
							</th>
							<th class="text-center">ctrl+shift+s</th>
						</tr>
						<tr>
							<th>
								Quick Post
							</th>
							<th class="text-center">ctrl+shift+q</th>
						</tr>
						<tr>
							<th>
								Settings
							</th>
							<th class="text-center">ctrl+shift+c</th>
						</tr>
						<tr>
							<th>
								Toggle SideBar
							</th>
							<th class="text-center">ctrl+shift+e</th>
						</tr>
						
					</tbody>
				</table>
		    </div>
		</div>
    </div>
    <div class="col-md-4">
    	<div class="panel panel-primary">
		    <div class="panel-heading">
		        <h3 class="panel-title"><i class="fa fa-medkit"></i> Need Help?</h3>
		    </div>
		    <div class="panel-body">
		    	#renderView(view="_tags/needhelp", module="contentbox-admin" )#
				
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