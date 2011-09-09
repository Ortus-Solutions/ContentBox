<cfoutput>
<h2>'#rc.oWidget.getPluginName()#' Widget</h2>
<div>
	<ul>
		<li><strong>Version:</strong> #rc.oWidget.getpluginVersion()# </li>
		<li><strong>ForgeBox Slug:</strong> #rc.oWidget.getForgeBoxSlug()# </li>
		<li><strong>Description:</strong> #rc.oWidget.getPluginDescription()#</li>
		<li><strong>Renderit Hint: </strong> <cfif structKeyExists(rc.metadata,"hint")>#rc.metadata.hint#<cfelse>N/A</cfif></li>
		<li><strong>Renderit Arguments: </strong>
			<cfif ArrayLen(rc.metadata.parameters)>
				<table class="tablelisting" width="95%">
					<tr>
						<th>Argument</th>
						<th>Type</th>
						<th>Required</th>
						<th>Default Value</th>
						<th>Hint</th>
					</tr>
				<cfloop array="#rc.metadata.parameters#" index="i">
					<tr>
						<td>#i.name#</td>
						<td><cfif structKeyExists(i,"type")>#i.type#<cfelse>Any</cfif></td>
						<td><cfif structKeyExists(i,"required")>#i.required#<cfelse>true</cfif></td>
						<td><cfif structKeyExists(i,"default")>#i.default#</cfif></td>
						<td><cfif structKeyExists(i,"hint")>#i.hint#</cfif></td>
					</tr>
				</cfloop>
				</table>
			<cfelse>
				No arguments defined
			</cfif>	
		</li>
	</ul>
</div>
<hr/>
<!--- Button Bar --->
<div id="bottomCenteredBar" class="textRight">
	<button class="buttonred" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>