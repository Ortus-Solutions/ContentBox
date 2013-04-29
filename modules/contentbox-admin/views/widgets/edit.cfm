<cfoutput>
#html.startForm(name="widgetEditForm",action=prc.xehWidgetSave,novalidate="novalidate")#
#html.hiddenField(name="widget",value=rc.widget)#
#html.hiddenField(name="type",value=rc.type)#
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-magic icon-large"></i> 
				Widgets Editor
			</div>
			<!--- Body --->
			<div class="body">
				
				<!--- MessageBox --->
				#getPlugin("MessageBox").renderit()#
				
				<p>
					You can modify the Widget CFC code from this editor.  Please be very careful as you are modifying the code directly.  Please make a backup
					if necessary.
				</p>
				
				<!--- Editor --->
				#html.textarea(name="widgetCode",value=prc.widgetCode,rows=30)#
			
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
					#html.href(href=prc.xehWidgets,text=html.button(name="cancelButton",value="Cancel",class="btn"))#
					#html.button(value="Save",class="btn btn-danger",title="Save and keep on working",onclick="return saveWidgetCode()")#
					#html.button(value="Save & Close", type="submit", class="btn btn-danger",title="Save widget and return to listing")#
					</div>
				</div>
				
				<!--- Loader --->
				<div class="loaders" id="uploadBarLoader">
					<i class="icon-spinner icon-spin icon-large icon-2x"></i> <br>
					<div id="uploadBarLoaderStatus" class="center textRed">Saving...</div>
				</div>
			</div>
		</div>	
	</div>
</div>
#html.endForm()#
</cfoutput>