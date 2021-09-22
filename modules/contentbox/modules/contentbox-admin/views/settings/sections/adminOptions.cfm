<cfoutput>
#html.startForm( name="adminSettingsForm", action=prc.xehSaveSettings )#
<fieldset>
    <legend><i class="fa fa-signal fa-lg"></i>  Dashboard Options</legend>

    <!--- Tag Line --->
    #html.textField(
        name            = "cb_dashboard_welcome_title",
        label           = "Welcome Title:",
        value           = prc.cbSettings.cb_dashboard_welcome_title,
        class           = "form-control",
        wrapper         = "div class=controls",
        labelClass      = "control-label",
        groupWrapper    = "div class=form-group"
    )#

    <!--- Description --->
    <div class="form-group">
        <label class="control-label" for="cb_dashboard_welcome_body">Welcome Body:</label>
        <div class="controls">
            <small>HTML/Markdown enabled.</small><br/>
            #html.textarea(
                name            = "cb_dashboard_welcome_body",
                value           = prc.cbSettings.cb_dashboard_welcome_body,
                rows            = "3",
                class           = "form-control mde"
            )#
        </div>
    </div>

    <!--- Dashboard Feed --->
    <div class="form-group">
        <label class="control-label" for="cb_dashboard_newsfeed">News Feed</label>
        <div class="controls">
            <small>The RSS feed URL to present in the dashboard. Leave blank if you don't want any news to display.</small><br/>
            #html.URLField(
                name  = "cb_dashboard_newsfeed",
                value = prc.cbSettings.cb_dashboard_newsfeed,
                class = "form-control",
                title = "The RSS feed to present in the dashboard"
            )#
        </div>
    </div>

    <!--- Recent Feed Count --->
    <div class="form-group">
        <label class="control-label" for="cb_dashboard_newsfeed_count">
            News Feed Count
            <span class="badge badge-info" id="cb_dashboard_newsfeed_count_label">#prc.cbSettings.cb_dashboard_newsfeed_count#</span>
        </label>
        <div class="controls">
            <strong class="m10">10</strong>
            <input 	type="text"
                    id="cb_dashboard_newsfeed_count"
                    name="cb_dashboard_newsfeed_count"
                    class="slider"
                    data-slider-value="#prc.cbSettings.cb_dashboard_newsfeed_count#"
                    data-provide="slider"
                    data-slider-min="10"
                    data-slider-max="50"
                    data-slider-step="10"
                    data-slider-tooltip="hide"
            >
            <strong class="m10">50</strong>
        </div>
    </div>

    <!--- Recent Entries --->
    <div class="form-group">
        <label class="control-label" for="cb_dashboard_recentEntries">
            Recent Entries Count
            <span class="badge badge-info" id="cb_dashboard_recentEntries_label">#prc.cbSettings.cb_dashboard_recentEntries#</span>
        </label>
        <div class="controls">
            <strong class="m10">10</strong>
            <input 	type="text"
                    id="cb_dashboard_recentEntries"
                    name="cb_dashboard_recentEntries"
                    class="slider"
                    data-slider-value="#prc.cbSettings.cb_dashboard_recentEntries#"
                    data-provide="slider"
                    data-slider-min="10"
                    data-slider-max="50"
                    data-slider-step="10"
                    data-slider-tooltip="hide"
            >
            <strong class="m10">50</strong>
        </div>
    </div>

    <!--- Recent Pages --->
    <div class="form-group">
        <label class="control-label" for="cb_dashboard_recentPages">
            Recent Pages Count
            <span class="badge badge-info" id="cb_dashboard_recentPages_label">#prc.cbSettings.cb_dashboard_recentPages#</span>
        </label>
        <div class="controls">
            <strong class="m10">10</strong>
            <input 	type="text"
                    id="cb_dashboard_recentPages"
                    name="cb_dashboard_recentPages"
                    class="slider"
                    data-slider-value="#prc.cbSettings.cb_dashboard_recentPages#"
                    data-provide="slider"
                    data-slider-min="10"
                    data-slider-max="50"
                    data-slider-step="10"
                    data-slider-tooltip="hide"
            >
            <strong class="m10">50</strong>
        </div>
    </div>

    <!--- Recent ContentStore --->
    <div class="form-group">
        <label class="control-label" for="cb_dashboard_recentContentStore">
            Recent Content Store Count
            <span class="badge badge-info" id="cb_dashboard_recentContentStore_label">#prc.cbSettings.cb_dashboard_recentContentStore#</span>
        </label>
        <div class="controls">
            <strong class="m10">10</strong>
            <input 	type="text"
                    id="cb_dashboard_recentContentStore"
                    name="cb_dashboard_recentContentStore"
                    class="slider"
                    data-slider-value="#prc.cbSettings.cb_dashboard_recentContentStore#"
                    data-provide="slider"
                    data-slider-min="10"
                    data-slider-max="50"
                    data-slider-step="10"
                    data-slider-tooltip="hide"
            >
            <strong class="m10">50</strong>
        </div>
    </div>

    <!--- Recent Comments--->
    <div class="form-group">
        <label class="control-label" for="cb_dashboard_recentComments">
            Recent Comments Count
            <span class="badge badge-info" id="cb_dashboard_recentComments_label">#prc.cbSettings.cb_dashboard_recentComments#</span>
        </label>
        <div class="controls">
            <strong class="m10">10</strong>
            <input 	type="text"
                    id="cb_dashboard_recentComments"
                    name="cb_dashboard_recentComments"
                    class="slider"
                    data-slider-value="#prc.cbSettings.cb_dashboard_recentComments#"
                    data-provide="slider"
                    data-slider-min="10"
                    data-slider-max="50"
                    data-slider-step="10"
                    data-slider-tooltip="hide"
            >
            <strong class="m10">50</strong>
        </div>
    </div>

    <!--- Recent Logins--->
    <div class="form-group">
        <label class="control-label" for="cb_security_latest_logins">
            Recent Logins Count
            <span class="badge badge-info" id="cb_security_latest_logins_label">#prc.cbSettings.cb_security_latest_logins#</span>
        </label>
        <div class="controls">
            <strong class="m10">10</strong>
            <input 	type="text"
                    id="cb_security_latest_logins"
                    name="cb_security_latest_logins"
                    class="slider"
                    data-slider-value="#prc.cbSettings.cb_security_latest_logins#"
                    data-provide="slider"
                    data-slider-min="10"
                    data-slider-max="50"
                    data-slider-step="10"
                    data-slider-tooltip="hide"
            >
            <strong class="m10">50</strong>
        </div>
    </div>
</fieldset>


<fieldset>
    <legend><i class="far fa-clone fa-lg"></i>  Paging Options</legend>

    <!--- Quick Search --->
    <div class="form-group">
        <label class="control-label" for="cb_admin_quicksearch_max">
            Max Quick Search Count:
            <span class="badge badge-info" id="cb_admin_quicksearch_max_label">#prc.cbSettings.cb_admin_quicksearch_max#</span>
        </label>
        <div class="controls">
            <small>The number of results to show in the global search results panel.</small><br/>
            <strong class="m10">10</strong>
            <input 	type="text"
                    id="cb_admin_quicksearch_max"
                    name="cb_admin_quicksearch_max"
                    class="slider"
                    data-slider-value="#prc.cbSettings.cb_admin_quicksearch_max#"
                    data-provide="slider"
                    data-slider-min="10"
                    data-slider-max="50"
                    data-slider-step="10"
                    data-slider-tooltip="hide"
            >
            <strong class="m10">50</strong>
        </div>
    </div>

    <!--- Max Blog Post --->
    <div class="form-group">
        <label class="control-label" for="cb_paging_maxentries">
            Max Home Page Blog Entries:
            <span class="badge badge-info" id="cb_paging_maxentries_label">#prc.cbSettings.cb_paging_maxentries#</span>
        </label>
        <div class="controls">
            <small>The number of entries to show on the blog before paging is done.</small><br/>
            <strong class="m10">10</strong>
            <input 	type="text"
                    id="cb_paging_maxentries"
                    name="cb_paging_maxentries"
                    class="slider"
                    data-slider-value="#prc.cbSettings.cb_paging_maxentries#"
                    data-provide="slider"
                    data-slider-min="10"
                    data-slider-max="50"
                    data-slider-step="10"
                    data-slider-tooltip="hide"
            >
            <strong class="m10">50</strong>
        </div>
    </div>

    <!--- Max Rows --->
    <div class="form-group">
        <label class="control-label" for="cb_paging_maxrows">
            Paging Max Rows
            <span class="badge badge-info" id="cb_paging_maxrows_label">#prc.cbSettings.cb_paging_maxrows#</span>
        </label>
        <div class="controls">
            <small>The max rows to use in the administrator.</small><br/>
            <strong class="m10">10</strong>
            <input 	type="text"
                    id="cb_paging_maxrows"
                    name="cb_paging_maxrows"
                    class="slider"
                    data-slider-value="#prc.cbSettings.cb_paging_maxrows#"
                    data-provide="slider"
                    data-slider-min="10"
                    data-slider-max="50"
                    data-slider-step="10"
                    data-slider-tooltip="hide"
            >
            <strong class="m10">50</strong>
        </div>
    </div>

    <!--- Max Band Gap --->
    <div class="form-group">
        <label class="control-label" for="cb_paging_bandgap">
            Paging Band Gap
            <span class="badge badge-info" id="cb_paging_bandgap_label">#prc.cbSettings.cb_paging_bandgap#</span>
        </label>
        <div class="controls">
            <small>The paging bandgap to use in the administrator.</small><br/>
            <strong class="m10">1</strong>
            <input 	type="text"
                    id="cb_paging_bandgap"
                    name="cb_paging_bandgap"
                    class="slider"
                    data-slider-value="#prc.cbSettings.cb_paging_bandgap#"
                    data-provide="slider"
                    data-slider-min="1"
                    data-slider-max="10"
                    data-slider-step="1"
                    data-slider-tooltip="hide"
            >
            <strong class="m10">10</strong>
        </div>
    </div>
</fieldset>

<!--- Button Bar --->
<div class="form-actions mt20">
	#html.submitButton( value="Save Settings", class="btn btn-danger" )#
</div>

#html.endForm()#
</cfoutput>
