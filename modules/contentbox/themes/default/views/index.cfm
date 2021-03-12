<cfoutput>
<cfset bodyHeaderStyle = "">
<cfset bodyHeaderH1Style = "">
<cfif cb.themeSetting( 'overrideHeaderColors' )>
	<cfif len( cb.themeSetting( 'overrideHeaderBGColor' ) )>
		<cfset bodyHeaderStyle = bodyHeaderStyle & 'background-color: ' & cb.themeSetting( 'overrideHeaderBGColor' ) & ';'>
	</cfif>

	<cfif len( cb.themeSetting( 'overrideHeaderTextColor' ) )>
		<cfset bodyHeaderH1Style = bodyHeaderH1Style & 'color: ' & cb.themeSetting( 'overrideHeaderTextColor' ) & ';'>
	</cfif>
</cfif>
<div id="body-header" style="#bodyHeaderStyle#">
	<div class="container">
		<!--- Title --->
		<div class="underlined-title">
			<h1 style="#bodyHeaderH1Style#">Blog</h1>
		</div>
	</div>
</div>

<!--- Body Main --->
<section id="body-main">
	<div class="container">
		<div class="row">
			<!--- Content --->
			<div class="col-sm-9">

				<!--- ContentBoxEvent --->
				#cb.event( "cbui_preIndexDisplay" )#

				<!--- Are we filtering by category? --->
				<cfif len( rc.category )>
					<p class="infoBar">
						Category Filtering: '#encodeForHTML( rc.category )#'
					</p>
					<p class="buttonBar">
						<a href="#cb.linkBlog()#" class="btn btn-info" title="Remove filter and view all entries">Remove Filter</a>
					</p>
					<br/>
				</cfif>

				<!--- Are we searching --->
				<cfif len( rc.q )>
					<p class="buttonBar">
						<a class="btn btn-primary" href="#cb.linkBlog()#" title="Clear search and view all entries">Clear Search</a>
					</p>
					<div class="infoBar">
						Searching by: '#encodeForHTML( rc.q )#'
					</div>
					<br/>
				</cfif>

				<!--- Entries displayed here --->
				#cb.quickEntries()#

				<!--- Pagination --->
				<cfif prc.entriesCount>
					<div class="contentBar">
						#cb.quickPaging()#
					</div>
				</cfif>

				<!--- ContentBoxEvent --->
				#cb.event( "cbui_postIndexDisplay" )#
			</div>

			<!--- SideBar --->
			<cfif args.sidebar>
				<div class="col-sm-3" id="blog-sidenav">
					#cb.quickView( view='_blogsidebar', args=args )#
				</div>
			</cfif>

		</div>
	</div>
</section>
</cfoutput>