<cfoutput>
<div id="widget-container">
    <div class="well well-small">
        <!--- Create Widget --->
        <cfif args.mode eq "edit">
            <div class="buttonBar">
                <button class="btn btn-danger" onclick="openRemoteModal('#event.buildLink(prc.xehWidgetCreate)#');return false"
                        title="Create a spanking new Widget">Create Widget</button>
            </div>
        </cfif>
        <!--- Filter Bar --->
        <div class="filterBar">
            <div>
                #html.label(field="widgetFilter",content="Quick Filter:",class="inline")#
                #html.textField(name="widgetFilter",size="30",class="textfield")#
            </div>
        </div>
    </div>
    <div class="tabbable tabs-left">           
        <!--- Navigation Bar --->
        <ul class="nav nav-tabs" id="widget-sidebar">
            <li class="active"><a href="##widget-store" class="current" data-toggle="tab">All</a></li>
            <cfloop query="prc.categories">
                <li><a href="##widget-store" data-toggle="tab">#prc.categories.category#</a></li>
            </cfloop>
        </ul>
        
        <!--- ContentBars --->
        <div class="tab-content">
            <div class="widget-store full tab-pane active">
                <!--- Category Total Bar --->
                <div id="widget-total-bar" class="widget-total-bar">Category: <strong>All</strong> (#prc.widgets.recordcount# Widgets)</div>
                    <!--- Widgets --->
                    <cfloop query="prc.widgets">
                        <cfscript>
                        	try{
                            	p = prc.widgetService.getWidget( name=prc.widgets.name, type=prc.widgets.widgetType );
                        	} catch( Any e ){
                        		log.error( 'Error Building #prc.widgets.toString()#. #e.message# #e.detail#', e );
                        		writeOutput( "<div class='alert alert-danger'>Error building '#prc.widgets.name#' widget: #e.message# #e.detail#</div>" );
                        		continue;
                        	}
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
                            iconName = prc.widgets.icon;
                            if( args.cols==2 ) {
                                extraClasses = "half ";
                                extraClasses &= currentRow mod 2==0 ? "spacer" : "";
                                extraClasses = "third ";
                                extraClasses &= currentRow mod 3!=1 ? "spacer" : "";
                            }
                            else {
                                extraClasses = "third ";
                                extraClasses &= currentRow mod 3!=1 ? "spacer" : "";
                            }
                        </cfscript>
                        <cfset hasProtocol = reFindNoCase( "\b(?:https?):?", p.getPluginAuthorURL() )>
                        <cfset pluginURL = hasProtocol ? p.getPluginAuthorURL() : "http://" & p.getPluginAuthorURL()>
                        <div class="widget-content pull-left #extraClasses#" name="#widgetName#" category="#category#" type="#prc.widgets.widgettype#" displayname="#p.getPluginName()#">
                            <cfif isSimpleValue( p )>
                                <div class="alert alert-error">Error loading widget: #widgetName#<br>
                                    <p>Debugging:</p>
                                    #prc.widgets.debug#
                                </div>
                            <cfelse>
                                <div class="widget-title">
                                    #p.getPluginName()#
                                    <span class="widget-type">#prc.widgets.widgettype#</span>
                                </div>
                                <img class="widget-icon" src="#prc.cbroot#/includes/images/widgets/#iconName#" width="80" />
                                <div class="widget-teaser">#p.getPluginDescription()#</div>
                                <div class="widget-actions">
                                    v#p.getPluginVersion()#
                                    By <a href="#pluginURL#" target="_blank">#p.getPluginAuthor()#</a>
                                    <cfif args.mode eq "edit">
                                        <span class="widget-type">
                                            <div class=" btn-group">
                                                <!---read docs--->
                                                <a title="Read Widget Documentation" class="btn btn-mini" href="javascript:openRemoteModal('#event.buildLink(prc.xehWidgetDocs)#',{widget:'#urlEncodedFormat(widgetName)#',type:'#urlEncodedFormat(prc.widgets.widgettype)#'})">
                                                    <i class="icon-book icon-large"></i> 
                                                </a>
                                                <cfif prc.oAuthor.checkPermission("WIDGET_ADMIN")>
                                                    <!--- Editor --->
                                                    <a title="Edit Widget" class="btn btn-mini" href="#event.buildLink(linkTo=prc.xehWidgetEditor,queryString='widget=#widgetName#&type=#prc.widgets.widgettype#')#">
                                                        <i class="icon-edit icon-large"></i> 
                                                    </a>
                                                    <!---only allow deletion of core widgets--->
                                                    <cfif prc.widgets.widgettype eq "core">
                                                        <!--- Delete Command --->
                                                        <a title="Delete Widget" href="javascript:remove('#JSStringFormat(widgetName)#')" class="confirmIt btn btn-mini" data-title="Delete #widgetName#?">
                                                            <i class="icon-trash icon-large"></i> 
                                                        </a>
                                                    </cfif>
                                                </cfif>
                                            </div> <!--- end btn group --->
                                        </span>
                                    </cfif>
                                </div> <!--- end widget actions div --->  
                            </cfif>
                        </div> <!--- end widget-content --->
                    </cfloop>
                <div class="widget-no-preview" style="display:none;">Sorry, no widgets matched your search!</div>
            </div>
        </div>
    </div>
</div>
</cfoutput>