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
			<p class="center">
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
			<h2>Latest 10 Entries</h2>
			<input type="button" class="button" onclick="window.location='#event.buildLink(rc.xehBlogEditor)#'" value="Create Entry" />
			
			#html.startForm(name="entryForm",action=rc.xehRemoveEntry)#
				<!--- Render latest posts --->
				<input type="hidden" name="entryID" id="entryID" value="" />
				<table name="entries" id="entries" class="tablesorter" width="98%">
					<thead>
						<tr>
							<th>Title</th>
							<th width="200" class="center">Entry Info</th>
							<th width="75">Comments</th>
							<th width="75">Published</th>
							<th width="75" class="center {sorter:false}">Actions</th>
						</tr>
					</thead>
					
					<tbody>
						<cfloop array="#rc.posts#" index="post">
						<tr>
							<td>
								<a href="#event.buildLink(rc.xehBlogEditor)#/entryID/#post.getEntryID()#" title="Edit Post">#post.getTitle()#</a><br/>
								<strong>By #post.getAuthorName()#</strong>
							</td>
							<td>
								<!--- password protect --->
								<cfif post.isPasswordProtected()>
									<img src="#prc.bbRoot#/includes/images/lock.png" alt="locked" title="Entry is password protected"/>
								<cfelse>
									<img src="#prc.bbRoot#/includes/images/lock_off.png" alt="locked" title="Entry is public"/>
								</cfif>
								&nbsp;
								<!--- comments icon --->
								<cfif post.getallowComments()>
									<img src="#prc.bbRoot#/includes/images/comments.png" alt="locked" title="Commenting is Open!"/>
								<cfelse>
									<img src="#prc.bbRoot#/includes/images/comments_off.png" alt="locked" title="Commenting is Closed!"/>
								</cfif>
								<br/>
								<strong>Created:</strong> #post.getDisplayCreatedDate()#
								<strong>Published:</strong> #post.getDisplayPublishedDate()#
							</td>
							<td class="center">#post.getNumberOfComments()#</td>
							<td class="center">
								<cfif post.getIsPublished()>
									<img src="#prc.bbRoot#/includes/images/button_ok.png" alt="published" title="Entry Published!" />
								<cfelse>
									<img src="#prc.bbRoot#/includes/images/button_cancel.png" alt="draft" title="Entry Draft!" />
								</cfif>
							</td>
							<td class="center">
								<!--- Edit Command --->
								<a href="#event.buildLink(rc.xehEntryEditor)#/entryID/#post.getEntryID()#" title="Edit #post.getTitle()#"><img src="#prc.bbroot#/includes/images/edit.png" alt="edit" /></a>
								&nbsp;
								<!--- View in Site --->
								<a href="##" title="View Entry In Site"><img src="#prc.bbroot#/includes/images/eye.png" alt="edit" /></a>
								&nbsp;
								<!--- Delete Command --->
								<a title="Delete Entry" href="javascript:removePost('#post.getEntryID()#')" class="confirmIt" data-title="Delete Entry?"><img src="#prc.bbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
							</td>
						</tr>
						</cfloop>
					</tbody>
				</table>
			#html.endForm()#
			
			<!--- Latest Comments --->
			<h2>Latest 10 Comments</h2>
			<form name="commentForm" id="commentForm" method="post" action="#event.buildLink(rc.xehRemoveComment)#">
			<input type="hidden" name="commentID" id="commentID" value="" />
			
			<!--- Render latest posts --->
			<table name="comments" id="comments" class="tablesorter" width="98%">
				<thead>
					<tr>
						<th>Comment</th>
						<th width="200" class="center">Post Info</th>
						<th width="75" class="center {sorter:false}">Actions</th>
					</tr>
				</thead>
				
				<tbody>
					<cfloop array="#rc.comments#" index="comment">
					<tr>
						<td>
							<span class="commentTablePostInfo">
							Posted on <a href="#event.buildLink('entry')#/#comment.getPost().getEntryID()#">#comment.getPost().getTitle()#</a>
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
function removePost(entryID){
	$("##entryID").val( entryID );
	$("##entryForm").submit();
}
function removeComment(commentID){
	$("##commentID").val( commentID );
	$("##commentForm").submit();
}
$(document).ready(function() {
	$("##comments").tablesorter();
	$("##entries").tablesorter();
});
</script>
</cfoutput>