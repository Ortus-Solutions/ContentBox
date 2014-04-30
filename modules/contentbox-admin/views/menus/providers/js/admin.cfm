<cfoutput>
    <div class="row-fluid">
        <span class="span12">
            #html.textarea(
                label="JavaScript Code:",
                name="js",
                id="",
                bind=args.menuItem, 
                maxlength="100",
                required="required",
                title="JavaScript to be executed when this item is clicked",
                class="textfield input-block-level",
                wrapper="div class=controls",
                labelClass="control-label",
                groupWrapper="div class=control-group"
            )#
        </span>
    </div>
    <div class="row-fluid">
        <span class="span12">
            #html.textfield(
                label="URL Classes:",
                name="urlClass",
                id="",
                bind=args.menuItem, 
                maxlength="100",
                title="Extra CSS classes to add to this menu item",
                class="textfield input-block-level",
                wrapper="div class=controls",
                labelClass="control-label",
                groupWrapper="div class=control-group"
            )#
        </span>
    </div>
</cfoutput>