<cfoutput>
<!--- rules --->
<table name="rules" id="rules" class="tablesorter table table-hover table-striped table-condensed" width="98%">
	<thead>
		<tr>
			<th>Secured</th>
			<th>Credentials</th>
			<th width="65" class="center"><i class="icon-reorder icon-large"></i></th>
			<th width="70" class="center {sorter:false}">Actions</th>
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
			<td class="center">
				<div id="ruleid-#rule.getRuleID()#_order"><span class="badge badge-info">#rule.getOrder()#</span></div>
			</td>
			<td class="center">
				<!--- Actions --->
				<div class="btn-group">
			    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##" title="Role Actions">
						<i class="icon-cogs icon-large"></i>
					</a>
			    	<ul class="dropdown-menu text-left pull-right">
						<cfif prc.oAuthor.checkPermission("SECURITYRULES_ADMIN")>
							<!--- Delete Command --->
							<li><a title="Delete Rule Permanently" href="javascript:remove('#rule.getRuleID()#')" class="confirmIt" data-title="Delete Rule?"><i class="icon-trash icon-large" id="delete_#rule.getRuleID()#"></i> Delete</a></li>
							<!--- Edit Command --->
							<li><a href="#event.buildLink(prc.xehEditorRule)#/ruleID/#rule.getRuleID()#" title="Edit Rule"><i class="icon-edit icon-large"></i> Edit</a></li>
							<!--- Export --->
							<li class="dropdown-submenu pull-left">
								<a href="javascript:null"><i class="icon-download icon-large"></i> Export</a>
								<ul class="dropdown-menu text-left">
									<li><a href="#event.buildLink(linkto=prc.xehExport)#/ruleID/#rule.getRuleID()#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
									<li><a href="#event.buildLink(linkto=prc.xehExport)#/ruleID/#rule.getRuleID()#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
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