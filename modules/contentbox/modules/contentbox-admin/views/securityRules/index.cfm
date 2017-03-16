<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
        	<i class="fa fa-road fa-lg"></i>
			Security Rules
        </h1>
        <!--- messageBox --->
		#getModel( "messagebox@cbMessagebox" ).renderit()#
		<!---Import Log --->
		<cfif flash.exists( "importLog" )>
			<div class="consoleLog">#flash.get( "importLog" )#</div>
		</cfif>
    </div>
</div>
<div class="row">
	<div class="col-md-12">
		<div class="panel panel-primary">
		    <div class="panel-heading">
		        <h3 class="panel-title"><i class="fa fa-info-circle"></i> About Security Rules</h3>
		    </div>
		    <div class="panel-body">
		    	<!--- Usage --->
				<div class="alert alert-danger">
					<i class="fa fa-exclamation-triangle fa-lg"></i>
					Please remember that the security rules are fired in the order shown. You can drag and drop
					the rows to the desired order of firing. Be careful with security rules as with much power comes great responsibility!
				</div>
				
				<ul class="tipList">
					<li>Security rules are used to secure ContentBox according to incoming events or URLs, much like a firewall.</li>
					<li>The order of the rules is extremely important as they fire and traverse as you see them on screen.</li>
					<li>If a security rule has no permissions or roles it means that only authentication is needed.</li>
				</ul>
		    </div>
		</div>
	</div>
</div>	
<div class="row">
	<div class="col-md-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				<div class="row">
					<div class="col-md-7">
						<div class="form-group form-inline no-margin">
							#html.textField(
								name="ruleFilter",
								class="form-control",
								placeholder="Quick Filter"
							)#
						</div>
					</div>
					<div class="col-md-5">
						<div class="pull-right">
							<cfif prc.oAuthor.checkPermission( "SECURITYRULES_ADMIN,TOOLS_EXPORT,TOOLS_IMPORT" )>
								<div class="buttonBar">
									<!---Global --->
									<div class="btn-group btn-group-sm">
								    	<a class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" href="##">
											Bulk Actions <span class="caret"></span>
										</a>
								    	<ul class="dropdown-menu">
								    		<cfif prc.oAuthor.checkPermission( "SECURITYRULES_ADMIN" )>
											<li><a href="#event.buildLink(prc.xehApplyRules)#" class="confirmIt"
												data-title="Really Apply Rules?"
												data-message="Please be aware that you could be locked out of application if your rules are not correct.">
												<i class="fa fa-bolt fa-lg"></i> Apply Rules
												</a>
											</li>
											</cfif>
											<cfif prc.oAuthor.checkPermission( "SECURITYRULES_ADMIN,TOOLS_IMPORT" )>
											<li><a href="javascript:importContent()"><i class="fa fa-upload"></i> Import</a></li>
											</cfif>
											<cfif prc.oAuthor.checkPermission( "SYSTEM_RAW_SETTINGS,TOOLS_EXPORT" )>
												<li><a href="#event.buildLink (linkto=prc.xehExportAll )#.json" target="_blank"><i class="fa fa-download"></i> Export All as JSON</a></li>
												<li><a href="#event.buildLink( linkto=prc.xehExportAll )#.xml" target="_blank"><i class="fa fa-download"></i> Export All as XML</a></li>
											</cfif>
											<cfif prc.oAuthor.checkPermission( "SECURITYRULES_ADMIN" )>
											<li><a href="#event.buildLink(prc.xehResetRules)#" 
												data-title="<i class='fa fa-refresh'></i> Really Reset All Rules?" class="confirmIt"
												data-message="We will remove all rules and re-create them to ContentBox factory defaults.">
												<i class="fa fa-eraser"></i> Reset Rules
												</a>
											</li>
											</cfif>
								    	</ul>
								    </div>
									<a href="#event.buildLink(prc.xehEditorRule)#" class="btn btn-sm btn-danger">
										Create Rule
									</a>
								</div>
							</cfif>
						</div>
					</div>
				</div>
			</div>
		    <div class="panel-body">
		    	#html.startForm(name="ruleForm",action=prc.xehRemoveRule)#
					#html.hiddenField(name="ruleID" )#
					<div id="rulesTable">#renderView( "securityRules/rulesTable" )#</div>
				#html.endForm()#
		    </div>
		</div>
	</div>
</div>
<cfif prc.oAuthor.checkPermission( "SECURITYRULES_ADMIN,TOOLS_IMPORT" )>
	<cfscript>
		dialogArgs = {
			title = "Import Security Rules",
			contentArea = "security rules",
			action = prc.xehImportAll,
			contentInfo = "Choose the ContentBox <strong>JSON</strong> security rules file to import."
		};
	</cfscript>
	#renderView( view="_tags/dialog/import", args=dialogArgs )#
</cfif>
</cfoutput>