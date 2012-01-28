<cfoutput>
<!--- rules --->
<table name="rules" id="rules" class="tablesorter" width="98%">
	<thead>
		<tr>
			<th>Secured</th>
			<th>Credentials</th>
			<th width="65" class="center"><img src="#prc.cbRoot#/includes/images/sort.png" alt="sort" title="Order"/></th>
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
				<div id="ruleid-#rule.getRuleID()#_order">#rule.getOrder()#</div>
			</td>
			<td class="center">
				<cfif prc.oAuthor.checkPermission("SECURITYRULES_ADMIN")>
				<!--- Edit Command --->
				<a href="#event.buildLink(prc.xehEditorRule)#/ruleID/#rule.getRuleID()#" title="Edit Rule"><img src="#prc.cbroot#/includes/images/edit.png" alt="edit" /></a>
				&nbsp;
				<!--- Delete Command --->
				<a title="Delete Rule Permanently" href="javascript:remove('#rule.getRuleID()#')" class="confirmIt" data-title="Delete Rule?"><img id="delete_#rule.getRuleID()#" src="#prc.cbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
				</cfif>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>
</cfoutput>