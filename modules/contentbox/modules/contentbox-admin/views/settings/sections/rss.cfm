<cfoutput>
#html.startForm( name="rssSettingsForm", action=prc.xehSaveSettings )#
<fieldset>
    <legend><i class="fa fa-rss fa-lg"></i>  RSS Options</legend>

    <!--- RSS title --->
    <div class="form-group">
        #html.label(class="control-label",field="",content="Feed Title: " )#
        <div class="controls">
            <small>The title of the rss feeds</small></br>
            #html.textField(name="cb_rss_title", required="required", value=prc.cbSettings.cb_rss_title, class="form-control input-sm width98",title="The title of the rss feed." )#
        </div>
    </div>

    <!--- RSS feed generator --->
    <div class="form-group">
    	#html.label(class="control-label",field="",content="Feed Generator: " )#
        <div class="controls">
            <small>RSS feed generator</small></br>
             #html.textField(name="cb_rss_generator",required="required",value=prc.cbSettings.cb_rss_generator,class="form-control input-sm width98",title="The generator of the rss feed." )#
        </div>
    </div>

    <!--- RSS feed copyright --->
    <div class="form-group">
        #html.label(class="control-label",field="",content="Feed Copyright: " )#
        <div class="controls">
            <small>RSS feed copyright</small></br>
             #html.textField(name="cb_rss_copyright",required="required",value=prc.cbSettings.cb_rss_copyright,class="form-control input-sm width98",title="Copyright." )#
        </div>
    </div>

    <!--- RSS feed description --->
    <div class="form-group">
        #html.label(class="control-label",field="",content="Feed Description: " )#
        <div class="controls">
            <small>RSS feed description</small></br>
             #html.textField(name="cb_rss_description",required="required",value=prc.cbSettings.cb_rss_description,class="form-control input-sm width98",title="RSS feed description." )#
        </div>
    </div>

	<!--- RSS feed webmaster --->
	<div class="form-group">
	    #html.label(class="control-label",field="",content="Feed Webmaster: " )#
	    <div class="controls">
	        <small>RSS feed webmaster. Ex: myemail@mysite.com (Site Administrator)</small></br>
	        #html.textField(
	        	name="cb_rss_webmaster",
	        	value=prc.cbSettings.cb_rss_webmaster,
	        	class="form-control input-sm width98",
	        	title="RSS feed webmaster."
	        )#
	    </div>
	</div>

    <!--- Max RSS Entries --->
    <div class="form-group">
        <label class="control-label" for="cb_rss_maxEntries">
            Max RSS Content Items:
            <span class="badge badge-info" id="cb_rss_maxEntries_label">#prc.cbSettings.cb_rss_maxEntries#</span>
        </label>
        <div class="controls">
            <small>The number of recent content items to show on the syndication feeds.</small><br/>
            <strong class="m10">10</strong>
            <input 	type="text"
                    id="cb_rss_maxEntries"
                    name="cb_rss_maxEntries"
                    class="slider"
                    data-slider-value="#prc.cbSettings.cb_rss_maxEntries#"
                    data-provide="slider"
                    data-slider-min="10"
                    data-slider-max="50"
                    data-slider-step="10"
                    data-slider-tooltip="hide"
            >
            <strong class="m10">50</strong>

        </div>
    </div>

    <!--- Max RSS Comments --->
    <div class="form-group">
        <label class="control-label" for="cb_rss_maxComments">
            Max RSS Content Comments:
            <span class="badge badge-info" id="cb_rss_maxComments_label">#prc.cbSettings.cb_rss_maxComments#</span>
        </label>
        <div class="controls">
            <small>The number of recent comments to show on the syndication feeds.</small><br/>
            <strong class="m10">10</strong>
            <input 	type="text"
                    id="cb_rss_maxComments"
                    name="cb_rss_maxComments"
                    class="slider"
                    data-slider-value="#prc.cbSettings.cb_rss_maxComments#"
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
    <legend><i class="far fa-hdd fa-lg"></i>  RSS Caching</legend>

    <!--- RSS Caching --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_rss_caching",
            content="Activate RSS feed caching:"
        )#
        <div class="controls">
        	#html.checkbox(
				name    = "cb_rss_caching_toggle",
				data	= { toggle: 'toggle', match: 'cb_rss_caching' },
				checked	= prc.cbSettings.cb_rss_caching
			)#
			#html.hiddenField(
				name	= "cb_rss_caching",
				value	= prc.cbSettings.cb_rss_caching
			)#
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
        <label class="control-label" for="cb_rss_cachingTimeout">
            Feed Cache Timeouts:
            <span class="badge badge-info" id="cb_rss_cachingTimeout_label">#prc.cbSettings.cb_rss_cachingTimeout#</span>
        </label>
        <div class="controls">
            <small>The number of minutes a feed XML is cached per permutation of feed type.</small><br/>
            <strong class="m10">5</strong>
            <input 	type="text"
                    id="cb_rss_cachingTimeout"
                    name="cb_rss_cachingTimeout"
                    class="slider"
                    data-slider-value="#prc.cbSettings.cb_rss_cachingTimeout#"
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

    <!--- Rss Cache Last Access Timeouts --->
    <div class="form-group">
        <label class="control-label" for="cb_rss_cachingTimeoutIdle">
            Feed Cache Idle Timeouts:
            <span class="badge badge-info" id="cb_rss_cachingTimeoutIdle_label">#prc.cbSettings.cb_rss_cachingTimeoutIdle#</span>
        </label>
        <div class="controls">
            <small>The number of idle minutes allowed for cached RSS feeds to live. Usually this is less than the timeout you selected above</small><br/>
            <strong class="m10">5</strong>
            <input 	type="text"
                    id="cb_rss_cachingTimeoutIdle"
                    name="cb_rss_cachingTimeoutIdle"
                    class="slider"
                    data-slider-value="#prc.cbSettings.cb_rss_cachingTimeoutIdle#"
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
