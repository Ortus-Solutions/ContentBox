<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	
	<!--- Admin Actions --->
	<cfif prc.oAuthor.checkPermission("RELOAD_MODULES")>
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Admin Actions
		</div>
		<div class="body">
			<cfif flash.exists("moduleReloaded")>
				<div class="flickerMessages">
					'#flash.get("moduleReloaded")#' Executed!
				</div>
			</cfif>
			<!--- Reload button --->
			<p class="actionBar">
				#html.startForm(name="reloadForm",action=prc.xehReloadModule)#
				#html.select(label="Choose Command To Execute:",name="targetModule",options=prc.reloadOptions)#
				#html.submitButton(value="Issue Reload",class="buttonred")#
				#html.endForm()#
			</p>
		</div>
	</div>	
	</cfif>
	
	<!--- Snapshot Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/camera.png" alt="info" width="24" height="24" />Data Snapshots
		</div>
		<div class="body">
			<!--- Accordion Snapshots --->
			<div id="accordion" class="clearfix">
				<!--- Discussion Snapshot --->
				<h2> 
					<img src="#prc.cbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" /> 
					<img src="#prc.cbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" /> 
					<img src="#prc.cbroot#/includes/images/comments_black.png" alt="info" /> Discussions </h2>
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
					<img src="#prc.cbroot#/includes/images/pen.png" alt="info" /> Content </h2>
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
			<img src="#prc.cbroot#/includes/images/info.png" alt="info" width="24" height="24" />Need Help?
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
			<img src="#prc.cbroot#/includes/images/help.png" alt="info" width="24" height="24" />Help Tips
		</div>
		<div class="body">
			<ul class="tipList">
				<li title="Click Me!" onclick="exposeIt('##mainBody')">Right click on a row to activate quick look!</li>
				<li title="Click Me!" onclick="exposeIt('##btnQuickPost')">'Quick Post' is a minimalistic editing machine</li>
				<li title="Click Me!" onclick="exposeIt('##btnCreateEntry')">'Create Entry' is a full blown editing machine</li>
			</ul>
		</div>
	</div>	
	
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/line_chart.png" alt="sofa" width="30" height="30" />
			Welcome to your ContentBox Dashboard
		</div>
		<!--- Body --->
		<div class="body" id="mainBody">
			<!--- Messagebox --->
			#getPlugin("MessageBox").renderit()#
			
			
			<!--- Latest Entries --->
			#html.anchor(name="recentEntries")#
			<div class="contentBar" id="entriesBar">
				<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
				<div class="buttonBar">
					<button class="button2" 	id="btnCreateEntry" title="Create a new blog entry" onclick="return to('#event.buildLink(prc.xehBlogEditor)#')">Create Entry</button>
					<button class="buttonred" 	id="btnQuickPost" 	title="Create a new quick post" onclick="showQuickPost()">Quick Post</button>
				</div>				
				</cfif>
				<div class="filterBar">
					<h3><img src="#prc.cbroot#/includes/images/blog.png" alt="blog" /> Recent Entries</h3>
				</div>				
				#prc.entriesViewlet#
			</div>
			
			<!--- Latest Pages --->
			#html.anchor(name="recentPages")#
			<div class="contentBar" id="entriesBar">
				<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
				<div class="buttonBar">
					<button class="button2" 	id="btnCreateEntry" title="Create a new page" onclick="return to('#event.buildLink(prc.xehPageEditor)#')">Create Page</button>
				</div>				
				</cfif>
				<div class="filterBar">
					<h3><img src="#prc.cbroot#/includes/images/page_big.png" alt="blog" /> Recent Pages</h3>
				</div>				
				#prc.pagesViewlet#
			</div>
			
			<!--- Latest Comments --->
			#html.anchor(name="recentComments")#
			<div class="contentBar">
				<div class="buttonBar">					
				</div>				
				<div class="filterBar">
					<h3><img src="#prc.cbroot#/includes/images/comments_32.png" alt="blog" /> Recent Comments</h3>
				</div>	
				<!--- Info Bar --->
				<cfif NOT prc.cbSettings.cb_comments_enabled>
					<div class="infoBar">
						<img src="#prc.cbRoot#/includes/images/info.png" alt="comments" />
						Comments are currently disabled site-wide!
					</div>
				</cfif>			
				#prc.commentsViewlet#
			</div>
			
		</div>	
	</div>
</div>
</cfoutput>