<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1"><i class="fa fa-magic fa-lg"></i> Widgets</h1>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
       	<!--- MessageBox --->
		#getModel( "messagebox@cbMessagebox" ).renderit()#
    </div>
</div>
<div class="row">
	<div class="col-md-9">
		<div class="panel panel-default">
		    <div class="panel-body">

				<!--- CategoryForm --->
				#html.startForm(name="widgetForm",action=prc.xehWidgetRemove)#
					#html.hiddenField(name="widgetFile" )#

					<!--- widgets --->
					#renderView(view="widgets/widgetList", module="contentbox-admin", args={ mode="edit", cols=2 } )#

				#html.endForm()#

		    </div>
		</div>
	</div>
	<div class="col-md-3">

		<div class="panel panel-primary">
		    <div class="panel-heading">
		        <h3 class="panel-title"><i class="fa fa-question-circle"></i> Widget Help</h3>
		    </div>
		    <div class="panel-body">
		    	<p>Render widgets in your layouts and views by using the CB Helper method <code>widget()</code>:</p>
				<div class="bg-helper bg-success">
					##cb.widget( "name",{arg1=val,arg2=val} )##
				</div>
				<p>Render module widgets by appending the module name <code>@module</code>:</p>
				<div class="bg-helper bg-success">
					##cb.widget( "name@module",{arg1=val,arg2=val} )##
				</div>
				<p>Get an instance of a widget in your layouts and views using the CB helper method <code>getWidget()</code></p>
				<div class="bg-helper bg-success">
					 ##cb.getWidget( "name" )##
					 ##cb.getWidget( "name@module" )##
				</div>
		    </div>
		</div>
	</div>
</div>
</cfoutput>