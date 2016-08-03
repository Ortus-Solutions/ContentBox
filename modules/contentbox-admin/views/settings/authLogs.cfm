<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
            <i class="fa fa-bar-chart-o fa-lg"></i>
            Authentication Logs
        </h1>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        #getModel( "messagebox@cbMessagebox" ).renderit()#
    </div>
</div>
<div class="row">
    <div class="col-md-12">
    	<div class="panel panel-default">
    		<div class="panel-body">

    			<!-- Buttons -->
				<div class="pull-right padding10">
					<a href="#event.buildLink( prc.xehSettings )###security_options" class="btn btn-primary">Configure Tracker</a>
					<a href="#event.buildLink( prc.xehTruncate )#" class="btn btn-danger confirmIt">Truncate Logs</a>
				</div>

				<p>Here you see all recent Logins and as well the login attempts to your system</p>
				<cfif prc.featureEnabled>

					<!--- templates --->
					<table name="templates" id="templates" class="table table-striped table-hover table-condensed">
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
								<td class="text-center">
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
								<td class="text-center">
									<cfif thisLog.getIsBlocked()>
										<i class="fa fa-times fa-lg textRed" data-original-title="Blocked"></i>
									<cfelse>
										<i class="fa fa-check fa-lg textGreen" data-original-title="All Ok"></i>
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
			</div> <!-- end panel body -->
		</div> <!-- end panel -->
	</div>
</div>
</cfoutput>