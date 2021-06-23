<cfoutput>
<div class="row">
    <div class="col-md-12">
		<h1 class="h1">
			<i class="fa fa-magic fa-lg"></i> Widgets
		</h1>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
       	<!--- MessageBox --->
		#cbMessageBox().renderit()#
    </div>
</div>

<div class="row">
	<div class="col-md-12">

		<div class="panel panel-default">
		    <div class="panel-body">

				<!--- CategoryForm --->
				#html.startForm( name="widgetForm", action=prc.xehWidgetRemove )#
					#html.hiddenField( name="widgetFile" )#

					<!--- widgets --->
					#renderView(
						view 			= "widgets/widgetList",
						args 			= { mode : "edit", cols : 2 },
						prePostExempt 	= true
					)#

				#html.endForm()#

		    </div>
		</div>
	</div>

</div>
</cfoutput>