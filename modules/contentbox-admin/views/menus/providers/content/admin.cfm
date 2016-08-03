<cfoutput>
    <div class="row">
        <div class="form-group col-md-12">
            <label for="contentTitle" class="control-label">Select Content Item:</label>
            <div class="controls">
                <div class="input-group no-margin">
                    <span class="input-group-addon btn-info select-content">
                       <i class="fa fa-file"></i>
                    </span>
                    <input type="hidden" name="contentSlug" class="textfield" required="true" value="#args.slug#" />
                    <input type="text" name="contentTitle" class="form-control" required="true" title="Select a content item" readonly=true value="#args.title#" />
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <span class="col-md-6">
            #html.textfield(
                label="URL Classes:",
                name="urlClass",
                id="",
                bind=args.menuItem, 
                maxlength="100",
                title="Extra CSS classes to add to this menu item",
                class="form-control",
                wrapper="div class=controls",
                labelClass="control-label",
                groupWrapper="div class=form-group"
            )#
        </span>
        <span class="col-md-6">
            #html.select(
                options=html.options([
                    {"name"= "Select", "value"= ""},
                    {"name"= "_self", "value"= "_self"},
                    {"name"= "_blank", "value"= "_blank"},
                    {"name"= "_parent", "value"= "_parent"},
                    {"name"= "_top", "value"= "_top"}
                ]),
                selectedValue="",
                name="target",
                label="Target:",
                id="",
                bind=args.menuItem, 
                title="Where URL should be opened",
                class="form-control input-sm",
                wrapper="div class=controls",
                labelClass="control-label",
                groupWrapper="div class=form-group"
            )#
        </span>
    </div>
</cfoutput>