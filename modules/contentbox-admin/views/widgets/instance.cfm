<cfoutput>
    <cfif rc.modal>
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h3><span id="widget-title-bar"><img width="25" src="#prc.cbroot#/includes/images/widgets/#prc.widget.icon#" /> #rc.mode# '#prc.widget.plugin.getPluginName()#' Widget</span></h3>
        </div>
        <div class="modal-body">
    </cfif>
        <div id="widget-preview-wrapper">
            <div class="widget-arguments" id="widget-arguments">
                #html.startForm(name="widgetArgsForm_#prc.widget.name#", class="form-vertical")#
                <fieldset <cfif arrayLen( prc.metadata ) eq 1>style="display:none;"</cfif>>
                    <legend>Public Methods</legend>
                    <label for="renderMethodSelect"><strong>Select a Method:</strong></label>
                    <select name="renderMethodSelect" id="renderMethodSelect" class="renderMethodSelect">
                        <cfloop array="#prc.metadata#" index="method">
                            <option value="#method.name#" <cfif prc.widget.udf eq method.name>selected=true</cfif>>#method.name#()</option>
                        </cfloop> 
                    </select>
                </fieldset>
                #html.startFieldSet(legend="Widget Arguments")#
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
                        if( !structKeyExists(thisArg,"required") ){ thisArg.required = false; }
                        if( !structKeyExists(thisArg,"hint") ){ thisArg.hint = ""; }
                        if( !structKeyExists(thisArg,"type") ){ thisArg.type = "any"; }
                        if( !structKeyExists(thisArg,"default") ){ thisArg.default = ""; }
                        if( !structKeyExists(thisArg,"options") ){ thisArg.options = ""; }
                        if( !structKeyExists(thisArg,"optionsUDF") ){ thisArg.optionsUDF = ""; }
                        thisArg.value = structKeyExists( prc.vals, thisArg.name ) ? prc.vals[ thisArg.name ] == "" ? thisArg.default : prc.vals[ thisArg.name ] : thisArg.default;
                        // required stuff
                        if( thisarg.required ){
                            requiredText = "<span class='textRed'>Required</span>";
                            requiredValidator = "required";
                        }
                    </cfscript>
                    <!--- control group --->
                    <div class="control-group">
                        <!--- label --->
                        #html.label( field=thisArg.name, content="#thisArg.name# (Type=#thisArg.type#) #requiredText#", class="control-label" )#
                        <div class="controls">
                            <!--- argument hint --->
                            <cfif len( thisArg.hint )><small>#thisArg.hint#</small><br/></cfif>
                            
                            <!--- HTML Control --->

                            <!---Boolean?--->
                            <cfif thisArg.type eq "boolean">
                                #html.select( name=thisArg.name, options="true,false", selectedValue=thisArg.value, class="input-block-level" )#
                            <!--- Options --->
                            <cfelseif listLen( thisArg.options )>
                                #html.select( name=thisArg.name, options=thisArg.options, selectedValue=thisArg.value, class="input-block-level" )#
                            <!--- OptionsUDF --->
                            <cfelseif listLen( thisArg.optionsUDF )>
                                <cfset options = evaluate( "prc.widget.plugin.#thisArg.optionsUDF#()" )>
                                #html.select( name=thisArg.name, options=options, selectedValue=thisArg.value, class="input-block-level" )#
                            <!--- Default --->
                            <cfelse>
                                #html.textfield( name=thisArg.name, size="35", class="input-block-level", required=requiredValidator, title=thisArg.hint, value=thisArg.value )#
                            </cfif>
                        </div>
                    </div>
                </cfloop>
                <!--- hidden usage fields --->
                #html.hiddenfield( name="widgetName", id="widgetName", value=prc.widget.name )#
                #html.hiddenfield( name="widgetDisplayName", id="widgetDisplayName", value=prc.widget.plugin.getPluginName() )#
                #html.hiddenfield( name="widgetType", value=prc.widget.widgetType )#
                #html.hiddenfield( name="widgetUDF", value=prc.widget.udf )#
                #html.endFieldSet()#
                #html.endForm()#
            </div>    
            <div class="widget-preview">
                <div class="well well-small">
                    <h4>Widget Preview</h4>
                    <a href="javascript:void(0);" class="widget-preview-refresh btn btn-mini"><i class="icon-refresh"></i> Refresh</a>
                </div>
                <div id="widget-preview-content" class="widget-preview-content"></div>
            </div>
        </div>
    <cfif rc.modal>
        </div>
        <div class="modal-footer">
            <div class="widget-footer-right">
                <cfif rc.mode eq "edit">
                    <a id="widget-button-cancel" href="javascript:void(0);" class="btn" onclick="closeRemoteModal()">Cancel</a>
                    <button class="btn btn-danger" id="widget-button-update">Update Widget</button>
                <cfelse>
                    <a id="widget-button-close" href="javascript:void(0);" class="btn" onclick="closeRemoteModal()">Close</a>
                </cfif>
            </div>
        </div>
    </cfif>
</cfoutput>