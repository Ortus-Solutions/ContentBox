<section id="body-main">
	<div class="container">
	<h1>Sitemap</h1>
<cfoutput>
	<ul>
		<li>
			<a href="#prc.linkHome#">Home</a>
		</li>
		
		<cfloop array="#prc.aPages#" index="content">
			<li>
				<a href="#prc.siteBaseURL##content[ 'slug' ]#">#content[ 'title' ]#</a>
			</li>
		</cfloop>

		<cfif !prc.disableBlog>				
		<li><a href="#prc.siteBaseURL##prc.blogEntryPoint#">#left( prc.blogEntryPoint, -1 )#</a>
			<ul>
				<cfloop array="#prc.aEntries#" index="content">
					<li>
						<a href="#prc.siteBaseURL##prc.blogEntryPoint##content[ 'slug' ]#">#content[ 'title' ]#</a>
					</li>
				</cfloop>
			</ul>
		</li>
	</cfif>
	</ul> 	
</cfoutput>
</div>
</section>