﻿<cfoutput>
#html.startForm(name="importerForm", action=rc.xehDataImport, novalidate="novalidate",multipart=true)#		
<div class="row-fluid">
	<!--- main content --->
	<div class="span12" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-exchange icon-large"></i>
				Import Tools
			</div>
			<!--- Body --->
			<div class="body">
				<!--- MessageBox --->
				#getPlugin("MessageBox").renderit()#
				<div class="hero-unit">
                    <p>Import content into your ContentBox site with only a few clicks!</p>
                    <div class="control-group">
                        <div class="controls row-fluid">
                            <div class="span6 well well-small text-center alert-success">
                                <h2>ContentBox Package (.cbox)</h2>
                                <small>If you're importing content from another ContentBox site, this option is for you.</small><br /><br />
                                <label class="btn btn-success btn-toggle radio" for="import-contentbox">
                                    #html.radioButton(name="importtype",id="import-contentbox",checked=true,value="contentbox")# Import ContentBox Package
                                </label>
                            </div>
                            <div class="span6 well well-small text-center">
                                <h2>Database Import</h2>
                                <small>ContentBox also supports imports from Mango, WordPress, BlogCFC, and MachBlog databases via Datasource connections!</small><br />
                                <label class="btn btn-toggle radio clearfix" for="import-database">
                                    #html.radioButton(name="importtype",id="import-database",value="database")# 
                                    Import from Database
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="contentbox-import" class="well">
                	<p>
						With this tool, you can import an existing ContentBox site (created by using the Export Tools). Yes, that's right: an entire ContentBox site! 
						<br /><br />Simply upload a valid ContentBox export package file (<strong>.cbox</strong>). You'll be shown a handy preview of the import that will occur, and will also have the opportunity to specify whether or not you'd like to overwrite existing content. 
						<br /><br />Easy, right? Well, what are you waiting for?
					</p>
	                <fieldset>
	                	<legend><i class="icon-upload icon-large"></i> Import ContentBox Package</legend>
	                    <div class="row-fluid">
	    					<div class="control-group">
	    						<div class="controls">
	    							#html.label(field="CBUpload",content="Select ContentBox Package",class="control-label")#
			    					<div class="fileupload fileupload-new" data-provides="fileupload">
										<div class="input-append textfield">
											<div class="uneditable-input span3">
												<i class="icon-file fileupload-exists"></i> <span class="fileupload-preview"></span>
											</div>
											<span class="btn btn-file">
												<span class="fileupload-new">Select file</span>
												<span class="fileupload-exists">Change</span>
												<input type="file" name="CBUpload" />
												#html.hiddenField(name="validated",value="false")#
		    									#html.hiddenField(name="overwrite",id="overwrite",value="false")#
											</span>
											<a href="##" class="btn fileupload-exists" data-dismiss="fileupload">Remove</a>
										</div>
									</div>
								</div>
							</div>
	                    </div>
	                </fieldset>
            	</div>
                <div id="database-import" class="well" style="display:none;">
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
						#html.textField(name="dsn",label="Datasource Name:",class="textfield",size="50",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
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
								#html.textField(name="defaultPassword",size="50")#   
		                   	</div>
						</div>
						<!--- Roles --->
						#html.select(label="Default Author Role:",name="roleID",options=prc.roles,column="roleID",nameColumn="role",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
					</fieldset>	

                </div>

                <!--- Submit Button --->
				<div class="actionBar" id="uploadBar">
					#html.button(type="submit", id="import_button", value="<i class='icon-ok'></i> Start Import", class="btn btn-danger btn-large")#
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
<!---Import Dialog --->
<div id="importDialog" class="modal hide fade">
	<div id="modalContent"></div>
</div>
</cfoutput>