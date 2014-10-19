<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1"><i class="fa fa-magic icon-large"></i> Widgets Editor</h1>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        <!--- MessageBox --->
		#getPlugin("MessageBox").renderit()#
    </div>
</div>
<div class="row">
	#html.startForm(name="widgetEditForm",action=prc.xehWidgetSave,novalidate="novalidate")#
    <div class="col-md-8">
        <div class="panel panel-default">
		    <div class="panel-body">
				<p>
					You can modify the Widget CFC code from this editor.  Please be very careful as you are modifying the code directly.  Please make a backup
					if necessary.
				</p>
				<!--- Editor --->
				#html.textarea(
					name="widgetCode",
					value=prc.widget.widgetCode,
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
		    	#html.hiddenField(name="widget",value=rc.widget)#
				#html.hiddenField(name="type",value=rc.type)#
		    	<div class="btn-group text-center">
					#html.href(
						href=prc.xehWidgets,
						text=html.button(name="cancelButton",value="Cancel",class="btn")
					)#
					#html.button(
						value="Test",
						class="btn",
						title="Live-Test Widget",
						onclick="return testWidgetCode()"
					)#
					#html.button(
						value="Save",
						class="btn btn-danger",
						title="Save and keep on working",
						onclick="return saveWidgetCode()"
					)#
					#html.button(
						value="Save & Close", 
						type="submit", 
						class="btn btn-danger",
						title="Save widget and return to listing"
					)#
				</div>
				<!--- Loader --->
				<div class="loaders" id="uploadBarLoader">
					<i class="icon-spinner icon-spin icon-large icon-2x"></i> <br>
					<div id="uploadBarLoaderStatus" class="center textRed">Saving...</div>
				</div>
		    </div>
		</div>
		<div class="panel panel-primary">
		    <div class="panel-heading">
		        <h3 class="panel-title"><i class="fa fa-info-circle"></i> Help</h3>
		    </div>
		    <div class="panel-body">
		    	<h4>Methods</h4>
				<p>All widgets have a default method called <code>renderIt()</code> that executes when you 
				call the widget.  However, you can create as many public methods and ContentBox
				widget selector will allow you to select them. You can also ignore methods from ContentBox by annotating the method with a <code>cbIgnore</code> annotation:
				</p>
				<div class="alert alert-success">
					function myMethod() <strong>cbIgnore=true</strong>{}
				</div>
				<h4>Arguments</h4>
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
				<h4>Drop downs & Multi-Select</h4>
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
    #html.endForm()#
</div>
</cfoutput>