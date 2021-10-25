<cfoutput>
	<nav class="navbar navbar-expand-lg bg-white navbar-light shadow-sm" id="header-main">
		<div class="container">
			<div class="navbar-brand" >
				<cfif cb.themeSetting( 'headerLogo' ) is "">
					<a href="#cb.linkHome()#" class="navbar-brand" title="#cb.siteTagLine()#" data-toggle="tooltip"><strong>#cb.siteName()#</strong></a>
				<cfelse>
					<a href="#cb.linkHome()#" class="navbar-brand brand-img" title="#cb.siteTagLine()#" data-toggle="tooltip"><img src="#cb.themeSetting( 'headerLogo' )#" alt="#cb.siteName()#"></a>
				</cfif>
				<button type="button" id="cb-navbar-toggle" class="navbar-toggler" data-toggle="collapse" data-target="##cb-nav-collapse" aria-controls="cb-nav-collapse" aria-expanded="false" aria-label="Toggle navigation">
					<span class="sr-only">Toggle navigation</span>
					<svg xmlns="http://www.w3.org/2000/svg" width="10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
					</svg>
				</button>
			</div>
	
			<!--- Generate Menu --->
			
			<div class="collapse navbar-collapse" id="cb-nav-collapse">
				<ul class="navbar-nav ml-auto mb-2 mb-lg-0">
					<cfset menuData = cb.rootMenu( type="data", levels="2" )>
					<!--- Iterate and build pages --->
					<cfloop array="#menuData#" index="menuItem">
						<cfif structKeyExists( menuItem, "subPageMenu" )>
							<li class="nav-item dropdown">
								<a href="#menuItem.link#" class="nav-link dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
									#menuItem.title#
								</a>
								#buildSubMenu( menuData=menuItem.subPageMenu, parentLink=menuItem.link, parentTitle=menuItem.title )#
							</li>
						<cfelse>
							<li class="nav-item">
								<cfif cb.isPageView() AND event.buildLink( cb.getCurrentPage().getSlug() ) eq menuItem.link>
									<a class="nav-link active"  href="#menuItem.link#">#menuItem.title#</a>
								<cfelse>
									<a class="nav-link"  href="#menuItem.link#">#menuItem.title#</a>
								</cfif>
							</li>
						</cfif>
					</cfloop>
	
					<!--- Blog Link, verify active --->
					<cfif ( prc.oCurrentSite.getIsBlogEnabled() )>
						<li class="nav-item">
							<cfif cb.isBlogView()>
								<a class="nav-link active" href="#cb.linkBlog()#">Blog</a>
							<cfelse>
								<a class="nav-link" href="#cb.linkBlog()#">Blog</a>
							</cfif>
						</li>
					</cfif>
				</ul>
				
			</div>
			<cfif cb.themeSetting( "showSiteSearch", true )>
				<!--- Search Bar --->
				<div id="body-search">
					<form id="searchForm" name="searchForm" method="post" action="#cb.linkContentSearch()#">
						<div class="input-group">
							<input type="hidden" class="form-control" placeholder="Search" name="q" id="q" value="#cb.getSearchTerm()#" />

							<button type="submit" class="btn nav-link" onmouseover="document.getElementById( 'q' ).type = 'text'">
								<svg fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" width="20" >
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
								</svg>
							</button>
						</div>
					</form>
				</div>
			</cfif>
		</div>
	</nav>
	
	<cfscript>
	any function buildSubMenu( required menuData, required parentLink, required parentTitle ){
		var menu = '<ul class="dropdown-menu" aria-labelledby="#parentTitle#">';
	
		for( var menuItem in arguments.menuData ){
			if( !structKeyExists( menuItem, "subPageMenu" ) ){
				menu &= '<li><a class="dropdown-item" href="#menuItem.link#">#menuItem.title#</a></li>';
			} else {
				menu &= '<li class="dropdown-submenu"><a href="#menuItem.link#" class="dropdown-toggle" data-toggle="dropdown">#menuItem.title#</a>';
				menu &= buildSubMenu( menuItem.subPageMenu, menuItem.link, menuItem.parentTitle );
				menu &= '</li>';
			}
		}
		menu &= '</ul>';
	
		return menu;
	}
	</cfscript>
</cfoutput>
	