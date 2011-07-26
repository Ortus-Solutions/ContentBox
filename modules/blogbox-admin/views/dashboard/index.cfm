<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/settings.png" alt="info" width="24" height="24" />BlogBox Actions
		</div>
		<div class="body">
			<cfif flash.exists("moduleReloaded")>
				<div class="flickerMessages">
					Module <strong>#flash.get("moduleReloaded")#</strong> was reloaded!
				</div>
			</cfif>
			<!--- Reload button --->
			<p class="actionBar">
				<a href="#event.buildLink(rc.xehReloadModule&"/blogbox-admin")#" title="Reload Administrator Module" class="confirmIt">
					<button class="button2">Reload Admin</button>
				</a>
				<a href="#event.buildLink(rc.xehReloadModule&"/blogbox-ui")#" title="Reload Site Module" class="confirmIt">
					<button class="button2">Reload Site</button>
				</a>
			</p>
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
					<button class="button2" 	id="btnCreateEntry" title="Create a new blog entry" onclick="return to('#event.buildLink(rc.xehBlogEditor)#')">Create Entry</button>
					<button class="buttonred" 	id="btnQuickPost" 	title="Create a new quick post" onclick="showQuickPost()">Quick Post</button>
				</div>				
				<div class="filterBar">
					<h3><img src="#prc.bbroot#/includes/images/blog.png" alt="blog" /> Recent (#prc.bbSettings.bb_dashboard_recentEntries#) Entries</h3>
				</div>				
				#rc.entriesViewlet#
			</div>
			
			<!--- Latest Comments --->
			#html.anchor(name="recentComments")#
			<div class="contentBar">
				<div class="buttonBar">					
				</div>				
				<div class="filterBar">
					<h3><img src="#prc.bbroot#/includes/images/comments_32.png" alt="blog" /> Recent (#prc.bbSettings.bb_dashboard_recentComments#) Comments</h3>
				</div>				
				#rc.commentsViewlet#
			</div>
			
		</div>	
	</div>
</div>
<!--- QUick Post --->
#renderView("dashboard/quickPost")#
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$("##comments").tablesorter();
	$("##entries").tablesorter();
});
function removeComment(commentID){
	$("##commentID").val( commentID );
	$("##commentForm").submit();
}
</script>
</cfoutput>