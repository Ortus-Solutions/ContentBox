<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/entry.png" alt="info" width="24" height="24" />Editor
		</div>
		<div class="body">
			<!--- Create/Edit form --->
			#html.startForm(action=prc.xehCategoriesSave,name="categoryEditor",novalidate="novalidate")#
				<input type="hidden" name="categoryID" id="categoryID" value="" />
				
				<label for="category">Category:</label>
				<input name="category" id="category" type="text" required="required" maxlength="100" size="25" class="textfield"/>
				
				<label for="slug">Slug: (blank to generate it):</label>
				<input name="slug" id="slug" type="text" maxlength="100" size="25" class="textfield"/>
				
				<div class="actionBar">
					#html.resetButton(name="btnReset",value="Reset",class="button")#
					#html.submitButton(value="Save",class="buttonred")#
				</div>
			#html.endForm()#
		</div>
	</div>		
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.bbroot#/includes/images/category.png" alt="sofa" width="30" height="30" />
			Categories
		</div>
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- CategoryForm --->
			#html.startForm(name="categoryForm",action=rc.xehCategoryRemove)#
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
			
			<div class="infoBar">
				<img src="#prc.bbRoot#/includes/images/info.png" alt="info"/>
				You cannot delete categories that have posts attached to them.  You will need to un-attach those categories first.
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
					<cfloop array="#rc.categories#" index="category">
					<tr>
						<td><a href="javascript:edit('#category.getCategoryID()#','#category.getCategory()#','#category.getSlug()#')" title="Edit #category.getCategory()#">#category.getCategory()#</a></td>
						<td>#category.getSlug()#</td>
						<td class="center">#category.getnumberOfEntries()#</td>
						<td class="center">
							<!--- Edit Command --->
							<a href="javascript:edit('#category.getCategoryID()#','#category.getCategory()#','#category.getSlug()#')" title="Edit #category.getCategory()#"><img src="#prc.bbroot#/includes/images/edit.png" alt="edit" border="0" /></a>
							<!--- Delete Command --->
							<cfif category.getNumberOfEntries() EQ 0>
							<a title="Delete Author" href="javascript:remove('#category.getcategoryID()#')" class="confirmIt" data-title="Delete Category?"><img id="delete_#category.getCategoryID()#" src="#prc.bbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
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
</script>
</cfoutput>