﻿<cfoutput>
<cfif category.getNumberOfEntries()>
<div class="categoryList">
	<!--- mini rss --->
	<a class="floatRight" href="#cb.linkRSS(category=category)#" title="RSS Feed For #category.getCategory()#"><img src="#cb.themeRoot()#/includes/images/mini-rss.gif" alt="rss" border="0"/></a>
	<!--- Category --->
	<img src="#cb.themeRoot()#/includes/images/tag_blue.png" alt="Category" /> 
	<a href="#cb.linkCategory(category)#" title="Filter by #category.getCategory()#">#category.getCategory()# (#category.getNumberOfEntries()#)</a>
</div>
</cfif>
</cfoutput>