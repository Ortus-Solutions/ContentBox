<cfoutput>
<div class="row">
    <div class="col-md-12">
    	
    	<div class="text-center">
    		<img src="#prc.cbroot#/includes/images/ContentBox_300.png" alt="logo" class="margin10" title="Modular CMS"/>
		    <h2><span class="label label-warning">#getModuleConfig('contentbox').version#</span></h2>
	        <blockquote class="clearfix">
				<strong>ContentBox</strong> #$r( "dashboard.about.blockquote1.1@admin" )#<a href="http://www.ortussolutions.com">Ortus Solutions</a> #$r( "dashboard.about.blockquote1.2@admin" )# <a href="http://www.coldbox.org">ColdBox Platform</a> #$r( "dashboard.about.blockquote1.3@admin" )#
				<small><a href="http://www.ortussolutions.com/products/contentbox">www.ortussolutions.com/products/contentbox</a></small>
			</blockquote>
		</div>

		<div class="panel panel-default">
		    <div class="panel-heading">
		        <h3 class="panel-title">#$r( "dashboard.about.components.title@admin" )#</h3>
		    </div>
		    <div class="panel-body">
		    	<table name="settings" id="settings" class="table table-hover table-striped">
					<thead>
						<tr>
							<th>#$r( "dashboard.about.components.table.head1@admin" )#</th>	
							<th width="300" class="text-center">#$r( "dashboard.about.components.table.head2@admin" )#</th>
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
		        <h3 class="panel-title">#$r( "dashboard.about.shortcuts.title@admin" )#</h3>
		    </div>
		    <div class="panel-body">
		    	<p>#$r( "dashboard.about.shortcuts.body1@admin" )# <code>#$r( "dashboard.about.shortcuts.body2@admin" )#</code> #$r( "dashboard.about.shortcuts.body3@admin" )# <code>&lt;a href="google.com"/&gt;...&lt;/a&gt;</code> #$r( "dashboard.about.shortcuts.body4@admin" )# <code>&lt;a href="google.com" data-keybinding="ctrl+shift+g"/&gt;...&lt;/a&gt;</code>, 
				#$r( "dashboard.about.shortcuts.body5@admin" )# <span class="label label-warning">ctrl+shift+g</span> #$r( "dashboard.about.shortcuts.body6@admin" )# <span class="label label-warning">onclick</span> #$r( "dashboard.about.shortcuts.body7@admin" )#
				</p>
				
				<table name="settings" id="settings" class="table table-hover table-striped">
					<thead>
						<tr>
							<th>#$r( "dashboard.about.shortcuts.table.head1@admin" )#</th>	
							<th width="150" class="text-center">#$r( "dashboard.about.shortcuts.table.head2@admin" )#</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th>
								#$r( "dashboard.about.shortcuts.table.r01.1@admin" )#
							</th>
							<th class="text-center">ctrl+shift+w</th>
						</tr>
						<tr>
							<th>
								#$r( "dashboard.about.shortcuts.table.r02.1@admin" )#
							</th>
							<th class="text-center">ctrl+shift+h</th>
						</tr>
						<tr>
							<th>
								#$r( "dashboard.about.shortcuts.table.r03.1@admin" )#
							</th>
							<th class="text-center">ctrl+shift+p</th>
						</tr>
						<tr>
							<th>
								#$r( "dashboard.about.shortcuts.table.r04.1@admin" )#
							</th>
							<th class="text-center">ctrl+shift+b</th>
						</tr>
						<tr>
							<th>
								#$r( "dashboard.about.shortcuts.table.r05.1@admin" )#
							</th>
							<th class="text-center">ctrl+s</th>
						</tr>
						<tr>
							<th>
								#$r( "dashboard.about.shortcuts.table.r06.1@admin" )#
							</th>
							<th class="text-center">ctrl+shift+d</th>
						</tr>
						<tr>
							<th>
								#$r( "dashboard.about.shortcuts.table.r07.1@admin" )#
							</th>
							<th class="text-center">ctrl+p</th>
						</tr>
						<tr>
							<th>
								#$r( "dashboard.about.shortcuts.table.r08.1@admin" )#
							</th>
							<th class="text-center">ctrl+shift+l</th>
						</tr>
						<tr>
							<th>
								#$r( "dashboard.about.shortcuts.table.r09.1@admin" )#
							</th>
							<th class="text-center">ctrl+shift+a</th>
						</tr>
						<tr>
							<th>
								#$r( "dashboard.about.shortcuts.table.r10.1@admin" )#
							</th>
							<th class="text-center">ctrl+shift+p</th>
						</tr>
						<tr>
							<th>
								#$r( "dashboard.about.shortcuts.table.r11.1@admin" )#
							</th>
							<th class="text-center">ctrl+shift+b</th>
						</tr>
						<tr>
							<th>
								#$r( "dashboard.about.shortcuts.table.r12.1@admin" )#
							</th>
							<th class="text-center">ctrl+shift+m</th>
						</tr>
						<tr>
							<th>
								#$r( "dashboard.about.shortcuts.table.r13.1@admin" )#
							</th>
							<th class="text-center">ctrl+shift+u</th>
						</tr>
						<tr>
							<th>
								#$r( "dashboard.about.shortcuts.table.new_menu@admin" )#
							</th>
							<th class="text-center">ctrl+shift+v</th>
						</tr>
						<tr>
							<th>
								#$r( "dashboard.about.shortcuts.table.r14.1@admin" )#
							</th>
							<th class="text-center">ctrl+shift+s or \</th>
						</tr>
						<tr>
							<th>
								#$r( "dashboard.about.shortcuts.table.r16.1@admin" )#
							</th>
							<th class="text-center">ctrl+shift+c</th>
						</tr>
						<tr>
							<th>
								#$r( "dashboard.about.shortcuts.table.r17.1@admin" )#
							</th>
							<th class="text-center">ctrl+shift+e</th>
						</tr>
						
					</tbody>
				</table>
		    </div>
		</div>

		<div class="panel panel-primary">
		    <div class="panel-heading">
		        <h3 class="panel-title"><i class="fa fa-medkit"></i> #$r( "dashboard.about.help.title@admin" )#</h3>
		    </div>
		    <div class="panel-body">
		    	#renderView(view="_tags/needhelp", module="contentbox-admin" )#
				
				<h2>#$r( "dashboard.about.help.links@admin" )#</h2>
				<ul>
					<li><a href="https://github.com/Ortus-Solutions/ContentBox" target="_blank">#$r( "dashboard.about.help.sourceCode@admin" )#</a></li>
					<li><a href="https://ortussolutions.atlassian.net/browse/CONTENTBOX" target="_blank">#$r( "dashboard.about.help.submitBugs@admin" )#</a></li>
					<li><a href="http://www.ortussolutions.com/services" target="_blank">#$r( "dashboard.about.help.services@admin" )#</a></li>
				</ul>
		    </div>
		</div>
		
    </div>
</div>
</cfoutput>