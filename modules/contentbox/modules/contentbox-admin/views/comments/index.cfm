<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1">
        	<i class="far fa-comments"></i> Comments (#prc.commentsCount#)
			<cfif len( rc.searchComments )>
				<i class="fas fa-chevron-right fa-sm"></i> Search:
				#encodeForHTML( searchComments )#
			</cfif>
		</h1>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <!-- MessageBox -->
		#cbMessageBox().renderit()#

        <!--- Info Bar --->
		<cfif NOT prc.cbSiteSettings.cb_comments_enabled>
			<div class="alert alert-info">
				<i class="fa fa-exclamation-triangle fa-lg"></i>
				Comments are currently disabled site-wide!
			</div>
		</cfif>
    </div>
</div>

<div class="row">
    <div class="col-md-9">
        #html.startForm(
			name   = "commentForm",
			action = prc.xehCommentRemove,
			class  = "form-vertical"
		)#
        	#html.hiddenField( name="commentStatus", value="" )#
			#html.hiddenField( name="page", value=rc.page )#

			<div class="panel panel-default">
				<div class="panel-heading">
					<div class="row">

						<!--- Quick Filter --->
						<div class="col-md-6 col-xs-4">
							<div class="form-group form-inline no-margin">
								#html.textField(
									name 		= "commentSearch",
									class		= "form-control rounded quicksearch",
									placeholder = "Quick Filter"
								)#
							</div>
						</div>

						<!---Bulk Actions --->
						<div class="col-md-6 col-xs-8">
							<cfif prc.oCurrentAuthor.checkPermission( "COMMENTS_ADMIN" )>
								<div class="text-right">
									<div class="btn-group">
								    	<button class="btn dropdown-toggle btn-info" data-toggle="dropdown">
											Bulk Actions <span class="caret"></span>
										</button>
								    	<ul class="dropdown-menu">
								    		<li>
												<a href="javascript:changeStatus( 'approve' )">
													<i class="fa fa-thumbs-up"></i> Approve Selected
												</a>
											</li>
											<li>
												<a href="javascript:changeStatus( 'moderate' )">
													<i class="fa fa-thumbs-down"></i> Moderate Selected
												</a>
											</li>
											<li>
												<a href="javascript:removeAllSelected()" class="confirmIt">
													<i class="far fa-trash-alt"></i> Remove Selected
												</a>
											</li>
											<li>
												<a
													href="javascript:removeAllModerated()"
													class="confirmIt"
													data-message="Are you sure you want to delete all moderated comments?"
													title="Nuclear: Delete all moderated comments!">
													<i class="fa fa-times"></i> Remove All Moderated
												</a>
											</li>
								    	</ul>
								    </div>
								</div>
							</cfif>
						</div>
					</div>
				</div>

				<div class="panel-body">
					<!--- comments table --->
					<table
						name="comments"
						id="comments"
						class="table table-striped-removed table-hover"
					>
						<thead>
							<tr>
								<th
									id="checkboxHolder"
									class="{sorter:false} text-center"
									width="15">
									<input
										type="checkbox"
										onClick="checkAll( this.checked, 'commentID' )"
									/>
								</th>
								<th width="200">Author</th>
								<th class="{sorter:false}">Comment</th>
								<th width="75" class="text-center {sorter:false}">Actions</th>
							</tr>
						</thead>

						<tbody>
							<cfloop array="#prc.comments#" index="comment">
							<tr <cfif !comment.getIsApproved()>class="danger"</cfif> data-commentID="#comment.getCommentID()#">
								<!--- Delete Checkbox with PK--->
								<td class="text-center">
									<input type="checkbox" name="commentID" id="commentID" value="#comment.getCommentID()#" />
								</td>
								<td>

									#getInstance( "Avatar@contentbox" ).renderAvatar(
										email = comment.getAuthorEmail(),
										size  = "30",
										class = "img img-circle"
									)#

									&nbsp;
									<a href="mailto:#comment.getAUthorEmail()#" title="#comment.getAUthorEmail()#">#comment.getAuthor()#</a>

									<br/>

									<cfif len(comment.getAuthorURL())>
										<div class="ml5 mt10">
											<i class="fas fa-globe"></i>
											<a href="<cfif NOT findnocase( "http",comment.getAuthorURL())>http://</cfif>#comment.getAuthorURL()#" title="Open URL" target="_blank">
												#left(comment.getAuthorURL(),25)#<cfif len(comment.getAuthorURL()) gt 25>...</cfif>
											</a>
										</div>
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
											<a class="btn btn-sm btn-primary" href="javascript:changeStatus('approve','#comment.getCommentID()#')" title="Approve"><i id="status_#comment.getCommentID()#" class="fa fa-thumbs-up fa-lg"></i></a>
										<cfelse>
											<a class="btn btn-sm btn-default" href="javascript:changeStatus('moderate','#comment.getCommentID()#')" title="Unapprove"><i id="status_#comment.getCommentID()#" class="fa fa-thumbs-down fa-lg"></i></a>
										</cfif>
										<div class="btn-group">
											<a class="btn btn-sm btn-default btn-more dropdown-toggle" data-toggle="dropdown" href="##" title="Actions">
												<i class="fas fa-ellipsis-v fa-lg"></i>
											</a>
									    	<ul class="dropdown-menu text-left pull-right">
									    		<!--- Edit Command --->
												<li>
													<a href="javascript:openRemoteModal('#event.buildLink(prc.xehCommentEditor)#',{commentID:'#comment.getCommentID()#'} );" title="Edit Comment">
														<i class="fas fa-pen fa-lg"></i> Edit
													</a>
												</li>
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
									</cfif>
								</td>
							</tr>
							</cfloop>
						</tbody>
					</table>
					<!--- Paging --->
					#prc.oPaging.renderit(
						foundRows=prc.commentsCount,
						link=prc.pagingLink,
						asList=true
					)#
				</div>
			</div>
		#html.endForm()#
	</div>
	<div class="col-md-3">
		<div class="panel panel-primary">
		    <div class="panel-heading">
		        <h3 class="panel-title"><i class="fa fa-search"></i> Search</h3>
		    </div>
		    <div class="panel-body<cfif len(rc.searchComments)> selected</cfif>">
		    	<!--- Search Form --->
				#html.startForm( name="commentSearchForm",action=prc.xehComments, class="form-vertical", method="get" )#
					<div class="form-group">
						#html.textField(
							label="Search:",
							name="searchComments",
							class="form-control",
							size="16",
							title="Search all authors, author emails and content",
							value=event.getValue( "searchComments","" )
						)#
					</div>

					<div class="text-center">
						<button class="btn btn-default btn-sm" onclick="return to('#event.buildLink(prc.xehComments)#')">Clear</button>
						<button type="submit" class="btn btn-primary btn-sm">Search</button>
					</div>
				#html.endForm()#
		    </div>
		</div>
		<div class="panel panel-primary">
		    <div class="panel-heading">
		        <h3 class="panel-title"><i class="fas fa-filter"></i> Filters</h3>
		    </div>
		    <div class="panel-body<cfif rc.isFiltering> selected</cfif>">
		    	#html.startForm( name="commentFilterForm",action=prc.xehComments, class="form-vertical", method="get" )#
			    	<div class="form-group">
			    		<!--- Status --->
						<label for="fStatus">Comment Status: </label>
						<select name="fStatus" id="fStatus" class="form-control input-sm">
							<option value="any"   <cfif rc.fStatus eq "any">selected="selected"</cfif>>Any Status (#prc.countApproved + prc.countUnApproved#)</option>
							<option value="true"  <cfif rc.fStatus eq "true">selected="selected"</cfif>>Approved (#prc.countApproved#)</option>
							<option value="false" <cfif rc.fStatus eq "false">selected="selected"</cfif>>Moderated (#prc.countUnApproved#)</option>
						</select>
			    	</div>

					<div class="text-center">
						<button class="btn btn-default btn-sm" onclick="return to('#event.buildLink(prc.xehComments)#')">Reset</button>
						<button type="submit" class="btn btn-primary btn-sm">Apply</button>
					</div>
				#html.endForm()#
		    </div>
		</div>
	</div>
</div>
</cfoutput>