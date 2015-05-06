<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
        	<i class="fa fa-book icon-large"></i>
				ContentBox API Docs
        </h1>
    </div>
</div>
<div class="row">
    <div class="col-md-8">
    	<div class="panel panel-default">
		    <div class="panel-body">
		    	<!--- messageBox --->
				#getPlugin("MessageBox").renderit()#
				<!--- Renderit --->
				#prc.cfcViewer.renderit()#
		    </div>
		</div>
    </div>
    <div class="col-md-4">
    	<div class="panel panel-primary">
    		<div class="panel-heading">
    			<h3 class="panel-title">API Chooser</h3>
    		</div>
		    <div class="panel-body">
		    	#html.startForm(name="apiForm")#
					<p>Select the API to view: </p>
					<div class="form-group">
						#html.select(
							name="apislug",
							options="Model,Plugins,Widgets",
							selectedValue=rc.apislug, 
							class="form-control input-sm"
						)#
					</div>
				#html.endform()#
			
				<div class="actionBar">
					<a href="#event.buildLink(prc.xehAPIDocs&"/index/apislug/#rc.apislug#/?_cfcviewer_package=#rc._cfcviewer_package#&print=true")#" target="_blank">
						<button name="print" class="btn btn-primary"><i class="fa fa-print icon-large"></i> Print</button>
					</a>
				</div>
		    </div>
		</div>
    </div>
</div>
</cfoutput>