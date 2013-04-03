<cfoutput>
#html.startForm(name="widgetEditForm",action=prc.xehWidgetSave,novalidate="novalidate")#
#html.hiddenField(name="widget",value=rc.widget)#
#html.hiddenField(name="type",value=rc.type)#
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<i class="icon-cogs"></i> Actions
		</div>
		<div class="body">
			
			<div class="actionBar">
				#html.href(href=prc.xehWidgets,text=html.button(name="cancelButton",value="Cancel",class="button"))#
				#html.button(value="Save",class="buttonred",title="Save and keep on working",onclick="return saveWidgetCode()")#
				#html.submitButton(value="Save & Close",class="buttonred",title="Save widget and return to listing")#
			</div>
			
			<!--- Loader --->
			<div class="loaders" id="uploadBarLoader">
				<i class="icon-spinner icon-spin icon-large icon-2x"></i> <br>
				<div id="uploadBarLoaderStatus" class="center textRed">Saving...</div>
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
#html.endForm()#
</cfoutput>