<cfoutput>
<cfif prc.oCurrentAuthor.checkPermission( "EDITORS_DISPLAY_OPTIONS" )>
	<div class="panel panel-default">

		<div class="panel-heading">
			<h4 class="panel-title">
				<a
					class="accordion-toggle collapsed block"
					data-toggle="collapse"
					data-parent="##accordion"
					href="##displayoptions">
				<i class="fas fa-photo-video"></i> Display Options
				</a>
			</h4>
		</div>

		<div id="displayoptions" class="panel-collapse collapse">
			<div class="panel-body">

				<!--- PAGE LAYOUT --->
				<div class="form-group">
					<label for="layout" class="control-label">
						<i class="fas fa-columns"></i>
						Layout:
					</label>
					<select name="layout" id="layout" class="form-control input-sm">
						<!--- Core Layouts --->
						<option value="-inherit-" <cfif prc.oContent.getLayoutWithDefault() eq "-inherit-">selected="selected"</cfif>>-inherit-</option>
						<option value="-no-layout-" <cfif prc.oContent.getLayoutWithDefault() eq "-no-layout-">selected="selected"</cfif>>-no-layout-</option>
						<!-- Custom Layouts -->
						#html.options(
							values 			: prc.availableLayouts,
							selectedValue	: prc.oContent.getLayoutWithDefault()
						)#
					</select>
				</div>

				<!--- SHOW IN MENU BUILDERS --->
				<div class="form-group">
					<label for="layout" class="control-label">
						<i class="fas fa-bars"></i>
						Show in Menus:
					</label>
					#html.select(
						name          : "showInMenu",
						class         : "form-control input-sm",
						options       : "Yes,No",
						selectedValue : yesNoFormat( prc.oContent.getShowInMenu() )
					)#
				</div>

				<!--- SHOW IN SEARCH --->
				<div class="form-group">
					<label for="layout" class="control-label">
						<i class="fas fa-search"></i>
						Show in Search:
					</label>
					#html.select(
						name          : "showInSearch",
						class         : "form-control input-sm",
						options       : "Yes,No",
						selectedValue : yesNoFormat( prc.oContent.getShowInSearch() )
					)#
				</div>
			</div>
		</div>
	</div>
</cfif>
</cfoutput>