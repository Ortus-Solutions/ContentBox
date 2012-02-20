<cfoutput>
<!--- ContentBoxEvent --->
#cb.event("cbui_BeforeSideBar")#

<!--- Search Form --->
<h2>Entry Search</h2>
#cb.widget(name="SearchForm",args={type="blog"})#

<!--- Categories --->
<h2>Categories</h2>
<div class="bg"></div>
	
<!--- 
	Display Categories using ContentBox collection template rendering
	the default convention for the template is "category.cfm" you can change it via the quickCategories() 'template' argument.
	I could have done it manually, but again, why?
 --->
#cb.quickCategories()#

<br/>

<h2>Recent Entries</h2>
<div class="bg"></div>
#cb.widget('RecentEntries')#

#cb.widget("Meta")#

<h2>Archives</h2>
<div class="bg"></div>
#cb.widget('Archives')#

<br/>

<!--- RSS Buttons --->
<button class="button" onclick="return to('#cb.linkRSS()#')" title="Subscribe to our RSS Feed!"><img class="topAligned" src="#cb.layoutRoot()#/includes/images/feed.png" alt="feed" /> Site Updates</button>	
<!--- RSS Entry Comments --->
<cfif cb.isEntryView()>
<button class="button" onclick="return to('#cb.linkRSS(comments=true,entry=prc.entry)#')" title="Subscribe to our Entry's Comment(s) RSS Feed!"><img class="topAligned" src="#cb.layoutRoot()#/includes/images/feed.png" alt="feed" /> Entry Comments</button>	
</cfif>

<br/><br/>

<!--- ContentBoxEvent --->
#cb.event("cbui_afterSideBar")#
</cfoutput>