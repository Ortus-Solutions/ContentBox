<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#rc.bbroot#/includes/images/iinfo_icon.png" alt="info" width="24" height="24" />BlogBox Stats
		</div>
		<div class="body">
			Check out your stats!
		</div>
	</div>	
	
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#rc.bbroot#/includes/images/info.png" alt="info" width="24" height="24" />Need Help?
		</div>
		<div class="body">
			<a href="http://www.ortussolutions.com" target="_blank" title="The Gurus behind ColdBox">
			<img src="#rc.bbroot#/includes/images/ortus-top-logo.png" alt="Ortus Solutions" border="0" /></a><br/>
			
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
			<img src="#rc.bbroot#/includes/images/line_chart.png" alt="sofa" width="30" height="30" />
			Welcome to your BlogBox Dashboard
		</div>
		<!--- Body --->
		<div class="body">
			<p>What would you like to do?</p>
			<ul>
				<li><a href="#event.buildLink(rc.xehBlogEditor)#">New Post</a></li>
				<li><a href="#event.buildLink('blog')#">View Blog</a></li>
			</ul>
			
			<!--- Messagebox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- Latest 10 Entries --->
			<h2>Latest 10 Entries</h2>
			<input type="button" onclick="window.location='#event.buildLink(rc.xehBlogEditor)#'" value="New Post" />
			<form name="entryForm" id="entryForm" method="post" action="#event.buildLink(rc.xehRemoveEntry)#">
				<!--- Render latest posts --->
				<input type="hidden" name="entryID" id="entryID" value="" />
				<table name="entries" id="entries" class="tablelisting" width="98%">
					<thead>
						<tr>
							<th>Title</th>
							<th width="200" class="center">Post Info</th>
							<th width="125" class="center">Actions</th>
						</tr>
					</thead>
					
					<tbody>
						<cfloop array="#rc.posts#" index="post">
						<tr>
							<td><a href="#event.buildLink(rc.xehBlogEditor)#/entryID/#post.getEntryID()#" title="Edit Post">#post.getTitle()#</a></td>
							<td>
								#post.getAuthor()#<br/>
								#post.getDisplayTime()#
							</td>
							<td class="center">
								<input type="button" onclick="window.location='#event.buildLink('entry/#post.getEntryID()#')#'" value="View" />
								<input type="button" onclick="removePost('#post.getEntryID()#')" value="Delete" />
							</td>
						</tr>
						</cfloop>
					</tbody>
				</table>
			</form>
			
			<!--- Latest Comments --->
			<h2>Latest 10 Comments</h2>
			<form name="commentForm" id="commentForm" method="post" action="#event.buildLink(rc.xehRemoveComment)#">
			<input type="hidden" name="commentID" id="commentID" value="" />
			
			<!--- Render latest posts --->
			<table name="comments" id="comments" class="tablelisting" width="98%">
				<thead>
					<tr>
						<th>Comment</th>
						<th width="200" class="center">Post Info</th>
						<th width="75" class="center">Actions</th>
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
		if( confirm("Really delete?") ){
			$("##entryID").val( entryID );
			$("##entryForm").submit();
		}
	}
	function removeComment(commentID){
		if( confirm("Really delete?") ){
			$("##commentID").val( commentID );
			$("##commentForm").submit();
		}
	}
</script>
</cfoutput>