<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
            <i class="fa fa-bar-chart-o icon-large"></i>
            Authentication Logs
        </h1>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        #getPlugin( "MessageBox" ).renderit()#
    </div>
</div>
<div class="row">
    <div class="col-md-12">
    	<div class="panel panel-default">
    		<div class="panel-body">
				<p>Here you see all recent Logins and as well the login attempts to your system</p>
				<cfif prc.featureEnabled>

					<div class="pull-right padding10">
						<a href="#event.buildLink( prc.xehTruncate )#" class="btn btn-danger confirmIt">Truncate Logs</a>
					</div>

					<p>Click <a href="#event.buildLink( prc.xehRawSettings )#?search=cb_security_">here</a> to change Settings</p> 

					<!--- templates --->
					<table name="templates" id="templates" class="table table-bordered table-hover table-striped">
						<thead>
							<tr class="info">
								<th>Username / IP</th>
								<th>Attempts</th>
								<th>Date</th>
								<th>Successfull IP</th>
								<th>Status</th>
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
									<cfif thisLog.getLastLoginSuccessIP() neq ''>
										<a href="#prc.cbSettings.cb_comments_whoisURL#=#thisLog.getLastLoginSuccessIP()#" title="Get IP Information" target="_blank">#thisLog.getLastLoginSuccessIP()#</a>	
									<cfelse>
										-
									</cfif>
								</td>
								<td>
									<cfif thisLog.getIsBlocked()>
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
			</div> <!-- end panel body -->
		</div> <!-- end panel -->
	</div>
</div>
</cfoutput>