<cfoutput>
<!--- Count --->
<input type="hidden" name="rulesCount" id="rulesCount" value="#arrayLen( prc.rules )#">
<!--- rules --->
<table name="rules" id="rules" class="table table-hover table-striped-removed " width="100%">
	<thead>
		<tr>
			<th>Security Rule</th>
			<th width="50" class="text-center">Order Index</th>
			<th width="50" class="text-center {sorter:false}">Actions</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.rules#" index="rule">
		<tr id="ruleid-#rule.getId()#">
			<td class="breakCellWords">
				<cfif rule.getMatch() eq "event">
					<span class="badge badge-info" title="Matches an event string">#rule.getMatch()#</span>
				<cfelse>
					<span class="badge badge-warning" title="Matches a URI">#rule.getMatch()#</span>
				</cfif>

				<cfif rule.getUseSSL()>
					<span class="label label-danger">
						<i class="fas fa-key"></i> SSL
					</span>
				</cfif>

				<div class="mt10">
					<span title="Securelist">
						<i class="fas fa-lock"></i>
						<code>#rule.getSecureList()#</code>
					</span>
				</div>

				<cfif len( rule.getWhiteList() )>
					<div class="mt10">
						<span title="Whitelist">
							<i class="fas fa-unlock textGreen"></i>
							<code>#rule.getWhiteList()#</code>
						</span>
					</div>
				</cfif>

				<div class="mt10">
					<span title="Redirect Link">
						<i class="fas fa-external-link-alt"></i>
						<code>#rule.getRedirect()#</code>
					</span>
				</div>

				<cfif len( rule.getPermissions() )>
					<div class="mt10">
						<strong>Permissions:</strong> #rule.getPermissions()#
					</div>
				</cfif>

				<cfif len( rule.getRoles() )>
					<div class="mt10">
						<strong>Roles:</strong> #rule.getRoles()#
					</div>
				</cfif>
			</td>

			<td class="text-center">
				<div id="ruleid-#rule.getId()#_order">
					<span class="badge badge-info">#rule.getOrder()#</span>
				</div>
			</td>

			<td class="text-center">
				<!--- Actions --->
				<div class="btn-group btn-group-sm">
			    	<a class="btn btn-sm btn-default btn-more dropdown-toggle" data-toggle="dropdown" href="##" title="Role Actions">
						<i class="fas fa-ellipsis-v fa-lg"></i>
					</a>
			    	<ul class="dropdown-menu text-left pull-right">
						<cfif prc.oCurrentAuthor.checkPermission( "SECURITYRULES_ADMIN" )>
							<!--- Delete Command --->
							<li>
								<a title="Delete Rule Permanently" href="javascript:remove('#rule.getId()#')" class="confirmIt" data-title="<i class='far fa-trash-alt'></i> Delete Rule?">
									<i class="far fa-trash-alt fa-lg" id="delete_#rule.getId()#"></i> Delete
								</a>
							</li>
							<!--- Edit Command --->
							<li>
								<a href="#event.buildLink(prc.xehEditorRule)#/ruleID/#rule.getId()#" title="Edit Rule">
									<i class="fas fa-pen fa-lg"></i> Edit
								</a>
							</li>
							<!--- Export --->
							<li>
								<a href="#event.buildLink(to=prc.xehExport)#/ruleID/#rule.getId()#.json" target="_blank">
									<i class="fas fa-file-export fa-lg"></i> Export as JSON
								</a>
							</li>
							<li>
								<a href="#event.buildLink(to=prc.xehExport)#/ruleID/#rule.getId()#.xml" target="_blank">
									<i class="fas fa-file-export fa-lg"></i> Export as XML
								</a>
							</li>
						</cfif>
			    	</ul>
			    </div>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>
</cfoutput>