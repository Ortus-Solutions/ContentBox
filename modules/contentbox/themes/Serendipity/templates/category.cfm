<cfoutput>
	<!--- Mini RSS --->
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
			class="badge badge-category"
		>
			#category.getCategory()# (#category.getNumberOfPublishedEntries()#)
		</a>
		
</cfoutput>
