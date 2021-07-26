<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
            <i class="fas fa-bars fa-lg"></i> Menu Designer
        </h1>
    </div>
</div>

#html.startForm(
    action      = prc.xehMenuSave,
    name        = "menuForm",
    novalidate  = "novalidate",
    class       = "form-vertical"
)#

<div class="row">

    <div class="col-md-9">

        <div class="panel panel-default">
            <div class="panel-heading">
                <div class="p11 size16">
                    <div class="actions">
                        <a class="btn btn-sm btn-info text-white" onclick="window.location.href='#event.buildLink( prc.xehMenus )#';return false;"><i class="fas fa-chevron-left"></i> Back</a>
                    </div>
                </div>
            </div>
            <div class="panel-body">

                #cbMessageBox().renderit()#

                <menu class="well well-sm">
                    <p>Click any of the options below to insert a new menu item of that type.</p>
                    <cfloop collection="#prc.providers#" item="provider">
                        <div class="btn-group" role="group">
                            <a class="btn btn-sm provider btn-info" data-provider="#provider#" title="#prc.providers[ provider ].getDescription()#">
                                <i class="#prc.providers[ provider].getIconClass()#"></i> #provider#
                            </a>
                        </div>
                    </cfloop>

                    <div class="btn-group pull-right" role="group">
                        <a class="btn btn-sm btn-primary" data-action="collapse-all">
                            <span style="display:inline-block;" title="Collapse All"><i class="fa fa-minus"></i> Collapse All</span>
                        </a>
                        <a class="btn btn-sm btn-primary" data-action="expand-all" style="margin-right:4px;">
                            <span style="display:inline-block;" title="Expand All"><i class="fa fa-plus"></i> Expand All</span>
                        </a>
                    </div>
                </menu>

                <div class="row">
                    <div class="col-md-7">
                        <h3>Menu Sandbox</h3>
                        <p>Insert new menu items and then drag-and-drop to get them in the perfect order.</p>
                        <div class="alert alert-danger" id="menuErrors" style="display:none;">
                            Uh oh, looks like one (or more) of your menu items is incomplete. Please complete all items and then try again.
                        </div>
                        <div id="placeholder-message" class="alert alert-info">You haven't added any menu items yet. Click on one of the menu types above to get started.</div>
                        <div class="designer well well-sm">
                            <div class="dd" id="nestable">
                                <ol class="dd-list">
                                    #prc.menuItems#
                                </ol>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-5">
                        <h3>Preview <a class="btn btn-sm btn-primary" id="preview-button"><i class="fas fa-recycle"></i></a></h3>
                        <p>Here's an instant preview of your menu.</p>
                        <div id="preview-panel" class="well well-sm">No Preview Available</div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <div class="col-md-3">
        <div class="panel panel-primary">
            <div class="panel-heading">
				<h3 class="panel-title">
					<i class="fas fa-bars fa-lg"></i> Menu Data
				</h3>
            </div>
            <div class="panel-body">
                <!--- id --->
                #html.hiddenField( name="menuID", bind=prc.menu )#
                #html.hiddenField( name="menuItems" )#
                <!--- title --->
                #html.textfield(
                    label="Title:",
                    name="title",
                    bind=prc.menu,
                    maxlength="100",
                    required="required",
                    title="The title for this menu",
                    class="form-control",
                    wrapper="div class=controls",
                    labelClass="control-label",
                    groupWrapper="div class=form-group"
                )#
                #html.select(
                    options="ul,ol",
                    name="listType",
                    label="List Type:",
                    bind=prc.menu,
                    required="required",
                    title="Select the type of list (ordered or unordered)",
                    class="form-control input-sm",
                    wrapper="div class=controls",
                    labelClass="control-label",
                    groupWrapper="div class=form-group"
                )#
                <div class="form-group">
                    <label for="slug" class="control-label">Menu Slug:</label>
                    <div class="controls">
                        <div id='slugCheckErrors'></div>
                        <div class="input-group">
                            #html.textfield(
                                name="slug",
                                value=prc.menu.getSlug(),
                                maxlength="100",
                                class="form-control",
                                title="The unique slug for this menu",
                                disabled="#prc.menu.isLoaded() ? 'true' : 'false'#"
                            )#
                            <a title="" class="input-group-addon" href="javascript:void(0)" onclick="toggleSlug(); return false;" data-original-title="Lock/Unlock Menu Slug" data-container="body">
                                <i id="toggleSlug" class="fa fa-#prc.menu.isLoaded() ? 'lock' : 'unlock'#"></i>
                            </a>
                        </div>
                    </div>
                </div>
                #html.textfield(
                    label="CSS Classes:",
                    name="menuClass",
                    bind=prc.menu,
                    maxlength="100",
                    title="Additional CSS classes to use for the main menu HTML element",
                    class="form-control",
                    wrapper="div class=controls",
                    labelClass="control-label",
                    groupWrapper="div class=form-group"
                )#
                #html.textfield(
                    label="List CSS Classes:",
                    name="listClass",
                    bind=prc.menu,
                    maxlength="100",
                    title="CSS classes to apply to all list elements (ul/ol) within this menu",
                    class="form-control",
                    wrapper="div class=controls",
                    labelClass="control-label",
                    groupWrapper="div class=form-group"
                )#
                <div class="actionBar">
                    <input type="hidden" name="saveEvent" id="saveEvent" value="#prc.xehMenuEditor#" />
                    <a class="btn btn-primary"  id="submitSave">Save</a>
                    <a class="btn btn-danger"   id="submitMenu">Save + Close</a>
                </div>
            </div>
        </div>
    </div>
</div>
#html.endForm()#

<!--- CONTEXT MENU TEMPLATE --->
<div id="context-menu" class="dropdown clearfix" style="position: absolute;display:none;">
    <ul class="dropdown-menu" role="menu" style="display:block;margin-bottom:5px;">
        <cfloop collection="#prc.providers#" item="provider">
            <li>
                <a tabindex="-1" class="child-provider" data-provider="#provider#" title="#prc.providers[ provider].getDescription()#">
                    <i class="#prc.providers[ provider].getIconClass()#"></i> Add #provider# Item
                </a>
            </li>
        </cfloop>
  </ul>
</div>

<!--- PREVIEW DIALOG --->
<div id="previewDialog" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document" >
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h3><i class="far fa-eye"></i> Menu Preview</h3>
            </div>
            <div class="modal-body"></div>
        </div>
    </div>
</div>
</cfoutput>