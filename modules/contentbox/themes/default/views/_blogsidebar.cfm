<cfoutput>
<!--- ContentBoxEvent --->
#cb.event( "cbui_BeforeSideBar" )#

<cfif cb.themeSetting( "showCategoriesBlogSide", true )>
	<div class="panel panel-default">
		<div class="panel-heading">
			<h4>Categories</h4>
		</div>
		<!---
		Display Categories using ContentBox collection template rendering
		the default convention for the template is "category.cfm" you can change it via the quickCategories() 'template' argument.
		--->
		<ul>
			#cb.quickCategories()#
		</ul>
	</div>
</cfif>

<cfif cb.themeSetting( "showRecentEntriesBlogSide", true )>
	<div class="panel panel-default">
		<div class="panel-heading">
			<h4>Recent Entries</h4>
		</div>
		#cb.widget( 'RecentEntries' )#
	</div>
</cfif>

<cfif cb.themeSetting( "showSiteUpdatesBlogSide", true )>
	<!--- RSS Buttons --->
	<div class="panel panel-default">
		<div class="panel-heading">
			<h4>Site Updates</h4>
		</div>
		<ul>
			<li><a href='#cb.linkRSS()#' title="Subscribe to our RSS Feed!"><i class="fa fa-rss"></i></a> <a href='#cb.linkRSS()#' title="Subscribe to our RSS Feed!">RSS Feed</a></li>
		</ul>
	</div>
</cfif>

<cfif cb.isEntryView()>
	<cfif cb.themeSetting( "showEntryCommentsBlogSide", true )>
	<!--- RSS Entry Comments --->
	<div class="panel panel-default">
		<div class="panel-heading">
			<h4>Entry Comments</h4>
		</div>
		<ul>
			<li>
				<a
					href="#cb.linkRSS( comments=true, entry=prc.entry )#"
					title="Subscribe to our Entry's Comment(s) RSS Feed!"
				>
					<i class="fa fa-rss"></i>
				</a>
				<a
					href="#cb.linkRSS(comments=true,entry=prc.entry)#"
					title="Subscribe to our Entry's Comment(s) RSS Feed!"
				>
					RSS Feed
				</a>
			</li>
		</ul>
	</div>
	</cfif>
</cfif>

<cfif cb.themeSetting( "showArchivesBlogSide", true )>
	<div class="panel panel-default">
		<div class="panel-heading">
			<h4>Archives</h4>
		</div>
		#cb.widget( "Archives" )#
	</div>
</cfif>

<cfif cb.themeSetting( "showEntriesSearchBlogSide", true )>
	<div class="panel panel-default">
		<div class="panel-heading">
			<h4>Entries Search</h4>
		</div>
		#cb.widget( "SearchForm" )#
	</div>
</cfif>

<!--- ContentBoxEvent --->
#cb.event( "cbui_afterSideBar" )#
</cfoutput>