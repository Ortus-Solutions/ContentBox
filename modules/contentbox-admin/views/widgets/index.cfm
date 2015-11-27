<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1"><i class="fa fa-magic fa-lg"></i> Widgets</h1>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
       	<!--- MessageBox --->
		#getModel( "messagebox@cbMessagebox" ).renderit()#
		
		<!--- Logs --->
		<cfif flash.exists( "forgeboxInstallLog" )>
			<h3>Installation Log</h3>
			<div class="consoleLog">#flash.get( "forgeboxInstallLog" )#</div>
		</cfif>
    </div>
</div>
<div class="row">
	<div class="col-md-9">
		<div class="panel panel-default">
		    <div class="panel-body">
		        <!-- Vertical Nav -->
		        <div class="tab-wrapper tab-primary">
		            <!-- Tabs -->
		            <ul class="nav nav-tabs">
		            	<li title="Manage Widgets" class="active">
		            		<a href="##managePane" data-toggle="tab"><i class="fa fa-cog fa-lg"></i>  Manage</a>
		            	</li>
						<!--- Install --->
						<cfif prc.oAuthor.checkPermission( "FORGEBOX_ADMIN" )>
							<li title="Install New Widgets">
								<a href="##forgeboxPane" data-toggle="tab" onclick="loadForgeBox()"><i class="fa fa-cloud-download fa-lg"></i> ForgeBox</a>
							</li>
						</cfif>
		            </ul>
		            <!-- End Tabs -->
		            <!-- Tab Content -->
		            <div class="tab-content">
		                <div id="managePane" class="tab-pane active">
							<!--- CategoryForm --->
							#html.startForm(name="widgetForm",action=prc.xehWidgetRemove)#
								#html.hiddenField(name="widgetFile" )#
				
								<!--- widgets --->
								#renderView(view="widgets/widgetList", module="contentbox-admin", args={ mode="edit", cols=2 } )#

							#html.endForm()#
						</div>
						<!--- end manage pane --->
						<!--- ForgeBox --->
						<div id="forgeboxPane" class="tab-pane">
							<div class="text-center">
								<i class="fa fa-spinner fa-spin fa-lg icon-4x"></i> <br/>
								Please wait, connecting to ForgeBox...
							</div>
						</div>
		            </div>
		            <!-- End Tab Content -->
		        </div>
		        <!-- End Vertical Nav -->
		    </div>
		</div>
	</div>
	<div class="col-md-3">
		<cfif prc.oAuthor.checkPermission( "WIDGET_ADMIN" )>
			<div class="panel panel-primary">
			    <div class="panel-heading">
			        <h3 class="panel-title"><i class="fa fa-upload"></i> Widget Uploader</h3>
			    </div>
			    <div class="panel-body">
			    	#html.startForm(
			    		name="widgetUploadForm",
			    		action=prc.xehWidgetupload,
			    		multipart=true,
			    		novalidate="novalidate"
			    	)#
					
						#getModel( "BootstrapFileUpload@contentbox-admin" ).renderIt( 
			                name="fileWidget",
			                label="Upload Widget:",
			                columnWidth=2,
			                useRemoveButton=false,
			                required=true
			            )#				
	
						<div class="actionBar" id="uploadBar">
							#html.submitButton(value="Upload & Install", class="btn btn-danger" )#
						</div>
		
						<!--- Loader --->
						<div class="loaders" id="uploadBarLoader">
							<i class="fa fa-spinner fa-spin fa-lg fa-2x"></i> <br>
							Uploading & Installing
						</div>
					#html.endForm()#
			    </div>
			</div>
		</cfif>
		<div class="panel panel-primary">
		    <div class="panel-heading">
		        <h3 class="panel-title"><i class="fa fa-question-circle"></i> Widget Help</h3>
		    </div>
		    <div class="panel-body">
		    	<p>Render widgets in your layouts and views by using the CB Helper method <code>widget()</code>:</p>
				<div class="bg-helper bg-success">
					##cb.widget( "name",{arg1=val,arg2=val} )##
				</div>
				<p>Render module widgets by appending the module name <code>@module</code>:</p>
				<div class="bg-helper bg-success">
					##cb.widget( "name@module",{arg1=val,arg2=val} )##
				</div>
				<p>Get an instance of a widget in your layouts and views using the CB helper method <code>getWidget()</code></p>
				<div class="bg-helper bg-success">
					 ##cb.getWidget( "name" )##
					 ##cb.getWidget( "name@module" )##
				</div>
		    </div>
		</div>
	</div>
</div>
</cfoutput>