<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	
	<!--- Event --->
	#announceInterception("cbadmin_preDashboardSideBar")#
	
	<!--- Admin Actions --->
	<cfif prc.oAuthor.checkPermission("RELOAD_MODULES")>
	<div class="small_box">
		<div class="header">
			<i class="icon-cogs"></i>
			Admin Actions
		</div>
		<div class="body">
			<cfif flash.exists("moduleReloaded")>
				<div class="flickerMessages">
					'#flash.get("moduleReloaded")#' Executed!
				</div>
			</cfif>
			<!--- Reload button --->
			<p class="actionBar">
				#html.startForm(name="reloadForm",action=prc.xehAdminAction)#
				#html.select(label="Choose Command To Execute:",name="targetModule",options=prc.xehAdminActionData)#
				<button class="btn btn-danger btn-small"><i class="icon-play"></i> Run</button>
				#html.endForm()#
			</p>
		</div>
	</div>	
	</cfif>
	
	<!--- Snapshot Box --->
	<div class="small_box">
		<div class="header">
			<i class="icon-camera"></i> Data Snapshots
		</div>
		<div class="body">
			<!--- Accordion Snapshots --->
			<div id="accordion" class="clearfix">
				<!--- Top Content Snapshot --->
				<h2> 
					<img src="#prc.cbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" /> 
					<img src="#prc.cbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" /> 
					<i class="icon-bar-chart icon-large"></i> Top Visited Content 
				</h2>
				<div class="pane">
					
					<cfchart chartwidth="265" format="png" tipstyle="mouseOver" showlegend="false" >
						<cfchartseries type="pie" colorlist="##B22222,##FF69B4,##FF8C00, ##1E90FF,##ADFF2F" datalabelstyle="value"  >
							<cfloop array="#prc.topContent#" index="topContent">
								<cfchartdata item="#topContent.getTitle()#.."  value="#topContent.getHits()#">
							</cfloop>
						</cfchartseries>
					</cfchart>
					
					<table class="tablesorter" width="100%">
						<thead>
							<tr>
								<th>Title</th>
								<th width="40" class="center">Hits</th>
							</tr>
						</thead>
						<tbody>
							<cfloop array="#prc.topContent#" index="topContent">
								<tr>
									<td>
										<a href="#prc.CBHelper.linkContent( topContent )#">#topContent.getTitle()#</a>
									</td>
									<td class="center">#topContent.getHits()#</td>
								</tr>
							</cfloop>
						</tbody>
					</table>
				</div>
				<!--- Top Commented Snapshot --->
				<h2> 
					<img src="#prc.cbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" /> 
					<img src="#prc.cbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" /> 
					<i class="icon-bar-chart icon-large"></i> Top Commented Content 
				</h2>
				<div class="pane">
					
					<cfchart chartwidth="265" format="png" tipstyle="none" >
						<cfchartseries type="bar" colorlist="##B22222,##FF69B4,##FF8C00, ##1E90FF,##ADFF2F" datalabelstyle="value">
							<cfloop array="#prc.topCommented#" index="topCommented">
								<cfchartdata item="#topCommented.getTitle()#"  value="#topCommented.getNumberOfComments()#">
							</cfloop>
						</cfchartseries>
					</cfchart>
					
					<table class="tablesorter" width="100%">
						<thead>
							<tr>
								<th>Title</th>
								<th width="40" class="center">Comments</th>
							</tr>
						</thead>
						<tbody>
							<cfloop array="#prc.topCommented#" index="topCommented">
								<tr>
									<td>
										<a href="#prc.CBHelper.linkContent( topCommented )#">#topCommented.getTitle()#</a>
									</td>
									<td class="center">#topCommented.getNumberOfComments()#</td>
								</tr>
							</cfloop>
						</tbody>
					</table>
				</div>
				<!--- Discussion Snapshot --->
				<h2> 
					<img src="#prc.cbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" /> 
					<img src="#prc.cbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" /> 
					<i class="icon-comments icon-large"></i> Discussions 
				</h2>
				<div class="pane">
					<ul>
						<li><a title="View Comments" href="#event.buildLink(prc.xehComments)#">#prc.commentsCount# Comments</a> </li>
						<li><a title="View Approved Comments" href="#event.buildLink(prc.xehComments)#?fStatus=true">#prc.commentsApprovedCount# Approved</a></li>
						<li><a title="View UnApproved Comments" href="#event.buildLink(prc.xehComments)#?fStatus=false">#prc.commentsUnApprovedCount# Pending</a> </li>
					</ul>		
				</div>
				<!--- Content Snapshot --->
				<h2> 
					<img src="#prc.cbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" /> 
					<img src="#prc.cbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" /> 
					<i class="icon-pencil icon-large"></i> Content </h2>
				<div class="pane">
					<ul>
						<li><a title="View Entries" href="#event.buildLink(prc.xehEntries)#">#prc.entriesCount# Entries</a> </li>
						<li><a title="View Entries" href="#event.buildLink(prc.xehPages)#">#prc.pagesCount# Page(s)</a> </li>
						<li><a title="View Categories" href="#event.buildLink(prc.xehCategories)#">#prc.categoriesCount# Categories</a> </li>
					</ul>
				</div>
			</div>
			<!--End Accordion-->
			
		</div>
	</div>	
	
	<!--- Info Box --->
	<div class="small_box expose">
		<div class="header">
			<i class="icon-medkit"></i> Need Help?
		</div>
		<div class="body">
			<a href="http://www.ortussolutions.com" target="_blank" title="The Gurus behind ColdBox and ContentBox">
			<div class="center"><img src="#prc.cbroot#/includes/images/ortus-top-logo.png" alt="Ortus Solutions" border="0" /></a><br/></div>
			
			<p><strong>Ortus Solutions</strong> is the company behind anything ColdBox and ContentBox. Need professional support, architecture analysis,
			code reviews, custom development or anything ColdFusion, ColdBox, ContentBox related? 
			<a href="mailto:help@ortussolutions.com">Contact us</a>, we are here
			to help!</p>
		</div>
	</div>	
	<!--- Help Box--->
	<div class="small_box" id="help_tips">
		<div class="header">
			<i class="icon-question-sign"></i> Help Tips
		</div>
		<div class="body">
			<ul class="tipList">
				<li title="Click Me!" onclick="exposeIt('##mainBody')">Right click on a row to activate quick look!</li>
				<li title="Click Me!" onclick="exposeIt('##btnQuickPost')">'Quick Post' is a minimalistic editing machine</li>
				<li title="Click Me!" onclick="exposeIt('##btnCreateEntry')">'Create Entry' is a full blown editing machine</li>
			</ul>
		</div>
	</div>	
	
	<!--- Event --->
	#announceInterception("cbadmin_postDashboardSideBar")#
	
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<i class="icon-dashboard icon-larger"></i>
			Welcome to your ContentBox Dashboard
		</div>
		<!--- Body --->
		<div class="body" id="mainBody">
			<!--- Messagebox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- Event --->
			#announceInterception("cbadmin_preDashboardContent")#
			
			<!--- Installer Checks --->
			<cfif prc.installerCheck.installer>
				<div class="alert alert-error" id="installerCheck">
					<a href="##" class="close" data-dismiss="alert">&times;</a>
					<i class="icon-warning-sign icon-large icon-2x"></i>
					The installer module still exists! Please delete it from your server as leaving it online is a security risk.
					<button class="btn btn-danger" onclick="deleteInstaller()">Delete Installer</button>
				</div>
			</cfif>
			<cfif prc.installerCheck.dsncreator>
				<div class="alert alert-error" id="dsnCreatorCheck">
					<a href="##" class="close" data-dismiss="alert">&times;</a>
					<i class="icon-warning-sign icon-large icon-2x"></i>
					The DSN creator module still exists! Please delete it from your server as leaving it online is a security risk.
					<button class="btn btn-danger" onclick="deleteDSNCreator()">Delete DSN Creator</button>
				</div>
			</cfif>
			
			<!--- Latest Entries --->
			#html.anchor(name="recentEntries")#
			<div class="contentBar" id="entriesBar">
				<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
				<div class="buttonBar">
					<button class="btn btn-primary" 	id="btnCreateEntry" title="Create a new blog entry" onclick="return to('#event.buildLink(prc.xehBlogEditor)#')">Create Entry</button>
					<button class="btn btn-danger" 		id="btnQuickPost" 	title="Create a new quick post" onclick="showQuickPost()">Quick Post</button>
				</div>				
				</cfif>
				<div class="filterBar">
					<h3><i class="icon-quote-left"></i> Recent Entries</h3>
				</div>				
				#prc.entriesViewlet#
			</div>
			
			<!--- Latest Pages --->
			#html.anchor(name="recentPages")#
			<div class="contentBar" id="entriesBar">
				<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
				<div class="buttonBar">
					<button class="btn btn-primary" 	id="btnCreateEntry" title="Create a new page" onclick="return to('#event.buildLink(prc.xehPageEditor)#')">Create Page</button>
				</div>				
				</cfif>
				<div class="filterBar">
					<h3><i class="icon-pencil"></i> Recent Pages</h3>
				</div>				
				#prc.pagesViewlet#
			</div>
			
			<!--- Latest Comments --->
			#html.anchor(name="recentComments")#
			<div class="contentBar">
				<div class="buttonBar">					
				</div>				
				<div class="filterBar">
					<h3><i class="icon-comments"></i> Recent Comments</h3>
				</div>	
				<!--- Info Bar --->
				<cfif NOT prc.cbSettings.cb_comments_enabled>
					<div class="alert alert-info">
						<i class="icon-exclamation-sign icon-2x pull-left"></i>
						Comments are currently disabled site-wide!
					</div>
				</cfif>			
				#prc.commentsViewlet#
			</div>
			
			<!--- Latest News --->
			<cfif prc.latestNews.items.recordCount>
			#html.anchor(name="recentNews")#
			<div class="contentBar">			
				<h3><i class="icon-rss"></i> Recent News</h3>
				<cfloop query="prc.latestNews.items" endrow="5">
					<div class="box padding10">
						<h4><a href="#prc.latestNews.items.URL#" target="_blank">#prc.latestNews.items.title#</a></h4>
						<div><p><strong>#dateFormat( prc.latestNews.items.datepublished, "full" )#</strong></p></div>
						<p>#left( cb.stripHTML( prc.latestNews.items.body ), 500 )#...</p>
					</div>
				</cfloop>
			</div>
			</cfif>
			
			<!--- Event --->
			#announceInterception("cbadmin_postDashboardContent")#
			
		</div>	
	</div>
</div>
</cfoutput>