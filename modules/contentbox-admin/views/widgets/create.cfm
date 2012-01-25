<cfoutput>
<h2>Create New Widget</h2>
#html.startForm(name="widgetForm",action=prc.xehWidgetSave,novalidate="novalidate")#
<div>
	<p>
		First give me some information first and I will create a new ContentBox widget for you.  Then you 
		can edit it to your heart's content! You can find your ContentBox widgets in the following location:
		<em>#prc.widgetsPath#</em>
	</p>
	#html.textField(name="name",label="Widget Name: ",required="required",class="textfield",size="50")#
	#html.inputField(name="version",label="Widget Version: ",type="numeric",required="required",class="textfield",size="50",value="1.0")#
	#html.textField(name="description",label="Widget Description: ",required="required",class="textfield",size="50")#
	#html.textField(name="author",label="Author: ",required="required",class="textfield",size="50",value=prc.oAuthor.getName())#
	#html.inputField(name="authorURL",label="Author URL: ",type="URL",required="required",class="textfield",size="50",value="http://")#
</div>
<hr/>
<!--- Button Bar --->
<div id="bottomCenteredBar" class="textRight">
	#html.button(class="buttonred",onclick="closeRemoteModal()",value="Cancel")#
	#html.submitButton(class="button2",value="Create")#
</div>
#html.endForm()#
</cfoutput>