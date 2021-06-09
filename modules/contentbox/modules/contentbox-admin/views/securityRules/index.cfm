<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
        	<i class="fas fa-passport fa-lg"></i>
			Security Rules
			<span id="rulesCountContainer"></span>
		</h1>

    </div>
</div>

<div class="row">
	<div class="col-md-12">

		<!--- messageBox --->
		#cbMessageBox().renderit()#

		<!---Import Log --->
		<cfif flash.exists( "importLog" )>
			<div class="consoleLog">#flash.get( "importLog" )#</div>
		</cfif>

		<div class="panel panel-info">

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
		#html.startForm( name="ruleForm", action=prc.xehRemoveRule )#

		<div class="panel panel-default">
			<div class="panel-heading">
				<div class="row">

					<!--- Quick Search --->
					<div class="col-md-6 col-xs-4">
						<div class="form-group form-inline no-margin">
							#html.textField(
								name        = "ruleFilter",
								class       = "form-control rounded quicksearch",
								placeholder = "Quick Filter"
							)#
						</div>
					</div>

					<div class="col-md-6 col-xs-8">
						<cfif prc.oCurrentAuthor.checkPermission( "SECURITYRULES_ADMIN,TOOLS_EXPORT,TOOLS_IMPORT" )>
							<div class="text-right">
								<!---Global --->
								<div class="btn-group">
									<button class="btn dropdown-toggle btn-info" data-toggle="dropdown">
										Bulk Actions <span class="caret"></span>
									</button>
									<ul class="dropdown-menu">
										<cfif prc.oCurrentAuthor.checkPermission( "SECURITYRULES_ADMIN" )>
										<li>
											<a
												href="#event.buildLink( prc.xehApplyRules )#"
												class="confirmIt"
												data-title="Really Apply Rules?"
												data-message="Please be aware that you could be locked out of application if your rules are not correct."
											>
												<i class="fas fa-bolt fa-lg"></i> Apply Rules
											</a>
										</li>
										</cfif>
										<cfif prc.oCurrentAuthor.checkPermission( "SECURITYRULES_ADMIN,TOOLS_IMPORT" )>
											<li>
												<a href="javascript:importContent()">
													<i class="fas fa-file-import fa-lg"></i> Import
												</a>
											</li>
										</cfif>
										<cfif prc.oCurrentAuthor.checkPermission( "SYSTEM_RAW_SETTINGS,TOOLS_EXPORT" )>
											<li>
												<a
													href="#event.buildLink ( prc.xehExportAll )#.json"
													target="_blank"
												>
													<i class="fas fa-file-export fa-lg"></i> Export All
												</a>
											</li>
											<li>
												<a href="javascript:exportSelected( '#event.buildLink( prc.xehExportAll )#' )">
													<i class="fas fa-file-export fa-lg"></i> Export Selected
												</a>
											</li>
										</cfif>
										<cfif prc.oCurrentAuthor.checkPermission( "SECURITYRULES_ADMIN" )>
										<li>
											<a
												href="#event.buildLink( prc.xehResetRules )#"
												data-title="<i class='fas fa-recycle'></i> Really Reset All Rules?"
												class="confirmIt"
												data-message="We will remove all rules and re-create them to ContentBox factory defaults."
											>
												<i class="fas fa-eraser"></i> Reset Rules
											</a>
										</li>
										</cfif>
									</ul>
								</div>
								<button
									class="btn btn-primary"
									onclick="return to('#event.buildLink( prc.xehEditorRule )#')"
								>
									Create Rule
								</button>
							</div>
						</cfif>
					</div>

				</div>
			</div>

		    <div class="panel-body">
				#html.hiddenField( name="ruleID" )#
				<div id="rulesTable">
					#renderView( view = "securityRules/rulesTable", prePostExempt = true )#
				</div>
			</div>
		</div>

		#html.endForm()#
	</div>
</div>

<cfif prc.oCurrentAuthor.checkPermission( "SECURITYRULES_ADMIN,TOOLS_IMPORT" )>
	#renderView(
		view 			= "_tags/dialog/import",
		args 			= {
			title       : "Import Security Rules",
			contentArea : "security rules",
			action      : prc.xehImportAll,
			contentInfo : "Choose the ContentBox <strong>JSON</strong> security rules file to import."
		},
		prePostExempt 	= true
	)#
</cfif>
</cfoutput>