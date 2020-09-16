<cfoutput>

<div class="row">
    <div class="col-md-12">
		<h1 class="h1">
			<i class="fas fa-history"></i> History
		</h1>
    </div>
</div>

<div class="row">

	<div class="col-md-8">
		<div class="panel panel-default">
			<div class="panel-heading">
				<div class="floatRight mt10">
					<a
						<cfif prc.content.getContentType() eq "page">
							href="#event.buildLink( prc.xehPagesEditor )#/contentId/#prc.content.getContentId()#"
						<cfelseif prc.content.getContentType() eq "contentstore">
							href="#event.buildLink( prc.xehContentStoreEditor )#/contentId/#prc.content.getContentId()#"
						<cfelse>
							href="#event.buildLink( prc.xehEntriesEditor )#/contentId/#prc.content.getContentId()#"
						</cfif>
						class="btn btn-sm btn-default"
					>
						Edit
					</a>
				</div>

				<div class="size16 p10">
					<i class="fas fa-box"></i> #prc.content.getTitle()#
				</div>
			</div>

			<div class="panel-body">
				<!--- MessageBox --->
				#getInstance( "messagebox@cbMessagebox" ).renderit()#
				<!--- Version History Panel --->
				#prc.versionsPager#
			</div>
		</div>
	</div>

    <div class="col-md-4">
		<div class="panel panel-primary">

		    <div class="panel-heading">
		        <h3 class="panel-title">
		        	<i class="fas fa-info-circle"></i> Details
		        </h3>
			</div>

		    <div class="panel-body">
				<table class="table table-hover table-striped-removed" width="100%">
					<tr>
						<th class="textRight">Created:</th>
						<td>
							#prc.content.getDisplayCreatedDate()#
						</td>
					</tr>
					<tr>
						<th class="textRight">Creator:</th>
						<td>
							<a href="mailto:#prc.content.getCreatorEmail()#">
								#getInstance( "Avatar@cb" ).renderAvatar(
									email	= prc.content.getCreatorEmail(),
									size	= "20",
									class	= "img img-circle"
								)#
								#prc.content.getCreatorName()#
							</a>
						</td>
					</tr>
					<tr>
						<th class="textRight">Published:</th>
						<td>
							#prc.content.getDisplayPublishedDate()#
						</td>
					</tr>
					<tr>
						<th class="textRight">Expires:</th>
						<td>
							#prc.content.getDisplayExpireDate()#
						</td>
					</tr>
					<tr>
						<th class="textRight">Modified:</th>
						<td>
							#prc.content.getDisplayModifiedDate()#
						</td>
					</tr>
					<tr>
						<th class="textRight">Last Edit:</th>
						<td>
							<a href="mailto:#prc.content.getAuthorEmail()#">
								#getInstance( "Avatar@cb" ).renderAvatar(
									email	= prc.content.getAuthorEmail(),
									size	= "20",
									class	= "img img-circle"
								)#
								#prc.content.getAuthorName()#
							</a>
						</td>
					</tr>
				</table>
				<div class="text-center">
					<button
						class="btn btn-default btn-sm"
						title="Back to listing"
						<cfif len( prc.content.getParentID() )>
							onclick="to( '#event.buildLink( prc.xehBackTrack )#/parent/#prc.content.getParentID()#' );return false;"
						<cfelse>
							onclick="to( '#event.buildLink( prc.xehBackTrack )#' );return false;"
						</cfif>
					>
						<i class="fas fa-chevron-left"></i> Back
					</button>
					<cfif len( prc.xehOpenContent )>
						<button
							class="btn btn-primary btn-sm"
							title="View in Site"
							onclick="window.open( '#prc.xehOpenContent#' );return false;"
						>
							<i class="far fa-eye"></i> Open
						</button>
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
					<li><i class="far fa-lightbulb fa-lg"></i> Right click on a row to activate quick look!</li>
					<li><i class="far fa-lightbulb fa-lg"></i> Rollback will create a new version with the rollbacked content.</li>
				</ul>
		    </div>
		</div>
    </div>
</div>
</cfoutput>