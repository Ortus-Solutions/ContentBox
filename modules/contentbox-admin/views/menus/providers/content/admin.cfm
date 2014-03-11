<cfoutput>
    <div class="control-group">
        <label for="submenu" class="control-label">Select Content Item:</label>
        <div class="controls">
            <div class="input-prepend" style="display:block;">
                <span class="select-content add-on btn-info"><i class="icon-file-alt"></i></span>
                <input type="hidden" name="contentSlug" class="textfield" required="true" value="#args.slug#" />
                <input type="text" name="contentTitle" class="textfield" required="true" title="Select a content item" readonly=true value="#args.title#" />
            </div>
        </div>
    </div>
</cfoutput>