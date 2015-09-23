<cfoutput>
<header id="header-main" class="navbar">
	<div class="container">

		<div class="navbar-header" >
			<button type="button" id="cb-navbar-toggle" class="navbar-toggle collapsed" data-toggle="collapse" data-target="##cb-nav-collapse">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a href="#cb.linkHome()#" class="navbar-brand" title="#cb.siteTagLine()#" data-toggle="tooltip">#cb.siteName()#</a>
		</div>

		<!--- Generate Menu --->
		#cb.quickView( '_menu' )#
	</div>
</header>
</cfoutput>