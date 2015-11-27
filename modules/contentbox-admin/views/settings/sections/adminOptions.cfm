<cfoutput>
<fieldset>
    <legend><i class="fa fa-dashboard fa-lg"></i>  Dashboard Options</legend>
    
    <!--- Tag Line --->
    #html.textField( 
        name="cb_dashboard_welcome_title",
        label="Welcome Title:",
        value=prc.cbSettings.cb_dashboard_welcome_title,
        class="form-control",
        wrapper="div class=controls",
        labelClass="control-label",
        groupWrapper="div class=form-group"
    )#
    <!--- Description --->
    #html.textarea(
        name="cb_dashboard_welcome_body",
        label="Welcome Body:",
        value=prc.cbSettings.cb_dashboard_welcome_body,
        rows="3",
        class="form-control",
        wrapper="div class=controls",
        labelClass="control-label",
        groupWrapper="div class=form-group"
    )#
    
    <!--- Dashboard Feed --->
    <div class="form-group">
        <label class="control-label" for="cb_dashboard_newsfeed">News Feed</label>
        <div class="controls">
            <small>The RSS feed to present in the dashboard. Leave blank if you don't want any news to display.</small><br/>
            #html.textField(
                name="cb_dashboard_newsfeed",
                value=prc.cbSettings.cb_dashboard_newsfeed,
                class="form-control",
                title="The RSS feed to present in the dashboard"
            )#
        </div>
    </div>
    <!--- Recent Feed Count --->
    <div class="form-group">
        <label class="control-label" for="cb_dashboard_newsfeed_count">News Feed Count</label>
        <div class="controls">
            <select name="cb_dashboard_newsfeed_count" id="cb_dashboard_newsfeed_count" class="form-control input-sm">
                <cfloop from="5" to="50" step="5" index="i">
                    <option value="#i#" <cfif i eq prc.cbSettings.cb_dashboard_newsfeed_count>selected="selected"</cfif>>#i#</option>
                </cfloop>
            </select>
        </div>
    </div>
    <!--- Recent Entries --->
    <div class="form-group">
        <label class="control-label" for="cb_dashboard_recentEntries">Recent Entries Count</label>
        <div class="controls">
            <select name="cb_dashboard_recentEntries" id="cb_dashboard_recentEntries" class="form-control input-sm">
                <cfloop from="5" to="50" step="5" index="i">
                    <option value="#i#" <cfif i eq prc.cbSettings.cb_dashboard_recentEntries>selected="selected"</cfif>>#i#</option>
                </cfloop>
            </select>
        </div>
    </div>    
    <!--- Recent Pages --->
    <div class="form-group">
        <label class="control-label" for="cb_dashboard_recentPages">Recent Pages Count</label>
        <div class="controls">
            <select name="cb_dashboard_recentPages" id="cb_dashboard_recentPages" class="form-control input-sm">
                <cfloop from="5" to="50" step="5" index="i">
                    <option value="#i#" <cfif i eq prc.cbSettings.cb_dashboard_recentPages>selected="selected"</cfif>>#i#</option>
                </cfloop>
            </select>
        </div>
    </div>
    <!--- Recent ContentStore --->
    <div class="form-group">
        <label class="control-label" for="cb_dashboard_recentContentStore">Recent Content Store Count</label>
        <div class="controls">
            <select name="cb_dashboard_recentContentStore" id="cb_dashboard_recentContentStore" class="form-control input-sm">
                <cfloop from="5" to="50" step="5" index="i">
                    <option value="#i#" <cfif i eq prc.cbSettings.cb_dashboard_recentContentStore>selected="selected"</cfif>>#i#</option>
                </cfloop>
            </select>
        </div>
    </div>  
    <!--- Recent Comments--->
    <div class="form-group">
        <label class="control-label" for="cb_dashboard_recentComments">Recent Comments Count</label>
        <div class="controls">
            <select name="cb_dashboard_recentComments" id="cb_dashboard_recentComments" class="form-control input-sm">
                <cfloop from="5" to="50" step="5" index="i">
                    <option value="#i#" <cfif i eq prc.cbSettings.cb_dashboard_recentComments>selected="selected"</cfif>>#i#</option>
                </cfloop>
            </select>
        </div>
    </div>
    <!--- Recent Logins--->
    <div class="form-group">
        <label class="control-label" for="cb_security_latest_logins">Recent Logins Count</label>
        <div class="controls">
            <select name="cb_security_latest_logins" id="cb_security_latest_logins" class="form-control input-sm">
                <cfloop from="5" to="50" step="5" index="i">
                    <option value="#i#" <cfif i eq prc.cbSettings.cb_security_latest_logins>selected="selected"</cfif>>#i#</option>
                </cfloop>
            </select>
        </div>
    </div>
</fieldset>
<fieldset>
    <legend><i class="fa fa-copy fa-lg"></i>  Paging Options</legend>

    <!--- Quick Search --->
    <div class="form-group">
        <label class="control-label" for="cb_admin_quicksearch_max">Max Quick Search Count:</label>
        <div class="controls">
            <small>The number of results to show in the global search results panel.</small><br/>
            <select name="cb_admin_quicksearch_max" id="cb_admin_quicksearch_max" class="form-control input-sm">
                <cfloop from="5" to="50" step="5" index="i">
                    <option value="#i#" <cfif i eq prc.cbSettings.cb_admin_quicksearch_max>selected="selected"</cfif>>#i#</option>
                </cfloop>
            </select>
        </div>
    </div>
    <!--- Max Blog Post --->
    <div class="form-group">
        <label class="control-label" for="cb_paging_maxentries">Max Home Page Blog Entries:</label>
        <div class="controls">
            <small>The number of entries to show on the blog before paging is done.</small><br/>
            <select name="cb_paging_maxentries" id="cb_paging_maxentries" class="form-control input-sm">
                <cfloop from="5" to="50" step="5" index="i">
                    <option value="#i#" <cfif i eq prc.cbSettings.cb_paging_maxentries>selected="selected"</cfif>>#i#</option>
                </cfloop>
            </select>
        </div>
    </div>
    <!--- Max Rows --->
    <div class="form-group">
        <label class="control-label" for="cb_paging_maxrows">Paging Max Rows</label>
        <div class="controls">
            <small>The max rows to use in the administrator.</small><br/>
            <select name="cb_paging_maxrows" id="cb_paging_maxrows" class="form-control input-sm">
                <cfloop from="5" to="50" step="5" index="i">
                    <option value="#i#" <cfif i eq prc.cbSettings.cb_paging_maxrows>selected="selected"</cfif>>#i#</option>
                </cfloop>
            </select>
        </div>
    </div>
    <!--- Max Band Gap --->
    <div class="form-group">
        <label class="control-label" for="cb_paging_bandgap">Paging Band Gap</label>
        <div class="controls">
            <small>The paging bandgap to use in the administrator.</small><br/>
            <select name="cb_paging_bandgap" id="cb_paging_bandgap" class="form-control input-sm">
                <cfloop from="1" to="10" index="i">
                    <option value="#i#" <cfif i eq prc.cbSettings.cb_paging_bandgap>selected="selected"</cfif>>#i#</option>
                </cfloop>
            </select>
        </div>
    </div>
</fieldset>
</cfoutput>