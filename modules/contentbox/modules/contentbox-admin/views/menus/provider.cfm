<cfoutput>
	<a class="dd-handle dd3-handle btn" title="Drag to reorder">
		<i class="fa fa-crosshairs fa-lg"></i>
	</a>

	<cfset btnCls = !args.menuItem.getActive() ? "btn-danger" : "btn-primary">

	<a class="dd3-type btn #btnCls#" title="#args.provider.getDescription()#">
		<i class="#args.provider.getIconClass()#"></i>
	</a>

	<div class="dd3-content double" data-toggle="context" data-target="##context-menu">
		#args.menuItem.getLabel()#
	</div>

	<div class="dd3-extracontent" style="display:none;">
		<!--- id --->
		<cfset label = "label-#getTickCount()#">
		#html.hiddenField( name="menuItemID", bind=args.menuItem, id="" )#
		#html.hiddenField( name="menuType", value=args.provider.getType(), id="" )#

		<fieldset>
			<legend>Common Attributes</legend>
			<p>These attributes will be applied to the main &lt;li&gt; element</p>
			<div class="row">
				<span class="col-md-6">
					#html.textfield(
						label="Item Content:",
						name="label",
						id="",
						bind=args.menuItem,
						maxlength="100",
						required="required",
						title="The content for this menu item",
						class="form-control",
						wrapper="div class=controls",
						labelClass="control-label",
						groupWrapper="div class=form-group"
					)#
				</span>
				<span class="col-md-6">
					#html.textfield(
						label="CSS Classes:",
						name="itemClass",
						id="",
						bind=args.menuItem,
						maxlength="100",
						title="Additional CSS classes to use for this menu item's HTML element",
						class="form-control",
						wrapper="div class=controls",
						labelClass="control-label",
						groupWrapper="div class=form-group"
					)#
				</span>
			</div>
		</fieldset>

		<!---End default fields--->
		<cfif len( args.provider.getAdminTemplate( menuItem=args.menuItem ) )>
			<fieldset>
				<legend>#args.provider.getName()# Attributes</legend>
				<p>These attributes can be used to customize the item's content</p>
				<!---do provider thing--->
				#args.provider.getAdminTemplate( menuItem=args.menuItem )#

				<div class="row">
					<span class="col-md-6">
						<!--- data attribute --->
						#html.textfield(
							label="Data Attributes:",
							name="data",
							id="",
							bind=args.menuItem,
							maxlength="100",
							title="Data attributes: You can use JSON ( {""me"":""you""} ) or a comma-delimited list ( me=you,icecream=awesome )",
							class="form-control",
							wrapper="div class=controls",
							labelClass="control-label",
							groupWrapper="div class=form-group"
						)#
					</span>
					<span class="col-md-6">
						<!--- title --->
						#html.textfield(
							label="Title:",
							name="title",
							id="",
							bind=args.menuItem,
							maxlength="100",
							title="The title for this menu item",
							class="form-control",
							wrapper="div class=controls",
							labelClass="control-label",
							groupWrapper="div class=form-group"
						)#
					</span>
				</div>

			</fieldset>
		</cfif>
		<!---end provider thing--->
	</div>

	<a class="dd3-expand btn" title="Edit Details">
		<i class="fas fa-pen fa-lg"></i>
	</a>
	<a 	class="dd3-delete btn btn-danger confirmIt"
		data-message="Are you sure you want to remove this menu item and all its descendants? <br> Please note that changes are not final until you save the menu."
		data-title="Delete Menu Item"
		title="Delete Menu Item + Descendants"
		href="javascript:removeMenuItem( 'key_#args.menuItem.getMenuItemID()#' )">
		<i class="far fa-trash-alt fa-lg"></i>
	</a>
</cfoutput>