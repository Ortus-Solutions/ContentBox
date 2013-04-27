<cfoutput>
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
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
					<!--- Filter Bar --->
					<div class="filterBar">
						<div>
							#html.textField(name="categoryFilter",size="30",class="textfield",label="Quick Filter:")#
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
							<td><a href="javascript:edit('#category.getCategoryID()#','#category.getCategory()#','#category.getSlug()#')" title="Edit #category.getCategory()#">#category.getCategory()#</a></td>
							<td>#category.getSlug()#</td>
							<td class="center"><span class="badge badge-info">#category.getNumberOfPages()#</span></td>
							<td class="center"><span class="badge badge-info">#category.getnumberOfEntries()#</span></td>
							<td class="center">
								<cfif prc.oAuthor.checkPermission("CATEGORIES_ADMIN")>
								<!--- Edit Command --->
								<a href="javascript:edit('#category.getCategoryID()#','#category.getCategory()#','#category.getSlug()#')" title="Edit #category.getCategory()#"><i class="icon-edit icon-large"></i></a>
								<!--- Delete Command --->
								<a title="Delete Category" href="javascript:remove('#category.getcategoryID()#')" class="confirmIt" data-title="Delete Category?"><i class="icon-remove-sign icon-large" id="delete_#category.getCategoryID()#"></i></a>
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

	<!--- main sidebar --->
	<div class="span3" id="main-sidebar">
		<!--- Editor Box --->
		<cfif prc.oAuthor.checkPermission("CATEGORIES_ADMIN")>
		<div class="small_box">
			<div class="header">
				<i class="icon-edit"></i> Editor
			</div>
			<div class="body">
				<!--- Create/Edit form --->
				#html.startForm(action=prc.xehCategoriesSave,name="categoryEditor",novalidate="novalidate",class="form-vertical")#
					#html.hiddenField(name="categoryID",value="")#
					#html.textField(name="category",label="Category:",required="required",maxlength="100",size="30",class="input-block-level",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
					#html.textField(name="slug",label="Slug (blank to generate it):",maxlength="100",size="30",class="input-block-level",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
					#html.resetButton(name="btnReset",value="Reset Form",class="btn")#
					#html.submitButton(value="Save Category",class="btn btn-danger")#
					
				#html.endForm()#
			</div>
		</div>		
		</cfif>
	</div>
</div>
</cfoutput>