<cfoutput>
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-comments icon-large"></i>
				Comments (#prc.commentsCount#)
				<cfif len(rc.searchComments)> > Search: #event.getValue("searchComments")#</cfif>
			</div>
			<!--- Body --->
			<div class="body">	
				
				<!--- MessageBox --->
				#getPlugin("MessageBox").renderit()#
				
				<!--- entryForm --->
				#html.startForm(name="commentForm",action=prc.xehCommentRemove)#
				#html.hiddenField(name="commentStatus",value="")#
				#html.hiddenField(name="page",value=rc.page)#
				
				<!--- Info Bar --->
				<cfif NOT prc.cbSettings.cb_comments_enabled>
					<div class="alert alert-info">
						<i class="icon-exclamation-sign icon-large"></i>
						Comments are currently disabled site-wide!
					</div>
				</cfif>
				
				<!--- Content Bar --->
				<div class="well well-small" id="contentBar">
					
					<!--- Bulk Butons --->
					<cfif prc.oAuthor.checkPermission("COMMENTS_ADMIN")>
					<div class="buttonBar">
						<div class="btn-group">
					    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
								Global Actions <span class="caret"></span>
							</a>
					    	<ul class="dropdown-menu">
					    		<li><a href="javascript:changeStatus('approve')"><i class="icon-thumbs-up"></i> Approve</a></li>
								<li><a href="javascript:changeStatus('moderate')"><i class="icon-thumbs-down"></i> Moderate</a></li>
								<li><a href="javascript:remove()" class="confirmIt"><i class="icon-trash"></i> Remove</a></li>
					    	</ul>
					    </div>
					</div>
					</cfif>
					
					<!--- Filter Bar --->
					<div class="filterBar">
						<div>
							#html.label(field="commentFilter",content="Quick Filter:",class="inline")#
							#html.textField(name="commentFilter",size="30",class="textfield")#
						</div>
					</div>
				</div>
				
				<!--- comments --->
				<table name="comments" id="comments" class="table table-striped table-hover tablesorter table-condensed" width="98%">
					<thead>
						<tr>
							<th id="checkboxHolder" class="{sorter:false}" width="20"><input type="checkbox" onClick="checkAll(this.checked,'commentID')"/></th>
							<th width="200">Author</th>
							<th>Comment</th>
							<th width="120" class="center">Date</th>			
							<th width="100" class="center {sorter:false}">Actions</th>
						</tr>
					</thead>
					
					<tbody>
						<cfloop array="#prc.comments#" index="comment">
						<tr <cfif !comment.getIsApproved()>class="error"</cfif> data-commentID="#comment.getCommentID()#">
							<!--- Delete Checkbox with PK--->
							<td>
								<input type="checkbox" name="commentID" id="commentID" value="#comment.getCommentID()#" />
							</td>
							<td>
								#getMyPlugin(plugin="Avatar",module="contentbox").renderAvatar(email=comment.getAuthorEmail(),size="30")#
								&nbsp;<a href="mailto:#comment.getAUthorEmail()#" title="#comment.getAUthorEmail()#">#comment.getAuthor()#</a>
								<br/>
								<cfif len(comment.getAuthorURL())>
									<i class="icon-cloud"></i>
									<a href="<cfif NOT findnocase("http",comment.getAuthorURL())>http://</cfif>#comment.getAuthorURL()#" title="Open URL" target="_blank">
										#left(comment.getAuthorURL(),25)#<cfif len(comment.getAuthorURL()) gt 25>...</cfif>
									</a>
									<br />
								</cfif>
								<i class="icon-laptop"></i> 
								<a href="#prc.cbSettings.cb_comments_whoisURL#=#comment.getAuthorIP()#" title="Get IP Information" target="_blank">#comment.getauthorIP()#</a>
							</td>
							<td>
								<!--- Entry Or Page --->
								<strong>#comment.getParentTitle()#</strong> 
								<br/>
								#left(comment.getContent(),prc.cbSettings.cb_comments_maxDisplayChars)#
								<cfif len(comment.getContent()) gt prc.cbSettings.cb_comments_maxDisplayChars>....<strong>more</strong></cfif>
							</td>
							<td class="center">
								#comment.getDisplayCreatedDate()#
							</td>
							<td class="center">
								<cfif prc.oAuthor.checkPermission("COMMENTS_ADMIN")>
									<!--- Edit Command --->
									<a href="javascript:openRemoteModal('#event.buildLink(prc.xehCommentEditor)#',{commentID:'#comment.getCommentID()#'});" title="Edit Comment"><i class="icon-edit icon-large"></i></a>
									&nbsp;
									<!--- Approve/Unapprove --->
									<cfif !comment.getIsApproved()>
										<a href="javascript:changeStatus('approve','#comment.getCommentID()#')" title="Approve Comment"><i id="status_#comment.getCommentID()#" class="icon-thumbs-up icon-large"></i></a>
									<cfelse>
										<a href="javascript:changeStatus('moderate','#comment.getCommentID()#')" title="Unapprove Comment"><i id="status_#comment.getCommentID()#" class="icon-thumbs-down icon-large"></i></a>
									</cfif>
									&nbsp;
									<!--- Delete Command --->
									<a title="Delete Comment Permanently" href="javascript:remove('#comment.getCommentID()#')" class="confirmIt" data-title="Delete Comment?"><i id="delete_#comment.getCommentID()#" class="icon-trash icon-large"></i></a>
									&nbsp;	
								</cfif>
								<!--- View in Site --->
								<a href="#prc.CBHelper.linkComment(comment)#" title="View Comment In Site" target="_blank"><i class="icon-eye-open icon-large"></i></a>
							</td>
						</tr>
						</cfloop>
					</tbody>
				</table>
				
				<!--- Paging --->
				#prc.pagingPlugin.renderit(foundRows=prc.commentsCount, link=prc.pagingLink, asList=true)#

				#html.endForm()#
			</div>	
		</div>
	</div>

	<!--- main sidebar --->
	<div class="span3" id="main-sidebar">
		<!--- Saerch Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-search"></i> Search
			</div>
			<div class="body<cfif len(rc.searchComments)> selected</cfif>">
				<!--- Search Form --->
				#html.startForm(name="commentSearchForm",action=prc.xehComments)#
					#html.textField(label="Search:",name="searchComments",class="input-block-level",size="16",title="Search all authors, author emails and content",value=event.getValue("searchComments",""))#
					<button type="submit" class="btn btn-danger">Search</button>
					<button class="btn" onclick="return to('#event.buildLink(prc.xehComments)#')">Clear</button>				
				#html.endForm()#
			</div>
		</div>		
		<!--- Filter Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-filter"></i> Filters
			</div>
			<div class="body<cfif rc.isFiltering> selected</cfif>">
				#html.startForm(name="commentFilterForm",action=prc.xehComments)#
				<!--- Status --->
				<label for="fStatus">Comment Status: </label>
				<select name="fStatus" id="fStatus" class="input-block-level">
					<option value="any"   <cfif rc.fStatus eq "any">selected="selected"</cfif>>Any Status (#prc.countApproved + prc.countUnApproved#)</option>
					<option value="true"  <cfif rc.fStatus eq "true">selected="selected"</cfif>>Approved (#prc.countApproved#)</option>
					<option value="false" <cfif rc.fStatus eq "false">selected="selected"</cfif>>Moderated (#prc.countUnApproved#)</option>				
				</select>
				<button type="submit" class="btn btn-danger">Apply Filters</button>
				<button class="btn" onclick="return to('#event.buildLink(prc.xehComments)#')">Reset</button>				
				#html.endForm()#
			</div>
		</div>	
	</div>
</div>
</cfoutput>