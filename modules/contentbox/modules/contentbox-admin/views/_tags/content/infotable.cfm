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
						<cfif args.content.isExpired()>
							<span class="p5 label label-danger">
								Expired
							</span>
						<cfelseif args.content.isPublishedInFuture()>
							<span class="p5 label label-info">
								Future Publish
							</span>
						<cfelseif args.content.isContentPublished()>
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

				<cfif len( args.content.getExpireDate() )>
					<tr>
						<th class="col-md-4">Expired:</th>
						<td class="col-md-8">
							#args.content.getDisplayExpireDate()#
						</td>
					</tr>
				</cfif>

				<tr>
                    <th class="col-md-4">Version:</th>
                    <td class="col-md-8">
						<span class="badge badge-info">#args.content.getActiveContent().getVersion()#</span>
                    </td>
				</tr>

				<tr>
                    <th class="col-md-4">Created By:</th>
                    <td class="col-md-8">
						<a href="mailto:#args.content.getCreatorEmail()#">
							#getInstance( "Avatar@contentbox" ).renderAvatar(
								email	= args.content.getCreatorEmail(),
								size	= "20",
								class	= "img img-circle"
							)#
							#args.content.getCreatorName()#
						</a>
                    </td>
                </tr>

                <tr>
                    <th class="col-md-4">Created:</th>
                    <td class="col-md-8">
                        #args.content.getDisplayCreatedDate()#
                    </td>
                </tr>

                <tr>
                    <th class="col-md-4">Published:</th>
                    <td class="col-md-8">
                        #args.content.getDisplayPublishedDate()#
                    </td>
                </tr>

                <tr>
                    <th class="col-md-4">Last Editor:</th>
                    <td class="col-md-8">
						<a href="mailto:#args.content.getAuthorEmail()#">
							#getInstance( "Avatar@contentbox" ).renderAvatar(
								email	= args.content.getAuthorEmail(),
								size	= "20",
								class	= "img img-circle"
							)#
							#args.content.getAuthorName()#
						</a>
                    </td>
                </tr>

                <tr>
                    <th class="col-md-4">Modified:</th>
                    <td class="col-md-8">
                        #args.content.getActiveContent().getDisplayCreatedDate()#
                    </td>
                </tr>

                <cfif args.content.hasChild()>
                <tr>
                    <th class="col-md-4">Child Pages:</th>
                    <td class="col-md-8">
						<span class="badge badge-info">
							#args.content.getNumberOfChildren()#
						</span>
                    </td>
                </tr>
                </cfif>

                <tr>
                    <th class="col-md-4">Views:</th>
                    <td class="col-md-8">
						<span class="badge badge-info">
							#args.content.getNumberOfHits()#
						</span>
                    </td>
                </tr>

                <tr>
                    <th class="col-md-4">Comments:</th>
                    <td class="col-md-8">
						<span class="badge badge-info">
							#args.content.getNumberOfComments()#
						</span>
                    </td>
                </tr>

            </table>
        </div>
    </div>
</div>
</cfoutput>