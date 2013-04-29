<cfoutput>
#html.startForm(name="importerForm", action=rc.xehImport, novalidate="novalidate")#		
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-exchange icon-large"></i>
				Import Databases Into ContentBox
			</div>
			<!--- Body --->
			<div class="body">	
			
			<!--- messageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<p>
				From this import tool you can connect to other content datasources and import your data into ContentBox. 
				All importing messages are being logged, so please verify your application logs for information.
			</p>
			
			<!--- dsn Info --->
			<fieldset>
			<legend><i class="icon-bolt icon-large"></i> <strong>Datasource Options</strong></legend>
				<p>
					This server must have a defined datasource to the source blog database in order to import it. Please
					make sure this datasource exists in the ColdFusion administrator.
				</p>
				#html.textField(name="dsn",label="Datasource Name:",class="textfield",size="50",required="required",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
				#html.textField(name="dsnUsername",label="Datasource Username: (Optional)",class="textfield",size="50",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
				#html.textField(name="dsnPassword",label="Datasource Password: (Optional)",class="textfield",size="50",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
			</fieldset>	
			
			<!--- importer --->
			<fieldset>
			<legend><i class="icon-cog icon-large"></i> <strong>Source Content</strong></legend>
				#html.select(name="importer",options="Select Source,Mango,WordPress,BlogCFC,MachBlog",label="Choose your importer source:",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
				
				<!--- Default Password --->
				<div class="control-group">
					#html.label(field="tableprefix",content="Table Prefix:",class="control-label")#
				   	<div class="controls">
				       	<small>The table prefix used by the source software.</small><br/>
						#html.textField(name="tableprefix",size="50")#
                   	</div>
				</div>
                <!--- Default Password --->
				<div class="control-group">
				    #html.label(field="defaultPassword",content="Default Author Password:",class="control-label")#
				   	<div class="controls">
				    	<small>Since ContentBox uses its own encryption algorithm, you cannot port passwords. Use the following
						default password for all authors and then do password change requests.</small><br/>
						#html.textField(name="defaultPassword",size="50",required="required")#   
                   	</div>
				</div>
				<!--- Roles --->
				#html.select(label="Default Author Role:",name="roleID",options=prc.roles,column="roleID",nameColumn="role",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
			</fieldset>	
			</div>
		</div>
	</div>

	<!--- main sidebar --->
	<div class="span3" id="main-sidebar">
		<!--- Saerch Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-cogs"></i> Actions
			</div>
			<div class="body">
				<!--- Submit Button --->
				<div class="actionBar" id="uploadBar">
					#html.button(type="submit", value="<i class='icon-ok'></i> Start Import", class="btn btn-danger btn-large", onclick="return confirm('Really Start?')")#
				</div>
				
				<!--- Loader --->
				<div class="loaders" id="uploadBarLoader">
					<i class="icon-spinner icon-spin icon-large icon-2x"></i><br/>
					Importing Action
				</div>
				
			</div>
		</div>	
	</div>
</div>
#html.endForm()#
</cfoutput>