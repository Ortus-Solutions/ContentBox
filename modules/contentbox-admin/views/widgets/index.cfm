<cfoutput>
<div class="row-fluid">    
	<!--- main content --->    
	<div class="span9" id="main-content">    
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<ul class="sub_nav nav nav-tabs">
					<!--- Manage --->
					<li title="Manage Widgets" class="active"><a href="##managePane" data-toggle="tab"><i class="icon-cog icon-large"></i>  Manage</a></li>
					<!--- Install --->
					<cfif prc.oAuthor.checkPermission("FORGEBOX_ADMIN")>
					<li title="Install New Widgets"><a href="##forgeboxPane" data-toggle="tab" onclick="loadForgeBox()"><i class="icon-cloud-download icon-large"></i> ForgeBox</a></li>
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
				
				<div class="panes tab-content">
					<div id="managePane" class="tab-pane active">
					<!--- CategoryForm --->
					#html.startForm(name="widgetForm",action=prc.xehWidgetRemove)#
					#html.hiddenField(name="widgetFile")#
		
					<!--- widgets --->
					#renderView(view="widgets/widgetList", module="contentbox-admin", args={ mode="edit", cols=2 } )#

					#html.endForm()#
					</div>
					<!--- end manage pane --->
					
					<!--- ForgeBox --->
					<div id="forgeboxPane" class="tab-pane">
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
	</div>    

	<!--- main sidebar --->    
	<div class="span3" id="main-sidebar">    
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
						#html.submitButton(value="Upload & Install", class="btn btn-danger")#
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
				<p>Render widgets in your layouts and views by using the CB Helper method <code>widget()</code>:</p>
				<div class="alert alert-success">
					##cb.widget("name",{arg1=val,arg2=val})##
				</div>
				<p>Render module widgets by appending the module name <code>@module</code>:</p>
				<div class="alert alert-success">
					##cb.widget("name@module",{arg1=val,arg2=val})##
				</div>
				<p>Get an instance of a widget in your layouts and views using the CB helper method <code>getWidget()</code></p>
				<div class="alert alert-success">
					 ##cb.getWidget("name")##
					 ##cb.getWidget("name@module")##
				</div>
			</div>
		</div>
	</div>    
</div>
</cfoutput>