<cfoutput>
<div class="row-fluid">
	<!--- main content --->
	<div class="span12" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-bar-chart icon-large"></i>
				Authentication Logs
			</div>
			<!--- Body --->
			<div class="body">
				
				<cfif prc.featureEnabled>

					<!-- Buttons -->
					<div class="pull-right padding10">
						<a href="#event.buildLink( prc.xehSettings )###security_options" class="btn btn-default">Configure Tracker</a>
						<a href="#event.buildLink( prc.xehTruncate )#" class="btn btn-danger confirmIt">Truncate Logs</a>
					</div>
				
					<!--- MessageBox --->
					#getPlugin("MessageBox").renderit()#
					<p>Here you see all recent system logins and as well the login attempts to your system.</p>

					<!--- templates --->
					<table name="templates" id="templates" class="tablesorter table table-hover table-striped" width="98%">
						<thead>
							<tr>
								<th>Username / IP</th>
								<th width="75">Attempts</th>
								<th width="200">Date</th>
								<th width="200">Successfull IP</th>
								<th width="100" class="textCenter">Status</th>
							</tr>
						</thead>				
						<tbody>
							<cfloop array="#prc.logs#" index="thisLog">
							<tr <cfif thisLog.getIsBlocked()>class="danger"</cfif>>
								<td>
									<strong>
										<!--- if ip look up --->
										<cfif listLen( thisLog.getValue(), "." ) eq 4 >
											<a href="#prc.cbSettings.cb_comments_whoisURL#=#thisLog.getValue()#" title="Get IP Information" target="_blank">#thisLog.getValue()#</a>											
										<cfelse>
											#thisLog.getvalue()#
										</cfif>
									</strong>
								</td>
								<td>
									#thisLog.getAttempts()#
								</td>
								<td>#thisLog.getDisplayCreatedDate()#</td>
								<td>
									<cfif len( thisLog.getLastLoginSuccessIP() )>
										<a href="#prc.cbSettings.cb_comments_whoisURL#=#thisLog.getLastLoginSuccessIP()#" title="Get IP Information" target="_blank">#thisLog.getLastLoginSuccessIP()#</a>	
									<cfelse>
										-
									</cfif>
								</td>
								<td class="textCenter">
									<cfif thisLog.getIsBlocked()>
										<i class="icon-remove icon-large textRed" data-original-title="Blocked"></i>
									<cfelse>
										<i class="icon-ok icon-large textGreen" data-original-title="All Ok"></i>
									</cfif>
								</td>
							</tr>
							</cfloop>
						</tbody>
					</table>
				<cfelse>
					<div class="alert alert-warning">
					Login Tracker is disabled! Click <a href="#event.buildLink( prc.xehSettings )###security_options">here</a> to enable it.
					</div>
				</cfif>
			</div>	
		</div>	
	</div>
</div>
</cfoutput>