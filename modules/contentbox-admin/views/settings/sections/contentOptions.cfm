<cfoutput>
    <fieldset>
        <legend><i class="fa fa-file fa-lg"></i>  Content Options</legend>

        <!--- Content Max Versions --->
        <div class="form-group">
            <label class="control-label" for="cb_versions_max_history">Content Max Versions To Keep:</label>
            <div class="controls">
                <small>The number of versions to keep before older versions are removed.</small><br/>
                <select name="cb_versions_max_history" id="cb_versions_max_history" class="form-control input-sm">
                    <cfloop from="10" to="1000" step="10" index="i">
                        <option value="#i#" <cfif i eq prc.cbSettings.cb_versions_max_history>selected="selected"</cfif>>#i#</option>
                    </cfloop>
                    <option value="" <cfif prc.cbSettings.cb_versions_max_history eq "">selected="selected"</cfif>>Unlimited</option>
                </select>
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
                <small>When enabled a commit changelog will have to be entered before any content revision is saved.</small><br/>
                #html.radioButton(
                    name="cb_versions_commit_mandatory",
                    checked=prc.cbSettings.cb_versions_commit_mandatory,
                    value=true
                )# Yes
                #html.radioButton(
                    name="cb_versions_commit_mandatory",
                    checked=not prc.cbSettings.cb_versions_commit_mandatory,
                    value=false
                )# No
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
                <small>Enable/Disabled page excerpt summaries.</small><br/>
                #html.radioButton(
                    name="cb_page_excerpts",
                    checked=prc.cbSettings.cb_page_excerpts,
                    value=true
                )# Yes
                #html.radioButton(
                    name="cb_page_excerpts",
                    checked=not prc.cbSettings.cb_page_excerpts,
                    value=false
                )# No
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
                <small>Enable/Disabled the ability to export pages/blog/etc from the UI module via format extensions like pdf,doc,print,json, and xml.</small><br/>
                #html.radioButton(
                    name    = "cb_content_uiexport",
                    checked = prc.cbSettings.cb_content_uiexport,
                    value   = true
                )# Yes
                #html.radioButton(
                    name    = "cb_content_uiexport",
                    checked = not prc.cbSettings.cb_content_uiexport,
                    value   = false
                )# No
            </div>
        </div>
    </fieldset>

	<fieldset>
    	<legend><i class="fa fa-bar-chart-o fa-lg"></i> Content Stats Tracking</legend>
        
        <!--- Hit Count --->
        <div class="form-group">
            #html.label(
            	class="control-label",
            	field="cb_content_hit_count",
            	content="Content Hit Count Tracking:"
            )#
            <div class="controls">
                <small>Enable/Disable content hit count tracking</small><br/>
                #html.radioButton(
                	name="cb_content_hit_count",
                	checked=prc.cbSettings.cb_content_hit_count,
                	value=true
                )# Yes
                #html.radioButton(
                	name="cb_content_hit_count",
                	checked=not prc.cbSettings.cb_content_hit_count,
                	value=false
                )# No
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
                <small>If enabled, the bot regex matching is ignored and hit tracking for bots is allowed </small><br/>
                #html.radioButton(
                	name="cb_content_hit_ignore_bots",
                	checked=prc.cbSettings.cb_content_hit_ignore_bots,
                	value=true
                )# Yes
                #html.radioButton(
                	name="cb_content_hit_ignore_bots",
                	checked=not prc.cbSettings.cb_content_hit_ignore_bots,
                	value=false
                )# No
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
        <legend><i class="fa fa-hdd-o fa-lg"></i>  Content Caching</legend>

        <!--- Content Caching --->
        <div class="form-group">
            #html.label(
                class="control-label",
                field="cb_content_caching",
                content="Activate Page rendered content caching:"
            )#
            <div class="controls">
                <small>Page content will be cached once it has been translated and rendered</small><br/>
                #html.radioButton(
                    name="cb_content_caching",
                    checked=prc.cbSettings.cb_content_caching,
                    value=true
                )# Yes
                #html.radioButton(
                    name="cb_content_caching",
                    checked=not prc.cbSettings.cb_content_caching,
                    value=false
                )# No
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
                <small>Blog entry content will be cached once it has been translated and rendered</small><br/>
                #html.radioButton(
                    name="cb_entry_caching",
                    checked=prc.cbSettings.cb_entry_caching,
                    value=true
                )# Yes
                #html.radioButton(
                    name="cb_entry_caching",
                    checked=not prc.cbSettings.cb_entry_caching,
                    value=false
                )# No
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
                <small>ContentStore content will be cached once it has been translated and rendered</small><br/>
                #html.radioButton(
                    name="cb_contentstore_caching",
                    checked=prc.cbSettings.cb_contentstore_caching,
                    value=true
                )# Yes
                #html.radioButton(
                    name="cb_contentstore_caching",
                    checked=not prc.cbSettings.cb_contentstore_caching,
                    value=false
                )# No
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
                <small>ContentBox will emit a 203 cache header to indicate that a page is resolved with caching.</small><br/>
                #html.radioButton(
                    name="cb_content_cachingHeader",
                    checked=prc.cbSettings.cb_content_cachingHeader,
                    value=true
                )# Yes
                #html.radioButton(
                    name="cb_content_cachingHeader",
                    checked=not prc.cbSettings.cb_content_cachingHeader,
                    value=false
                )# No
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
            <label class="control-label" for="cb_content_cachingTimeout">Content Cache Timeouts:</label>
            <div class="controls">
                <small>The number of minutes a rendered content (blog,page,contentStore) is cached for.</small><br/>
                <select name="cb_content_cachingTimeout" id="cb_content_cachingTimeout" class="form-control input-sm">
                    <cfloop from="5" to="100" step="5" index="i">
                        <option value="#i#" <cfif i eq prc.cbSettings.cb_content_cachingTimeout>selected="selected"</cfif>>#i#</option>
                    </cfloop>
                </select>
            </div>
        </div>
        <!--- Content Last Access Timeouts --->
        <div class="form-group">
            <label class="control-label" for="cb_rss_cachingTimeoutIdle">Content Cache Idle Timeouts:</label>
            <div class="controls">
                <small>The number of idle minutes allowed for cached rendered content (blog,page,contentStore) to live if not used. Usually this is less than the timeout you selected above</small><br/>
                <select name="cb_content_cachingTimeoutIdle" id="cb_content_cachingTimeoutIdle" class="form-control input-sm">
                    <cfloop from="5" to="100" step="5" index="i">
                        <option value="#i#" <cfif i eq prc.cbSettings.cb_content_cachingTimeoutIdle>selected="selected"</cfif>>#i#</option>
                    </cfloop>
                </select>
            </div>
        </div>
    </fieldset>
</cfoutput>