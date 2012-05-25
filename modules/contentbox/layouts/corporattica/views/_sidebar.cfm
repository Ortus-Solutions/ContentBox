<cfoutput>
<!--- ContentBoxEvent --->
#cb.event("cbui_BeforeSideBar")#

<div class="news">
	<h4>Blog Search</h4>
	<div class="bg"></div>
	#cb.widget(name="SearchForm",args={type="blog",label=""})#
	<br/>
</div>

<!--- Categories --->
<div class="news">
<h4>Categories</h4>
<!---
	Display Categories using ContentBox collection template rendering
	the default convention for the template is "category.cfm" you can change it via the quickCategories() 'template' argument.
	I could have done it manually, but again, why?
 --->
#cb.quickCategories()#
<br/>
</div>

<div class="news">
<h4>Recent Entries</h4>
#cb.widget('RecentEntries')#
<br/>
</div>

<div class="news">
<h4>Recent Comments</h4>
#cb.widget('RecentComments')#
<br/>

</div>

<div class="news">
<h4>Archives</h4>
#cb.widget("Archives")#
<br/>
</div>
<!--- RSS Buttons --->
<button class="button" onclick="return to('#cb.linkRSS()#')" title="Subscribe to our Blog RSS Feed!"><img class="topAligned" src="#cb.layoutRoot()#/includes/images/mini-rss.png" alt="feed" /> Blog Updates</button>
<!--- RSS Entry Comments --->
<cfif cb.isEntryView()>
<button class="button" onclick="return to('#cb.linkRSS(comments=true,entry=prc.entry)#')" title="Subscribe to our Entry's Comment(s) RSS Feed!"><img class="topAligned" src="#cb.layoutRoot()#/includes/images/mini-rss.png" alt="feed" /> Entry Comments</button>
</cfif>

<!--- ContentBoxEvent --->
#cb.event("cbui_afterSideBar")#
</cfoutput>