<cfoutput>
	<!--- Mini RSS --->
	<li><a class="floatRight" href="#cb.linkRSS(category=category)#" title="RSS Feed For #category.getCategory()#"><i class="fa fa-rss"></i></a>
	<!--- Category --->
	<a href="#cb.linkCategory(category)#" title="Filter by #category.getCategory()#">#category.getCategory()# (#category.getNumberOfEntries()#)</a></li>
</cfoutput>