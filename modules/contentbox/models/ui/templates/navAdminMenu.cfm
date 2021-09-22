<cfoutput>
<ul class="nav nav-pills nav-stacked">
	<!--- Loop over Top Menus --->
	<cfloop array="#local.thisMenu#" index="local.topMenu">

		<!--- Check Permissions --->
		<cfif !len( local.topMenu.permissions ) OR prc.oCurrentAuthor.checkPermission( local.topMenu.permissions )>
			<!--- LI --->
			<li
				class="<cfif arrayLen( local.topMenu.subMenu )>nav-dropdown<cfelse>nav</cfif><cfif event.getPrivateValue( 'tab#local.topMenu.name#', false )> active open </cfif>#local.topMenu.class#"
				data-name="#local.topMenu.name#"
			>

				<a
					href="#( isCustomFunction( local.topMenu.href ) ? local.topMenu.href( local.topMenu, event ) : local.topMenu.href )#"
					class="<cfif arrayLen( local.topMenu.subMenu )>dropdown-toggle</cfif>"
					<cfif arrayLen( local.topMenu.subMenu )>data-toggle="dropdown"</cfif>
					<cfif len( local.topMenu.title )>title="#local.topMenu.title#"</cfif>
					<cfif len( local.topMenu.target )>target="#local.topMenu.target#"</cfif>
					<cfif structKeyExists( local.topMenu, "data" ) && structCount( local.topMenu.data )>#parseADataAttributes( local.topMenu.data )#</cfif>
				>
					#( isCustomFunction( local.topMenu.label ) ? local.topMenu.label() : local.topMenu.label )# <cfif arrayLen( local.topMenu.subMenu )></cfif>
				</a>

				<!--- Do we have submenus --->
				<cfif arrayLen( local.topMenu.subMenu )>
					<ul class="nav-sub">
					<cfloop array="#local.topMenu.submenu#" index="local.thisSubMenu">
						<!--- Security --->
						<cfif !len( local.thisSubMenu.permissions ) OR prc.oCurrentAuthor.checkPermission( local.thisSubMenu.permissions )>
							<li
								class="<cfif event.getPrivateValue( "tab#local.topMenu.name#_#local.thisSubMenu.name#", false )>active </cfif>#local.thisSubMenu.class#"
								data-name="#local.thisSubMenu.name#"
							>

								<a
									href="#( isCustomFunction( local.thisSubMenu.href ) ? local.thisSubMenu.href( local.thisSubMenu, event ) : local.thisSubMenu.href )#"
									<cfif len( local.thisSubMenu.title )>title="#local.thisSubMenu.title#"</cfif>
									<cfif len( local.thisSubMenu.target )>target="#local.thisSubMenu.target#"</cfif>
									<cfif structKeyExists( local.thisSubMenu, "data" ) && structCount( local.thisSubMenu.data )>#parseADataAttributes( local.thisSubMenu.data )#</cfif>
								>
									#( isCustomFunction( local.thisSubMenu.label ) ? local.thisSubMenu.label() : local.thisSubMenu.label )#
								</a>

							</li>
						</cfif>
					</cfloop>
					</ul>
				</cfif>
			</li>
		</cfif>

	</cfloop>
</ul>
</cfoutput>