<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
            <img src="#prc.cbroot#/includes/images/face-glasses.png" alt="geek" height="30"/>
            Geek Panel
        </h1>
        <div class="label label-warning">Environment: #getSetting('Environment')#</div>
        

       
    </div>
    <div class="col-md-12">

        <!--- messageBox --->
        <div class="clearfix">
            #getModel( "messagebox@cbMessagebox" ).renderit()#
        </div>

        <!---Import Log --->
        <cfif flash.exists( "importLog" )>
            <div class="consoleLog">#flash.get( "importLog" )#</div>
        </cfif>

        <div class="panel panel-default">
            <div class="panel-body">
                <!-- Vertical Nav -->
                <div class="tab-wrapper tab-left tab-primary">
                    <!-- Tabs -->
                    <ul class="nav nav-tabs">
                        <li class="active">
                            <a href="##raw" data-toggle="tab"><i class="fa fa-cog fa-lg"></i> <span class="hidden-xs">Raw Settings</span></a>
                        </li>
                        <li>
                            <a href="##wirebox" data-toggle="tab"><i class="fa fa-th fa-lg"></i> <span class="hidden-xs">WireBox</span></a>
                        </li>
                        <li>
                            <a href="##cachebox" data-toggle="tab"><i class="fa fa-hdd-o fa-lg"></i> <span class="hidden-xs">CacheBox</span></a>
                        </li>
                        <li>
                            <a href="##_events" data-toggle="tab"><i class="fa fa-bullhorn fa-lg"></i> <span class="hidden-xs">Events</span></a>
                        </li>
                    </ul>
                    <!-- End Tabs -->
                    <!-- Tab Content -->
                    <div class="tab-content">
                        <!--- Raw Settings Pane --->
                        <div class="tab-pane active" id="raw">
                            <br>
                            <p>
                                Below are all the ContentBox settings in your installation. Modify at your own risk.
                                <div class="alert alert-warning">
                                    <i class="fa fa-info-circle"></i> Please note that core settings cannot be deleted from this panel.
                                </div>
                            </p>
                            <!---settings form--->
                            #html.startForm(name="settingForm",action=prc.xehSettingRemove)#
                                <input type="hidden" name="settingID" id="settingID" value="" />
                                <div class="row well well-sm">
                                    <div class="col-md-6">
                                        <div class="form-group form-inline no-margin">
                                            #html.textField(
                                                name="settingSearch",
                                                class="form-control",
                                                placeholder="Quick Search",
                                                value=event.getValue( "search", "" )
                                            )#
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="pull-right">
                                            <div class="btn-group btn-group-sm">
                                                <a class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" href="##">
                                                    <i class="fa fa-spinner fa-spin fa-lg hidden" id="specialActionsLoader"></i>
                                                    Special Actions
                                                    <span class="caret"></span>
                                                </a>
                                                <ul class="dropdown-menu">
                                                    <li><a href="javascript:openRemoteModal('#event.buildLink(prc.xehViewCached)#');"><i class="fa fa-hdd-o"></i> View Cached Settings</a></li>
                                                    <li><a href="javascript:flushSettingsCache()"><i class="fa fa-refresh"></i> Flush Settings Cache</a></li>
                                                    <cfif prc.oAuthor.checkPermission( "SYSTEM_RAW_SETTINGS,TOOLS_IMPORT" )>
                                                    <li><a href="javascript:importSettings()"><i class="fa fa-upload"></i> Import Settings</a></li>
                                                    </cfif>
                                                    <cfif prc.oAuthor.checkPermission( "SYSTEM_RAW_SETTINGS,TOOLS_EXPORT" )>
														<li><a href="#event.buildLink (linkto=prc.xehExportAll )#.json" target="_blank"><i class="fa fa-download"></i> Export All as JSON</a></li>
														<li><a href="#event.buildLink( linkto=prc.xehExportAll )#.xml" target="_blank"><i class="fa fa-download"></i> Export All as XML</a></li>
													</cfif>
                                                </ul>
                                            </div>
                                            
                                            <div class="btn-group btn-group-sm">
                                                <a href="##" onclick="return createSetting();" class="btn btn-primary btn-sm">Create Setting</a>
                                                <button class="btn btn-sm btn-primary dropdown-toggle" data-toggle="dropdown">
                                                    <span class="caret"></span>
                                                </button>
                                                <ul class="dropdown-menu">
                                                    <li><a href="javascript:viewAllSettings()"><i class="fa fa-truck"></i> View All</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!---settings load --->
                                <div id="settingsTableContainer">
                                    <i class="fa fa-spinner fa-spin fa-lg fa-2x"></i>
                                </div>
                            #html.endForm()#

                            <!--- Settings Editor --->
                            <div id="settingEditorContainer" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
                                <div class="modal-dialog modal-lg" role="document" >
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                            <h4 class="modal-title"><i class="fa fa-cogs"></i> Setting Editor</h4>
                                        </div>
                                        <div class="modal-body">
                                            <!--- Create/Edit form --->
                                            #html.startForm(
                                                action      = prc.xehSettingsave, 
                                                name        = "settingEditor", 
                                                novalidate  = "novalidate", 
                                                class       = "vertical-form"
                                            )#
                                                <input type="hidden" name="settingID" id="settingID" value="" />
                                                <div class="form-group">
                                                    <label for="name" class="control-label">Setting:</label>
                                                    <div class="controls">
                                                        <input name="name" id="name" type="text" required="required" maxlength="100" size="30" class="form-control"/>
                                                    </div>
                                                </div>
                                                <div class="checkbox">
                                                    <label>
                                                      <input type="checkbox" name="isCore" id="isCore" value="true"> <strong>Core Setting</strong>
                                                    </label>
                                                </div>
                                                <div class="form-group">
                                                    <label for="value" class="control-label">Value:</label>
                                                    <div class="controls">
                                                        <textarea name="value" id="value" rows="7" class="form-control"></textarea>
                                                    </div>
                                                </div>
                                            #html.endForm()#
                                        </div>
                                        <div class="modal-footer">
                                            #html.resetButton(
                                                name="btnReset",
                                                value="Cancel",
                                                class="btn", 
                                                onclick="closeModal( $('##settingEditorContainer') )"
                                            )#
                                            #html.button(
                                                name="btnSave",
                                                value="Save",
                                                class="btn btn-danger",
                                                onclick="submitSettingForm()"
                                            )#
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--- WireBox Pane --->
                        <div class="tab-pane" id="wirebox">
                            <br>
                            <p>The following are all the objects that are currently in the singleton scope.</p>
                            <div class="row well well-sm">
                                <div class="col-md-6">
                                    <div class="form-group form-inline no-margin">
                                        #html.textField(
                                            name="singletonsFilter",
                                            size="30",
                                            class="form-control",
                                            placeholder="Quick Filter"
                                        )#
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="pull-right">
                                        <div class="btn-group btn-group-sm">
                                            <button class="btn btn-sm btn-info" onclick="return to('#event.buildLink(prc.xehFlushSingletons)#')" title="Clear All Singletons"><i class="fa fa-trash-o"></i> Clear All Singletons</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            #html.startForm(name="singletonForm" )#
                                <!--- settings --->
                                <table name="singletons" id="singletons" class="table table-hover table-striped table-condensed" width="98%">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Path</th>
                                            <th class="text-center {sorter:false}">Actions</th>
                                        </tr>
                                    </thead>
            
                                    <tbody>
                                        <cfloop collection="#prc.singletons#" item="target">
                                        <tr>
                                            <td><strong>#target#</strong></td>
                                            <td>
                                                #wirebox.getBinder().getMapping(target).getPath()#
                                            </td>
                                            <td class="text-center">
                                                <a class="btn btn-sm btn-primary" href="javascript:openRemoteModal('#event.buildLink(prc.xehMappingDump)#', {id:'#target#'} )" title="Dump Mapping Memento"><i class="fa fa-eye fa-lg"></i> </a>
                                            </td>
                                        </tr>
                                        </cfloop>
                                    </tbody>
                                </table>
                            #html.endForm()#
                        </div>
                        <!--- CacheBox Pane --->
                        <div class="tab-pane" id="cachebox">
                            <br>
                            <cfimport prefix="cachebox" taglib="/coldbox/system/cache/report">
                            <cachebox:monitor cacheFactory="#controller.getCacheBox()#"
                                              baseURL="#event.buildLink(prc.xehRawSettings)#"
                                              enableMonitor=false/>
                        </div>
                        <!--- ContentBox Events Docs --->
                        <div class="tab-pane" id="_events">
                            <br>
                            <p>Here you can see all the registered interception events that ContentBox offers and you can implement in 
                            your application, modules, layouts, etc. You can read more about writing 
                            <a href="http://wiki.coldbox.org/wiki/Interceptors.cfm">interceptors</a> in our documentation.</p>
                            <div class="row well well-sm">
                                <div class="col-md-6">
                                    <div class="form-group form-inline no-margin">
                                        #html.textField(
                                            name="eventFilter",
                                            size="30",
                                            class="form-control",
                                            placeholder="Quick Filter"
                                        )#
                                    </div>
                                </div>
                                <div class="col-md-6"></div>
                            </div>
                            <!---Event Forms --->
                            #html.startForm(name="eventsForm" )#
                                <!--- events --->
                                <table name="eventsList" id="eventsList" class="table table-striped table-hover table-condensed" width="100%">
                                    <thead>
                                        <tr>
                                            <th width="30" class="{sorter:none}">No.</th>
                                            <th>Event</th>
                                            <th width="200">Module</th>
                                            <th width="100">Listeners</th>                                  
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfset index = 1>
                                        <cfloop array="#prc.interceptionPoints#" index="thisEvent">
                                        <cfif reFindNocase( "(cbui|cbadmin|fb)", thisEVent )>
                                            <cfset thisModule = listFirst( thisEvent, "_" )>
                                            <tr>
                                                <td>
                                                    <span class="badge badge-info">#index++#</badge>
                                                </td>
                                                <td>
                                                    #thisEvent#
                                                </td>
                                                <td>
                                                    <cfswitch expression="#thisModule#">
                                                        <cfcase value="cbui">ContentBox UI</cfcase>
                                                        <cfcase value="cbadmin">ContentBox Admin</cfcase>
                                                        <cfcase value="fb">ContentBox FileBrowser</cfcase>
                                                    </cfswitch>
                                                </td>
                                                <td>
                                                    <cfif structKeyExists( controller.getInterceptorService().getInterceptionStates(), thisEvent )>
                                                        <cfdump var="#structKeyArray( controller.getInterceptorService().getInterceptionStates()[ thisEvent ].getMetadataMap() )#">
                                                    <cfelse>
                                                        <span class="badge badge-inverse">0</badge>
                                                    </cfif>
                                                </td>
                                            </tr>
                                        </cfif>
                                        </cfloop>
                                    </tbody>
                                </table>
                            #html.endForm()#
                        </div>
                    </div>
                    <!-- End Tab Content -->
                </div>
                <!-- End Vertical Nav -->
            </div>
        </div>
    </div>
</div>
<cfscript>
    dialogArgs = {
        title = "Import Settings",
        contentArea = "settings",
        action = prc.xehSettingsImport,
        contentInfo = "Choose the ContentBox <strong>JSON</strong> settings file to import."
    };
</cfscript>
#renderView( view="_tags/dialog/import", args=dialogArgs )#
</cfoutput>