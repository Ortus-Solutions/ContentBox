<cfoutput>
	<cfset local.topMenu = local.thisMenu>
	<cfif !len( local.topMenu.permissions ) || prc.oCurrentAuthor.hasPermission( local.topMenu.permissions )>
		
<li #buildLIAttributes( event, local.topMenu )#>
		<cfset itemDefaults = { "class": "dropdown-toggle" }>
		
<#local.topMenu.itemType# #buildItemAttributes(
	event,
	local.topMenu,
	itemDefaults
)#>#( isCustomFunction( local.topMenu.label ) ? local.topMenu.label() : local.topMenu.label )#</#local.topMenu.itemType#>

		<cfif arrayLen( local.topMenu.subMenu )>
			<ul class="dropdown-menu">

			<cfloop array="#local.topMenu.submenu#" index="local.thisSubMenu">
				<cfif !len( local.thisSubMenu.permissions ) || prc.oCurrentAuthor.hasPermission( local.thisSubMenu.permissions )>
					
<li #buildLIAttributes( event, local.thisSubMenu )#>
					<cfset itemDefaults = {}>
					<#local.thisSubMenu.itemType# #buildItemAttributes(
	event,
	local.thisSubMenu,
	itemDefaults
)#>#(
	isCustomFunction( local.thisSubMenu.label ) ? local.thisSubMenu.label() : local.thisSubMenu.label
)#</#local.thisSubMenu.itemType#>
</li>

				</cfif>
			</cfloop>
			
			
			
			
			

                </ul>





		</cfif>
		
		
		
		
		
        </li>






	</cfif>
</cfoutput>
<cfscript>

</cfscript>
