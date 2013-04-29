<cfoutput>
#html.startForm(name="templateEditForm",action=prc.xehTemplateSave,novalidate="novalidate")#
#html.hiddenField(name="template",value=rc.encodedTemplate)#
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-envelope icon-large"></i>
				Email Template Editor -> #rc.template#
			</div>
			<!--- Body --->
			<div class="body">
				
				<!--- MessageBox --->
				#getPlugin("MessageBox").renderit()#
				
				<p>
					You can modify the Template code from this editor.  Please be very careful as you are modifying the code directly.  Please make a backup
					if necessary.
				</p>
				
				<!--- Editor --->
				#html.textarea(name="templateCode",value=prc.templateCode,rows=30)#
			
			</div>	
		</div>
	</div>

	<!--- main sidebar --->
	<div class="span3" id="main-sidebar">
		<!--- Info Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-cogs"></i> Actions
			</div>
			<div class="body">
				
				<div class="actionBar">
					<div class="btn-group">
					#html.href(href=prc.xehEmailTemplates,text=html.button(name="cancelButton",value="Cancel",class="btn"))#
					#html.button(value="Save",class="btn btn-danger",title="Save and keep on working",onclick="return saveTemplateCode()")#
					#html.button(value="Save & Close", type="submit", class="btn btn-danger",title="Save template and return to listing")#
					</div>
				</div>
				
				<!--- Loader --->
				<div class="loaders" id="uploadBarLoader">
					<i class="icon-spinner icon-spin icon-large icon-2x"></i>
					<div id="uploadBarLoaderStatus" class="center textRed">Saving...</div>
				</div>
			</div>
		</div>		
		<!--- Info Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-info-sign"></i>
				Info
			</div>
			<div class="body">
				<ul class="tipList">
					<li>Do not remove the <strong>cfoutput</strong> tags or no template will render.</li>
					<li>All templates have access to the <strong>CBHelper</strong> via the <strong>cb</strong> object.</li>
					<li>All templates have access to all ColdBox scopes and functions.</li>
				</ul>
				
				<div class="actionBar">
					<a href="javascript:openRemoteModal('#event.buildLink(prc.xehAPIDocs&"/index/apislug/plugins/print/?_cfcviewer_cfc=CBHelper")#')" 
					   class="btn" title="Get some quick CBHelper API Goodness!">
						CBHelper Docs
					</a>
					<a href="#event.buildLink(prc.xehApiDocs)#" target="_blank" class="btn" title="Open the ContentBox API Docs in another window">
						API Docs
					</a>
				</div>
			</div>
		</div>
	</div>
</div>
#html.endForm()#
</cfoutput>