<cfoutput>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3>Create New Widget</h3>
</div>
#html.startForm(name="widgetCreateForm",action=prc.xehWidgetSave,novalidate="novalidate")#
<div class="modal-body">
	<p>
		First give me some information first and I will create a new ContentBox widget for you.  Then you 
		can edit it to your heart's content! You can find your ContentBox widgets in the following location:
		<em>#prc.widgetsPath#</em>
	</p>
	
	<div class="alert alert-info">
		You can enter any category that seems fit for your widget.  You also select an icon for your widget that
		will identify it in ContentBox.
	</div>
	
	#html.textField(name="name",label="Widget Name: ",required="required",class="span4",size="50")#
	#html.inputField(name="version",label="Widget Version: ",type="numeric",required="required",class="span4",size="50",value="1.0")#
	#html.textField(name="description",label="Widget Description: ",required="required",class="span4",size="50")#
	#html.textField(name="author",label="Author: ",required="required",class="span4",size="50",value=prc.oAuthor.getName())#
	#html.inputField(name="authorURL",label="Author URL: ",type="URL",required="required",class="span4",size="50",value="http://")#
	#html.textField(name="category",label="Category: ",required="required",class="span4",size="50",value="Miscellaneous", title="The category can be anything you like, but just one.")#
	
	<label for="icon">Icon:</label>
	<div class="input-append">
		#html.textField(name="icon", required="required",class="span4",value="", title="The icon to identify your widget in ContentBox.", readonly="true", placeholder="Icon")#
		#html.button(class="btn", onclick="toggleIconSelector()", value="Choose Icon...")#
	</div>
	
	<!---Icon Selector --->
	<div class="clr"></div>
	<div class="widget-icon-selector" id="widget-icon-selector">
		<cfloop array="#prc.widgetIcons#" index="icon">
		<div>
			<a href="javascript:chooseIcon( '#icon#' )" title="#listfirst( icon, "." )#"><img class="widget-icon" src="#prc.widgetIconsIncludePath#/#icon#" alt="#listfirst( icon, "." )#" /></a>
		</div>
		</cfloop>
	</div>
</div>
<!--- Button Bar --->
<div class="modal-footer">
	#html.button(class="btn btn-danger",onclick="closeRemoteModal()",value="Cancel")#
	#html.button(type="submit", class="btn btn-primary", value="Create")#
</div>
#html.endForm()#
</cfoutput>