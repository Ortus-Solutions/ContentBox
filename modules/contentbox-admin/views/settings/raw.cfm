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
		
			<!--- Vertical Nav --->
			<div class="tabbable tabs-left">
    			<!--- Geek Navigation Bar --->
    			<ul class="nav nav-tabs">
    				<li class="active" title="Raw Settings"><a href="##raw" data-toggle="tab"><i class="icon-cog icon-large"></i> Raw Settings</a></li>
    				<li title="WireBox"><a href="##wirebox" data-toggle="tab"><i class="icon-th-large icon-large"></i> WireBox</a></li>
    				<li title="CacheBox Monitor"><a href="##cachebox" data-toggle="tab"><i class="icon-hdd icon-large"></i>  CacheBox</a></li>
    				<li title="ContentBox Events"><a href="##events" data-toggle="tab"><i class="icon-bullhorn icon-large"></i> Events</a></li>
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
    						#html.startForm(action=prc.xehSettingsave,name="settingEditor",novalidate="novalidate",class="vertical-form")#
    						<div class="modal-body">
    							<input type="hidden" name="settingID" id="settingID" value="" />
    							<input type="hidden" name="page" id="page" value="#rc.page#" />
    							<div class="control-group">
    							    <label for="name" class="control-label">Setting:</label>
    							    <div class="controls">
    							        <input name="name" id="name" type="text" required="required" maxlength="100" size="30" class="input-block-level"/>
    							    </div>
    							</div>
    							<div class="control-group">
    							    <label for="value" class="control-label">Value:</label>
    							    <div class="controls">
    							        <textarea name="value" id="value" rows="3" class="input-block-level"></textarea>
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
    								<a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="##">
    									Special Actions
    									<span class="caret"></span>
    								</a>
    								<ul class="dropdown-menu">
    									<li><a href="javascript:openRemoteModal('#event.buildLink(prc.xehViewCached)#');"><i class="icon-hdd"></i> View Cached Settings</a></li>
    									<li><a href="#event.buildLink(prc.xehFlushCache)#"><i class="icon-refresh"></i> Flush Settings Cache</a></li>
    								</ul>
    							</div>
    							
    							<div class="btn-group">
    								<a href="##" onclick="return createSetting();" class="btn btn-danger"><i class="icon-plus-sign"></i> Create Setting</a>
    								<button class="btn btn-danger dropdown-toggle" data-toggle="dropdown">
    									<span class="caret"></span>
    								</button>
    								<ul class="dropdown-menu">
    									<li><a href="#event.buildLink(prc.xehRawSettings)#/viewall/true"><i class="icon-truck"></i> View All</a></li>
    								</ul>
    							</div>
    								
    						</div>
    
    						<!--- Filter Bar --->
    						<div class="filterBar">
    							<div>
    								#html.label(field="settingFilter",content="Quick Filter:",class="inline")#
    								#html.textField(name="settingFilter",size="30",class="textfield")#
    							</div>
    						</div>
    					</div>
    					
    					<!--- settings --->
    					<table name="settings" id="settings" class="tablesorter table table-striped table-hover table-condensed" width="98%">
    						<thead>
    							<tr>
    								<th width="250">Name</th>
    								<th>Value</th>
    								<th width="125" class="center {sorter:false}">Actions</th>
    							</tr>
    						</thead>
    
    						<tbody>
    							<cfloop array="#prc.settings#" index="setting">
    							<tr>
    								<td><a href="javascript:edit('#setting.getSettingId()#','#setting.getName()#','#JSStringFormat(setting.getValue())#')" title="Edit Setting">#setting.getName()#</a></td>
    								<td>
    									<cfif len( setting.getValue() ) gt 90 >
    										#html.textarea(value=setting.getValue(), rows="5", cols="5")#
    									<cfelse>
    										#htmlEditFormat( setting.getValue() )#
    									</cfif>
    								</td>
    								<td class="center">
    									<!--- Edit Command --->
    									<a href="javascript:edit('#setting.getSettingId()#','#setting.getName()#','#JSStringFormat(setting.getValue())#')" title="Edit Setting"><i class="icon-edit icon-large"></i></a>
    									<!--- Delete Command --->
    									<a title="Delete Setting" href="javascript:remove('#setting.getsettingID()#')" class="confirmIt" data-title="Delete Setting?"><i class="icon-remove-sign icon-large" id="delete_#setting.getsettingID()#"></i></a>
    								</td>
    							</tr>
    							</cfloop>
    						</tbody>
    					</table>
    
    					<!--- Paging --->
    					<cfif !rc.viewAll>
    					#prc.pagingPlugin.renderit(foundRows=prc.settingsCount, link=prc.pagingLink, asList=true)#
    					</cfif>
    					
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
    							<button class="btn btn-primary" onclick="return to('#event.buildLink(prc.xehFlushSingletons)#')" title="Clear All Singletons"><i class="icon-magnet"></i> Clear All Singletons</button>
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
    									<a href="javascript:openRemoteModal('#event.buildLink(prc.xehMappingDump)#', {id:'#target#'})" title="Dump Mapping Memento"><i class="icon-eye-open icon-large"></i> </a>
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
</cfoutput>