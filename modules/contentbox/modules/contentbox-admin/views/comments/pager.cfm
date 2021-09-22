<cfoutput>
<div id="pagerComments">
<!--- Loader --->
<div class="loaders float-right" id="commentsPagerLoader">
	<i class="fa fa-spinner fa-spin fa-lg fa-2x"></i>
</div>

#html.startForm(name="commentPagerForm" )#
<!--- comments --->
<table name="comments_pager" id="comments_pager" class="table table-hover  table-striped-removed" width="100%">
	<thead>
		<tr>
			<th width="200">Author</th>
			<th>Comment</th>
			<th width="100" class="text-center">Actions</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.commentPager_comments#" index="comment">
		<tr <cfif !comment.getIsApproved()>class="error"</cfif> data-commentID="#comment.getCommentID()#">
			<td>
				#getInstance( "Avatar@contentbox" ).renderAvatar(
					email = comment.getAuthorEmail(),
					size  = "30",
					class = "img img-circle"
				)#

				&nbsp;<a href="mailto:#comment.getAUthorEmail()#" title="#comment.getAUthorEmail()#">#comment.getAuthor()#</a>

				<br/>

				<cfif len(comment.getAuthorURL())>
					<i class="fas fa-globe"></i>
					<a href="<cfif NOT findnocase( "http",comment.getAuthorURL())>http://</cfif>#comment.getAuthorURL()#" title="Open URL" target="_blank">
						#left(comment.getAuthorURL(),25)#<cfif len(comment.getAuthorURL()) gt 25>...</cfif>
					</a>
					<br />
				</cfif>

				<div class="ml5 mt10">
					<i class="far fa-calendar mr5"></i>
					#comment.getDisplayCreatedDate()#
				</div>

				<cfif len( comment.getauthorIP() )>
					<div class="ml5 mt10">
						<i class="fas fa-laptop"></i>
						<a href="#prc.cbSettings.cb_comments_whoisURL#=#comment.getAuthorIP()#" title="Get IP Information" target="_blank">#comment.getauthorIP()#</a>
					</div>
				</cfif>
			</td>

			<td>
				<a
					title="Open in Site"
					href="#prc.CBHelper.linkComment(comment)#"
					target="_blank"
				>
					#comment.getParentTitle()#
				</a>

				<div class="mt10">
					#left( comment.getDisplayContent(), prc.cbSiteSettings.cb_comments_maxDisplayChars )#
				<cfif len( comment.getDisplayContent() ) gt prc.cbSiteSettings.cb_comments_maxDisplayChars>
				....<strong>more</strong>
				</cfif>
				</div>
			</td>

			<td class="text-center">
				<cfif prc.oCurrentAuthor.checkPermission( "COMMENTS_ADMIN" )>
					<!--- Approve/Unapprove --->
					<cfif !comment.getIsApproved()>
						<a class="btn btn-sm btn-primary" href="javascript:commentPagerChangeStatus('approve','#comment.getCommentID()#')" title="Approve Comment"><i id="status_#comment.getCommentID()#" class="fa fa-thumbs-up fa-lg" ></i></a>
					<cfelse>
						<a class="btn btn-sm btn-default" href="javascript:commentPagerChangeStatus('moderate','#comment.getCommentID()#')" title="Unapprove Comment"><i id="status_#comment.getCommentID()#" class="fa fa-thumbs-down fa-lg"></i></a>
					</cfif>
				</cfif>

				<div class="btn-group">
					<a class="btn btn-sm btn-default btn-more dropdown-toggle" data-toggle="dropdown" href="##" title="Actions">
						<i class="fas fa-ellipsis-v fa-lg"></i>
					</a>
					<ul class="dropdown-menu text-left pull-right">
						<li><!--- Delete Command --->
							<a title="Delete Comment Permanently" href="javascript:remove('#comment.getCommentID()#')" class="confirmIt" data-title="<i class='far fa-trash-alt'></i> Delete Comment?">
								<i id="delete_#comment.getCommentID()#" class="far fa-trash-alt fa-lg"></i> Delete
							</a>
						</li>
						<li>
							<a href="#prc.CBHelper.linkComment(comment)#" title="View Comment In Site" target="_blank">
								<i class="far fa-eye fa-lg"></i> View In Site
							</a>
						</li>
					</ul>
				</div>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>
#html.endForm()#

<!--- Paging --->
<cfif prc.commentPager_pagination>
	#prc.commentPager_oPaging.renderit(
		foundRows = prc.commentPager_commentsCount,
		link      = prc.commentPager_pagingLink,
		asList    = true
	)#
</cfif>

</div>
</cfoutput>