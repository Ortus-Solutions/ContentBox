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
				#html.textarea(name="widgetCode",value=prc.widget.widgetCode,rows=30)#
			
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
					#html.button(value="Test",class="btn",title="Live-Test Widget",onclick="return testWidgetCode()")#
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

		<!--- Info Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-info-sign"></i> Help
			</div>
			<div class="body">
				<h3>Methods</h3>
				<p>All widgets have a default method called <code>renderIt()</code> that executes when you 
				call the widget.  However, you can create as many public methods and ContentBox
				widget selector will allow you to select them. You can also ignore methods from ContentBox by annotating the method with a <code>cbIgnore</code> annotation:
				</p>
				<div class="alert alert-success">
					function myMethod() <strong>cbIgnore=true</strong>{}
				</div>
				<h3>Arguments</h3>
				<p>Every argument you create in these methods becomes alive in our widget inserter. The following properties of an argument are useful:
				<ul>
					<li><strong>Name:</strong> The name of the argument and also its label</li>
					<li><strong>Label:</strong> The label to use for the argument instead of the name</li>
					<li><strong>Hint:</strong> The help text shown to the user</li>
					<li><strong>Type:</strong> The type the user must use and also adds validation</li>
					<li><strong>Required:</strong> Used for validation</li>
					<li><strong>Default:</strong> The default value for the argument</li>
				</ul>
				</p>
				<h3>Drop downs & Multi-Select</h3>
				<p>
					You can create argument drop downs by using our <code>options, optionsUDF, multiOptions, multiOptionsUDF</code> annotations on your arguments. The <code>options</code> annotation is a list of options to show with a <code>multiOptions</code> counterpart. The <code>optionsUDF, multiOptionsUDF</code> is the name of the function in the same widget to call that MUST return a list or an array of options.

					<div class="alert alert-success">
					function myMethod() <strong>optionsUDF="getValues"</strong>{}<br>
					function myMethod() <strong>multiOptionsUDF="getValues"</strong>{}<br>
					function myMethod() <strong>options="Recent,Commented"</strong>{}<br>
					</div>
				</p>
			</div>
		</div>	
	</div>
</div>
#html.endForm()#
</cfoutput>