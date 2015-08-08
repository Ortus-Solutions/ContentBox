<cfoutput>
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3><i class="fa fa-copy"></i> Import Preview</h3>
    </div>
    <cfif not structKeyExists( prc, "contents" )>
        <div class="modal-body" id="modal-body">
            <!--- messageBox --->
            #getModel( "messagebox@cbMessagebox" ).renderit()#
        </div>
    <cfelse>
        <div class="modal-body" id="modal-body">
            <div class="row">
                <div class="col-md-5">
                    <h4>Override Existing Content?</h4>
                    <small>By default all content that exists is not overwritten.</small><br>
                    #html.select(options="true,false", name="overrideContent", selectedValue="false", class="form-control input-sm",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=form-group" )#
                    <div class="alert">
                        <i class="fa fa-warning fa-lg"></i> <strong>Non-content</strong> imports (layouts, widgets, modules, etc.) will automatically overwrite any existing assets regardless of the choice above.</strong>
                    </div>
                    <!---Notice --->
                    <div class="alert alert-info">
                        <i class="fa fa-info-circle fa-lg"></i> Please note that import is an expensive process, so please be patient when importing.
                    </div>
                </div>
                <div class="col-md-7">
                    <h4>Import Summary</h4>
                    <div id="import-preview">
                        <table class="table table-bordered">
                            <tr>
                                <td>Exported By:</td>
                                <td>#prc.contents.exportedBy#</td>
                            </tr>
                            <tr>
                                <td>Exported Date:</td>
                                <td>#dateFormat( prc.contents.exportDate, "yyyy-mm-dd" )# #timeFormat( prc.contents.exportDate, "hh:mm:ss TT" )#</td>
                            </tr>
                            <tr>
                                <th>Content Area</th>
                                <th>Total</th>
                            </tr>
                            <cfset sortedContent = structSort( prc.contents.content, "text", "asc", "name" )>
                            <cfloop array="#sortedContent#" index="key">
                                <cfset content = prc.contents.content[ key ]>
                                <tr <cfif content.format eq "zip">class="warning"</cfif>>
                                    <td>#content.name#</td>
                                    <td><span class="badge">#content.total#</span></td>
                                </tr>
                            </cfloop>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <!--- Button Bar --->
            <div id="importButtonBar">
                <button class="btn" id="closeButton"> Cancel </button>
                <button class="btn btn-danger" id="importButton"> Import </button>
            </div>
            <!--- Loader --->
            <div class="center loaders" id="importBarLoader">
                <i class="fa fa-spinner fa-spin fa-lg fa-2x"></i>
                <br>Please wait, doing some hardcore importing action...
            </div>
        </div>
    </cfif>
</cfoutput>