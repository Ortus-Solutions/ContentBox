<cfoutput>
#html.startForm( name="searchSettingsForm", action=prc.xehSaveSettings )#
<fieldset>
    <legend><i class="fab fa-searchengin fa-lg"></i>  Search Options</legend>

    <!--- Max Search Results --->
    <div class="form-group">
        <label class="control-label" for="cb_search_maxResults">
            Max Search Results:
            <span class="badge badge-info" id="cb_search_maxResults_label">#prc.cbSettings.cb_search_maxResults#</span>
        </label>
        <div class="controls">
            <small>The number of search results to show before paging kicks in.</small><br/>
            <strong class="m10">5</strong>
            <input 	type="text"
                    id="cb_search_maxResults"
                    name="cb_search_maxResults"
                    class="slider"
                    data-slider-value="#prc.cbSettings.cb_search_maxResults#"
                    data-provide="slider"
                    data-slider-min="5"
                    data-slider-max="50"
                    data-slider-step="5"
                    data-slider-tooltip="hide"
            >
            <strong class="m10">50</strong>

        </div>
    </div>
    <!--- Search Adapter --->
    <div class="form-group">
        #html.label(class="control-label",field="cb_search_adapter",content="Search Adapter: " )#
        <div class="controls">
            <small>The ContentBox search engine adapter class (instantiation path) to use. You can create your own search engine adapters as
            long as they implement <em>contentbox.models.search.ISearchAdapter</em>. You can choose from our core adapters or
            enter your own CFC instantiation path below.</small><br/>

            <ul>
                <li><a href="javascript:chooseAdapter('contentbox.models.search.DBSearch')">ORM Database Search (contentbox.models.search.DBSearch)</a></li>
            </ul>

            #html.textField(
                name="cb_search_adapter",
                size="60",
                class="form-control",
                value=prc.cbSettings.cb_search_adapter,
                required="required",
                title="Please remember this must be a valid ColdFusion instantiation path"
            )#
        </div>
    </div>
</fieldset>
<!--- Button Bar --->
<div class="form-actions mt20">
	#html.submitButton( value="Save Settings", class="btn btn-danger" )#
</div>

#html.endForm()#
</cfoutput>
