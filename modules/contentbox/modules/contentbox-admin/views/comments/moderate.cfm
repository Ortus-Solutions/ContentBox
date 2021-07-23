<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
        	<i class="far fa-comments"></i> Comment Moderator
		</h1>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <!-- MessageBox -->
        #cbMessageBox().renderit()#
    </div>
</div>

<div class="row">
	<div class="col-md-12">

		<div class="panel panel-default">
			<div class="panel-body">

				<!--- Comment Details --->
				<fieldset>

					<legend><i class="far fa-eye fa-lg"></i> Details</legend>

						<div class="form-group pull-right">
							#getInstance( "Avatar@contentbox" ).renderAvatar(
								email=rc.comment.getAuthorEmail(),
								class="img-circle"
							)#
							&nbsp;
							<a 	href="mailto:#encodeForHTMLAttribute( rc.comment.getAUthorEmail() )#"
								title="#encodeForHTMLAttribute( rc.comment.getAUthorEmail() )#"
							>
								#encodeForHtml( rc.comment.getAuthor() )#
							</a>
						</div>

						<!--- Content Object --->
						<div class="form-group">
							<i class="fas fa-box"></i>
							Created on <strong>#rc.comment.getRelatedContent().getTitle()#</strong>
							<a
								href="#prc.CBHelper.linkComment( comment )#"
								title="View Comment In Site"
								target="_blank"
							>
								<i class="fas fa-external-link-alt"></i>
							</a>
						</div>

						<!--- Author URL --->
						<cfif len( rc.comment.getAuthorURL() )>
							<div class="form-group">
								<i class="fa fa-cloud"></i>
								<label>Author URL: </label>
								<a href="<cfif NOT findnocase( "http",rc.comment.getAuthorURL())>http://</cfif>#rc.comment.getAuthorURL()#" target="_blank">
									#encodeForHtml( rc.comment.getAuthorURL() )#
								</a>
							</div>
						</cfif>

						<!--- IP Address --->
						<div class="form-group">
							<i class="fa fa-laptop"></i>
							<label>IP Address: </label>
							<a href="#prc.cbSettings.cb_comments_whoisURL#=#rc.comment.getAuthorIP()#" title="Get IP Information" target="_blank">#rc.comment.getauthorIP()#</a>
						</div>

						<!--- Date --->
						<div class="form-group">
							<i class="fa fa-calendar"></i>
							<label>Created Date: </label>
							#rc.comment.getDisplayCreatedDate()#
						</div>

				</fieldset>

				<!--- content --->
				<fieldset>
					<legend><i class="fa fa-comment"></i> Comment</legend>
					<div>
						#rc.comment.getDisplayContent()#
					</div>
				</fieldset>

				<!--- Search Form --->
				#html.startForm( name="commentForm", action=prc.xehCommentstatus )#
					#html.hiddenField( name="commentID", bind=rc.comment )#
					#html.hiddenField( name="commentStatus", value="approve" )#
					<div class="form-actions">
						<!--- Buttons --->
						<button
							type="submit"
							class="btn btn-danger btn-lg"
							onclick="removeComment()">
							<i class="fa fa-trash"></i> Delete
						</button>
						<button
							type="submit"
							class="btn btn-primary btn-lg" />
							<i class="far fa-check-circle"></i> Approve
						</button>
					</div>
				#html.endForm()#

			</div>

		</div>
	</div>
</div>
</cfoutput>