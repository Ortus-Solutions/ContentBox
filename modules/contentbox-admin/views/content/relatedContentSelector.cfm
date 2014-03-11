<cfoutput>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3>Select Related Content</h3>
</div>
<div class="modal-body">
#html.startForm(name="relatedContentSelectorForm")#

    <!--- Loader --->
    <div class="loaders floatRight" id="relatedContentSelectorLoader">
        <i class="icon-spinner icon-spin icon-large"></i>
    </div>

    <!--- Content Bar --->
    <div class="well well-small" id="contentBar">

        <!--- Filter Bar --->
        <div class="filterBar">
            <div>
                #html.label(field="contentSearch",content="Quick Search:",class="inline")#
                #html.textField(name="contentSearch",size="30",class="textfield",value=rc.search)#
            </div>
        </div>
    </div>

    <!--- Render tables out --->
    <div id="contentContainer">
        <ul class="nav nav-tabs" id="contentTypes">
            <!---loop over content types--->
            <cfset types = listToArray( rc.contentType )>
            <cfloop from="1" to="#arrayLen( types )#" index="i">
                <cfset ct = types[ i ]>
                <li <cfif i eq 1> class="active"</cfif>>
                    <a href="###ct#" data-toggle="tab"><i class="#getContentTypeIconCls( ct )# icon-small" title="#ct#"></i> #ct#</a>
                </li>
            </cfloop>
            <!---<li class="active">
                <a href="##Page" data-toggle="tab"><i class="icon-file-alt icon-small" title="Page"></i> Page</a>
            </li>
            <li>
                <a href="##Entry" data-toggle="tab"><i class="icon-quote-left icon-small" title="Entry"></i> Entry</a>
            </li>
            <li>
                <a href="##ContentStore" data-toggle="tab"><i class="icon-hdd icon-small" title="ContentStore"></i> ContentStore</a>
            </li>--->
        </ul>
        <div class="tab-content">
            <cfloop from="1" to="#arrayLen( types )#" index="i">
                <cfset ct = types[ i ]>
                <div class="tab-pane fade<cfif i eq 1> active in</cfif>" id="#ct#"></div>
            </cfloop>
            <!---<div class="tab-pane fade active in" id="Page"></div>
            <div class="tab-pane fade" id="Entry"></div>
            <div class="tab-pane fade" id="ContentStore"></div>--->
        </div>
    </div>


#html.endForm()#
</div>
<!--- Button Bar --->
<div class="modal-footer">
    <button class="btn" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>