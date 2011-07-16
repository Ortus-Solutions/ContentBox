<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Entry Actions
		</div>
		<div class="body">
			<!--- Create button --->
			<p class="center">
				<a href="#event.buildLink(rc.xehEntryEditor)#" title="Create a new blog entry">
					<button class="button"> <img src="#prc.bbroot#/includes/images/add.png" alt="help"/> Create Entry</button>
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
			<img src="#prc.bbroot#/includes/images/blog.png" alt="sofa" width="30" height="30" />
			Blog Entries
		</div>
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- entryForm --->
			<form name="entryForm" id="entryForm" method="post" action="#event.buildLink(rc.xehEntryRemove)#">
			<input type="hidden" name="entryID" id="entryID" value="" />
			
			<!--- Filter Bar --->
			<div class="filterBar">
				<div>
					#html.label(field="entryFilter",content="Quick Filter:",class="inline")#
					#html.textField(name="entryFilter",size="30",class="textfield")#
				</div>
			</div>
			
			<!--- entries --->
			<table name="entries" id="entries" class="tablesorter" width="98%">
				<thead>
					<tr>
						<th>Name</th>
						<th>Author</th>			
						<th>Categories</th>
						<th width="125" class="center {sorter:false}">Actions</th>
					</tr>
				</thead>
				
				<tbody>
					<cfloop array="#rc.entries#" index="entry">
					<tr>
						<td><a href="#event.buildLink(rc.xehEntryEditor)#/entryID/#entry.getentryID()#" title="Edit #entry.getTitle()#">#entry.getTitle()#</a></td>
						<td>#entry.getAuthorName()#</td>
						<td>#entry.getCategoriesList()#</td>
						<td class="center">
							<!--- Edit Command --->
							<a href="#event.buildLink(rc.xehEntryEditor)#/entryID/#entry.getEntryID()#" title="Edit #entry.getTitle()#"><img src="#prc.bbroot#/includes/images/edit.png" alt="edit" /></a>
							<!--- Delete Command --->
							<a title="Delete Entry" href="javascript:remove('#entry.getEntryID()#')" class="confirmIt" data-title="Delete Entry?"><img id="delete_#entry.getEntryID()#" src="#prc.bbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
						</td>
					</tr>
					</cfloop>
				</tbody>
			</table>
			</form>

		</div>	
	</div>
</div>

<script type="text/javascript">
$(document).ready(function() {
	$("##entries").tablesorter();
	$("##entryFilter").keyup(function(){
		$.uiTableFilter( $("##entries"), this.value );
	})
});
function remove(entryID){
	$("##entryID").val( entryID );
	$("##entryForm").submit();
}
</script>

</cfoutput>