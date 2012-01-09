<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Editor Box --->
	<cfif prc.oAuthor.checkPermission("CATEGORIES_ADMIN")>
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/entry.png" alt="info" width="24" height="24" />Editor
		</div>
		<div class="body">
			<!--- Create/Edit form --->
			#html.startForm(action=prc.xehCategoriesSave,name="categoryEditor",novalidate="novalidate")#
				#html.hiddenField(name="categoryID",value="")#
				#html.textField(name="category",label="Category:",required="required",maxlength="100",size="30",class="textfield")#
				#html.textField(name="slug",label="Slug (blank to generate it):",maxlength="100",size="30",class="textfield")#
				<div class="actionBar">
					#html.resetButton(name="btnReset",value="Reset Form",class="button")#
					#html.submitButton(value="Save Category",class="buttonred")#
				</div>
			#html.endForm()#
		</div>
	</div>		
	</cfif>
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/category.png" alt="sofa" width="30" height="30" />
			Categories
		</div>
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- CategoryForm --->
			#html.startForm(name="categoryForm",action=prc.xehCategoryRemove)#
			<input type="hidden" name="categoryID" id="categoryID" value="" />
			
			<!--- Content Bar --->
			<div class="contentBar">
				<!--- Filter Bar --->
				<div class="filterBar">
					<div>
						#html.label(field="categoryFilter",content="Quick Filter:",class="inline")#
						#html.textField(name="categoryFilter",size="30",class="textfield")#
					</div>
				</div>
			</div>
			
			<!--- categories --->
			<table name="categories" id="categories" class="tablesorter" width="98%">
				<thead>
					<tr>
						<th>Name</th>
						<th>Slug</th>		
						<th width="75" class="center">Entries</th>	
						<th width="75" class="center {sorter:false}">Actions</th>
					</tr>
				</thead>				
				<tbody>
					<cfloop array="#prc.categories#" index="category">
					<tr>
						<td><a href="javascript:edit('#category.getCategoryID()#','#category.getCategory()#','#category.getSlug()#')" title="Edit #category.getCategory()#">#category.getCategory()#</a></td>
						<td>#category.getSlug()#</td>
						<td class="center">#category.getnumberOfEntries()#</td>
						<td class="center">
							<cfif prc.oAuthor.checkPermission("CATEGORIES_ADMIN")>
							<!--- Edit Command --->
							<a href="javascript:edit('#category.getCategoryID()#','#category.getCategory()#','#category.getSlug()#')" title="Edit #category.getCategory()#"><img src="#prc.cbroot#/includes/images/edit.png" alt="edit" border="0" /></a>
							<!--- Delete Command --->
							<a title="Delete Category" href="javascript:remove('#category.getcategoryID()#')" class="confirmIt" data-title="Delete Category?"><img id="delete_#category.getCategoryID()#" src="#prc.cbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
							</cfif>
						</td>
					</tr>
					</cfloop>
				</tbody>
			</table>
			#html.endForm()#
		
		</div>	
	</div>
</div>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$categoryEditor = $("##categoryEditor");
	// table sorting + filtering
	$("##categories").tablesorter();
	$("##categoryFilter").keyup(function(){
		$.uiTableFilter( $("##categories"), this.value );
	});
	// form validator
	$categoryEditor.validator({position:'top left'});
	// reset
	$('##btnReset').click(function() {
		$categoryEditor.find("##categoryID").val( '' );
	});
});
<cfif prc.oAuthor.checkPermission("CATEGORIES_ADMIN")>
function edit(categoryID,category,slug){
	$categoryEditor.find("##categoryID").val( categoryID );
	$categoryEditor.find("##category").val( category );
	$categoryEditor.find("##slug").val( slug );
}
function remove(categoryID){
	var $categoryForm = $("##categoryForm");
	$categoryForm.find("##categoryID").val( categoryID );
	$categoryForm.submit();
}
</cfif>
</script>
</cfoutput>