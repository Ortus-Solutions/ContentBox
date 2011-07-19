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
			<a href="http://www.ortussolutions.com" target="_blank" title="The Gurus behind ColdBox">
			<img src="#prc.bbroot#/includes/images/ortus-top-logo.png" alt="Ortus Solutions" border="0" /></a><br/>
			
			<p><strong>Ortus Solutions</strong> is the company behind anything ColdBox. Need professional support, architecture analysis,
			code reviews, custom development or anything ColdFusion, ColdBox related? 
			<a href="mailto:help@ortussolutions.com">Contact us</a>, we are here
			to help!</p>
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
		<div class="body">
			<!--- Messagebox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- Latest 10 Entries --->
			<div class="contentBar">
				<div class="buttonBar">
					<input type="button" title="Create new blog entry" class="button2" onclick="window.location='#event.buildLink(rc.xehBlogEditor)#'" value="Create Entry" />
					<button class="buttonred" title="Create a new quick post" onclick="remoteModal('#event.buildLink(rc.xehEntryQuickPost)#')">Quick Post</button>
				</div>				
				<div class="filterBar">
					<h3><img src="#prc.bbroot#/includes/images/blog.png" alt="blog" /> Recent Entries</h3>
				</div>				
			#rc.entriesViewlet#
			</div>
			
			<!--- Latest Comments --->
			<h3><img src="#prc.bbroot#/includes/images/comments_32.png" alt="comment" /> Recent Comments</h3>
			<form name="commentForm" id="commentForm" method="post" action="#event.buildLink(rc.xehRemoveComment)#">
			<input type="hidden" name="commentID" id="commentID" value="" />
			
			<!--- Render latest entrys --->
			<table name="comments" id="comments" class="tablesorter" width="98%">
				<thead>
					<tr>
						<th>Comment</th>
						<th width="200" class="center">entry Info</th>
						<th width="75" class="center {sorter:false}">Actions</th>
					</tr>
				</thead>
				
				<tbody>
					<cfloop array="#rc.comments#" index="comment">
					<tr>
						<td>
							<span class="commentTablePostInfo">
							Posted on <a href="#event.buildLink('entry')#/#comment.getentry().getEntryID()#">#comment.getentry().getTitle()#</a>
							</span><br/>
							#comment.getComment()#
						</td>
						<td>
							<!--- Avatar --->
							<cfif len(comment.getAuthorEmail())>
							<div class="commentTableAvatar">#getMyPlugin("Avatar").renderAvatar(comment.getAuthorEmail(),30)#</div>
							</cfif>
							<!--- Author --->
							<cfif len(comment.getAuthorURL())>
								<a href="#comment.getAuthorURL#" target="_blank">#comment.getAuthor()#</a>
							<cfelse>
								#comment.getAuthor()#
							</cfif>
							<br/>
							<!--- Display Time --->
							#comment.getDisplayTime()#
						</td>
						<td class="center">
							<input type="button" onclick="removeComment('#comment.getCommentID()#')" value="Delete" />
						</td>
					</tr>
					</cfloop>
				</tbody>
			
			</table>
			</form>			
		</div>	
	</div>
</div>
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