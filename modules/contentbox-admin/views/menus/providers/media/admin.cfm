<cfoutput>
    <div class="control-group">
        <label for="media" class="control-label">Select Media Item:</label>
        <div class="controls">
            <div class="input-prepend" style="display:block;">
                <span class="select-media add-on btn-info"><i class="icon-file-alt"></i></span>
                <input type="hidden" name="mediaPath" class="textfield" required="true" value="#args.menuItem.getMediaPath()#" />
                <input type="text" name="media" class="textfield" required="true" title="Select a media item" readonly=true value="#args.menuItem.getMediaPath()#" />
            </div>
        </div>
    </div>
</cfoutput>