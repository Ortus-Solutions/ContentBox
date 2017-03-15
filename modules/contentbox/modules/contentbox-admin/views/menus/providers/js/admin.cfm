<cfoutput>
    <div class="row">
        <span class="col-md-6">
            #html.textarea(
                label="JavaScript Code:",
                name="js",
                id="",
                bind=args.menuItem, 
                maxlength="100",
                required="required",
                title="JavaScript to be executed when this item is clicked",
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
</cfoutput>