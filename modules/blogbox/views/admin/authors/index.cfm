<cfoutput>
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
	function removeAuthor(authorID){
		if( confirm("Really delete?") ){
			$("##authorID").val( authorID );
			$("##authorForm").submit();
		}
	}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">
<!--- Title --->
<h1>Author Management</h1>
<!--- MessageBox --->
#getPlugin("MessageBox").renderit()#

<ul>
	<li><a href="#event.buildLink(rc.xehAuthorEditor)#">Create Author</a></li>
</ul>

<!--- AuthorForm --->
<form name="authorForm" id="authorForm" method="post" action="#event.buildLink(rc.xehAuthorRemove)#">
<input type="hidden" name="authorID" id="authorID" value="" />

<!--- authors --->
<table name="authors" id="authors" class="tablelisting" width="98%">
	<thead>
		<tr>
			<th>Name</th>
			<th>Email</th>
			<th>Username</th>
			<th>Last Login</th>
			<th>isActive</th>
			<th width="125" class="center">Actions</th>
		</tr>
	</thead>
	
	<tbody>
		<cfloop array="#rc.authors#" index="author">
		<tr>
			<td><a href="#event.buildLink(rc.xehAuthorEditor)#/authorID/#author.getAuthorID()#" title="Edit #author.getName()#">#author.getName()#</a></td>
			<td>#author.getEmail()#</td>
			<td>#author.getUsername()#</td>
			<td>#author.getDisplayLastLogin()#</td>
			<td>#author.getIsActive()#</td>
			<td class="center">
				<input type="button" onclick="removeAuthor('#author.getauthorID()#')" value="Delete" title="Delete Author"/>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>
</form>
</cfoutput>