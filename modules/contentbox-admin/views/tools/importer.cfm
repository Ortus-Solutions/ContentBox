<cfoutput>
#html.startForm(name="importerForm",action=rc.xehImport,novalidate="novalidate")#		
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Saerch Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Actions
		</div>
		<div class="body">
			<!--- Submit Button --->
			<div class="actionBar" id="uploadBar">
				#html.submitButton(value="Start Import",class="buttonred",title="Start Import Process",onclick="return confirm('Really Start?')")#
			</div>
			
			<!--- Loader --->
			<div class="loaders" id="uploadBarLoader">
				Importing Blog
				<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/>
			</div>
			
		</div>
	</div>	
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column" id="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/database.png" alt="settings" />
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
		<legend><img src="#prc.cbRoot#/includes/images/database_black.png" alt="modifiers"/> <strong>Datasource Options</strong></legend>
			<p>
				This server must have a defined datasource to the source blog database in order to import it. Please
				make sure this datasource exists in the ColdFusion administrator.
			</p>
			#html.textField(name="dsn",label="Datasource Name:",class="textfield",size="50",required="required")#
			#html.textField(name="dsnUsername",label="Datasource Username: (Optional)",class="textfield",size="50")#
			#html.textField(name="dsnPassword",label="Datasource Password: (Optional)",class="textfield",size="50")#
		</fieldset>	
		
		<!--- importer --->
		<fieldset>
		<legend><img src="#prc.cbRoot#/includes/images/source.png" alt="modifiers"/> <strong>Source Content</strong></legend>
			#html.label(field="importer",content="Choose your importer source:")#
			#html.select(name="importer",options="Select Source,Mango,WordPress,BlogCFC",style="width:200px")#
			
			<!--- Default Password --->
			#html.label(field="tableprefix",content="Table Prefix:")#
			<small>The table prefix used by the source software.</small><br/>
			#html.textField(name="tableprefix",class="textfield",size="30")#
			
			<!--- Default Password --->
			#html.label(field="defaultPassword",content="Default Author Password:")#
			<small>Since ContentBox uses its own encryption algorithm, you cannot port passwords. Use the following
			default password for all authors and then do password change requests.</small><br/>
			#html.textField(name="defaultPassword",class="textfield",size="30",required="required")#
			
			<!--- Roles --->
			#html.select(label="Default Author Role:",name="roleID",options=prc.roles,column="roleID",nameColumn="role")#
		</fieldset>	
			
		</div>
	</div>
</div>		
#html.endForm()#
</cfoutput>