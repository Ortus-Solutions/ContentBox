<cfoutput>
    <div class="row-fluid">
        <div class="control-group span12">
            <label for="media" class="control-label">Select Media Item:</label>
            <div class="controls">
                <div class="input-prepend input-block-level">
                    <span class="select-media add-on btn-info"><i class="icon-file-alt"></i></span>
                    <input type="hidden" name="mediaPath" class="textfield" required="true" value="#args.menuItem.getMediaPath()#" />
                    <input type="text" name="media" class="textfield input-block-level" required="true" title="Select a media item" readonly=true value="#args.menuItem.getMediaPath()#" />
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