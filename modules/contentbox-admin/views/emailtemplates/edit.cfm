<cfoutput>
#html.startForm(name="templateEditForm",action=prc.xehTemplateSave,novalidate="novalidate")#
#html.hiddenField(name="template",value=rc.encodedTemplate)#
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/settings.png" alt="info" width="24" height="24" />Actions
		</div>
		<div class="body">
			
			<div class="actionBar">
				#html.href(href=prc.xehEmailTemplates,text=html.button(name="cancelButton",value="Cancel",class="button"))# &nbsp;
				#html.button(value="Save",class="buttonred",title="Save and keep on working",onclick="return saveTemplateCode()")#
				#html.submitButton(value="Save & Close",class="buttonred",title="Save template and return to listing")#
			</div>
			
			<!--- Loader --->
			<div class="loaders" id="uploadBarLoader">
				<img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/>
				<div id="uploadBarLoaderStatus" class="center textRed">Saving...</div>
			</div>
		</div>
	</div>		
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/settings.png" alt="info" width="24" height="24" />
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
				   class="button" title="Get some quick CBHelper API Goodness!">
					<img src="#prc.cbRoot#/includes/images/help_small.png" alt="print" border="0"> CBHelper Docs
				</a>
				<a href="#event.buildLink(prc.xehApiDocs)#" target="_blank" class="button" title="Open the ContentBox API Docs in another window">
					<img src="#prc.cbRoot#/includes/images/help_small.png" alt="print" border="0"> API Docs
				</a>
			</div>
		</div>
	</div>
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/messages_icon.png" alt="email"/>
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
#html.endForm()#
</cfoutput>