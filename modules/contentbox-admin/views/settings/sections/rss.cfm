<cfoutput>
<fieldset>
    <legend><i class="fa fa-rss icon-large"></i>  RSS Options</legend>

    <!--- Max RSS Entries --->
    <div class="form-group">
        <label class="control-label" for="cb_rss_maxEntries">Max RSS Content Items:</label>
        <div class="controls">
            <small>The number of recent content items to show on the syndication feeds.</small><br/>
            <select name="cb_rss_maxEntries" id="cb_rss_maxEntries" class="form-control input-sm">
                <cfloop from="5" to="50" step="5" index="i">
                    <option value="#i#" <cfif i eq prc.cbSettings.cb_rss_maxEntries>selected="selected"</cfif>>#i#</option>
                </cfloop>
            </select>
        </div>
    </div>    
    <!--- Max RSS Comments --->
    <div class="form-group">
        <label class="control-label" for="cb_rss_maxComments">Max RSS Content Comments:</label>
        <div class="controls">
            <small>The number of recent comments to show on the syndication feeds.</small><br/>
            <select name="cb_rss_maxComments" id="cb_rss_maxComments" class="form-control input-sm">
                <cfloop from="5" to="50" step="5" index="i">
                    <option value="#i#" <cfif i eq prc.cbSettings.cb_rss_maxComments>selected="selected"</cfif>>#i#</option>
                </cfloop>
            </select>
        </div>
    </div>
</fieldset>
<fieldset>
    <legend><i class="fa fa-hdd-o icon-large"></i>  RSS Caching</legend>

    <!--- RSS Caching --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_rss_caching",
            content="Activate RSS feed caching:"
        )#
        <div class="controls">
            #html.radioButton(
                name="cb_rss_caching",
                checked=prc.cbSettings.cb_rss_caching,
                value=true
            )# Yes
            #html.radioButton(
                name="cb_rss_caching",
                checked=not prc.cbSettings.cb_rss_caching,
                value=false
            )# No
        </div>
    </div>
    <!--- RSS Cache Name --->
    <div class="form-group">
        <label class="control-label" for="cb_rss_cacheName">Feed Cache Provider:</label>
        <div class="controls">
            <small>Choose the CacheBox provider to cache feeds into.</small><br/>
            #html.select(
                name="cb_rss_cacheName",
                options=prc.cacheNames,
                selectedValue=prc.cbSettings.cb_rss_cacheName,
                class="input-sm"
            )#
        </div>
    </div>
    <!--- Rss Cache Timeouts --->
    <div class="form-group">
        <label class="control-label" for="cb_rss_cachingTimeout">Feed Cache Timeouts:</label>
        <div class="controls">
            <small>The number of minutes a feed XML is cached per permutation of feed type.</small><br/>
            <select name="cb_rss_cachingTimeout" id="cb_rss_cachingTimeout" class="input-sm">
                <cfloop from="5" to="100" step="5" index="i">
                    <option value="#i#" <cfif i eq prc.cbSettings.cb_rss_cachingTimeout>selected="selected"</cfif>>#i#</option>
                </cfloop>
            </select>
        </div>
    </div>
    <!--- Rss Cache Last Access Timeouts --->
    <div class="form-group">
        <label class="control-label" for="cb_rss_cachingTimeoutIdle">Feed Cache Idle Timeouts:</label>
        <div class="controls">
            <small>The number of idle minutes allowed for cached RSS feeds to live. Usually this is less than the timeout you selected above</small><br/>
            <select name="cb_rss_cachingTimeoutIdle" id="cb_rss_cachingTimeoutIdle" class="form-control input-sm">
                <cfloop from="5" to="100" step="5" index="i">
                    <option value="#i#" <cfif i eq prc.cbSettings.cb_rss_cachingTimeoutIdle>selected="selected"</cfif>>#i#</option>
                </cfloop>
            </select>
        </div>
    </div>
</fieldset>
</cfoutput>