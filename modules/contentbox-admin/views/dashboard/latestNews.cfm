<cfoutput>
#html.anchor(name="recentNews" )#
<cfif prc.latestNews.items.recordCount>
	<h3><i class="icon-rss"></i> Recent News</h3>
	<cfloop query="prc.latestNews.items" endrow="5">
		<div class="box padding10">
			<h4><a href="#prc.latestNews.items.URL#" target="_blank">#prc.latestNews.items.title#</a></h4>
			<div><p><strong>#dateFormat( prc.latestNews.items.datepublished, "full" )#</strong></p></div>
			<p>#left( cb.stripHTML( prc.latestNews.items.body ), 500 )#...</p>
		</div>
	</cfloop>
</cfif>
</cfoutput>