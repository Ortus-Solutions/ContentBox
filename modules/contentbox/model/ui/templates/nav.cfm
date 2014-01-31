<cfoutput>
<!--- Loop over Top Menus --->
<cfloop array="#local.thisMenu#" index="local.topMenu">
	<cfif !len( local.topMenu.permissions ) OR prc.oAuthor.checkPermission( local.topMenu.permissions )>
	<li class="dropdown<cfif event.getValue(name='tab#local.topMenu.name#',defaultValue=false,private=true)> active</cfif>#local.topMenu.class#" data-name="#local.topMenu.name#">
		<a href="#( isCustomFunction( local.topMenu.href ) ? local.topMenu.href() : local.topMenu.href )#" class="dropdown-toggle" <cfif arrayLen( local.topMenu.subMenu )>data-toggle="dropdown"</cfif><!---
		---><cfif len( local.topMenu.title )> title="#local.topMenu.title#"</cfif><!---
		---><cfif len( local.topMenu.target )> target="#local.topMenu.target#"</cfif><!---
		----><cfif structKeyExists( local.topMenu, "data" ) && structCount( local.topMenu.data )>#parseADataAttributes( local.topMenu.data )#</cfif>>#( isCustomFunction( local.topMenu.label ) ? local.topMenu.label() : local.topMenu.label )# <cfif arrayLen( local.topMenu.subMenu )><i class="caret"></i></cfif></a>
		<!--- Do we have submenus --->
		<cfif arrayLen( local.topMenu.subMenu )>
		<ul class="dropdown-menu">
		<cfloop array="#local.topMenu.submenu#" index="local.thisSubMenu">
			<!--- Security --->
			<cfif !len(local.thisSubMenu.permissions) OR prc.oAuthor.checkPermission( local.thisSubMenu.permissions )>
			<li class="<cfif event.getValue(name="tab#local.topMenu.name#_#local.thisSubMenu.name#",defaultValue=false,private=true)>active</cfif>#local.thisSubMenu.class#" data-name="#local.thisSubMenu.name#">
				<a href="#( isCustomFunction( local.thisSubMenu.href ) ? local.thisSubMenu.href() : local.thisSubMenu.href )#"<!---
				---><cfif len(local.thisSubMenu.title)> title="#local.thisSubMenu.title#"</cfif><!---
				---><cfif len(local.thisSubMenu.target)> target="#local.thisSubMenu.target#"</cfif><!---
				----><cfif structKeyExists( local.thisSubMenu, "data" ) && structCount( local.thisSubMenu.data )>#parseADataAttributes( local.thisSubMenu.data )#</cfif>>#( isCustomFunction( local.thisSubMenu.label ) ? local.thisSubMenu.label() : local.thisSubMenu.label )#</a>
			</li>
			</cfif>
		</cfloop>
		</ul>
		</cfif>
	</li>
	</cfif>
</cfloop>
</cfoutput>