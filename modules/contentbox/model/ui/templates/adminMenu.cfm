<cfoutput>
<ul id="main_nav">
	<!--- Loop over Top Menus --->
	<cfloop array="#menu#" index="local.thisMenu">
		<cfif !len(local.thisMenu.permissions) OR prc.oAuthor.checkPermission( local.thisMenu.permissions )>
		<li>
			<a href="#local.thisMenu.href#"<!---
			---><cfif len(local.thisMenu.title)> title="#local.thisMenu.title#"</cfif><!---
			---><cfif len(local.thisMenu.target)> target="#local.thisMenu.target#"</cfif><!---
			---><cfif event.getValue("tab#local.thisMenu.name#",false,true)> class="current"</cfif>>#local.thisMenu.label#</a>
			<!--- Do we have submenus --->
			<cfif arrayLen(local.thisMenu.subMenu)>
			<ul>
			<cfloop array="#local.thisMenu.submenu#" index="local.thisSubMenu">
				<!--- Security --->
				<cfif !len(local.thisSubMenu.permissions) OR prc.oAuthor.checkPermission( local.thisSubMenu.permissions )>
				<li>
					<a href="#local.thisSubMenu.href#"<!---
					---><cfif len(local.thisSubMenu.title)> title="#local.thisSubMenu.title#"</cfif><!---
					---><cfif len(local.thisSubMenu.target)> target="#local.thisSubMenu.target#"</cfif><!---
					---><cfif event.getValue("tab#local.thisMenu.name#_#local.thisSubMenu.name#",false,true)> class="current"</cfif>>#local.thisSubMenu.label#</a>
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