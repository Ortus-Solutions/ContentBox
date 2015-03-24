<cfoutput>
<div class="row-fluid">
	<!--- main content --->
	<div class="span12" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-bar-chart icon-large"></i>
				Authentication Log
			</div>
			<!--- Body --->
			<div class="body">
				
				<!--- MessageBox --->
				#getPlugin("MessageBox").renderit()#
				<p>Here you see all recent Logins and as well the login attempts to your system</p>
				<cfif prc.featureEnable>
					<p>Click <a href="#event.buildLink(prc.xehRawSettings)#?search=cb_security_">here</a> to change Settings</p> 
					
					<!--- templates --->
					<table name="templates" id="templates" class="tablesorter table table-hover table-striped" width="98%">
						<thead>
							<tr>
								<th>Username / IP</th>
								<th>Attempts</th>
								<th>Date</th>
								<th>Successfull from IP</th>
								<th>Status</th>
							</tr>
						</thead>				
						<tbody>
							<cfloop array="#prc.logs#" index = "elem">
							<tr>
								<td>
									<strong>#elem.getvalue()#</strong>
								</td>
								<td>
									#elem.getAttempts()#
								</td>
								<td>#LSDateFormat(elem.getCreatedDate())# #LSTimeFormat(elem.getCreatedDate())#</td>
								<td>
									<cfif elem.getLastLoginSuccessIP() neq ''>
										#elem.getLastLoginSuccessIP()#
									<cfelse>
										-
									</cfif>
								</td>
								<td>
									<cfif elem.getIsBlocked()>
										<i title="" class="icon-remove icon-large textRed" data-original-title="Blocked"></i>
									<cfelse>
										<i class="icon-ok icon-large textGreen"></i>
									</cfif>
								</td>
							</tr>
							</cfloop>
						</tbody>
					</table>
				<cfelse>
					This feature is disabled! Click <a href="#event.buildLink(prc.xehRawSettings)#?search=cb_security_">here</a> to enable it.
				</cfif>
			</div>	
		</div>	
	</div>
</div>
</cfoutput>