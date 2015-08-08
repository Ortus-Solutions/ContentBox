<cfoutput>
<fieldset>
    <legend><i class="fa fa-search fa-lg"></i>  Search Options</legend>

    <!--- Max Search Results --->
    <div class="form-group">
        <label class="control-label" for="cb_search_maxResults">Max Search Results:</label>
        <div class="controls">
            <small>The number of search results to show before paging kicks in.</small><br/>
            <select name="cb_search_maxResults" id="cb_search_maxResults" class="form-control input-sm">
                <cfloop from="5" to="50" step="5" index="i">
                    <option value="#i#" <cfif i eq prc.cbSettings.cb_search_maxResults>selected="selected"</cfif>>#i#</option>
                </cfloop>
            </select>
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
</cfoutput>