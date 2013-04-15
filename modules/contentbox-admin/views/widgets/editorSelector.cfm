<cfoutput>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3><span id="widget-title-bar"><i class="icon-magic"></i> Select a Widget</span></h3>
</div>
<div class="modal-body">
    <div class="widget-detail" id="widget-detail" style="display:none;">
    	<div class="widget-preview">
    	    <div class="widget-preview-toolbar">
    	        Preview
                <a href="javascript:void(0);" class="widget-preview-refresh btn btn-mini"><i class="icon-refresh"></i> Refresh</a>
    	    </div>
            <div id="widget-preview-content" class="widget-preview-content"></div>
    	</div>
    	<div class="widget-arguments" id="widget-arguments"></div>    
    </div>
    <div class="widget-container body_vertical_nav clearfix" id="widget-container">
        <div class="vertical_nav" id="widget-sidebar">
            <ul>
                <li class="active"><a href="##" class="current">All</a></li>
    			<cfloop query="prc.categories">
                	<li><a href="##">#prc.categories.category#</a></li>
    			</cfloop>
            </ul>
        </div>
        <div class="widget-store">
            <div class="widget-toolbar">
            	<div class="widget-filter" id="widget-filter">
        	        #html.label(field="widgetFilter",content="Quick Filter:",class="inline")#
        			#html.textField(name="widgetFilter",size="30",class="textfield")#
        	    </div>
                <div id="widget-total-bar" class="widget-total-bar">Category: <strong>All</strong> (#prc.widgets.recordcount# Widgets)</div>
            </div>
            <cfloop query="prc.widgets">
    			<cfscript>
    				p = prc.widgets.plugin;
    				widgetName = prc.widgets.name;
    				widgetSelector = prc.widgets.name;
    				category = prc.widgets.category;
    				iconName = prc.widgets.icon;
    				switch( prc.widgets.widgettype ) {
    					case 'module':
                        	widgetName &= "@" & prc.widgets.module;
                        	break;
                       	case 'layout':
                       		widgetName = "~" & widgetName;
                       		break;
    				}
    			</cfscript>					
    			<div class="widget-content" name="#widgetName#" category="#category#" type="#prc.widgets.widgettype#" displayname="#p.getPluginName()#">
                    <div class="widget-title">
                        #p.getPluginName()#
                        <span class="widget-type">#prc.widgets.widgettype#</span>
                    </div>
                    <img class="widget-icon" src="#prc.cbroot#/includes/images/widgets/#iconName#" width="80" />
                    <div class="widget-teaser">#p.getPluginDescription()#</div>
                    <div class="widget-arguments-holder" name="#widgetName#" category="#category#" style="display:none;">
                        <div class="widget-teaser">#p.getPluginDescription()#</div>
                        <div class="widget-args">
                            <div id="widgetArgs_#widgetName#">
                                <cfset pMetaData = p.getPublicMethods()>
                            	<fieldset <cfif arrayLen( pMetaData ) eq 1>style="display:none;"</cfif>>
                        	        <legend>Public Methods</legend>
                                    <label for="renderMethodSelect"><strong>Select a Method:</strong></label>
                            		<select name="renderMethodSelect_#widgetName#" id="renderMethodSelect_#widgetName#" class="renderMethodSelect">
                            		    <cfloop array="#pMetaData#" index="method">
                        					<option value="#method.name#" <cfif "renderIt" eq method.name>selected=true</cfif>>#method.name#()</option>
                        				</cfloop> 
                            		</select>
                                </fieldset>
                                <div class="widget-args-holder"></div>
                            </div>
                        </div>
                    </div>    
                </div>
    		</cfloop>
    		<div class="widget-no-preview" style="display:none;">Sorry, no widgets matched your search!</div>
        </div>
    </div>
</div>
<div class="modal-footer">
    <div class="widget-footer-left">
        <a id="widget-button-back" style="display:none;" href="javascript:void(0);" class="btn btn-primary"><i class="icon-reply"></i> Back to Widgets</a>&nbsp;
    </div>
    <div class="widget-footer-right">
        <a id="widget-button-cancel" href="javascript:void(0);" class="btn" onclick="closeRemoteModal()">Cancel</a>
		<button class="btn btn-danger" style="display:none;" id="widget-button-insert">Insert Widget</button>
    </div>
</div>
</cfoutput>