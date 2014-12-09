<cfoutput>
<div class="row-fluid">
	<!--- main content --->
	<div class="span12" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-envelope icon-large"></i>
				Email Templates
			</div>
			<!--- Body --->
			<div class="body">
				
				<!--- MessageBox --->
				#getPlugin("MessageBox").renderit()#
				
				<p>Here are your system email templates that are used to send email notifications. Modify at your own risk :) </p>
				
				<!--- templates --->
				<table name="templates" id="templates" class="tablesorter table table-hover table-striped" width="98%">
					<thead>
						<tr>
							<th>Template</th>
							<th width="150">Last Modified</th>
							<th width="50" class="center {sorter:false}">Actions</th>
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
							<td class="center">
								<!--- Editor --->
								<a class="btn" title="Edit Template" href="#event.buildLink(linkTo=prc.xehTemplateEditor,queryString='template=#URLEncodedFormat( listFirst( prc.templates.name, ".") )#')#"><i class="icon-edit icon-large"></i></a>
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