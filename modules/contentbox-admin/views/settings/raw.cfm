<cfoutput>
<div class="row-fluid" id="main-content">
	<div class="box">
		
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/face-glasses.png" alt="geek" height="30" style="height: 30px;" />
			Geek Panel <span class="label label-inverse">Environment: #getSetting('Environment')#</span>
		</div>
		
		<!--- Body --->
		<div class="body">
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!---Import Log --->
			<cfif flash.exists( "importLog" )>
			<div class="consoleLog">#flash.get( "importLog" )#</div>
			</cfif>
			
			<!--- Vertical Nav --->
			<div class="tabbable tabs-left">
    			<!--- Geek Navigation Bar --->
    			<ul class="nav nav-tabs">
    				<li class="active"><a href="##raw" data-toggle="tab"><i class="icon-cog icon-large"></i> Raw Settings</a></li>
    				<li><a href="##wirebox" data-toggle="tab"><i class="icon-th-large icon-large"></i> WireBox</a></li>
    				<li><a href="##cachebox" data-toggle="tab"><i class="icon-hdd icon-large"></i>  CacheBox</a></li>
    				<li><a href="##events" data-toggle="tab"><i class="icon-bullhorn icon-large"></i> Events</a></li>
    			</ul>
    			<!--- Tab Content --->
    			<div class="tab-content">
    				<!--- Raw Settings Pane --->
    				<div class="tab-pane active" id="raw">
    					<br>
    					<p>Manage the raw settings at your own risk buddy!</p>
						
    					<!--- Settings Editor --->
    					<div id="settingEditorContainer" class="modal hide fade">
    						<div id="modalContent">
    						<div class="modal-header">
    							<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    							<h3>Setting Editor</h3>
                            </div>
    						<!--- Create/Edit form --->
    						#html.startForm(action=prc.xehSettingsave, name="settingEditor", novalidate="novalidate", class="vertical-form")#
    						<div class="modal-body">
    							<input type="hidden" name="settingID" id="settingID" value="" />
    							<div class="control-group">
    							    <label for="name" class="control-label">Setting:</label>
    							    <div class="controls">
    							        <input name="name" id="name" type="text" required="required" maxlength="100" size="30" class="input-block-level"/>
    							    </div>
    							</div>
    							<div class="control-group">
    							    <label for="value" class="control-label">Value:</label>
    							    <div class="controls">
    							        <textarea name="value" id="value" rows="7" class="input-block-level"></textarea>
    							    </div>
    							</div>
    						</div>
    						<div class="modal-footer">
    							#html.resetButton(name="btnReset",value="Cancel",class="btn", onclick="closeModal( $('##settingEditorContainer') )")#
    							#html.submitButton(name="btnSave",value="Save",class="btn btn-danger")#
    						</div>
    						#html.endForm()#
    						</div>
    					</div>

    					<!--- settingForm --->
    					#html.startForm(name="settingForm",action=prc.xehSettingRemove)#
    					<input type="hidden" name="settingID" id="settingID" value="" />
    
    					<!--- content bar --->
    					<div class="well well-small">
    						
    						<!--- Flush Cache Button --->
    						<div class="pull-right">
    							<div class="btn-group">
    								<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
    									<i class="icon-spinner icon-spin icon-large hidden" id="specialActionsLoader"></i>
    									Special Actions
    									<span class="caret"></span>
    								</a>
    								<ul class="dropdown-menu">
    									<li><a href="javascript:openRemoteModal('#event.buildLink(prc.xehViewCached)#');"><i class="icon-hdd"></i> View Cached Settings</a></li>
    									<li><a href="javascript:flushSettingsCache()"><i class="icon-refresh"></i> Flush Settings Cache</a></li>
										<cfif prc.oAuthor.checkPermission("SYSTEM_RAW_SETTINGS,TOOLS_IMPORT")>
										<li><a href="javascript:importSettings()"><i class="icon-upload-alt"></i> Import Settings</a></li>
										</cfif>
										<cfif prc.oAuthor.checkPermission("SYSTEM_RAW_SETTINGS,TOOLS_EXPORT")>
										<li class="dropdown-submenu">
											<a href="##"><i class="icon-download"></i> Export All</a>
											<ul class="dropdown-menu text-left">
												<li><a href="#event.buildLink(linkto=prc.xehExportAll)#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
												<li><a href="#event.buildLink(linkto=prc.xehExportAll)#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
											</ul>
										</li>
										</cfif>
    								</ul>
    							</div>
    							
    							<div class="btn-group">
    								<a href="##" onclick="return createSetting();" class="btn btn-danger">Create Setting</a>
    								<button class="btn btn-danger dropdown-toggle" data-toggle="dropdown">
    									<span class="caret"></span>
    								</button>
    								<ul class="dropdown-menu">
    									<li><a href="javascript:viewAllSettings()"><i class="icon-truck"></i> View All</a></li>
    								</ul>
    							</div>
    								
    						</div>
    
    						<!--- Filter Bar --->
    						<div class="filterBar">
    							<div>
    								#html.label(field="settingSearch",content="Quick Search:",class="inline")#
    								#html.textField(name="settingSearch",size="30",class="textfield")#
    							</div>
    						</div>
    					</div>
    					
						<!---settings load --->
    					<div id="settingsTableContainer"><i class="icon-spinner icon-spin icon-large icon-2x"></i></div>
						
    					#html.endForm()#
    				</div>
				
    				<!--- WireBox Pane --->
    				<div class="tab-pane" id="wirebox">
    					<br>
    					<p>The following are all the objects that are currently in the singleton scope.</p>
    
    					#html.startForm(name="singletonForm")#
    
    					<!--- content bar --->
    					<div class="well well-small">
    						<!--- Flush Cache Button --->
    						<div class="buttonBar">
    							<button class="btn" onclick="return to('#event.buildLink(prc.xehFlushSingletons)#')" title="Clear All Singletons"><i class="icon-trash"></i> Clear All Singletons</button>
    						</div>
    						<!--- Filter Bar --->
    						<div class="filterBar">
    							<div>
    								#html.label(field="singletonsFilter",content="Quick Filter:",class="inline")#
    								#html.textField(name="singletonsFilter",size="30",class="textfield")#
    							</div>
    						</div>
    					</div>
    
    					<!--- settings --->
    					<table name="singletons" id="singletons" class="tablesorter table table-hover table-striped table-condensed" width="98%">
    						<thead>
    							<tr>
    								<th width="250">ID</th>
    								<th>Path</th>
    								<th width="50" class="center {sorter:false}">Actions</th>
    							</tr>
    						</thead>
    
    						<tbody>
    							<cfloop collection="#prc.singletons#" item="target">
    							<tr>
    								<td><strong>#target#</strong></td>
    								<td>
    									#wirebox.getBinder().getMapping(target).getPath()#
    								</td>
    								<td class="center">
    									<a class="btn" href="javascript:openRemoteModal('#event.buildLink(prc.xehMappingDump)#', {id:'#target#'})" title="Dump Mapping Memento"><i class="icon-eye-open icon-large"></i> </a>
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
    				<div class="tab-pane" id="events">
    					<br>
    					<p>Here you can see all the registered interception events that ContentBox offers and you can implement in 
    					your application, modules, layouts, etc. You can read more about writing 
    					<a href="http://wiki.coldbox.org/wiki/Interceptors.cfm">interceptors</a> in our documentation.</p>
    					
    					<!---Event Forms --->
    					#html.startForm(name="eventsForm")#
    					
    					<!--- content bar --->
    					<div class="well well-small">
    						<!--- Filter Bar --->
    						<div class="filterBar">
    							<div>
    								#html.label(field="eventFilter",content="Quick Filter:",class="inline")#
    								#html.textField(name="eventFilter",size="30",class="textfield")#
    							</div>
    						</div>
    					</div>
    					
    					<!--- events --->
    					<table name="eventsList" id="eventsList" class="tablesorter table table-striped table-hover table-condensed" width="98%">
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
                <!---End Tab Content--->
			</div>
			<!--- End Vertical Nav --->
		</div>
		<!--- End Body --->
	</div>
</div>

<div id="importDialog" class="modal hide fade">
	<div id="modalContent">
	    <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h3><i class="icon-copy"></i> Import Settings</h3>
	    </div>
        #html.startForm(name="importForm", action=prc.xehSettingsImport, class="form-vertical", multipart=true)#
        <div class="modal-body">
			<p>Choose the ContentBox <strong>JSON</strong> settings file to import.</p>
			
            #getMyPlugin( plugin="BootstrapFileUpload", module="contentbox" ).renderIt( 
                name="importFile",
                required=true
            )#			
			
			<label for="overrideSettings">Override settings?</label>
			<small>By default all settings that exist are not overwritten.</small><br>
			#html.select(options="true,false", name="overrideSettings", selectedValue="false", class="input-block-level",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
			
			<!---Notice --->
			<div class="alert alert-info">
				<i class="icon-info-sign icon-large"></i> Please note that import is an expensive process, so please be patient when importing.
			</div>
		</div>
        <div class="modal-footer">
            <!--- Button Bar --->
        	<div id="importButtonBar">
          		<button class="btn" id="closeButton"> Cancel </button>
          		<button class="btn btn-danger" id="importButton"> Import </button>
            </div>
			<!--- Loader --->
			<div class="center loaders" id="importBarLoader">
				<i class="icon-spinner icon-spin icon-large icon-2x"></i>
				<br>Please wait, doing some hardcore importing action...
			</div>
        </div>
		#html.endForm()#
	</div>
</div>
</cfoutput>