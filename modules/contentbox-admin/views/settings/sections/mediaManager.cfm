<cfoutput>
<fieldset>
    <legend><i class="fa fa-th fa-lg"></i> Media Manager</legend>
        <p>From here you can control the media manager settings.</p>

        <!--- Location --->
        <div class="form-group">
            #html.label(
                class="control-label",
                field="",
                content="Directory Root: "
            )#
            <div class="controls">
                <small>The relative path or ColdFusion mapping in your server that will be the expanded root of your media manager.</small></br>
                #html.textField(
                    name="cb_media_directoryRoot",
                    required="required",
                    value=prc.cbSettings.cb_media_directoryRoot,
                    class="form-control",
                    title="The directory root of all your media files, make sure it is web accessible please"
                )#
            </div>
        </div>
        <!---Media Providers --->
        <div class="form-group">
            #html.label(
                class="control-label",
                field="",
                content="Media Providers: "
            )#
            <div class="controls">
                <small>Media providers are used to deliver your media files securely and with greater flexibility as you can place your entire media root outside of the webroot.</small><br/>
                <cfloop array="#prc.mediaProviders#" index="thisProvider">
                <div class="alert alert-info">
                    <label class="control-label" class="radio inline">
                        #html.radioButton(
                            name="cb_media_provider",
                            checked=(prc.cbSettings.cb_media_provider eq thisProvider.name),
                            value=thisProvider.name
                        )#
                        <strong>#thisProvider.displayName#</strong>
                    </label><br/>
                    #thisProvider.description# <br/>
                </div>
                </cfloop>
            </div>
        </div>
        <!--- Media Provider Caching --->
        <div class="form-group">
            #html.label(
                class="control-label",
                field="cb_media_provider_caching",
                content="Provider Caching Headers:"
            )#
            <div class="controls">
                <small>If enabled,
 the media provider system will issue caching headers for all assets. 
                You can use the <em>cbcache=true</em> URL param to issue no caching headers on any asset.</small><br/>
                #html.radioButton(
                    name="cb_media_provider_caching",
                    checked=prc.cbSettings.cb_media_provider_caching,
                    value=true
                )# Yes
                #html.radioButton(
                    name="cb_media_provider_caching",
                    checked=not prc.cbSettings.cb_media_provider_caching,
                    value=false
                )# No
            </div>
        </div>
    </fieldset>
    <fieldset>
    <legend><i class="fa fa-cog fa-lg"></i> FileBrowser Options</legend>
        
        <!--- Create Folders --->
        <div class="form-group">
            #html.label(
                class="control-label",
                field="cb_media_createFolders",
                content="Allow Creation of Folders:"
            )#
            <div class="controls">
                #html.radioButton(
                    name="cb_media_createFolders",
                    checked=prc.cbSettings.cb_media_createFolders,
                    value=true
                )# Yes
                #html.radioButton(
                    name="cb_media_createFolders",
                    checked=not prc.cbSettings.cb_media_createFolders,
                    value=false
                )# No
            </div>
        </div>
        <!--- Delete --->
        <div class="form-group">
            #html.label(
                class="control-label",
                field="cb_media_allowDelete",
                content="Allow Deletes:"
            )#
            <div class="controls">
                #html.radioButton(
                    name="cb_media_allowDelete",
                    checked=prc.cbSettings.cb_media_allowDelete,
                    value=true
                )# Yes
                #html.radioButton(
                    name="cb_media_allowDelete",
                    checked=not prc.cbSettings.cb_media_allowDelete,
                    value=false
                )# No
            </div>
        </div>
        <!--- Downloads --->
        <div class="form-group">
            #html.label(
                class="control-label",
                field="cb_media_allowDownloads",
                content="Allow Downloads:"
            )#
            <div class="controls">
                #html.radioButton(
                    name="cb_media_allowDownloads",
                    checked=prc.cbSettings.cb_media_allowDownloads,
                    value=true
                )# Yes
                #html.radioButton(
                    name="cb_media_allowDownloads",
                    checked=not prc.cbSettings.cb_media_allowDownloads,
                    value=false
                )# No
            </div>
        </div>
        <!--- Uploads --->
        <div class="form-group">
            #html.label(
                class="control-label",
                field="cb_media_allowUploads",
                content="Allow Uploads:"
            )#
            <div class="controls">
                #html.radioButton(
                    name="cb_media_allowUploads",
                    checked=prc.cbSettings.cb_media_allowUploads,
                    value=true
                )# Yes
                #html.radioButton(
                    name="cb_media_allowUploads",
                    checked=not prc.cbSettings.cb_media_allowUploads,
                    value=false
                )# No
            </div>
        </div>
        <!--- Mime Types --->
        <div class="form-group">
            #html.label(
                class="control-label",
                field="cb_media_acceptMimeTypes",
                content="Accepted Upload File Mime Types"
            )#
            <div class="controls">
                <small>The allowed mime types the <em>CFFile Upload & HTML5 uploads</em> will allow (<a href="http://help.adobe.com/en_US/ColdFusion/9.0/CFMLRef/WSc3ff6d0ea77859461172e0811cbec22c24-738f.html" target="_blank">See Reference</a>).</small></br>
                #html.textField(
                    name="cb_media_acceptMimeTypes",
                    value=prc.cbSettings.cb_media_acceptMimeTypes,
                    class="form-control",
                    title="The accepted mime types of the CFFile upload action. Blank means all files are accepted."
                )#
            </div>
        </div>
        <!--- size limits --->
        #html.textField(
            name="cb_media_html5uploads_maxFileSize",
            label="HTML5 Uploads - Size Limit (mb):",
            required="required",
            value=prc.cbSettings.cb_media_html5uploads_maxFileSize,
            class="form-control",
            title="The size limit of the HTML5 uploads.",
            wrapper="div class=controls",
            labelClass="control-label",
            groupWrapper="div class=form-group"
        )#
        #html.textField(
            name="cb_media_html5uploads_maxFiles",
            label="HTML5 Uploads - Max Simultaneous Uploads:",
            required="required",
            value=prc.cbSettings.cb_media_html5uploads_maxFiles,
            class="form-control",
            title="The maximum simultaneous HTML5 uploads.",
            wrapper="div class=controls",
            labelClass="control-label",
            groupWrapper="div class=form-group"
        )#
        <!--- Quick View --->
        #html.inputField(
            type="numeric",
            name="cb_media_quickViewWidth",
            label="Quick View Image Width: (pixels)",
            value=prc.cbSettings.cb_media_quickViewWidth,
            class="form-control",
            title="The width in pixels of the quick view dialog",
            wrapper="div class=controls",
            labelClass="control-label",
            groupWrapper="div class=form-group"
        )#
        
    </fieldset>
</cfoutput>