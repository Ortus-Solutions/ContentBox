<cfoutput>
	<cfset menuItemID = structKeyExists( args, "menuItemID" ) ? args.menuItemID : args.menuItem.getId()>

	<div role="button" class="dd-handle dd3-handle btn" title="Drag to reorder">
		<i class="fa fa-crosshairs fa-lg"></i>
	</div>

	<div class="dd3-actions">
		<cfset btnCls = !args.menuItem.getActive() ? "btn-danger" : "btn-primary">

		<button type="button" class="dd3-type btn #btnCls#" title="#args.provider.getDescription()#">
			<i class="#args.provider.getIconClass()#"></i>
		</button>

		<div class="dd3-content double" data-toggle="context" data-target="##context-menu">
			#args.menuItem.getLabel()#
		</div>

		<button type="button" class="dd3-expand btn" title="Edit Details" @click="$store.menusStore.toggleEditor( '#menuItemID#' )">
			<i class="fas fa-pen fa-lg"></i>
		</button>

		<button class="dd3-delete btn confirmIt"
			data-message="Are you sure you want to remove this menu item and all its descendants? <br> Please note that changes are not final until you save the menu."
			data-title="Delete Menu Item"
			title="Delete Menu Item + Descendants"
			href="javascript:removeMenuItem( 'key_#args.menuItem.getMenuItemID()#' )">
			<i class="fa fa-trash fa-lg"></i>
		</button>
	</div>

	<div class="dd3-extracontent" x-show="$store.menusStore.editingMenus.indexOf( '#menuItemID#' ) > -1">
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
						label="Item Content:<span class='text-danger' aria-label='required'>*</span>",
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

		<!--- Render Provider Attributes --->
		<cfset adminTemplate = args.provider.getAdminTemplate( menuItem=args.menuItem )>
		<cfif len( adminTemplate )>
			<fieldset>
				<legend>#args.provider.getName()# Attributes</legend>
				<p>These attributes can be used to customize the item's content</p>

				<!---do provider thing--->
				#adminTemplate#

				<div class="row">

					<!--- data attribute --->
					<span class="col-md-6">
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

					<!--- title --->
					<span class="col-md-6">
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
</cfoutput>
