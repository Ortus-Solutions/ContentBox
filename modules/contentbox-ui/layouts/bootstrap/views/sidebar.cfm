<cfoutput>
<!--- ContentBoxEvent --->
#cb.event("cbui_BeforeSideBar")#

<ul class="nav nav-list">
	<li class="nav-header">
	Description
	</li>
	<li><!---#cb.siteDescription()#--->My really cool blog.</li>
	<li class="nav-header">
	Categories
	</li>
	<!--- 
	Display Categories using ContentBox collection template rendering
	the default convention for the template is "category.cfm" you can change it via the quickCategories() 'template' argument.
	I could have done it manually, but again, why?
	--->
	#cb.quickCategories()#
	<li class="nav-header" style="padding-top:10px;">Recent Entries</li>
	#cb.widget('RecentEntries')#
	
	<!--- RSS Buttons --->
	<li class="nav-header" style="padding-top:10px;">Site Updates</li>
	<li><a onclick="return to('#cb.linkRSS()#')" title="Subscribe to our RSS Feed!"><img class="topAligned" src="#cb.layoutRoot()#/includes/images/mini-rss.gif" alt="feed" /> RSS Feed</a></li>
	
	<cfif cb.isEntryView()>
	<!--- RSS Entry Comments --->
	<li class="nav-header" style="padding-top:10px;">Entry Comments</li>
	<li><a onclick="return to('#cb.linkRSS(comments=true,entry=prc.entry)#')" title="Subscribe to our Entry's Comment(s) RSS Feed!"><img class="topAligned" src="#cb.layoutRoot()#/includes/images/feed.png" alt="feed" /> RSS Feed</a></li>
	</cfif>
	
	<li class="nav-header">Archives</li>
	#cb.widget("Archives")#
	
	<li class="nav-header" style="padding-top:10px;">Entries Search</li>
	#cb.widget("SearchForm")#
	
	<!---#cb.widget("Meta",{titleLevel="4"})#--->
	
</ul> 

<!--- ContentBoxEvent --->
#cb.event("cbui_afterSideBar")#
</cfoutput>