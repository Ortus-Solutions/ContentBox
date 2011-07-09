<cfoutput>
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
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
</cfsavecontent>
<cfhtmlhead text="#js#">

<!--- Title --->
<h1>Welcome to your BlogBox Dashboard</h1>
<p>What would you like to do?
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
</cfoutput>