<cfoutput>
	<!--- Mini RSS --->
	<li>
		<a
			class="float-right"
			href="#cb.linkRSS( category=category )#"
			title="RSS Feed For #category.getCategory()#"
		>
			<i class="fa fa-rss"></i>
		</a>
		<!--- Category --->
		<a
			href="#cb.linkCategory( category )#"
			title="Filter by #category.getCategory()#"
		>
			#category.getCategory()# (#category.getNumberOfPublishedEntries()#)
		</a>
	</li>
</cfoutput>