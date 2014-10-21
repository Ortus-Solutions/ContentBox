<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
        	<i class="fa fa-envelope icon-large"></i>
			Email Templates
        </h1>
        <!--- messageBox --->
		#getPlugin("MessageBox").renderit()#
    </div>
</div>
<div class="row">
	<div class="col-md-12">
		<div class="panel panel-default">
		    <div class="panel-body">
		    	<p>Here are your system email templates that are used to send email notifications. Modify at your own risk :) </p>
		    	<!--- templates --->
				<table name="templates" id="templates" class="table-bordered table table-hover table-striped" width="100%">
					<thead>
						<tr class="info">
							<th>Template</th>
							<th width="150">Last Modified</th>
							<th width="50" class="text-center {sorter:false}">Actions</th>
						</tr>
					</thead>				
					<tbody>
						<cfloop query="prc.templates">
						<tr>
							<td>
								<strong>#prc.templates.name#</strong>
							</td>
							<td>
								#prc.templates.datelastModified#
							</td>
							<td class="text-center">
								<!--- Editor --->
								<a class="btn btn-sm btn-primary" title="Edit Template" href="#event.buildLink(linkTo=prc.xehTemplateEditor,queryString='template=#URLEncodedFormat( listFirst( prc.templates.name, ".") )#')#"><i class="fa fa-edit icon-large"></i></a>
							</td>
						</tr>
						</cfloop>
					</tbody>
				</table>
		    </div>
		</div>
	</div>
</div>
</cfoutput>