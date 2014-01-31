<cfoutput>
<!--- authors --->
<table name="authors" id="authors" class="tablesorter table table-striped table-hover" width="98%">
	<thead>
		<tr>
			<th id="checkboxHolder" class="{sorter:false}" width="20"><input type="checkbox" onClick="checkAll(this.checked,'authorID')"/></th>
			<th>Name</th>
			<th>Email</th>
			<th>Role</th>
			<th>Last Login</th>
			<th width="40" class="center"><i class="icon-thumbs-up icon-large" title="Active User?"></i></th>
			<th width="65" class="center {sorter: false}">Actions</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.authors#" index="author">
		<tr<cfif prc.oAuthor.getAuthorID() eq author.getAuthorID()> class="success"</cfif> data-authorID="#author.getAuthorID()#" >
			<!--- check box --->
			<td>
				<input type="checkbox" name="authorID" id="authorID" value="#author.getAuthorID()#" />
			</td>
			<td>
				#getMyPlugin(plugin="Avatar",module="contentbox").renderAvatar(email=author.getEmail(),size="30")#
				<!--- Display Link if Admin Or yourself --->
				<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN") OR prc.oAuthor.getAuthorID() eq author.getAuthorID()>
					<a href="#event.buildLink(prc.xehAuthorEditor)#/authorID/#author.getAuthorID()#" title="Edit #author.getName()#">#author.getName()#</a>
				<cfelse>
					#author.getName()#
				</cfif>
				<cfif prc.oAuthor.getAuthorID() eq author.getAuthorID()>
					<i class="icon-star icon-large textOrange" title="That's you!"></i>
				</cfif>
			</td>
			<td>#author.getEmail()#</td>
			<td>#author.getRole().getRole()#</td>
			<td>#author.getDisplayLastLogin()#</td>
			<td class="center">
				<cfif author.getIsActive()>
					<i class="icon-ok-sign icon-large textGreen" title="User Active"></i>
				<cfelse>
					<i class="icon-minus-sign icon-large textRed" title="User Deactivated"></i>
				</cfif>
			</td>
			<td class="center">
				<!--- Actions --->
				<div class="btn-group">
			    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##" title="User Actions">
						<i class="icon-cogs icon-large"></i>
					</a>
			    	<ul class="dropdown-menu text-left pull-right">
						<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN") OR prc.oAuthor.getAuthorID() eq author.getAuthorID()>
							<!--- Delete Command --->
							<cfif prc.oAuthor.getAuthorID() neq author.getAuthorID()>
								<li><a title="Delete Author" href="javascript:removeAuthor('#author.getAuthorID()#')" class="confirmIt" data-title="Delete Author?"><i id="delete_#author.getAuthorID()#" class="icon-trash icon-large"></i> Delete</a></li>
							<cfelse>
								<li><a title="Can't Delete Yourself" href="javascript:alert('Can\'t delete yourself buddy!')" class="textRed"><i id="delete_#author.getAuthorID()#" class="icon-trash icon-large"></i> Can't Delete</a></li>
							</cfif>
							<!--- Edit Command --->
							<li><a href="#event.buildLink(prc.xehAuthorEditor)#/authorID/#author.getAuthorID()#" title="Edit #author.getName()#"><i class="icon-edit icon-large"></i> Edit</a></li>
					
							<!--- Export --->
							<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN,TOOLS_EXPORT")>
							<li class="dropdown-submenu pull-left">
								<a href="javascript:null"><i class="icon-download icon-large"></i> Export</a>
								<ul class="dropdown-menu text-left">
									<li><a href="#event.buildLink(linkto=prc.xehExport)#/authorID/#author.getAuthorID()#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
									<li><a href="#event.buildLink(linkto=prc.xehExport)#/authorID/#author.getAuthorID()#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
								</ul>
							</li>
							</cfif>
						<cfelse>
							<li><a href="javascript:null()"><em>No available actions</em></a></li>
						</cfif>
			    	</ul>
			    </div>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

<!--- Paging --->
<cfif !rc.showAll>
	#prc.pagingPlugin.renderit(foundRows=prc.authorCount, link=prc.pagingLink, asList=true)#
<cfelse>
	<span class="label label-info">Total Records: #prc.authorCount#</span>
</cfif>

</cfoutput>