<cfoutput>
<div class="panel panel-primary">
    <div class="panel-heading">
        <h3 class="panel-title"><i class="fa fa-lightbulb-o"></i> Datasource Wizard</h3>
    </div>
    <div class="panel-body">
    	<!--- Errors --->
		<cfif len( errors )>
			<div class="cbox_messagebox_error">
				<p class="cbox_messagebox">
					<strong>Oops! Something went wrong!</strong><br/>
					#errors#
				</p>
			</div>
		</cfif>
        <div class="jumbotron text-center">
			<h1>
				<i class="fa fa-database fa-2x"></i><br>
				Welcome To ContentBox!
			</h1>
			<p>
				You are one step closer to releasing your content out of its box! The first step in our installer is to make sure
				we can connect to your database of choice.  So if you have not created an empty database for ContentBox yet, please go do
				that now.  The next step is for ContentBox to create or use a datasource connection to the database from our CFML engine.
			</p>
		</div>
		<div class="form-vertical">
			<fieldset>
				<legend>Datasource Created?</legend>
				<p>Do you have a datasource created already?</p>
				
				<div class="form-group">
					<div class="controls">
						<label class="inline control-label">
							<input type="radio" name="dsnCreated" id="dsnCreated" value="true" onclick="showDSNPanel(true)" /> Yes
						</label> 
						<label class="inline control-label">
							<input type="radio" name="dsnCreated" id="dsnCreated" value="false" onclick="showDSNPanel(false)"/> No
						</label>
					</div>
				</div>
			</fieldset>
			
			<!--- DSN Exists Panel --->
			<fieldset id="dsnPanelExists" style="display: none">
				<legend>Created Datasource Information:</legend>
				<form name="dsnUseForm" id="dsnUseForm" action="index.cfm" method="post" novalidate="novalidate">
					
					<input type="hidden" name="action" id="action" value="process" />
					<input type="hidden" name="dsnCreated" value="true" />
					
					<div class="alert alert-info">
					<p>Please fill in the name of the datasource connection setup in your CFML engine.</p>
					</div>
					
					<label class="control-label">Datasource Name: 
						<input type="text" name="dsnName" id="dsnName" class="form-control" size="40"/>
					</label>
					
					<div class="actionBar">
						<input name="verifyButton" id="verifyButton" type="button" class="btn btn-primary" value="Verify Datasource" onclick="verifyDSN()" />
						<input name="createButton" id="createButton" type="submit" class="btn btn-danger" value="Continue Installation" style="display: none" />
					</div>
				</form>
			</fieldset>
			
			<!--- DSN Creation Panel --->
			<fieldset id="dsnPanelCreate" style="display: none">
				<legend>Datasource Creation Information:</legend>
				<form name="dsnForm" id="dsnForm" action="index.cfm" method="post" novalidate="novalidate">
					
					<input type="hidden" name="action" id="action" value="process" />
					<input type="hidden" name="dsnCreated" value="false" />
					
					<div class="alert alert-info">
					<p>Please fill in all the required information so we can create the datasource connection for you.</p>
					</div>
					
					<div class="form-group">
						<div class="controls">
							<label class="control-label" for="cfpassword">CFML Admin Password or Web Context Password: </label>
							<br /><small>Your CFML engine administrator password or the Lucee Web Context password. Contact your hosting provider or system administrator if you do not have one. (If you are using the Express Edition ONLY then use <code>contentbox</code> or 
							<cfif structKeyExists( server, "lucee" )>
								<a href="/lucee/admin/web.cfm" target="_blank">click here</a>
							<cfelse>
								<a href="/CFIDE/administrator" target="_blank">click here</a>
							</cfif>
							 to set one up)<br/></small>
							<input type="password" class="form-control" size="40" name="cfpassword" id="cfpassword" required="required" />
						</div>
					</div>
					
					<div class="form-group">
						<div class="controls">
							<label class="control-label" for="dsnCreateName">Datasource Name:</label>
							<br /><small>The name of the datasource connection we will create for you.<br/></small>
							<input type="text" class="form-control" size="40" name="dsnCreateName" id="dsnCreateName" required="required" />
						</div>
					</div>
					
					<div class="form-group">
						<div class="controls">
							<label class="control-label" for="dbType">Database Type:</label>
							<br /><small>Below are the current supported database types:<br/></small>
							<select name="dbType" id="dbType" class="form-control input-sm">
								<!---<option value="derby">Apache Derby</option>--->
								<option value="mssql">Microsft SQL Server</option>
								<option value="mysql">MySQL</option>
								<cfif listFindNoCase( "railo,lucee", server.coldfusion.productname )>
								<option value="HSQLDB">HSQLDB (Hypersonic Embedded SQL DB)</option>
								</cfif>
								<option value="oracle">Oracle</option>
								<option value="postgresql">PostgreSQL</option>
							</select>
						</div>
					</div>
					
					<div class="form-group">
						<div class="controls">
							<label class="control-label" for="dbServer">Database Server:</label>
							<br /><small>Your database host address (localhost, 127.0.0.1 or ip address, leave empty for embedded database)<br/></small>
							<input type="text" class="form-control" size="40" name="dbServer" id="dbServer" required="required" />
						</div>
					</div>
					
					<div class="form-group">
						<div class="controls">
							<label class="control-label" for="dbName">Database Name:</label>
							<br /><small>The name of the database that will be used for ContentBox. If using the embedded database, this will be used for the location as well within the application.<br/></small>
							<input type="text" class="form-control" size="40" name="dbName" id="dbName" required="required" />
						</div>
					</div>
					
					<div class="form-group">
						<div class="controls">
							<label class="control-label" for="dbUsername">Database Username:</label>
							<br /><small>The name of the database user that will use the connection. (Use <code>sa</code> for embedded database)<br/></small>
							<input type="text" class="form-control" size="40" name="dbUsername" id="dbUsername" />
						</div>
					</div>
					
					<div class="form-group">
						<div class="controls">
							<label class="control-label" for="dbUsername">Database Password:</label>
							<br /><small>The password of the database user that will use the connection.  (Use empty for embedded database)<br/></small>
							<input type="password" class="form-control" size="40" name="dbPassword" id="dbPassword" />
						</div>
					</div>

					<div class="actionBar">	
						<input name="verifyDataButton" id="verifyDataButton" type="button" class="btn btn-primary" value="Verify Data" onclick="verifyData()" />
						<input name="createDSNButton" id="createDSNButton" type="submit" class="btn btn-danger" value="Create Datasource" style="display: none" />
						<div id="actionBarLoader" style="display:none"><i class="icon-spinner icon-spin fa-lg fa-2x"></i> Creating, Please Wait...</div>
					</div>

				</form>
			</fieldset>
		</div>
    </div>
</div>
<cfinclude template="indexHelper.cfm">
</cfoutput>
