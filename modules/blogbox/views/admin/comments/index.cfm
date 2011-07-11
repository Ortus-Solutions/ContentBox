<cfoutput>
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
	function remove(commentID){
		if( confirm("Really delete?") ){
			$("##commentID").val( commentID );
			$("##categoryID").submit();
		}
	}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">
<!--- Title --->
<h1>Comment Management</h1>
<!--- MessageBox --->
#getPlugin("MessageBox").renderit()#

<ul>
	<li><a href="#event.buildLink(rc.xehCommentEditor)#">Create Comment</a></li>
</ul>

<!--- CategoryForm --->
<form name="commentForm" id="categoryID" method="post" action="#event.buildLink(rc.xehCommentRemove)#">
<input type="hidden" name="commentID" id="commentID" value="" />

<!--- comments --->
<table name="comments" id="comments" class="tablelisting" width="98%">
	<thead>
		<tr>
			<th>Name</th>
			<th>Slug</th>			
			<th width="125" class="center">Actions</th>
		</tr>
	</thead>
	
	<tbody>
		<cfloop array="#rc.comments#" index="comment">
		<tr>
			<td><a href="#event.buildLink(rc.xehCommentEditor)#/commentID/#comment.getcommentID()#" title="Edit Comment">#comment.getContent()#</a></td>
			
			<td class="center">
				<input type="button" onclick="remove('#comment.getcommentID()#')" value="Delete" title="Delete Comment"/>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>
</form>
</cfoutput>