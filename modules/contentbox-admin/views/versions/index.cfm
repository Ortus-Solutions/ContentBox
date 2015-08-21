<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1"><i class="fa fa-clock-o"></i> Content Version History</h1>
    </div>
</div>
<div class="row">
    <div class="col-md-8">
        <!--- MessageBox --->
		#getModel( "messagebox@cbMessagebox" ).renderit()#
		<!--- Version History Panel --->
		#prc.versionsPager#
    </div>
    <div class="col-md-4">
    	<div class="panel panel-primary">
		    <div class="panel-heading">
		        <h3 class="panel-title">
		        	<i class="fa fa-camera"></i> #prc.content.getContentType()# Snapshot
		        </h3>
		    </div>
		    <div class="panel-body">
		    	<table class="table table-hover table-condensed table-striped" width="100%">
					<tr>
						<th width="95" class="textRight">Title:</th>
						<td>
							#prc.content.getTitle()#
						</td>
					</tr>
					<tr>
						<th class="textRight">Published On:</th>
						<td>
							#prc.content.getDisplayPublishedDate()#
						</td>
					</tr>
					<tr>
						<th class="textRight">Created On:</th>
						<td>
							#prc.content.getDisplayCreatedDate()#
						</td>
					</tr>
					<tr>
						<th class="textRight">Created By:</th>
						<td>
							<a href="mailto:#prc.content.getCreatorEmail()#">#prc.content.getCreatorName()#</a>
						</td>
					</tr>
					<tr>
						<th class="textRight">Active Version:</th>
						<td>
							#prc.content.getActiveContent().getVersion()#
						</td>
					</tr>
				</table>
				<div class="text-center">
					<button class="btn btn-primary btn-sm" onclick="to('#event.buildLink( prc.xehBackTrack )#/parent/#prc.content.getParentID()#');return false;"><i class="fa fa-reply"></i> Back</button>
					<cfif len( prc.xehOpenContent )>
						<button class="btn btn-primary btn-sm" onclick="window.open('#prc.xehOpenContent#');return false;"><i class="fa fa-eye"></i> Open</button>
					</cfif>
				</div>
		    </div>
		</div>
		<div class="panel panel-info">
		    <div class="panel-heading">
		        <h3 class="panel-title">
		        	<i class="fa fa-question-circle"></i> Help Tips
		        </h3>
		    </div>
		    <div class="panel-body">
		    	<ul class="tipList list-unstyled">
					<li><i class="fa fa-lightbulb-o"></i> Right click on a row to activate quick look!</li>
					<li><i class="fa fa-lightbulb-o"></i> Rollback will create a new version with the rollbacked content.</li>
				</ul>
		    </div>
		</div>
    </div>
</div>
</cfoutput>