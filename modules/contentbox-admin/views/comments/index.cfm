<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Saerch Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/search.png" alt="info" width="24" height="24" />Search
		</div>
		<div class="body<cfif len(rc.searchComments)> selected</cfif>">
			<!--- Search Form --->
			#html.startForm(name="commentSearchForm",action=prc.xehComments)#
				#html.textField(label="Search:",name="searchComments",class="textfield",size="16",title="Search all authors, author emails and content",value=event.getValue("searchComments",""))#
				<input type="submit" value="Search" class="buttonred" />
				<button class="button" onclick="return to('#event.buildLink(prc.xehComments)#')">Clear</button>				
			#html.endForm()#
		</div>
	</div>		
	<!--- Filter Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/filter.png" alt="info" width="24" height="24" />Filters
		</div>
		<div class="body<cfif rc.isFiltering> selected</cfif>">
			#html.startForm(name="commentFilterForm",action=prc.xehComments)#
			<!--- Status --->
			<label for="fStatus">Comment Status: </label>
			<select name="fStatus" id="fStatus" style="width:200px">
				<option value="any"   <cfif rc.fStatus eq "any">selected="selected"</cfif>>Any Status (#rc.countApproved + rc.countUnApproved#)</option>
				<option value="true"  <cfif rc.fStatus eq "true">selected="selected"</cfif>>Approved (#rc.countApproved#)</option>
				<option value="false" <cfif rc.fStatus eq "false">selected="selected"</cfif>>Moderated (#rc.countUnApproved#)</option>				
			</select>
			<!--- ActionBar --->
			<div class="actionBar">
				<input type="submit" value="Apply Filters" class="buttonred" />
				<button class="button" onclick="return to('#event.buildLink(prc.xehComments)#')">Reset</button>				
			</div>			
			#html.endForm()#
		</div>
	</div>	
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column" id="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.cbroot#/includes/images/comments_32.png" alt="sofa" width="30" height="30" />
			Comments (#rc.commentsCount#)
			<cfif len(rc.searchComments)> > Search: #event.getValue("searchComments")#</cfif>
		</div>
		<!--- Body --->
		<div class="body">	
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- entryForm --->
			#html.startForm(name="commentForm",action=rc.xehCommentRemove)#
			#html.hiddenField(name="commentStatus",value="")#
			#html.hiddenField(name="page",value=rc.page)#
			
			<!--- Info Bar --->
			<cfif NOT prc.cbSettings.cb_comments_enabled>
				<div class="infoBar">
					<img src="#prc.cbRoot#/includes/images/info.png" alt="comments" />
					Comments are currently disabled site-wide!
				</div>
			</cfif>
			
			<!--- Content Bar --->
			<div class="contentBar" id="contentBar">
				
				<!--- Bulk Butons --->
				<cfif prc.oAuthor.checkPermission("COMMENTS_ADMIN")>
				<div class="buttonBar">
					<button class="button2" onclick="return changeStatus('approve')" title="Bulk Approve Comments">Approve</button>
					<button class="button2" onclick="return changeStatus('moderate')" title="Bulk Moderate Comments">Moderate</button>
					<!--- As Link for confirmations --->
					<a href="javascript:remove()" class="confirmIt" data-title="Really do a bulk delete?">
						<button class="button2" onclick="return false" title="Bulk Remove Comments">Remove</button>
					</a>
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
			
			<!--- Paging --->
			#rc.pagingPlugin.renderit(rc.commentsCount,rc.pagingLink)#
		
			<!--- comments --->
			<table name="comments" id="comments" class="tablesorter" width="98%">
				<thead>
					<tr>
						<th id="checkboxHolder" class="{sorter:false}" width="20"><input type="checkbox" onClick="checkAll(this.checked,'commentID')"/></th>
						<th width="200">Author</th>
						<th>Comment</th>
						<th width="115" class="center">Date</th>			
						<th width="90" class="center {sorter:false}">Actions</th>
					</tr>
				</thead>
				
				<tbody>
					<cfloop array="#rc.comments#" index="comment">
					<tr <cfif !comment.getIsApproved()>class="unapproved"</cfif> data-commentID="#comment.getCommentID()#">
						<!--- Delete Checkbox with PK--->
						<td>
							<input type="checkbox" name="commentID" id="commentID" value="#comment.getCommentID()#" />
						</td>
						<td>
							#getMyPlugin(plugin="Avatar",module="contentbox").renderAvatar(email=comment.getAuthorEmail(),size="30")#
							&nbsp;<a href="mailto:#comment.getAUthorEmail()#" title="#comment.getAUthorEmail()#">#comment.getAuthor()#</a>
							<br/>
							<cfif len(comment.getAuthorURL())>
								<img src="#prc.cbRoot#/includes/images/link.png" alt="link" /> 
								<a href="<cfif NOT findnocase("http",comment.getAuthorURL())>http://</cfif>#comment.getAuthorURL()#" title="Open URL" target="_blank">
									#left(comment.getAuthorURL(),25)#<cfif len(comment.getAuthorURL()) gt 25>...</cfif>
								</a>
								<br />
							</cfif>
							<img src="#prc.cbRoot#/includes/images/database_black.png" alt="server" /> 
							<a href="#prc.cbSettings.cb_comments_whoisURL#=#comment.getAuthorIP()#" title="Get IP Information" target="_blank">#comment.getauthorIP()#</a>
						</td>
						<td>
							<!--- Entry Or Page --->
							<img src="#prc.cbRoot#/includes/images/page.png" alt="link" title="Posted Entry"/> <strong>#comment.getParentTitle()#</strong> 
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
								<a href="javascript:openRemoteModal('#event.buildLink(rc.xehCommentEditor)#',{commentID:'#comment.getCommentID()#'});" title="Edit Comment"><img src="#prc.cbroot#/includes/images/edit.png" alt="edit" /></a>
								&nbsp;
								<!--- Approve/Unapprove --->
								<cfif !comment.getIsApproved()>
									<a href="javascript:changeStatus('approve','#comment.getCommentID()#')" title="Approve Comment"><img id="status_#comment.getCommentID()#" src="#prc.cbroot#/includes/images/hand_pro.png" alt="approve" /></a>
								<cfelse>
									<a href="javascript:changeStatus('moderate','#comment.getCommentID()#')" title="Unapprove Comment"><img id="status_#comment.getCommentID()#" src="#prc.cbroot#/includes/images/hand_contra.png" alt="unapprove" /></a>
								</cfif>
								&nbsp;
								<!--- Delete Command --->
								<a title="Delete Comment Permanently" href="javascript:remove('#comment.getCommentID()#')" class="confirmIt" data-title="Delete Comment?"><img id="delete_#comment.getCommentID()#" src="#prc.cbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
								&nbsp;	
							</cfif>
							<!--- View in Site --->
							<a href="#prc.CBHelper.linkComment(comment)#" title="View Comment In Site" target="_blank"><img src="#prc.cbroot#/includes/images/eye.png" alt="edit" border="0"/></a>
						</td>
					</tr>
					</cfloop>
				</tbody>
			</table>
			
			<!--- Paging --->
			#rc.pagingPlugin.renderit(rc.commentsCount,rc.pagingLink)#
			
			#html.endForm()#
		</div>	
	</div>
</div>
</cfoutput>