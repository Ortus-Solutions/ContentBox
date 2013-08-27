<cfoutput>
<div class="navbar navbar-fixed-top navbar-inverse" id="adminMenuBar">
	<div class="navbar-inner">
		<div class="container">
		
			<a class="btn btn-navbar" data-toggle="collapse" data-target="##adminMenuBarContent">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</a>	
			<div class="nav-collapse collapse" id="adminMenuBarContent">
			 	<ul class="nav">
					<!--- Loop over Top Menus --->
					<cfloop array="#menu#" index="local.topMenu">
						<cfif !len(local.topMenu.permissions) OR prc.oAuthor.checkPermission( local.topMenu.permissions )>
						<li class="dropdown<cfif event.getValue(name='tab#local.topMenu.name#',defaultValue=false,private=true)> active</cfif>">
							<a href="#local.topMenu.href#" class="dropdown-toggle" <cfif arrayLen( local.topMenu.subMenu )>data-toggle="dropdown"</cfif><!---
							---><cfif len(local.topMenu.title)> title="#local.topMenu.title#"</cfif><!---
							---><cfif len(local.topMenu.target)> target="#local.topMenu.target#"</cfif><!---
							----><cfif structKeyExists( local.topMenu, "data" ) && structCount( local.topMenu.data )>#parseADataAttributes( local.topMenu.data )#</cfif>>#local.topMenu.label# <cfif arrayLen( local.topMenu.subMenu )><i class="caret"></i></cfif></a>
							<!--- Do we have submenus --->
							<cfif arrayLen(local.topMenu.subMenu)>
							<ul class="dropdown-menu">
							<cfloop array="#local.topMenu.submenu#" index="local.thisSubMenu">
								<!--- Security --->
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
							</cfif>
						</li>
						</cfif>
					</cfloop>
				</ul>
				<ul class="nav pull-right" id="sidebar-toggle" data-stateurl="#HTMLEditFormat( event.buildLink( prc.xehAuthorSideBar ) )#">
					<li title="(ctrl+shift+e)" data-placement="bottom"><a href="javascript:toggleSidebar()"><i class="icon-collapse-alt icon-large" id="sidebar_trigger"></i> Sidebar</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>
</cfoutput>