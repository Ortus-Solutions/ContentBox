<cfoutput>
<div class="categoryList">
	<!--- mini rss --->
	<a class="floatRight" href="#bb.linkRSS(category=category)#" title="RSS Feed For #category.getCategory()#"><img src="#bb.layoutRoot()#/includes/images/mini-rss.gif" alt="rss" border="0"/></a>
	<!--- Category --->
	<img src="#bb.layoutRoot()#/includes/images/tag_blue.png" alt="Category" /> 
	<a href="#bb.linkCategory(category)#" title="Filter by #category.getCategory()#">#category.getCategory()# (#category.getNumberOfEntries()#)</a>
</div>
</cfoutput>