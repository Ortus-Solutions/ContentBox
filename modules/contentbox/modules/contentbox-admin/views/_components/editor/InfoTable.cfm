<cfoutput>
<div class="panel panel-default">

    <div class="panel-heading">
        <h4 class="panel-title">
            <a class="accordion-toggle block" data-toggle="collapse" data-parent="##accordion" href="##pageinfo">
                <i class="fa fa-info-circle fa-lg"></i> Info
            </a>
        </h4>
    </div>

    <div id="pageinfo" class="panel-collapse collapse in">
        <div class="panel-body">
            <!--- Persisted Info --->
			<table class="table table-hover table-condensed table-striped-removed">

				<tr>
                    <th class="col-md-4">Status:</th>
                    <td class="col-md-8">
						<!--- Status --->
						<cfif prc.oContent.isExpired()>
							<span class="p5 label label-danger">
								Expired
							</span>
						<cfelseif prc.oContent.isPublishedInFuture()>
							<span class="p5 label label-info">
								Future Publish
							</span>
						<cfelseif prc.oContent.isContentPublished()>
							<span class="p5 label label-success">
								Published
							</span>
						<cfelse>
							<span class="p5 label label-default">
								Draft
							</span>
						</cfif>
                    </td>
				</tr>

				<cfif len( prc.oContent.getExpireDate() )>
					<tr>
						<th class="col-md-4">Expired:</th>
						<td class="col-md-8">
							#prc.oContent.getDisplayExpireDate()#
						</td>
					</tr>
				</cfif>

				<tr>
                    <th class="col-md-4">Version:</th>
                    <td class="col-md-8">
						<span class="badge badge-info">#prc.oContent.getActiveContent().getVersion()#</span>
                    </td>
				</tr>

				<tr>
                    <th class="col-md-4">Created By:</th>
                    <td class="col-md-8">
						<a href="mailto:#prc.oContent.getCreatorEmail()#">
							#getInstance( "Avatar@contentbox" ).renderAvatar(
								email	= prc.oContent.getCreatorEmail(),
								size	= "20",
								class	= "img img-circle"
							)#
							#prc.oContent.getCreatorName()#
						</a>
                    </td>
                </tr>

                <tr>
                    <th class="col-md-4">Created:</th>
                    <td class="col-md-8">
                        #prc.oContent.getDisplayCreatedDate()#
                    </td>
                </tr>

                <tr>
                    <th class="col-md-4">Published:</th>
                    <td class="col-md-8">
                        #prc.oContent.getDisplayPublishedDate()#
                    </td>
                </tr>

                <tr>
                    <th class="col-md-4">Last Editor:</th>
                    <td class="col-md-8">
						<a href="mailto:#prc.oContent.getAuthorEmail()#">
							#getInstance( "Avatar@contentbox" ).renderAvatar(
								email	= prc.oContent.getAuthorEmail(),
								size	= "20",
								class	= "img img-circle"
							)#
							#prc.oContent.getAuthorName()#
						</a>
                    </td>
                </tr>

                <tr>
                    <th class="col-md-4">Modified:</th>
                    <td class="col-md-8">
                        #prc.oContent.getActiveContent().getDisplayCreatedDate()#
                    </td>
                </tr>

                <cfif prc.oContent.hasChild()>
                <tr>
                    <th class="col-md-4">Child Pages:</th>
                    <td class="col-md-8">
						<span class="badge badge-info">
							#prc.oContent.getNumberOfChildren()#
						</span>
                    </td>
                </tr>
                </cfif>

                <tr>
                    <th class="col-md-4">Views:</th>
                    <td class="col-md-8">
						<span class="badge badge-info">
							#prc.oContent.getNumberOfHits()#
						</span>
                    </td>
                </tr>

                <tr>
                    <th class="col-md-4">Comments:</th>
                    <td class="col-md-8">
						<span class="badge badge-info">
							#prc.oContent.getNumberOfComments()#
						</span>
                    </td>
                </tr>

            </table>
        </div>
    </div>
</div>
</cfoutput>