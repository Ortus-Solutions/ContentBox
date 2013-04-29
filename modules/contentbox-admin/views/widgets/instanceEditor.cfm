<cfscript>
	p = prc.widget.plugin;
	widgetName = prc.widget.name;
	widgetSelector = prc.widget.name;
	category = prc.widget.category;
	iconName = prc.widget.icon;
</cfscript>				
<cfoutput>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3><span id="widget-title-bar">
        <img width="25" src="#prc.cbroot#/includes/images/widgets/#iconName#" /> Edit '#p.getPluginName()#' Widget
      	</span>
    </h3>
</div>
<div class="modal-body">
    <div class="widget-detail" id="widget-detail">
    	<div class="widget-preview">
    	    <div class="widget-preview-toolbar">
    	        Preview
                <a href="javascript:void(0);" class="widget-preview-refresh btn btn-mini"><i class="icon-refresh"></i> Refresh</a>
    	    </div>
            <div id="widget-preview-content" class="widget-preview-content"></div>
    	</div>
    	<div class="widget-arguments" id="widget-arguments">
    	    <div class="widget-teaser">#p.getPluginDescription()#</div>
            <div class="widget-args">
                <div id="widgetArgs_#widgetName#">
                    <fieldset <cfif arrayLen( prc.metadata ) eq 1>style="display:none;"</cfif>>
            	        <legend>Public Methods</legend>
                        <label for="renderMethodSelect"><strong>Select a Method:</strong></label>
                		<select name="renderMethodSelect" id="renderMethodSelect">
                		    <cfloop array="#prc.metadata#" index="method">
            					<option value="#method.name#" <cfif prc.widget.udf eq method.name>selected=true</cfif>>#method.name#()</option>
            				</cfloop> 
                		</select>
                    </fieldset>
                    <div class="widget-args-holder"></div>
                </div>
            </div>
    	</div>    
    </div>
</div>
<div class="modal-footer">
    <div class="widget-footer-left">
        &nbsp;
    </div>
    <div class="widget-footer-right">
        <a id="widget-button-cancel" href="javascript:void(0);" onclick="closeRemoteModal()" class="btn">Cancel</a>
		<button class="btn btn-danger" id="widget-button-update">Update Widget</button>
    </div>
</div>
</cfoutput>