<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
        	<i class="fa fa-envelope icon-large"></i>
			Email Template Editor -> #rc.template#
        </h1>
        <!--- messageBox --->
		#getPlugin("MessageBox").renderit()#
    </div>
</div>
#html.startForm(name="templateEditForm",action=prc.xehTemplateSave,novalidate="novalidate")#
<div class="row">
	<div class="col-md-8">
		<div class="panel panel-default">
		    <div class="panel-body">
		    	<!--- MessageBox --->
				#getPlugin("MessageBox").renderit()#
		    	#html.hiddenField(name="template",value=rc.encodedTemplate)#
		    	<p>
					You can modify the Template code from this editor.  Please be very careful as you are modifying the code directly.  Please make a backup
					if necessary.
				</p>
				
				<!--- Editor --->
				#html.textarea(
					name="templateCode",
					value=prc.templateCode,
					rows=30,
					class="form-control"
				)#
		    </div>
		</div>
	</div>
	<div class="col-md-4">
		<div class="panel panel-primary">
		    <div class="panel-heading">
		        <h3 class="panel-title"><i class="fa fa-cogs"></i> Actions</h3>
		    </div>
		    <div class="panel-body">
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
		<div class="panel panel-primary">
		    <div class="panel-heading">
		        <h3 class="panel-title"><i class="fa fa-info-circle"></i>
				Info</h3>
		    </div>
		    <div class="panel-body">
		    	<ul class="tipList">
					<li>Do not remove the <strong>cfoutput</strong> tags or no template will render.</li>
					<li>All templates have access to the <strong>CBHelper</strong> via the <strong>cb</strong> object.</li>
					<li>All templates have access to all ColdBox scopes and functions.</li>
				</ul>
				
				<div class="actionBar">
					<a href="javascript:openRemoteModal('#event.buildLink(prc.xehAPIDocs&"/index/apislug/plugins/print/?_cfcviewer_cfc=CBHelper")#')" 
					   class="btn btn-info" title="Get some quick CBHelper API Goodness!">
						CBHelper Docs
					</a>
					<a href="#event.buildLink(prc.xehApiDocs)#" target="_blank" class="btn btn-info" title="Open the ContentBox API Docs in another window">
						API Docs
					</a>
				</div>
		    </div>
		</div>
	</div>
</div>
#html.endForm()#
</cfoutput>