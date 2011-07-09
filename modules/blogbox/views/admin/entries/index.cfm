<cfoutput>
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
	function remove(categoryID){
		if( confirm("Really delete?") ){
			$("##categoryID").val( categoryID );
			$("##authorForm").submit();
		}
	}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">
<!--- Title --->
<h1>Category Management</h1>
<!--- MessageBox --->
#getPlugin("MessageBox").renderit()#

<ul>
	<li><a href="#event.buildLink(rc.xehCategoryEditor)#">Create Category</a></li>
</ul>

<!--- CategoryForm --->
<form name="categoryForm" id="authorForm" method="post" action="#event.buildLink(rc.xehCategoryRemove)#">
<input type="hidden" name="categoryID" id="categoryID" value="" />

<!--- authors --->
<table name="categories" id="categories" class="tablelisting" width="98%">
	<thead>
		<tr>
			<th>Name</th>
			<th>Slug</th>			
			<th width="125" class="center">Actions</th>
		</tr>
	</thead>
	
	<tbody>
		<cfloop array="#rc.categories#" index="category">
		<tr>
			<td><a href="#event.buildLink(rc.xehCategoryEditor)#/categoryID/#category.getcategoryID()#" title="Edit #category.getCategory()#">#category.getCategory()#</a></td>
			<td>#category.getSlug()#</td>
			<td class="center">
				<input type="button" onclick="remove('#category.getcategoryID()#')" value="Delete" title="Delete Category"/>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>
</form>
</cfoutput>