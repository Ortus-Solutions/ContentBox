﻿<cfoutput>
<nav class="navbar navbar-default" id="header-main">
	<div class="container">

		<div class="navbar-header" >
			<button type="button" id="cb-navbar-toggle" class="navbar-toggle collapsed" data-toggle="collapse" data-target="##cb-nav-collapse">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a href="#cb.linkHome()#" class="navbar-brand" title="#cb.siteTagLine()#" data-toggle="tooltip"><strong>#cb.siteName()#</strong></a>
		</div>

		<!--- Generate Menu --->
		<div class="collapse navbar-collapse" id="cb-nav-collapse">
			<ul class="nav navbar-nav navbar-right">
				<cfset menuData = cb.rootMenu( type="data", levels="2" )>

				<!--- Iterate and build pages --->
				<cfloop array="#menuData#" index="menuItem">
					<cfif structKeyExists( menuItem, "subPageMenu" )>
						<li class="dropdown">
							<a href="#menuItem.link#" class="dropdown-toggle" data-toggle="dropdown">#menuItem.title# <b class="caret"></b></a>
							#buildSubMenu( menuItem.subPageMenu )#
						</li>
					<cfelse>
						<cfif cb.isPageView() AND event.buildLink( cb.getCurrentPage().getSlug() ) eq menuItem.link>
							<li class="active">
						<cfelse>
							<li>
						</cfif>
							<a href="#menuItem.link#">#menuItem.title#</a>
						</li>
					</cfif>
				</cfloop>

				<!--- Blog Link, verify active --->
				<cfif ( !prc.cbSettings.cb_site_disable_blog )>
					<cfif cb.isBlogView()><li class="active"><cfelse><li></cfif>
						<a href="#cb.linkBlog()#">Blog</a>
					</li>
				</cfif>
			</ul>

			<!--- Blog Search Form ---
			<cfif ( !prc.cbSettings.cb_site_disable_blog )>
				<form id="searchForm" class="navbar-form navbar-right" name="searchForm" method="post" action="#cb.linkSearch()#">
					<input type="text" class="form-control col-lg-8" placeholder="Search">
				</form>
			</cfif>--->
		</div>
	</div>
</nav>

<!--- Search Bar --->
<div id="body-search">
	<div class="container">
		<form id="searchForm" name="searchForm" method="post" action="#cb.linkContentSearch()#">
			<div class="input-group">
				<input type="text" class="form-control" placeholder="Enter search terms..." name="q" id="q" value="#cb.getSearchTerm()#">
				<span class="input-group-btn">
					<button type="submit" class="btn btn-default">Search</button>
				</span>
			</div>
		</form>
	</div>
</div>

<cfscript>
any function buildSubMenu( required menuData ){
	var menu = '<ul class="dropdown-menu">';
	for( var menuItem in arguments.menuData ){
		if( !structKeyExists( menuItem, "subPageMenu" ) ){
			menu &= '<li><a href="#menuItem.link#">#menuItem.title#</a></li>';
		} else {
			menu &= '<li class="dropdown-submenu"><a href="#menuItem.link#" class="dropdown-toggle" data-toggle="dropdown">#menuItem.title#</a>';
			menu &= buildSubMenu( menuItem.subPageMenu );
			menu &= '</li>';
		}
	}
	menu &= '</ul>';

	return menu;
}
</cfscript>
</cfoutput>