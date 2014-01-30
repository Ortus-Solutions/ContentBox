<cfoutput>
<ul class="dropdown-menu" id="main-profile-menu">
<cfloop array="#local.topMenu.submenu#" index="local.thisSubMenu">
	<cfif !len(local.thisSubMenu.permissions) OR prc.oAuthor.checkPermission( local.thisSubMenu.permissions )>
	<li class="<cfif event.getValue(name="tab#local.topMenu.name#_#local.thisSubMenu.name#",defaultValue=false,private=true)>active</cfif>">
		<a href="#local.thisSubMenu.href#"<!---
		---><cfif len(local.thisSubMenu.title)> title="#local.thisSubMenu.title#"</cfif><!---
		---><cfif len(local.thisSubMenu.target)> target="#local.thisSubMenu.target#"</cfif><!---
		----><cfif structKeyExists( local.thisSubMenu, "data" ) && structCount( local.thisSubMenu.data )>#parseADataAttributes( local.thisSubMenu.data )#</cfif>>#local.thisSubMenu.label#</a>
	</li>
	</cfif>
</cfloop> 
</ul>
</cfoutput>