<cfoutput>
    <div class="row-fluid">
        <div class="control-group span12">
            <label for="submenu" class="control-label">Select Content Item:</label>
            <div class="controls">
                <div class="input-prepend input-block-level">
                    <span class="select-content add-on btn-info"><i class="icon-file-alt"></i></span>
                    <input type="hidden" name="contentSlug" class="textfield" required="true" value="#args.slug#" />
                    <input type="text" name="contentTitle" class="textfield input-block-level" required="true" title="Select a content item" readonly=true value="#args.title#" />
                </div>
            </div>
        </div>
    </div>
    <div class="row-fluid">
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
        <span class="span6">
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