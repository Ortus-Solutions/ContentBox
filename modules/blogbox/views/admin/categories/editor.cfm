<cfoutput>
<cfform action="#event.buildLink(rc.xehCategoriesSave)#" method="POST" name="categoryForm" id="categoryForm">
	<input type="hidden" name="categoryID" id="category" value="#rc.category.getCategoryID()#" />
	<h1>Category Editor</h1>
	
	<p>Name:<br/>
	<cfinput name="category" type="text" required="true" validateat="onSubmit" 
			 maxlength="100" size="50" message="Please enter a category." 
			 value="#rc.category.getCategory()#"/>
	</p>
	
	<p>Slug: (Optional-Blank to generate it)<br/>
	<cfinput name="slug" type="text" required="false" validateat="onSubmit" 
			 maxlength="100" size="50" 
			 value="#rc.category.getSlug()#"/>
	</p>
	
	<hr/>
	
	<p>
		<a href="#event.buildLink(rc.xehCategories)#">Cancel</a> or
		<input type="submit" value="Save">
	</p>
</cfform>
</cfoutput>