<cfoutput>
    <div class="row">
        <span class="col-md-6">
            #html.textfield(
                label="URL:",
                name="url",
                id="",
                bind=args.menuItem, 
                maxlength="100",
                required="required",
                title="The URL for this menu item",
                class="form-control",
                wrapper="div class=controls",
                labelClass="control-label",
                groupWrapper="div class=form-group"
            )#
        </span>
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
    </div>
    <div class="row">
        <span class="col-md-12">
            #html.select(
                options="_blank,_self,_parent,_top", 
                name="target",
                label="Target:",
                id="",
                bind=args.menuItem, 
                required="required",
                title="Where URL should be opened",
                class="form-control input-sm",
                wrapper="div class=controls",
                labelClass="control-label",
                groupWrapper="div class=form-group"
            )#
        </span>
    </div>
</cfoutput>