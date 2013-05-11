<cfoutput>
<div class="box">
	<div class="header">
		<i class="icon-lightbulb icon-large"></i> Datasource Wizard
	</div>
	<div class="body clearfix">
		<div>
			<!--- Errors --->
			<cfif len( errors )>
				<div class="cbox_messagebox_error">
					<p class="cbox_messagebox">
						<strong>Oops! Something went wrong!</strong><br/>
						#errors#
					</p>
				</div>
			</cfif>
			
			<div class="hero-unit">
				<h1>Welcome To ContentBox!</h1>
				<p>
					You are one step closer to releasing your content out of its box! The first step in our installer is to make sure
					we can connect to your database of choice.  So if you have not created an empty database for ContenBox yet, please go do
					that now.  The next step is for ContentBox to create or use a datasource connection to the database from our CFML engine.
				</p>
			</div>
			
			<fieldset>
				<legend>Datasource Created?</legend>
				<p>Do you have a datasource created already?</p>
				<label class="inline">
					<input type="radio" name="dsnCreated" id="dsnCreated" value="true" onclick="showDSNPanel(true)" /> Yes
				</label>
				<label class="inline">
					<input type="radio" name="dsnCreated" id="dsnCreated" value="false" onclick="showDSNPanel(false)"/> No
				</label>
			</fieldset>
			
			<!--- DSN Exists Panel --->
			<fieldset id="dsnPanelExists" style="display: none">
				<legend>Created Datasource Information:</legend>
				<form name="dsnUseForm" id="dsnUseForm" action="index.cfm" method="post" novalidate="novalidate">
					<input type="hidden" name="action" id="action" value="process" />
					<input type="hidden" name="dsnCreated" value="true" />
					<p>Please fill in the name of the datasource connection setup in your CFML engine.</p>
					<label>Datasource Name: 
						<input type="text" name="dsnName" id="dsnName" class="textfield" size="40"/>
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
					<p>Please fill in all the required information so we can create the datasource connection for you.</p>
					
					<label for="cfpassword">CFML Administrator Password: </label>
					<small>Your CFML engine administrator password. Contact your hosting provider or system administrator if you do not have one.<br/></small>
					<input type="password" class="textfield" size="40" name="cfpassword" id="cfpassword" required="required" />
					
					<label for="dsnCreateName">Datasource Name:</label>
					<small>The name of the datasource connection we will create for you.<br/></small>
					<input type="text" class="textfield" size="40" name="dsnCreateName" id="dsnCreateName" required="required" />
					
					<label for="dbType">Database Type:</label>
					<small>Below are the current supported database types:<br/></small>
					<select name="dbType" id="dbType" class="textfield">
						<!---<option value="derby">Apache Derby</option>--->
						<option value="mssql">Microsft SQL Server</option>
						<option value="mysql">MySQL</option>
						<!---<option value="oracle">Oracle</option>--->
						<option value="postgresql">PostgreSQL</option>
					</select>
					
					<label for="dbServer">Database Server:</label>
					<small>Your database host address (localhost, 127.0.0.1 or ip address)<br/></small>
					<input type="text" class="textfield" size="40" name="dbServer" id="dbServer" required="required" />
					
					<label for="dbName">Database Name:</label>
					<small>The name of the database that will be used for ContentBox.<br/></small>
					<input type="text" class="textfield" size="40" name="dbName" id="dbName" required="required" />
					
					<label for="dbUsername">Database Username:</label>
					<small>The name of the database user that will use the connection.<br/></small>
					<input type="text" class="textfield" size="40" name="dbUsername" id="dbUsername" />
					
					<label for="dbUsername">Database Password:</label>
					<small>The password of the database user that will use the connection.<br/></small>
					<input type="password" class="textfield" size="40" name="dbPassword" id="dbPassword" />
					
					<div class="actionBar">	
						<input name="verifyDataButton" id="verifyDataButton" type="button" class="btn btn-primary" value="Verify Data" onclick="verifyData()" />
						<input name="createDSNButton" id="createDSNButton" type="submit" class="btn btn-danger" value="Create Datasource" style="display: none" />
						<div id="actionBarLoader" style="display:none"><i class="icon-spinner icon-spin icon-large icon-2x"></i> Creating, Please Wait...</div>
					</div>
				</form>
			</fieldset>
		</div>
	</div>
</div>
<cfinclude template="indexHelper.cfm">
</cfoutput>