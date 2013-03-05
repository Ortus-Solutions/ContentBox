<cfoutput>
<h2 style="position:relative;">
    <span id="widget-title-bar">Select a Widget</span>
    <div class="widget-filter" id="widget-filter">
        #html.label(field="widgetFilter",content="Quick Filter:",class="inline")#
		#html.textField(name="widgetFilter",size="30",class="textfield")#
    </div>
</h2>
<div class="widget-detail" id="widget-detail" style="display:none;">
	<div class="widget-preview">
	    <div class="widget-preview-toolbar">
	        Preview
            <a href="javascript:void(0);" class="widget-preview-refresh">Refresh</a>
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
        <div id="widget-total-bar" class="widget-total-bar">Category: <strong>All</strong> (#prc.widgets.recordcount# Widgets)</div>
        <cfloop query="prc.widgets">
			<cfscript>
				p = prc.widgets.plugin;
				widgetName = prc.widgets.name;
				widgetSelector = prc.widgets.name;
				category = prc.widgets.category;
				
				switch( prc.widgets.widgettype ) {
					case 'module':
                    	widgetName &= "@" & prc.widgets.module;
                    	break;
                   	case 'layout':
                   		widgetName = "~" & widgetName;
                   		break;
				}
				if( prc.widgets.icon != "" ) {
					iconName = prc.widgets.icon;
				}
				else {
    				switch( prc.widgets.category ) {
    					case "Content":
    						iconName = "page_writing.png";
    						break;
    					case "Utilities":
    						iconName = "tune.png";
    						break;
    					case "Module":
    						iconName = "box.png";
    						break;
    					case "Layout":
    						iconName = "layout_squares_small.png";
    						break;
    					default:
    						iconName = "puzzle.png";
    						break;
    				}	
				}
			</cfscript>					
			<cfif isSimpleValue(p)>
				<!---<tr class="selected">
					<td colspan="4">There is a problem creating widget: '#widgetName#', please check the application log files.</td>
				</tr>--->
			<cfelse>
				<div class="widget-content" name="#widgetName#" category="#category#">
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
                            	#renderWidgetArgs( p.renderit, widgetName, prc.widgets.widgetType, p.getPluginName() )#
                            </div>
                        </div>
                    </div>    
                </div>
			</cfif>
		</cfloop>
		<div class="widget-no-preview" style="display:none;">Sorry, no widgets matched your search!</div>
    </div>
</div>
<div class="widget-footer">
    <div class="widget-footer-left">
        <a id="widget-button-back" style="display:none;" href="javascript:void(0);" class="button2">Back to Widgets</a>&nbsp;
    </div>
    <div class="widget-footer-right">
        <button class="buttonred" style="display:none;" id="widget-button-insert">Insert Widget</button>
        <a id="widget-button-cancel" href="javascript:void(0);" class="button" onclick="closeRemoteModal()">Cancel</a>
    </div>
</div>
</cfoutput>