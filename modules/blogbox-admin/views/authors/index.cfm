<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#rc.bbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Author Actions
		</div>
		<div class="body">
			<!--- Help button --->
			<p class="center">
				<a href="#event.buildLink(rc.xehAuthorEditor)#" title="Create a new Author">
					<button class="button"> <img src="#rc.bbroot#/includes/images/add.png" alt="help"/> Create Author</button>
				</a>
			</p>
		</div>
	</div>		
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#rc.bbroot#/includes/images/user-admin.png" alt="sofa" width="30" height="30" />
			Author Management
		</div>
		<!--- Body --->
		<div class="body">
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- AuthorForm --->
			<form name="authorForm" id="authorForm" method="post" action="#event.buildLink(rc.xehAuthorRemove)#">
			<input type="hidden" name="authorID" id="authorID" value="" />
			
			<!--- Filter Bar --->
			<div class="filterBar">
				<div>
					#html.label(field="authorFilter",content="Quick Filter:",class="inline")#
					#html.textField(name="authorFilter",size="20")#
				</div>
			</div>

			<!--- authors --->
			<table name="authors" id="authors" class="tablesorter" width="98%">
				<thead>
					<tr>
						<th>Name</th>
						<th>Email</th>
						<th>Username</th>
						<th>Last Login</th>
						<th>isActive</th>
						<th width="125" class="center {sorter: false}">Actions</th>
					</tr>
				</thead>
				
				<tbody>
					<cfloop array="#rc.authors#" index="author">
					<tr>
						<td>
							#getMyPlugin(plugin="Avatar",module="blogbox").renderAvatar(email=author.getEmail(),size="30")#
							<a href="#event.buildLink(rc.xehAuthorEditor)#/authorID/#author.getAuthorID()#" title="Edit #author.getName()#">#author.getName()#</a>
						</td>
						<td>#author.getEmail()#</td>
						<td>#author.getUsername()#</td>
						<td>#author.getDisplayLastLogin()#</td>
						<td>#author.getIsActive()#</td>
						<td class="center">
							<!--- Edit Command --->
							<a href="#event.buildLink(rc.xehAuthorEditor)#/authorID/#author.getAuthorID()#" title="Edit #author.getName()#"><img src="#rc.bbroot#/includes/images/edit.png" alt="edit" /></a>
							<!--- Delete Command --->
							<a title="Delete Author" href="javascript:removeAuthor('#author.getAuthorID()#')" class="confirmIt" data-title="Delete Author?"><img id="delete_#author.getAuthorID()#" src="#rc.bbRoot#/includes/images/delete.png" border="0" alt="delete"/></a>
						</td>
					</tr>
					</cfloop>
				</tbody>
			</table>
			</form>
		
		</div>	<!--- body --->
	</div> <!--- main box --->
</div> <!--- main column --->

<script type="text/javascript">
$(document).ready(function() {
	$("##authors").tablesorter();
	$("##authorFilter").keyup(function(){
		$.uiTableFilter( $("##authors"), this.value );
	})
});
function removeAuthor(authorID){
	$("##authorID").val( authorID );
	$("##authorForm").submit();
}
</script>
</cfoutput>