<cfoutput>
<div id="widget-container">

    <div class="well well-sm">
        <div class="form-group no-margin">
            #html.textField(
                name        = "widgetFilter",
                class       = "form-control",
                placeholder = "Quick Filter"
            )#
        </div>
    </div>

    <div class="tab-wrapper tab-left tab-primary">
        <!--- Navigation Bar --->
        <ul class="nav nav-tabs" id="widget-sidebar">
            <li class="active">
                <a href="##widget-store" class="current" data-toggle="tab">All</a>
            </li>
            <cfloop query="prc.categories">
                <cfif len( prc.categories.category )>
                    <li>
                        <a href="##widget-store" data-toggle="tab">#prc.categories.category#</a>
                    </li>
                </cfif>
            </cfloop>
        </ul>
        <!--- Array to hold all the error messages when generating widgets,output at the bottom of the list, not in the middle --->
        <cfset aWidgetErrors = []>
        
        <!--- ContentBars --->
        <div class="tab-content">
            <div class="widget-store full tab-pane active">
                <!--- Category Total Bar --->
                <div id="widget-total-bar" class="widget-total-bar">Category: <strong>All</strong> (#prc.widgets.recordcount# Widgets)</div>
                <div class="row bg-helper">
                    <!--- Widgets --->
                    <cfloop query="prc.widgets">
                        <cfscript>
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
                            try{
                                p = prc.widgetService.getWidget( name=widgetName, type=prc.widgets.widgetType );
                            } catch( Any e ){
                                log.error( 'Error Building #prc.widgets.toString()#. #e.message# #e.detail#', e );
                                arrayAppend( aWidgetErrors, "<div class='alert alert-danger margin10'>Error building '#prc.widgets.name#' widget: #e.message# <p><a data-toggle='collapse' data-target='##Widget_Error_#prc.widgets.name#'>Toggle Full Error</a></p><div id='Widget_Error_#prc.widgets.name#' class='collapse'>#e.detail#</div></div>" );
                                
                                continue;
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
                        <cfset hasProtocol = reFindNoCase( "\b(?:https?):?", p.getAuthorURL() )>
                        <cfset widgetURL = hasProtocol ? p.getAuthorURL() : "http://" & p.getAuthorURL()>
                        <cfset widgetCursor = args.mode eq "edit" ? "" : "widget-selector ">
                        <div class="col-md-6">
                            <div    class="#widgetCursor#panel panel-info" 
                                    name="#widgetName#" 
                                    category="#category#" 
                                    type="#prc.widgets.widgettype#" 
                                    displayname="#p.getName()#"
                                    iconName="#iconName#"
                            >
                                <cfif isSimpleValue( p )>
                                    <div class="alert alert-danger">Error loading widget: #widgetName#<br>
                                        <p>Debugging:</p>
                                        #prc.widgets.debug#
                                    </div>
                                <cfelse>
                                    <div class="panel-heading">
                                        <cfif args.mode eq "edit">
                                            <div class="btn-group btn-group-sm actions">
                                                <!---read docs--->
                                                <a data-toggle="tooltip" data-placement="left" title="Read Widget Documentation" class="btn btn-sm btn-info" href="javascript:openRemoteModal('#event.buildLink(prc.xehWidgetDocs)#',{widget:'#urlEncodedFormat(widgetName)#',type:'#urlEncodedFormat(prc.widgets.widgettype)#'} )">
                                                    <i class="fa fa-book fa-lg"></i> 
                                                </a>
                                                <cfif prc.oAuthor.checkPermission( "WIDGET_ADMIN" )>
                                                    <!--- Test --->
                                                    <a title="Test Widget" class="btn btn-sm btn-info" 
                                                        href="javascript:testWidgetCode( '#widgetName#', '#prc.widgets.widgetType#' )">
                                                        <i class="fa fa-bolt fa-lg"></i> 
                                                    </a>
                                                    <!---only allow deletion of core widgets--->
                                                    <cfif prc.widgets.widgettype eq "core">
                                                        <!--- Delete Command --->
                                                        <a title="Delete Widget" href="javascript:remove('#JSStringFormat(widgetName)#')" class="confirmIt btn btn-sm btn-danger" data-title="Delete #widgetName#?">
                                                            <i class="fa fa-trash-o fa-lg"></i> 
                                                        </a>
                                                    </cfif>
                                                </cfif>
                                            </div> <!--- end btn group --->
                                        </cfif>
                                        <h3 class="panel-title"><strong>#p.getName()#</strong></h3>
                                    </div>
                                    <div class="panel-body">
                                        <div class="row">
                                            <div class="col-md-4 text-center"><i class="fa fa-#iconName# fa-lg fa-4x"></i></div>
                                            <div class="col-md-8">#p.getDescription()#</div>
                                        </div>
                                    </div>
                                    <div class="panel-footer">
                                        v#p.getVersion()#
                                        By <a href="#widgetURL#" target="_blank">#p.getAuthor()#</a>
                                        <span class="pull-right label label-primary">#prc.widgets.widgettype#</span>
                                    </div>
                                </cfif>
                            </div> <!--- end widget-content --->
                        </div>
                    </cfloop>
                    
                </div>
                
                <div class="row">
                <cfloop array="#aWidgetErrors#" index="widgetError" >
                	#widgetError#
                </cfloop>	
                </div>
                    
                <div class="widget-no-preview" style="display:none;">Sorry, no widgets matched your search!</div>
            </div>
        </div>
    </div>
</div>
</cfoutput>
