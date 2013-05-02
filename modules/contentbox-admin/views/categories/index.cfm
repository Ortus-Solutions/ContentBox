<cfoutput>
<div class="row-fluid" id="main-content">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<i class="icon-tags icon-large"></i>
			Content Categories
		</div>
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- CategoryForm --->
			#html.startForm(name="categoryForm",action=prc.xehCategoryRemove,class="form-vertical")#
			<input type="hidden" name="categoryID" id="categoryID" value="" />
			
			<!--- Content Bar --->
			<div class="well well-small">
				<!--- Command Bar --->
				<div class="pull-right">
					<a href="##" onclick="return createCategory();" class="btn btn-danger">Create Category</a>
				</div>
				<!--- Filter Bar --->
				<div class="filterBar">
					<div>
						#html.textField(name="categoryFilter",size="30", class="textfield", label="Quick Filter: ", labelClass="inline")#
					</div>
				</div>
			</div>
			
			<!--- categories --->
			<table name="categories" id="categories" class="tablesorter table table-striped table-hover" width="98%">
				<thead>
					<tr>
						<th>Category Name</th>
						<th>Slug</th>		
						<th width="75" class="center">Pages</th>
						<th width="75" class="center">Entries</th>	
						<th width="75" class="center {sorter:false}">Actions</th>
					</tr>
				</thead>				
				<tbody>
					<cfloop array="#prc.categories#" index="category">
					<tr>
						<td><a href="javascript:edit('#category.getCategoryID()#',
							   						 '#HTMLEditFormat( JSStringFormat( category.getCategory() ) )#',
							   						 '#HTMLEditFormat( JSStringFormat( category.getSlug() ) )#')" title="Edit #category.getCategory()#">#category.getCategory()#</a></td>
						<td>#category.getSlug()#</td>
						<td class="center"><span class="badge badge-info">#category.getNumberOfPages()#</span></td>
						<td class="center"><span class="badge badge-info">#category.getnumberOfEntries()#</span></td>
						<td class="center">
							<cfif prc.oAuthor.checkPermission("CATEGORIES_ADMIN")>
							<!--- Edit Command --->
							<a href="javascript:edit('#category.getCategoryID()#',
							   						 '#HTMLEditFormat( JSStringFormat( category.getCategory() ) )#',
							   						 '#HTMLEditFormat( JSStringFormat( category.getSlug() ) )#')" title="Edit #category.getCategory()#"><i class="icon-edit icon-large"></i></a>
							<!--- Delete Command --->
							<a title="Delete Category" href="javascript:remove('#category.getcategoryID()#')" class="confirmIt" data-title="Delete Category?"><i class="icon-trash icon-large" id="delete_#category.getCategoryID()#"></i></a>
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
<cfif prc.oAuthor.checkPermission("CATEGORIES_ADMIN")>
<!--- Permissions Editor --->
<div id="categoryEditorContainer" class="modal hide fade">
	<div id="modalContent">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>Category Editor</h3>
    </div>
	<!--- Create/Edit form --->
	#html.startForm(action=prc.xehCategoriesSave,name="categoryEditor",novalidate="novalidate",class="form-vertical")#
	<div class="modal-body">
		#html.hiddenField(name="categoryID",value="")#
		#html.textField(name="category",label="Category:",required="required",maxlength="100",size="30",class="input-block-level",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
		#html.textField(name="slug",label="Slug (blank to generate it):",maxlength="100",size="30",class="input-block-level",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
	</div>
	<!--- Footer --->
	<div class="modal-footer">
		#html.resetButton(name="btnReset",value="Cancel",class="btn", onclick="closeModal( $('##categoryEditorContainer') )")#
		#html.submitButton(name="btnSave",value="Save Category",class="btn btn-danger")#
	</div>
	#html.endForm()#
	</div>
</div>
</cfif>
</cfoutput>