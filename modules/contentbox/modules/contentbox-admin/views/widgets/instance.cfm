<cfoutput>
    <cfif rc.modal>
        <div class="modal-dialog modal-lg" role="document" >
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4><span id="widget-title-bar"><i class="fa fa-#prc.widget.icon# fa-lg fa-2x"></i> #rc.mode# '#prc.widget.widget.getName()#' Widget</span></h4>
                </div>
                <div class="modal-body">
    </cfif>
        <div id="widget-preview-wrapper" class="row">
            <div class="widget-arguments col-md-3" id="widget-arguments">
                #html.startForm( name="widgetArgsForm_#prc.widget.name#", class="form-vertical" )#
                    <fieldset <cfif arrayLen( prc.metadata ) eq 1>style="display:none;"</cfif>>
                        <legend>Public Methods</legend>
                        <label for="renderMethodSelect"><strong>Select a Method:</strong></label>
                        <select name="renderMethodSelect" id="renderMethodSelect" class="renderMethodSelect form-control input-sm">
                            <cfloop array="#prc.metadata#" index="method">
                                <option value="#method.name#" <cfif prc.widget.udf eq method.name>selected=true</cfif>>#method.name#()</option>
                            </cfloop>
                        </select>
                    </fieldset>
                    #html.startFieldSet( legend="Widget Arguments" )#
                    <!--- instructions --->
                    <cfif arrayLen( prc.md.parameters )>
                        <p>Please fill out the arguments for this widget:</p>
                    <cfelse>
                        <p>There are no arguments for this widget!</p>
                    </cfif>
                    <!--- Iterate and present arguments --->
                    <cfloop from="1" to="#arrayLen( prc.md.parameters )#" index="x">
                        <cfscript>
                            // duplicate so we don't affect real md as ACF caches this stupidity
                            thisArg = duplicate( prc.md.parameters[ x ] );
                            requiredText = "";
                            requiredValidator = "";
                            // Verify attributes
                            if( !structKeyExists( thisArg, "label" ) ){ thisArg.label = thisArg.name; }
                            if( !structKeyExists( thisArg, "required" ) ){ thisArg.required = false; }
                            if( !structKeyExists( thisArg, "hint" ) ){ thisArg.hint = ""; }
                            if( !structKeyExists( thisArg, "type" ) ){ thisArg.type = "any"; }
                            if( !structKeyExists( thisArg, "default" ) ){ thisArg.default = ""; }
                            if( !structKeyExists( thisArg, "options" ) ){ thisArg.options = ""; }
                            if( !structKeyExists( thisArg, "optionsUDF" ) ){ thisArg.optionsUDF = ""; }
                            if( !structKeyExists( thisArg, "multiOptions" ) ){ thisArg.multiOptions = ""; }
                            if( !structKeyExists( thisArg, "multiOptionsUDF" ) ){ thisArg.multiOptionsUDF = ""; }
                            // calculate default value
                            thisArg.value = structKeyExists( prc.vals, thisArg.name ) ? prc.vals[ thisArg.name ] == "" ? thisArg.default : prc.vals[ thisArg.name ] : thisArg.default;
                            // required stuff
                            if( thisarg.required ){
                                requiredText = "<span class='text-red'>Required</span>";
                                requiredValidator = "required";
                            }
                        </cfscript>
                        <!--- control group --->
                        <div class="form-group">
                            <!--- label --->
                            #html.label(
                                field   = thisArg.name,
                                content = "#thisArg.label# (#thisArg.type#) #requiredText#",
                                class   = "control-label"
                            )#
                            <div class="controls">
                                <!--- argument hint --->
                                <cfif len( thisArg.hint )><small>#thisArg.hint#</small><br/></cfif>

                                <!--- HTML Control --->

                                <!---Boolean?--->
                                <cfif thisArg.type eq "boolean">
                                    #html.select(
                                        name=thisArg.name,
                                        options="true,false",
                                        selectedValue=thisArg.value,
                                        class="form-control input-sm"
                                    )#
                                <!--- Options --->
                                <cfelseif listLen( thisArg.options )>
                                    #html.select(
                                        name=thisArg.name,
                                        options=thisArg.options,
                                        selectedValue=thisArg.value,
                                        class="form-control input-sm"
                                    )#
                                <!--- OptionsUDF --->
                                <cfelseif listLen( thisArg.optionsUDF )>
									<cfset options = invoke( prc.widget.widget, thisArg.optionsUDF )>
                                    #html.select(
                                        name=thisArg.name,
                                        options=options,
                                        selectedValue=thisArg.value,
                                        class="form-control input-sm"
                                    )#
                                <!--- Options --->
                                <cfelseif listLen( thisArg.multiOptions )>
                                    #html.select(
                                        name=thisArg.name,
                                        options=thisArg.multiOptions,
                                        selectedValue=thisArg.value,
                                        class="form-control input-sm",
                                        multiple="true",
                                        size="5"
                                    )#
                                <!--- MultiOptionsUDF --->
                                <cfelseif listLen( thisArg.multiOptionsUDF )>
									<cfset options = invoke( prc.widget.widget, thisArg.multiOptionsUDF )>
                                    #html.select(
                                        name=thisArg.name,
                                        options=options,
                                        selectedValue=thisArg.value,
                                        class="form-control input-sm",
                                        multiple="true",
                                        size="5"
                                    )#
                                <!--- Default --->
                                <cfelse>
                                    #html.textfield(
                                        name=thisArg.name, size="35",
                                        class="form-control",
                                        required=requiredValidator,
                                        title=thisArg.hint,
                                        value=thisArg.value
                                    )#
                                </cfif>
                            </div>
                        </div>
                    </cfloop>
                    <!--- hidden usage fields --->
                    #html.hiddenfield(
                        name    = "widgetName",
                        id      = "widgetName",
                        value   = prc.widget.name
                    )#
                    #html.hiddenfield(
                        name    = "widgetIcon",
                        id      = "widgetIcon",
                        value   = prc.widget.icon
                    )#
                    #html.hiddenfield(
                        name    = "widgetDisplayName",
                        id      = "widgetDisplayName",
                        value   = prc.widget.widget.getName()
                    )#
                    #html.hiddenfield(
                        name    = "widgetType",
                        value   = prc.widget.widgetType
                    )#
                    #html.hiddenfield(
                        name    = "widgetUDF",
                        value   = prc.widget.udf
                    )#
                    #html.endFieldSet()#
                #html.endForm()#
            </div>
            <div class="widget-preview col-md-9">
                <div class="well well-sm">
                    <h4>Widget Preview</h4>
                    <a href="javascript:void( 0 );" class="widget-preview-refresh btn btn-mini btn-default"><i class="fas fa-recycle"></i> Refresh</a>
                </div>
                <div id="widget-preview-content" class="widget-preview-content"></div>
            </div>
        </div>
    <cfif rc.modal>
                </div>
                <div class="modal-footer">
                    <div class="widget-footer-right">
                        <cfif rc.mode eq "edit">
                            <a id="widget-button-cancel" href="javascript:void(0);" class="btn btn-danger" onclick="closeRemoteModal()">Cancel</a>
                            <button class="btn btn-info" id="widget-button-update">Update Widget</button>
                        <cfelse>
                            <a id="widget-button-close" href="javascript:void(0);" class="btn btn-danger" onclick="closeRemoteModal()">Close</a>
                        </cfif>
                    </div>
                </div>
            </div>
        </div>
    </cfif>
</cfoutput>
