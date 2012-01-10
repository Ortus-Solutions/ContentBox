<cfoutput>
<!--- rules --->
<table name="rules" id="rules" class="tablesorter" width="98%">
	<thead>
		<tr>
			<th width="50">Match</th>
			<th>Securelist</th>
			<th>Whitelist</th>
			<th>Redirect</th>
			<th>Permissions</th>
			<th>Roles</th>
			<th width="55" class="center"><img src="#prc.cbRoot#/includes/images/sort.png" alt="sort" title="Order"/></th>
			<th width="70" class="center {sorter:false}">Actions</th>
		</tr>
	</thead>
	
	<tbody>
		<cfloop array="#prc.rules#" index="rule">
		<tr>
			<td>
				#rule.getMatch()#
			</td>
			<td>
				#rule.getSecureList()#
			</td>
			<td>
				#rule.getWhiteList()#
			</td>
			<td>
				#rule.getRedirect()# (SSL: #yesNoFormat( rule.getUseSSL() )#)
			</td>
			<td>
				#rule.getPermissions()#
			</td>
			<td>
				#rule.getRoles()#
			</td>
			<td class="center">
				#rule.getOrder()#
				<cfif prc.oAuthor.checkPermission("SECURITYRULES_ADMIN")>
				<!--- Order Up --->
				<cfif ( rule.getOrder()-1 ) GTE 0 >
					<a href="javascript:changeOrder('#rule.getRuleID()#', #rule.getOrder()-1#,'up')" title="Order Up"><img id="orderup_#rule.getRuleID()#" src="#prc.cbRoot#/includes/images/_up.gif" alt="order"/></a>
				</cfif>
				<!--- Increase Order Index--->
				<a href="javascript:changeOrder('#rule.getRuleID()#',#rule.getOrder()+1#,'down')" title="Order Down"><img id="orderdown_#rule.getRuleID()#" src="#prc.cbRoot#/includes/images/_down.gif" alt="order"/></a>
				</cfif>
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