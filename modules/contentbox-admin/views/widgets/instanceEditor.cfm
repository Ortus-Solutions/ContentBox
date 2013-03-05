<cfscript>
	p = prc.widget.plugin;
	widgetName = prc.widget.name;
	widgetSelector = prc.widget.name;
	category = prc.widget.category;
	if( prc.widget.icon != "" ) {
		iconName = prc.widget.icon;
	}
	else {
		switch( prc.widget.category ) {
			case "Content":
				iconName = "page_writing.png";
				break;
			case "Utilities":
				iconName = "tune.png";
				break;
			case "Miscellaneous":
				iconName = "puzzle.png";
				break;
			case "Module":
				iconName = "box.png";
				break;
			case "Layout":
				iconName = "layout_squares_small.png";
				break;
		}	
	}
</cfscript>				
<cfoutput>
<h2 style="position:relative;">
    <span id="widget-title-bar">
        <img width="25" src="#prc.cbroot#/includes/images/widgets/#iconName#" /> Edit '#p.getPluginName()#' Widget</span>
</h2>
<div class="widget-detail" id="widget-detail">
	<div class="widget-preview">
	    <div class="widget-preview-toolbar">
	        Preview
            <a href="javascript:void(0);" class="widget-preview-refresh">Refresh</a>
	    </div>
        <div id="widget-preview-content" class="widget-preview-content"></div>
	</div>
	<div class="widget-arguments" id="widget-arguments">
	    <div class="widget-teaser">#p.getPluginDescription()#</div>
        <div class="widget-args">
            <div id="widgetArgs_#widgetName#">
            	#renderWidgetArgs( p.renderit, widgetName, prc.widget.widgetType, p.getPluginName(), prc.vals )#
            </div>
        </div>
	</div>    
</div>
<div class="widget-footer">
    <div class="widget-footer-left">
        &nbsp;
    </div>
    <div class="widget-footer-right">
        <button class="buttonred" id="widget-button-update">Update Widget</button>
        <a id="widget-button-cancel" href="javascript:void(0);" onclick="closeRemoteModal()" class="button">Cancel</a>
    </div>
</div>
</cfoutput>