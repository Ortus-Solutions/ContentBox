<cfoutput>
<!--- ContentBoxEvent --->
#cb.event("cbui_BeforeSideBar")#

<!--- Categories --->
<h4>Categories</h4>
<div class="bg"></div>
	
<!--- 
	Display Categories using ContentBox collection template rendering
	the default convention for the template is "category.cfm" you can change it via the quickCategories() 'template' argument.
	I could have done it manually, but again, why?
 --->
#cb.quickCategories()#

<br/>

<h4>Description</h4>
<div class="bg"></div>
<p>#cb.siteDescription()#</p>

#cb.widget("Meta",{titleLevel="4"})#

<h4>Recent Entries</h4>
<div class="bg"></div>
#cb.widget('RecentEntries')#

<h4>Entries Search</h4>
<div class="bg"></div>
#cb.widget(name="SearchForm",args={type="blog"})#
<br/>

<h4>Archives</h4>
<div class="bg"></div>
#cb.widget("Archives")#
<br/>

<!--- RSS Buttons --->
<button class="button" onclick="return to('#cb.linkRSS()#')" title="Subscribe to our Blog RSS Feed!"><img class="topAligned" src="#cb.layoutRoot()#/includes/images/feed.png" alt="feed" /> Blog Updates</button>	
<!--- RSS Entry Comments --->
<cfif cb.isEntryView()>
<button class="button" onclick="return to('#cb.linkRSS(comments=true,entry=prc.entry)#')" title="Subscribe to our Entry's Comment(s) RSS Feed!"><img class="topAligned" src="#cb.layoutRoot()#/includes/images/feed.png" alt="feed" /> Entry Comments</button>	
</cfif>

<!--- ContentBoxEvent --->
#cb.event("cbui_afterSideBar")#
</cfoutput>