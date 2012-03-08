<cfoutput>
<ul id="main_nav">
	<!--- Loop over Top Menus --->
	<cfloop array="#menu#" index="local.topMenu">
		<cfif !len(local.topMenu.permissions) OR prc.oAuthor.checkPermission( local.topMenu.permissions )>
		<li>
			<a href="#local.topMenu.href#"<!---
			---><cfif len(local.topMenu.title)> title="#local.topMenu.title#"</cfif><!---
			---><cfif len(local.topMenu.target)> target="#local.topMenu.target#"</cfif><!---
			---><cfif event.getValue(name="tab#local.topMenu.name#",defaultValue=false,private=true)> class="current"</cfif>>#local.topMenu.label#</a>
			<!--- Do we have submenus --->
			<cfif arrayLen(local.topMenu.subMenu)>
			<ul>
			<cfloop array="#local.topMenu.submenu#" index="local.thisSubMenu">
				<!--- Security --->
				<cfif !len(local.thisSubMenu.permissions) OR prc.oAuthor.checkPermission( local.thisSubMenu.permissions )>
				<li>
					<a href="#local.thisSubMenu.href#"<!---
					---><cfif len(local.thisSubMenu.title)> title="#local.thisSubMenu.title#"</cfif><!---
					---><cfif len(local.thisSubMenu.target)> target="#local.thisSubMenu.target#"</cfif><!---
					---><cfif event.getValue(name="tab#local.topMenu.name#_#local.thisSubMenu.name#",defaultValue=false,private=true)> class="current"</cfif>>#local.thisSubMenu.label#</a>
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