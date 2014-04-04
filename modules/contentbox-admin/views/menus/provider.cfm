<cfoutput>
    <a class="dd-handle dd3-handle btn" title="Drag to reorder"><i class="icon-move icon-large"></i></a>
    <cfset btnCls = !args.menuItem.getActive() ? "btn-danger" : "btn-inverse">
    <a class="dd3-type btn #btnCls#" title="#args.provider.getDescription()#"><i class="#args.provider.getIconCls()#"></i></a>
    <div class="dd3-content double" data-toggle="context" data-target="##context-menu">#args.menuItem.getLabel()#</div>
    <div class="dd3-extracontent" style="display:none;">
        <!--- id --->
        <cfset label = "label-#getTickCount()#">
        #html.hiddenField( name="menuItemID", bind=args.menuItem, id="" )#  
        #html.hiddenField( name="menuType", value=args.provider.getType(), id="" )# 
        <div class="row-fluid">
            <span class="span6">
                #html.textfield(
                    label="Label:",
                    name="label",
                    id="",
                    bind=args.menuItem, 
                    maxlength="100",
                    required="required",
                    title="The label for this menu item",
                    class="textfield width95",
                    wrapper="div class=controls",
                    labelClass="control-label",
                    groupWrapper="div class=control-group"
                )#
                #html.textfield(
                    label="Data Attributes:",
                    name="data",
                    id="",
                    bind=args.menuItem, 
                    maxlength="100",
                    title="Data attributes to set on this menu item's HTML element",
                    class="textfield width95",
                    wrapper="div class=controls",
                    labelClass="control-label",
                    groupWrapper="div class=control-group"
                )#
            </span>
            <span class="span6">
                <!--- title --->
                #html.textfield(
                    label="Title:",
                    name="title",
                    id="",
                    bind=args.menuItem, 
                    maxlength="100",
                    title="The title for this menu item",
                    class="textfield width95",
                    wrapper="div class=controls",
                    labelClass="control-label",
                    groupWrapper="div class=control-group"
                )#
                #html.textfield(
                    label="CSS Classes:",
                    name="cls",
                    id="",
                    bind=args.menuItem, 
                    maxlength="100",
                    title="Additional CSS classes to use for this menu item's HTML element",
                    class="textfield width95",
                    wrapper="div class=controls",
                    labelClass="control-label",
                    groupWrapper="div class=control-group"
                )#
            </span>
        </div>
        <div class="row-fluid">
        <!---End default fields--->

        <!---do provider thing--->
        #args.provider.getAdminTemplate( menuItem=args.menuItem )#
        </div>
        <!---end provider thing--->
    </div>
    <a class="dd3-expand btn" title="Edit Details"><i class="icon-edit icon-large"></i></a>
    <a class="dd3-delete btn btn-danger" data-toggle="confirmation" data-title="Are you sure you want to remove this menu item and all its descendants?"><i class="icon-trash icon-large"></i></a>
</cfoutput>