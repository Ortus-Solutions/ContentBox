<cfoutput>
<!--- BlogBoxEvent --->
#bb.event("bbui_BeforeSideBar")#

<!--- Search Form --->
<h2>Entry Search</h2>
#bb.widget("SearchForm")#

<!--- Categories --->
<h2>Categories</h2>
<div class="bg"></div>
	
<!--- 
	Display Categories using BlogBox collection template rendering
	the default convention for the template is "category.cfm" you can change it via the quickCategories() 'template' argument.
	I could have done it manually, but again, why?
 --->
#bb.quickCategories()#

<br/>

<h2>Recent Entries</h2>
<div class="bg"></div>
#bb.widget('RecentEntries')#

<h2>Archives</h2>
<div class="bg"></div>
#bb.widget('Archives')#

<br/>

<!--- RSS Buttons --->
<button class="button" onclick="return to('#bb.linkRSS()#')" title="Subscribe to our RSS Feed!"><img class="topAligned" src="#bb.layoutRoot()#/includes/images/feed.png" alt="feed" /> Site Updates</button>	
<!--- RSS Entry Comments --->
<cfif bb.isEntryView()>
<button class="button" onclick="return to('#bb.linkRSS(comments=true)#')" title="Subscribe to our RSS Feed!"><img class="topAligned" src="#bb.layoutRoot()#/includes/images/feed.png" alt="feed" /> Comments</button>	
</cfif>

<br/><br/>

<!--- BlogBoxEvent --->
#bb.event("bbui_afterSideBar")#
</cfoutput>