<cfoutput>
<!--- rules --->
<table name="rules" id="rules" class="table table-hover table-striped table-condensed table-bordered" width="100%">
	<thead>
		<tr class="info">
			<th>Secured</th>
			<th>Credentials</th>
			<th class="text-center"><i class="icon-reorder fa-lg"></i></th>
			<th class="text-center {sorter:false}">Actions</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.rules#" index="rule">
		<tr id="ruleid-#rule.getRuleID()#">
			<td>
				<strong>Match:</strong> #rule.getMatch()#<br/>
				<strong>SecureList:</strong> #rule.getSecureList()#<br/>
				<strong>WhiteList:</strong> #rule.getWhiteList()#<br/>
				<strong>Redirect To:</strong>#rule.getRedirect()# (SSL: #yesNoFormat( rule.getUseSSL() )#)
			</td>
			<td>
				<strong>Permissions:</strong>#rule.getPermissions()#<br/>
				<strong>Roles:</strong>#rule.getRoles()#
			</td>
			<td class="text-center">
				<div id="ruleid-#rule.getRuleID()#_order">
					<span class="badge badge-info">#rule.getOrder()#</span>
				</div>
			</td>
			<td class="text-center">
				<!--- Actions --->
				<div class="btn-group btn-group-sm">
			    	<a class="btn btn-sm btn-primary dropdown-toggle" data-toggle="dropdown" href="##" title="Role Actions">
						<i class="fa fa-cogs fa-lg"></i>
					</a>
			    	<ul class="dropdown-menu text-left pull-right">
						<cfif prc.oAuthor.checkPermission( "SECURITYRULES_ADMIN" )>
							<!--- Delete Command --->
							<li><a title="Delete Rule Permanently" href="javascript:remove('#rule.getRuleID()#')" class="confirmIt" data-title="<i class='fa fa-trash-o'></i> Delete Rule?"><i class="fa fa-trash-o fa-lg" id="delete_#rule.getRuleID()#"></i> Delete</a></li>
							<!--- Edit Command --->
							<li><a href="#event.buildLink(prc.xehEditorRule)#/ruleID/#rule.getRuleID()#" title="Edit Rule"><i class="fa fa-edit fa-lg"></i> Edit</a></li>
							<!--- Export --->
							<li class="dropdown-submenu pull-left">
								<a href="javascript:null"><i class="fa fa-download fa-lg"></i> Export</a>
								<ul class="dropdown-menu text-left">
									<li><a href="#event.buildLink(linkto=prc.xehExport)#/ruleID/#rule.getRuleID()#.json" target="_blank"><i class="fa fa-code"></i> as JSON</a></li>
									<li><a href="#event.buildLink(linkto=prc.xehExport)#/ruleID/#rule.getRuleID()#.xml" target="_blank"><i class="fa fa-sitemap"></i> as XML</a></li>
								</ul>
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