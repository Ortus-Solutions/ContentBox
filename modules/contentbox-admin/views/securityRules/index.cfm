<cfoutput>
<div class="row-fluid" id="main-content">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<i class="icon-road icon-large"></i>
			Security Rules
		</div>
		<!--- Body --->
		<div class="body">	
		
		<!--- messageBox --->
		#getPlugin("MessageBox").renderit()#
		
		<!---Import Log --->
		<cfif flash.exists( "importLog" )>
		<div class="consoleLog">#flash.get( "importLog" )#</div>
		</cfif>
		
		<!--- Usage --->
		<div class="alert alert-error">
			<i class="icon-warning-sign icon-large"></i>
			Please remember that the security rules are fired in the order shown. You can drag and drop
			the rows to the desired order of firing. Be careful with security rules as with much power comes great responsibility!
		</div>
		
		<ul class="tipList">
			<li>Security rules are used to secure ContentBox according to incoming events or URLs, much like a firewall.</li>
			<li>The order of the rules is extremely important as they fire and traverse as you see them on screen.</li>
			<li>If a security rule has no permissions or roles it means that only authentication is needed.</li>
		</ul>
		
		<!--- entryForm --->
		#html.startForm(name="ruleForm",action=prc.xehRemoveRule)#
			#html.hiddenField(name="ruleID")#
		
			<!--- Content Bar --->
			<div class="well well-small" id="contentBar">
				<!--- Create Butons --->
				<cfif prc.oAuthor.checkPermission("SECURITYRULES_ADMIN,TOOLS_EXPORT,TOOLS_IMPORT")>
				<div class="buttonBar">
					<!---Global --->
					<div class="btn-group">
				    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
							Global Actions <span class="caret"></span>
						</a>
				    	<ul class="dropdown-menu">
				    		<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN")>
							<li><a href="#event.buildLink(prc.xehApplyRules)#" class="confirmIt"
								data-title="Really Apply Rules?"
								data-message="Please be aware that you could be locked out of application if your rules are not correct.">
								<i class="icon-bolt icon-large"></i> Apply Rules
								</a>
							</li>
							</cfif>
							<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN,TOOLS_IMPORT")>
							<li><a href="javascript:importContent()"><i class="icon-upload-alt"></i> Import</a></li>
							</cfif>
							<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN,TOOLS_EXPORT")>
				    		<li class="dropdown-submenu">
								<a href="##"><i class="icon-download icon-large"></i> Export All</a>
								<ul class="dropdown-menu text-left">
									<li><a href="#event.buildLink(linkto=prc.xehExportAll)#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
									<li><a href="#event.buildLink(linkto=prc.xehExportAll)#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
								</ul>
							</li>
							</cfif>
							<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN")>
							<li><a href="#event.buildLink(prc.xehResetRules)#" 
								data-title="Really Reset All Rules?" class="confirmIt"
								data-message="We will remove all rules and re-create them to ContentBox factory defaults.">
								<i class="icon-eraser"></i> Reset Rules
								</a>
							</li>
							</cfif>
				    	</ul>
				    </div>
					<a href="#event.buildLink(prc.xehEditorRule)#" class="btn btn-danger">
						Create Rule
					</a>
				</div>
				</cfif>
				<!--- Filter Bar --->
				<div class="filterBar">
					<div>
						#html.label(field="ruleFilter",content="Quick Filter:",class="inline")#
						#html.textField(name="ruleFilter",size="30",class="textfield")#
					</div>
				</div>
			</div>
			
			<div id="rulesTable">#renderView("securityRules/rulesTable")#</div>
			
		#html.endForm()#
		
		</div>
	</div>
</div>		
<cfif prc.oAuthor.checkPermission("SECURITYRULES_ADMIN,TOOLS_IMPORT")>
<!---Import Dialog --->
<div id="importDialog" class="modal hide fade">
	<div id="modalContent">
	    <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h3><i class="icon-copy"></i> Import Security Rules</h3>
	    </div>
        #html.startForm(name="importForm", action=prc.xehImportAll, class="form-vertical", multipart=true)#
        <div class="modal-body">
			<p>Choose the ContentBox <strong>JSON</strong> security rules file to import.</p>
			
			#getMyPlugin( plugin="BootstrapFileUpload", module="contentbox" ).renderIt( 
				name="importFile",
				required=true
			)#
			
			<label for="overrideContent">Override Security Rules?</label>
			<small>By default all content that exist is not overwritten.</small><br>
			#html.select(options="true,false", name="overrideContent", selectedValue="false", class="input-block-level",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
			
			<!---Notice --->
			<div class="alert alert-info">
				<i class="icon-info-sign icon-large"></i> Please note that import is an expensive process, so please be patient when importing.
			</div>
		</div>
        <div class="modal-footer">
            <!--- Button Bar --->
        	<div id="importButtonBar">
          		<button class="btn" id="closeButton"> Cancel </button>
          		<button class="btn btn-danger" id="importButton"> Import </button>
            </div>
			<!--- Loader --->
			<div class="center loaders" id="importBarLoader">
				<i class="icon-spinner icon-spin icon-large icon-2x"></i>
				<br>Please wait, doing some hardcore importing action...
			</div>
        </div>
		#html.endForm()#
	</div>
</div>
</cfif>
</cfoutput>