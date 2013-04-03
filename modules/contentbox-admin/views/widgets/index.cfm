<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<cfif prc.oAuthor.checkPermission("WIDGET_ADMIN")>
		<div class="header">
			<i class="icon-upload-alt"></i> Widget Uploader
		</div>
		<div class="body">
			#html.startForm(name="widgetUploadForm",action=prc.xehWidgetupload,multipart=true,novalidate="novalidate")#

				#html.fileField(name="filePlugin",label="Upload Widget: ", class="textfield",required="required")#

				<div class="actionBar" id="uploadBar">
					#html.submitButton(value="Upload & Install",class="buttonred")#
				</div>

				<!--- Loader --->
				<div class="loaders" id="uploadBarLoader">
					<i class="icon-spinner icon-spin icon-large icon-2x"></i> <br>
					Uploading & Installing
				</div>
			#html.endForm()#
		</div>
		</cfif>
	</div>
	
	<!--- Help Box --->
	<div class="small_box">
		<div class="header">
			<i class="icon-question-sign"></i> Widget Help
		</div>
		<div class="body">
			<p>Render widgets in your layouts and views by using the CB Helper method <em>widget()</em>:</p>
			<div class="infoBar infoBar-green">
				##cb.widget("name",{arg1=val,arg2=val})##
			</div>
			<p>Render module widgets by appending the module name <em>@module</em>:</p>
			<div class="infoBar infoBar-green">
				##cb.widget("name@module",{arg1=val,arg2=val})##
			</div>
			<p>Get an instance of a widget in your layouts and views using the CB helper method <em>getWidget()</em></p>
			<div class="infoBar infoBar-green">
				 ##cb.getWidget("name")##
				 ##cb.getWidget("name@module")##
			</div>
		</div>
	</div>
</div>
<!--End sidebar-->
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<ul class="sub_nav">
				<!--- Manage --->
				<li title="Manage Widgets"><a href="##manage" class="current"><i class="icon-cog icon-large"></i>  Manage</a></li>
				<!--- Install --->
				<cfif prc.oAuthor.checkPermission("FORGEBOX_ADMIN")>
				<li title="Install New Widgets"><a href="##install" onclick="loadForgeBox()"><i class="icon-cloud-download icon-large"></i> ForgeBox</a></li>
				</cfif>
			</ul>
			<i class="icon-magic icon-large"></i> 
			Widgets
		</div>
		<!--- Body --->
		<div class="body">

			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- Logs --->
			<cfif flash.exists("forgeboxInstallLog")>
				<h3>Installation Log</h3>
				<div class="consoleLog">#flash.get("forgeboxInstallLog")#</div>
			</cfif>
			
			<div class="panes">
				<div id="managePane">
				<!--- CategoryForm --->
				#html.startForm(name="widgetForm",action=prc.xehWidgetRemove)#
				#html.hiddenField(name="widgetFile")#
	
				<!--- Content Bar --->
				<div class="contentBar">
					<!--- Create Widget --->
					<div class="buttonBar">
						<button class="button2" onclick="openRemoteModal('#event.buildLink(prc.xehWidgetCreate)#');return false"
								title="Create a spanking new Widget">Create New Widget</button>
					</div>
	
					<!--- Filter Bar --->
					<div class="filterBar">
						<div>
							#html.label(field="widgetFilter",content="Quick Filter:",class="inline")#
							#html.textField(name="widgetFilter",size="30",class="textfield")#
						</div>
					</div>
				</div>
	
				<!--- widgets --->
				<!--- Vertical Nav --->
				<div class="body_vertical_nav clearfix widgets">
					<!--- Navigation Bar --->
					<ul class="vertical_nav" id="widget-sidebar">
                        <li class="active"><a href="##" class="current">All</a></li>
            			<cfloop query="prc.categories">
                        	<li><a href="##">#prc.categories.category#</a></li>
            			</cfloop>
                    </ul>
					<!--- ContentBars --->
                    <div class="widget-store full">
                    	<!--- Category Total Bar --->
                        <div id="widget-total-bar" class="widget-total-bar">Category: <strong>All</strong> (#prc.widgets.recordcount# Widgets)</div>
						<!--- Widgets --->
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
                				}
                				iconName = prc.widgets.icon;
                			</cfscript>					
            				<div class="widget-content full" name="#widgetName#" category="#category#">
                                <div class="widget-title">
                                    #p.getPluginName()#
                                    <span class="widget-type">#prc.widgets.widgettype#</span>
                                </div>
                                <img class="widget-icon" src="#prc.cbroot#/includes/images/widgets/#iconName#" width="80" />
                                <div class="widget-teaser">#p.getPluginDescription()#</div>
                                <div class="widget-arguments-holder" name="#widgetName#" category="#category#" style="display:none;">
                                    <div class="widget-teaser">#p.getPluginDescription()#</div>
                                </div>
                                <div class="widget-actions">
                                    Version #p.getPluginVersion()#
									By <a href="#p.getPluginAuthorURL()#" target="_blank" title="#p.getPluginAuthorURL()#">#p.getPluginAuthor()#</a>
                                    <span class="widget-type">
										<!---read docs--->
                                        <a title="Read Widget Documentation" href="javascript:openRemoteModal('#event.buildLink(prc.xehWidgetDocs)#',{widget:'#urlEncodedFormat(widgetName)#',type:'#urlEncodedFormat(prc.widgets.widgettype)#'})">
										    <i class="icon-book icon-large"></i> 
                                        </a>
                                        <cfif prc.oAuthor.checkPermission("WIDGET_ADMIN")>
											&nbsp;
											<!--- Editor --->
											<a title="Edit Widget" href="#event.buildLink(linkTo=prc.xehWidgetEditor,queryString='widget=#widgetName#&type=#prc.widgets.widgettype#')#">
											    <i class="icon-edit icon-large"></i> 
											</a>
                            				<!---only allow deletion of core widgets--->
											<cfif prc.widgets.widgettype eq "core">
												&nbsp;
												<!--- Delete Command --->
												<a title="Delete Widget" href="javascript:remove('#JSStringFormat(widgetName)#')" class="confirmIt" data-title="Delete #widgetName#?">
													<i class="icon-remove-sign icon-large"></i> 
                                                </a>
											</cfif>
                            			</cfif>
									</span>
                                </div>    
                            </div>
                		</cfloop>
                		<div class="widget-no-preview" style="display:none;">Sorry, no widgets matched your search!</div>
                    </div>
                </div>
				
				#html.endForm()#
				</div>
				<!--- end manage pane --->
				
				<!--- ForgeBox --->
				<div id="forgeboxPane">
					<div class="center">
						<i class="icon-spinner icon-spin icon-large icon-4x"></i> <br/>
						Please wait, connecting to ForgeBox...
					</div>
				</div>
			<!--- end panes --->
		</div>
		<!--- end body --->
	</div>
</div>
</cfoutput>