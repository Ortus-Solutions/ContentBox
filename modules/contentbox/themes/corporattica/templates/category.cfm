﻿<cfoutput>
<cfif category.getNumberOfEntries()>
<div class="categoryList">
	<!--- mini rss --->
	<a href="#cb.linkRSS(category=category)#" title="RSS Feed For #category.getCategory()#"><img src="#cb.themeRoot()#/includes/images/mini-rss.png" alt="rss" border="0"/></a>
	<!--- Category --->
	<img src="#cb.themeRoot()#/includes/images/category_black.png" alt="Category" />
	<a href="#cb.linkCategory(category)#" title="Filter by #category.getCategory()#">#category.getCategory()# (#category.getNumberOfEntries()#)</a>
</div>
</cfif>
</cfoutput>