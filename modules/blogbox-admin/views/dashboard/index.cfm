<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Admin Actions
		</div>
		<div class="body">
			<cfif flash.exists("moduleReloaded")>
				<div class="flickerMessages">
					Module <strong>#flash.get("moduleReloaded")#</strong> was reloaded!
				</div>
			</cfif>
			<!--- Reload button --->
			<p class="actionBar">
				<a href="#event.buildLink(prc.xehReloadModule&"/blogbox-admin")#" title="Reload Administrator Module" class="confirmIt">
					<button class="button2">Reload Admin</button>
				</a>
				<a href="#event.buildLink(prc.xehReloadModule&"/blogbox-ui")#" title="Reload Site Module" class="confirmIt">
					<button class="button2">Reload Site</button>
				</a>
			</p>
		</div>
	</div>	
	
	<!--- Snapshot Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/camera.png" alt="info" width="24" height="24" />Data Snapshot
		</div>
		<div class="body">
			<form>
			<table class="tablelisting" width="100%">
				<thead>
					<tr>
						<th width="50%" class="center"><img src="#prc.bbroot#/includes/images/pen.png" alt="info" /> Content</th>
						<th class="center"><img src="#prc.bbroot#/includes/images/comments_black.png" alt="info" /> Discussion</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							<label class="inline"><a title="View Entries" href="#event.buildLink(prc.xehEntries)#">#prc.entriesCount# Entries</a> </label> <br/>
							<label class="inline"><a title="View Categories" href="#event.buildLink(prc.xehCategories)#">#prc.categoriesCount# Categories</a> </label><br/>
						</td>
						<td>
							<label class="inline"><a title="View Comments" href="#event.buildLink(prc.xehComments)#">#prc.commentsCount# Comments</a> </label> <br/>
							<label class="inline"><a title="View Approved Comments" href="#event.buildLink(prc.xehComments)#?fStatus=true">#prc.commentsApprovedCount# Approved</a></label><br/>
							<label class="inline"><a title="View UnApproved Comments" href="#event.buildLink(prc.xehComments)#?fStatus=false">#prc.commentsUnApprovedCount# Pending</a> </label><br/>
						</td>
					</tr>
				</tbody>
			</table>
			</form>
		</div>
	</div>	
	
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/info.png" alt="info" width="24" height="24" />Need Help?
		</div>
		<div class="body">
			<a href="http://www.ortussolutions.com" target="_blank" title="The Gurus behind ColdBox and BlogBox">
			<img src="#prc.bbroot#/includes/images/ortus-top-logo.png" alt="Ortus Solutions" border="0" /></a><br/>
			
			<p><strong>Ortus Solutions</strong> is the company behind anything ColdBox and BlogBox. Need professional support, architecture analysis,
			code reviews, custom development or anything ColdFusion, ColdBox, BlogBox related? 
			<a href="mailto:help@ortussolutions.com">Contact us</a>, we are here
			to help!</p>
		</div>
	</div>	
	<!--- Help Box--->
	<div class="small_box" id="help_tips">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/help.png" alt="info" width="24" height="24" />Help Tips
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
			<img src="#prc.bbroot#/includes/images/line_chart.png" alt="sofa" width="30" height="30" />
			Welcome to your BlogBox Dashboard
		</div>
		<!--- Body --->
		<div class="body" id="mainBody">
			<!--- Messagebox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- Latest 10 Entries --->
			#html.anchor(name="recentEntries")#
			<div class="contentBar" id="entriesBar">
				<div class="buttonBar">
					<button class="button2" 	id="btnCreateEntry" title="Create a new blog entry" onclick="return to('#event.buildLink(prc.xehBlogEditor)#')">Create Entry</button>
					<button class="buttonred" 	id="btnQuickPost" 	title="Create a new quick post" onclick="showQuickPost()">Quick Post</button>
				</div>				
				<div class="filterBar">
					<h3><img src="#prc.bbroot#/includes/images/blog.png" alt="blog" /> Recent Entries</h3>
				</div>				
				#prc.entriesViewlet#
			</div>
			
			<!--- Latest Comments --->
			#html.anchor(name="recentComments")#
			<div class="contentBar">
				<div class="buttonBar">					
				</div>				
				<div class="filterBar">
					<h3><img src="#prc.bbroot#/includes/images/comments_32.png" alt="blog" /> Recent Comments</h3>
				</div>	
				<!--- Info Bar --->
				<cfif NOT prc.bbSettings.bb_comments_enabled>
					<div class="infoBar">
						<img src="#prc.bbRoot#/includes/images/info.png" alt="comments" />
						Comments are currently disabled site-wide!
					</div>
				</cfif>			
				#prc.commentsViewlet#
			</div>
			
		</div>	
	</div>
</div>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
});
</script>
</cfoutput>