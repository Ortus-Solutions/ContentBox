<cfoutput>
<div id="pagerComments">
<!--- Loader --->
<div class="loaders floatRight" id="commentsPagerLoader">
	<i class="fa fa-spinner fa-spin fa-lg fa-2x"></i>
</div>
<!--- Paging --->
<cfif prc.commentPager_pagination>
	#prc.commentPager_oPaging.renderit(prc.commentPager_commentsCount,prc.commentPager_pagingLink)#
</cfif>
#html.startForm(name="commentPagerForm" )#
<!--- comments --->
<table name="comments_pager" id="comments_pager" class="table table-hover table-condensed table-striped" width="100%">
	<thead>
		<tr>
			<th width="200">Author</th>
			<th>Comment</th>
			<th width="175" class="text-center">Date</th>			
			<th width="100" class="text-center">Actions</th>
		</tr>
	</thead>
	
	<tbody>
		<cfloop array="#prc.commentPager_comments#" index="comment">
		<tr <cfif !comment.getIsApproved()>class="error"</cfif> data-commentID="#comment.getCommentID()#">
			<td>
				#getModel( "Avatar@cb" ).renderAvatar(email=comment.getAuthorEmail(),size="30" )#
				&nbsp;<a href="mailto:#comment.getAUthorEmail()#" title="#comment.getAUthorEmail()#">#comment.getAuthor()#</a>
				<br/>
				<cfif len(comment.getAuthorURL())>
					<i class="fa fa-cloud"></i> 
					<a href="<cfif NOT findnocase( "http",comment.getAuthorURL())>http://</cfif>#comment.getAuthorURL()#" target="_blank">
						#left(comment.getAuthorURL(),25)#<cfif len(comment.getAuthorURL()) gt 25>...</cfif>
					</a>
					<br />
				</cfif>
				<i class="fa fa-laptop"></i> 
				<a href="#prc.cbSettings.cb_comments_whoisURL#=#comment.getAuthorIP()#" title="Get IP Information" target="_blank">#comment.getauthorIP()#</a>
			</td>
			<td>
				<strong>#comment.getParentTitle()#</strong> 
				<br/>
				#left(comment.getContent(),prc.cbSettings.cb_comments_maxDisplayChars)#
				<cfif len(comment.getContent()) gt prc.cbSettings.cb_comments_maxDisplayChars>....<strong>more</strong></cfif>
			</td>
			<td class="text-center">
				#comment.getDisplayCreatedDate()#
			</td>
			<td class="text-center">
				<div class="btn-group btn-xs">
					<cfif prc.oAuthor.checkPermission( "COMMENTS_ADMIN" )>
						<!--- Approve/Unapprove --->
						<cfif !comment.getIsApproved()>
							<a class="btn btn-xs btn-info" href="javascript:commentPagerChangeStatus('approve','#comment.getCommentID()#')" title="Approve Comment"><i id="status_#comment.getCommentID()#" class="fa fa-thumbs-up fa-lg" ></i></a>
						<cfelse>
							<a class="btn btn-xs btn-info" href="javascript:commentPagerChangeStatus('moderate','#comment.getCommentID()#')" title="Unapprove Comment"><i id="status_#comment.getCommentID()#" class="fa fa-thumbs-down fa-lg"></i></a>
						</cfif>
						<!--- Delete Command --->
						<a class="btn btn-xs btn-info" title="Delete Comment Permanently" href="javascript:commentPagerRemove('#comment.getCommentID()#')"><i id="delete_#comment.getCommentID()#" class="fa fa-trash-o fa-lg" ></i></a>
					</cfif>
					<!--- View in Site --->
					<a class="btn btn-xs btn-info" href="#prc.CBHelper.linkComment(comment)#" title="View Comment In Site" target="_blank"><i class="fa fa-eye fa-lg"></i></a>
				</div>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>
#html.endForm()#
</div>
</cfoutput>