<cfoutput>
	<ul class="nav">
	  #cb.rootMenu(type="li")#
	  <li><a href="#event.buildLink('blog')#">Blog</a></li>
	</ul>
	<!--- Blog Search Form --->
	<form id="searchForm" class="navbar-search pull-left" name="searchForm" method="post" action="#cb.linkSearch()#">
		<input type="text" class="search-query span2" placeholder="Search">
	</form>
	<!--- Admin Links --->
	<ul class="nav pull-right">
		<li class="divider-vertical"></li>
		<li class="dropdown">
			<a href="##" class="dropdown-toggle" data-toggle="dropdown">Logged in as username<b class="caret"></b></a>
			<ul class="dropdown-menu">
				<li><a href="#event.buildlink('cbadmin')#">Site Admin</a></li>
		 		<li><a href="#event.buildlink('cbadmin.security.dologout')#">Logout</a></li>
	
			</ul>
		</li>
	</ul>
</cfoutput>

