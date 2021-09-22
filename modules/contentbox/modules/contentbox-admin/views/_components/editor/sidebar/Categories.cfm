<cfoutput>
<cfif prc.oCurrentAuthor.checkPermission( "EDITORS_CATEGORIES" )>
	<div class="panel panel-default">
		<div class="panel-heading">
			<h4 class="panel-title">
				<a class="accordion-toggle collapsed block" data-toggle="collapse" data-parent="##accordion" href="##categories">
					<i class="fas fa-tags"></i> Categories
				</a>
			</h4>
		</div>
		<div id="categories" class="panel-collapse collapse">
			<div class="panel-body">
				<!--- Display categories --->
				<div id="categoriesChecks">
				<cfloop from="1" to="#arrayLen( prc.categories )#" index="x">
					<div class="checkbox">
						<label>
						#html.checkbox(
							name 	= "category_#x#",
							value 	= "#prc.categories[ x ].getCategoryID()#",
							checked = prc.oContent.hasCategories( prc.categories[ x ] )
						)#
						#prc.categories[ x ].getCategory()#
						<cfif !prc.categories[ x ].getIsPublic()>
							<i
								class="ml5 fas fa-lock"
								title="Private Category"></i>
						</cfif>
						</label>
					</div>
				</cfloop>
				</div>

				<!--- New Categories --->
				#html.textField(
					name="newCategories",
					label="New Categories",
					size="30",
					title="Comma delimited list of new categories to create",
					class="form-control"
				)#
			</div>
		</div>
	</div>
</cfif>
</cfoutput>