<cfoutput>
    <div class="row-fluid">
        <span class="span6">
            #html.textfield(
                label="URL:",
                name="url",
                id="",
                bind=args.menuItem, 
                maxlength="100",
                required="required",
                title="The URL for this menu item",
                class="textfield input-block-level",
                wrapper="div class=controls",
                labelClass="control-label",
                groupWrapper="div class=control-group"
            )#
        </span>
        <span class="span6">
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
    <div class="row-fluid">
        <span class="span12">
            #html.select(
                options="_blank,_self,_parent,_top", 
                name="target",
                label="Target:",
                id="",
                bind=args.menuItem, 
                required="required",
                title="Where URL should be opened",
                class="textfield input-block-level",
                wrapper="div class=controls",
                labelClass="control-label",
                groupWrapper="div class=control-group"
            )#
        </span>
    </div>
</cfoutput>