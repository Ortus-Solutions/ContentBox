<cfoutput>
	#html.startForm( name="contentSettingsForm", action=prc.xehSaveSettings )#
    <fieldset>
        <legend><i class="fas fa-boxes fa-lg"></i>  Content Options</legend>

        <!--- Content Max Versions --->
        <div class="form-group">
            <label class="control-label" for="cb_versions_max_history">
                Content Max Versions To Keep:
                <span class="badge badge-info" id="cb_versions_max_history_label">#prc.cbSettings.cb_versions_max_history#</span>
            </label>
            <div class="controls">
                <small>The number of versions to keep before older versions are removed.</small><br/>
                <strong class="m10">10</strong>
                <input 	type="text"
                        id="cb_versions_max_history"
                        name="cb_versions_max_history"
                        class="slider"
                        data-slider-value="#prc.cbSettings.cb_versions_max_history#"
                        data-provide="slider"
                        data-slider-min="10"
                        data-slider-max="500"
                        data-slider-step="10"
                        data-scale="logarithmic"
                        data-slider-tooltip="hide"
                >
                <strong class="m10">500</strong>
            </div>
        </div>

        <!--- Commit Mandatory --->
        <div class="form-group">
            #html.label(
                class="control-label",
                field="cb_versions_commit_mandatory",
                content="Mandatory commit changelog:"
            )#
            <div class="controls">
                <small>When enabled a commit changelog will have to be entered before any content revision is saved.</small><br /><br />
                #html.checkbox(
					name    = "cb_versions_commit_mandatory_toggle",
					data	= { toggle: 'toggle', match: 'cb_versions_commit_mandatory' },
					checked	= prc.cbSettings.cb_versions_commit_mandatory
				)#
				#html.hiddenField(
					name	= "cb_versions_commit_mandatory",
					value	= prc.cbSettings.cb_versions_commit_mandatory
				)#
            </div>
        </div>
        <!--- Page Excerpts --->
        <div class="form-group">
            #html.label(
                class="control-label",
                field="cb_page_excerpts",
                content="Allow Page Excerpts:"
            )#
            <div class="controls">
                <small>Enable/Disabled page excerpt summaries.</small><br /><br />
                #html.checkbox(
					name    = "cb_page_excerpts_toggle",
					data	= { toggle: 'toggle', match: 'cb_page_excerpts' },
					checked	= prc.cbSettings.cb_page_excerpts
				)#
				#html.hiddenField(
					name	= "cb_page_excerpts",
					value	= prc.cbSettings.cb_page_excerpts
				)#
            </div>
        </div>
        <!--- UI Exports --->
        <div class="form-group">
            #html.label(
                class   = "control-label",
                field   = "cb_content_uiexport",
                content = "Allow UI content export formats:"
            )#
            <div class="controls">
                <small>Enable/Disabled the ability to export pages/blog/etc from the UI module via format extensions like pdf,doc,print,json, and xml.</small><br /><br />
                #html.checkbox(
					name    = "cb_content_uiexport_toggle",
					data	= { toggle: 'toggle', match: 'cb_content_uiexport' },
					checked	= prc.cbSettings.cb_content_uiexport
				)#
				#html.hiddenField(
					name	= "cb_content_uiexport",
					value	= prc.cbSettings.cb_content_uiexport
				)#
            </div>
        </div>
    </fieldset>

	<fieldset>
    	<legend><i class="far fa-chart-bar fa-lg"></i> Content Stats Tracking</legend>

        <!--- Hit Count --->
        <div class="form-group">
            #html.label(
            	class="control-label",
            	field="cb_content_hit_count",
            	content="Content Hit Count Tracking:"
            )#
            <div class="controls">
                <small>Enable/Disable content hit count tracking</small><br /><br />
                #html.checkbox(
					name    = "cb_content_hit_count_toggle",
					data	= { toggle: 'toggle', match: 'cb_content_hit_count' },
					checked	= prc.cbSettings.cb_content_hit_count
				)#
				#html.hiddenField(
					name	= "cb_content_hit_count",
					value	= prc.cbSettings.cb_content_hit_count
				)#
            </div>
        </div>

        <!--- Hit Count Ignore bots --->
        <div class="form-group">
            #html.label(
            	class="control-label",
            	field="cb_content_hit_ignore_bots",
            	content="Ignore Bots Regex Matching:"
            )#
            <div class="controls">
                <small>If enabled, the bot regex matching is ignored and hit tracking for bots is allowed </small><br /><br />
                #html.checkbox(
					name    = "cb_content_hit_ignore_bots_toggle",
					data	= { toggle: 'toggle', match: 'cb_content_hit_ignore_bots' },
					checked	= prc.cbSettings.cb_content_hit_ignore_bots
				)#
				#html.hiddenField(
					name	= "cb_content_hit_ignore_bots",
					value	= prc.cbSettings.cb_content_hit_ignore_bots
				)#
            </div>
        </div>

        <!--- Bot Regex Matching --->
        <div class="form-group">
	        #html.label( field="cb_content_bot_regex", content="Bot Regex Matchers:" )#
	        <div class="controls">
	            <small>A carriage return list of regular expressions to match against browser user agents. If it matches a bot, the hit count is ignored</small>
	            #html.textarea(
	            	name="cb_content_bot_regex",
	            	value=prc.cbSettings.cb_content_bot_regex,
	            	rows="4",
	            	class="form-control",
	            	title="One regex per line please"
	            )#
	        </div>
        </div>
    </fieldset>

    <fieldset>
        <legend><i class="far fa-hdd fa-lg"></i>  Content Caching</legend>

        <!--- Content Caching --->
        <div class="form-group">
            #html.label(
                class="control-label",
                field="cb_content_caching",
                content="Activate Page rendered content caching:"
            )#
            <div class="controls">
                <small>Page content will be cached once it has been translated and rendered</small><br /><br />
                #html.checkbox(
					name    = "cb_content_caching_toggle",
					data	= { toggle: 'toggle', match: 'cb_content_caching' },
					checked	= prc.cbSettings.cb_content_caching
				)#
				#html.hiddenField(
					name	= "cb_content_caching",
					value	= prc.cbSettings.cb_content_caching
				)#
            </div>
        </div>
        <!--- Entry Caching --->
        <div class="form-group">
            #html.label(
                class="control-label",
                field="cb_entry_caching",
                content="Activate Blog Entry rendered content caching:"
            )#
            <div class="controls">
                <small>Blog entry content will be cached once it has been translated and rendered</small><br /><br />
                #html.checkbox(
					name    = "cb_entry_caching_toggle",
					data	= { toggle: 'toggle', match: 'cb_entry_caching' },
					checked	= prc.cbSettings.cb_entry_caching
				)#
				#html.hiddenField(
					name	= "cb_entry_caching",
					value	= prc.cbSettings.cb_entry_caching
				)#
            </div>
        </div>
        <!--- Custom HTML Caching --->
        <div class="form-group">
            #html.label(
                class="control-label",
                field="cb_contentstore_caching",
                content="Activate ContentStore rendered content caching:"
            )#
            <div class="controls">
                <small>ContentStore content will be cached once it has been translated and rendered</small><br /><br />
                #html.checkbox(
					name    = "cb_contentstore_caching_toggle",
					data	= { toggle: 'toggle', match: 'cb_contentstore_caching' },
					checked	= prc.cbSettings.cb_contentstore_caching
				)#
				#html.hiddenField(
					name	= "cb_contentstore_caching",
					value	= prc.cbSettings.cb_contentstore_caching
				)#
            </div>
        </div>

        <!--- Content 203 Header --->
        <div class="form-group">
            #html.label(
                class="control-label",
                field="cb_content_cachingHeader",
                content="Send 203 Caching Header:"
            )#
            <div class="controls">
                <small>ContentBox will emit a 203 cache header to indicate that a page is resolved with caching.</small><br /><br />
                #html.checkbox(
					name    = "cb_content_cachingHeader_toggle",
					data	= { toggle: 'toggle', match: 'cb_content_cachingHeader' },
					checked	= prc.cbSettings.cb_content_cachingHeader
				)#
				#html.hiddenField(
					name	= "cb_content_cachingHeader",
					value	= prc.cbSettings.cb_content_cachingHeader
				)#
            </div>
        </div>

        <!--- Content Cache Name --->
        <div class="form-group">
            <label class="control-label" for="cb_content_cacheName">Content Cache Provider:</label>
            <div class="controls">
                <small>Choose the CacheBox provider to cache rendered content (blog,page,contentStore) into.</small><br/>
                #html.select(
                    name="cb_content_cacheName",
                    options=prc.cacheNames,
                    class="form-control input-sm",
                    selectedValue=prc.cbSettings.cb_content_cacheName
                )#
            </div>
        </div>

        <!--- Content Cache Timeouts --->
        <div class="form-group">
            <label class="control-label" for="cb_content_cachingTimeout">
                Content Cache Timeouts:
                <span class="badge badge-info" id="cb_content_cachingTimeout_label">#prc.cbSettings.cb_content_cachingTimeout#</span>
            </label>
            <div class="controls">
                <small>The number of minutes a rendered content (blog,page,contentStore) is cached for.</small><br/>
                <strong class="m10">5</strong>
                <input 	type="text"
                        id="cb_content_cachingTimeout"
                        name="cb_content_cachingTimeout"
                        class="slider"
                        data-slider-value="#prc.cbSettings.cb_content_cachingTimeout#"
                        data-provide="slider"
                        data-slider-min="5"
                        data-slider-max="1440"
                        data-slider-step="5"
                        data-slider-tooltip="hide"
                        data-slider-scale="logarithmic"
                >
                <strong class="m10">1440</strong>

            </div>
        </div>

        <!--- Content Last Access Timeouts --->
        <div class="form-group">
            <label class="control-label" for="cb_content_cachingTimeoutIdle">
                Content Cache Idle Timeouts:
                <span class="badge badge-info" id="cb_content_cachingTimeoutIdle_label">#prc.cbSettings.cb_content_cachingTimeoutIdle#</span>
            </label>
            <div class="controls">
                <small>The number of idle minutes allowed for cached rendered content (blog,page,contentStore) to live if not used. Usually this is less than the timeout you selected above</small><br/>
                <strong class="m10">5</strong>
                <input 	type="text"
                        id="cb_content_cachingTimeoutIdle"
                        name="cb_content_cachingTimeoutIdle"
                        class="slider"
                        data-slider-value="#prc.cbSettings.cb_content_cachingTimeoutIdle#"
                        data-provide="slider"
                        data-slider-min="5"
                        data-slider-max="1440"
                        data-slider-step="5"
                        data-slider-tooltip="hide"
                        data-slider-scale="logarithmic"
                >
                <strong class="m10">500</strong>

            </div>
        </div>
    </fieldset>
	<!--- Button Bar --->
	<div class="form-actions mt20">
		#html.submitButton( value="Save Settings", class="btn btn-danger" )#
	</div>

	#html.endForm()#
</cfoutput>
