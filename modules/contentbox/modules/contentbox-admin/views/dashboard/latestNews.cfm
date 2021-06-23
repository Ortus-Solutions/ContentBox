<cfoutput>
#html.anchor( name="recentNews" )#
<cfif prc.latestNews.items.recordCount>
	<cfloop query="prc.latestNews.items" endrow="5">
		<div class="box p10">
			<h4>
				<a href="#prc.latestNews.items.URL#" target="_blank">
					<i class="fa fa-external-link"></i> #prc.latestNews.items.title#
				</a>
			</h4>

			<div>
				<p class="label label-success"><strong>#dateFormat( prc.latestNews.items.datepublished, "full" )#</strong></p>
			</div>

			<p>
				#left( encodeForHTML( prc.latestNews.items.body ), 500 )#...
			</p>
		</div>
	</cfloop>
</cfif>
</cfoutput>