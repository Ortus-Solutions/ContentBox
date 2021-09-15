<cfoutput>
<div class="row">

    <div class="col-md-12">
        <h1 class="h1">
            <img src="#prc.cbroot#/includes/images/face-glasses.png" alt="geek" height="30"/>
            Geek Panel
        </h1>
        <div class="label label-info" title="Environment">#getSetting( 'Environment' )#</div>
	</div>

    <div class="col-md-12">

        <!--- messageBox --->
        <div class="clearfix">
            #cbMessageBox().renderit()#
        </div>

        <!---Import Log --->
        <cfif flash.exists( "importLog" )>
            <div class="consoleLog">#flash.get( "importLog" )#</div>
        </cfif>

        <div class="panel panel-default">
            <div class="panel-body">
                <!-- Vertical Nav -->
				<div class="tab-wrapper tab-primary">

                    <!-- Tabs -->
                    <ul class="nav nav-tabs">
                        <li class="active">
                            <a href="##raw" data-toggle="tab"><i class="fa fa-cog fa-lg"></i> <span class="hidden-xs">Raw Settings</span></a>
                        </li>
                        <li>
                            <a href="##cachebox" data-toggle="tab"><i class="far fa-hdd fa-lg"></i> <span class="hidden-xs">CacheBox</span></a>
                        </li>
                        <li>
                            <a href="##_events" data-toggle="tab"><i class="fas broadcast-tower fa-lg"></i> <span class="hidden-xs">Events</span></a>
                        </li>
                    </ul>
					<!-- End Tabs -->

                    <!-- Tab Content -->
                    <div class="tab-content">
                        <!--- Raw Settings Pane --->
						<div class="tab-pane active" id="raw">

                            <p>
                                Below are all the ContentBox settings in your installation. Modify at your own risk.
                                <div class="alert alert-info">
                                    <i class="fa fa-info-circle"></i> Please note that core settings cannot be deleted from this panel.
                                </div>
							</p>

                            <!---settings form--->
                            #html.startForm( name="settingForm", action=prc.xehSettingRemove )#
                                <input type="hidden" name="settingID" id="settingID" value="" />
                                <div class="row well well-sm">

									<div class="col-md-6 col-xs-4 flex flex-row">

                                        <div class="form-group m0 mr5">
                                            #html.textField(
                                                name        = "settingSearch",
                                                class       = "form-control rounded quicksearch",
                                                placeholder = "Quick Search",
                                                value       = event.getValue( "search", "" )
                                            )#
                                        </div>

										<div class="form-group m0">
											<select
												name="siteFilter"
												id="siteFilter"
												class="form-control text-light-gray"
												title="Site Filter"
												onchange="settingsLoad()"
											>
												<option value="" selected="selected">-- All Sites --</option>
												<cfloop array=#prc.allSites# index="thisSite">
													<option value="#thisSite[ 'siteID' ]#">
														#thisSite[ 'name' ]#
													</option>
												</cfloop>
											</select>
										</div>

									</div>

                                    <div class="col-md-6 col-xs-8">
										<div class="text-right">

											<div class="btn-group">

												<a class="btn btn-info dropdown-toggle" data-toggle="dropdown" href="##">
                                                    <i class="fa fa-spinner fa-spin fa-lg hidden" id="specialActionsLoader"></i>
                                                    Special Actions
                                                    <span class="caret"></span>
												</a>

                                                <ul class="dropdown-menu">
													<cfif prc.oCurrentAuthor.checkPermission( "SYSTEM_RAW_SETTINGS,TOOLS_EXPORT" )>
														<li>
															<a href="#event.buildLink( prc.xehExportAll )#.json" target="_blank">
																<i class="fas fa-file-export fa-lg"></i> Export All
															</a>
														</li>
														<li>
															<a href="javascript:exportSelected( '#event.buildLink( prc.xehExportAll )#' )">
																<i class="fas fa-file-export fa-lg"></i> Export Selected
															</a>
														</li>
													</cfif>
													<li>
														<a href="javascript:flushSettingsCache()">
															<i class="fas fa-recycle fa-lg"></i> Flush Settings Cache
														</a>
													</li>
                                                    <cfif prc.oCurrentAuthor.checkPermission( "SYSTEM_RAW_SETTINGS,TOOLS_IMPORT" )>
														<li>
															<a href="javascript:importContent()">
																<i class="fas fa-file-import fa-lg"></i> Import
															</a>
														</li>
                                                    </cfif>
													<li>
														<a href="javascript:openRemoteModal('#event.buildLink( prc.xehViewCached )#');">
															<i class="far fa-hdd fa-lg"></i> View Cached Settings
														</a>
													</li>
                                                </ul>
                                            </div>

                                            <div class="btn-group">
                                                <a
                                                	href="##"
                                                	onclick="return createSetting();"
													class="btn btn-primary">
													Create Setting
												</a>
                                                <button
                                                	class="btn btn-primary dropdown-toggle"
													data-toggle="dropdown"
												>
                                                    <span class="caret"></span>
                                                </button>
                                                <ul class="dropdown-menu">
													<li>
														<a href="javascript:viewAllSettings()"><i class="fas fa-microchip"></i> View All</a>
													</li>
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
											<h4 class="modal-title">
												<i class="fas fa-pen fa-lg"></i> Setting Editor
											</h4>
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
                                                    <label for="name" class="control-label">*Setting:</label>
                                                    <div class="controls">
                                                        <input name="name" id="name" type="text" required="required" maxlength="100" size="30" class="form-control"/>
                                                    </div>
												</div>

												<div class="form-group">
													<label for="name" class="control-label">Site:</label>
													<select name="site" id="site" class="form-control">
														<option value="" selected="selected">-- All Sites --</option>
														<cfloop array=#prc.allSites# index="thisSite">
															<option value="#thisSite[ 'siteID' ]#">
																#thisSite[ 'name' ]#
															</option>
														</cfloop>
													</select>
												</div>

                                                <div class="form-group">
                                                    <label for="value" class="control-label">*Value:</label>
                                                    <div class="controls">
                                                        <textarea
                                                        	name="value"
                                                        	id="value"
															rows="5"
															required="required"
                                                        	class="form-control"></textarea>
                                                    </div>
                                                </div>

												<div class="checkbox">
                                                    <label>
                                                    	<input type="checkbox" name="isCore" id="isCore" value="true"> <strong>Core Setting</strong>
                                                    </label>
												</div>
                                            #html.endForm()#
                                        </div>
                                        <div class="modal-footer">
                                            #html.resetButton(
                                                name="btnReset",
                                                value="Cancel",
                                                class="btn btn-default",
                                                onclick="closeModal( $('##settingEditorContainer') )"
                                            )#
                                            #html.button(
                                                name="btnSave",
                                                value="Save",
                                                class="btn btn-primary",
                                                onclick="submitSettingForm()"
                                            )#
                                        </div>
                                    </div>
                                </div>
                            </div>
						</div>

                        <!--- CacheBox Pane --->
                        <div class="tab-pane" id="cachebox">
                            <br>
							<cftry>
								<cfimport prefix = "cachebox" taglib = "/coldbox/system/cache/report">
									<cachebox:monitor
										cacheFactory = "#controller.getCacheBox()#"
										baseURL = "#event.buildLink( prc.xehRawSettings )#"
										enableMonitor = false />
								<cfcatch type = "any" >
									Can't render charting: #cfcatch.message# #cfcatch.detail#
								</cfcatch>
							</cftry>

						</div>

                        <!--- ContentBox Events Docs --->
                        <div class="tab-pane" id="_events">
                            <br>
                            <p>Here you can see all the registered interception events that ContentBox offers and you can implement in
                            your application, modules, layouts, etc. You can read more about writing
                            <a href="http://wiki.coldbox.org/wiki/Interceptors.cfm">interceptors</a> in our documentation.</p>
                            <div class="row well well-sm">
                                <div class="col-md-12">
                                    <div class="form-group no-margin">
                                        #html.textField(
                                            name        = "eventFilter",
                                            size        = "30",
                                            class       = "form-control rounded",
											placeholder = "Quick Filter"
                                        )#
                                    </div>
                                </div>
							</div>

                            <!---Event Forms --->
                            #html.startForm(name="eventsForm" )#
                                <!--- events --->
                                <table name="eventsList" id="eventsList" class="table table-striped-removed table-hover " width="100%">
                                    <thead>
                                        <tr>
                                            <th width="30" class="{sorter:none}">No.</th>
                                            <th>Event</th>
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
                                                    <span class="badge badge-default">#index++#</badge>
												</td>

												<td>
                                                    <code>#thisModule#:#thisEvent#</code>
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

#renderView(
	view = "_tags/dialog/import",
	args = {
        title       : "Import Settings",
        contentArea : "settings",
        action      : prc.xehSettingsImport,
        contentInfo : "Choose the ContentBox <strong>JSON</strong> settings file to import."
	},
	prePostExempt = true
)#
</cfoutput>