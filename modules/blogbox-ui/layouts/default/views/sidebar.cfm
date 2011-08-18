<cfoutput>
<!--- BlogBoxEvent --->
#bb.event("bbui_BeforeSideBar")#

<!--- Categories --->
<h4>Categories</h4>
<div class="bg"></div>
	
<!--- 
	Display Categories using BlogBox collection template rendering
	the default convention for the template is "category.cfm" you can change it via the quickCategories() 'template' argument.
	I could have done it manually, but again, why?
 --->
#bb.quickCategories()#

<br/>

<h4>Description</h4>
<div class="bg"></div>
<p>#bb.siteDescription()#</p>

<h4>Recent Entries</h4>
<div class="bg"></div>
#bb.widget('RecentEntries')#

<h4>Entries Search</h4>
<div class="bg"></div>
#bb.widget("SearchForm")#
<br/>

<!--- RSS Buttons --->
<button class="button" onclick="return to('#bb.linkRSS()#')" title="Subscribe to our RSS Feed!"><img class="topAligned" src="#bb.layoutRoot()#/includes/images/feed.png" alt="feed" /> Site Updates</button>	
<!--- RSS Entry Comments --->
<cfif bb.isEntryView()>
<button class="button" onclick="return to('#bb.linkRSS(comments=true)#')" title="Subscribe to our RSS Feed!"><img class="topAligned" src="#bb.layoutRoot()#/includes/images/feed.png" alt="feed" /> Entry Comments</button>	
</cfif>

<!--- BlogBoxEvent --->
#bb.event("bbui_afterSideBar")#
</cfoutput>