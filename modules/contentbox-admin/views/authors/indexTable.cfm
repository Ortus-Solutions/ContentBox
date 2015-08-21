<cfoutput>
<!--- authors --->
<table name="authors" id="authors" class="table table-striped table-hover table-bordered" width="100%">
	<thead>
		<tr>
			<th id="checkboxHolder" class="{sorter:false} text-center" width="20"><input type="checkbox" onClick="checkAll(this.checked,'authorID')"/></th>
			<th>Name</th>
			<th>Email</th>
			<th>Role</th>
			<th>Last Login</th>
			<th width="40" class="text-center"><i class="icon-thumbs-up fa-lg" title="Active User?"></i></th>
			<th width="65" class="text-center {sorter: false}">Actions</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.authors#" index="author">
		<tr<cfif prc.oAuthor.getAuthorID() eq author.getAuthorID()> class="success"</cfif> data-authorID="#author.getAuthorID()#" >
			<!--- check box --->
			<td class="text-center">
				<input type="checkbox" name="authorID" id="authorID" value="#author.getAuthorID()#" />
			</td>
			<td>
				#getModel( "Avatar@cb" ).renderAvatar( email=author.getEmail(), size="30" )#
				<!--- Display Link if Admin Or yourself --->
				<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN" ) OR prc.oAuthor.getAuthorID() eq author.getAuthorID()>
					<a href="#event.buildLink(prc.xehAuthorEditor)#/authorID/#author.getAuthorID()#" title="Edit #author.getName()#">#author.getName()#</a>
				<cfelse>
					#author.getName()#
				</cfif>
				<cfif prc.oAuthor.getAuthorID() eq author.getAuthorID()>
					<i class="fa fa-star fa-lg textOrange" title="That's you!"></i>
				</cfif>
			</td>
			<td>#author.getEmail()#</td>
			<td>#author.getRole().getRole()#</td>
			<td>#author.getDisplayLastLogin()#</td>
			<td class="text-center">
				<cfif author.getIsActive()>
					<i class="fa fa-check fa-lg textGreen" title="User Active"></i>
				<cfelse>
					<i class="fa fa-times fa-lg textRed" title="User Deactivated"></i>
				</cfif>
			</td>
			<td class="text-center">
				<!--- Actions --->
				<div class="btn-group btn-group-sm">
			    	<a class="btn btn-sm btn-primary dropdown-toggle" data-toggle="dropdown" href="##" title="User Actions">
						<i class="fa fa-cogs fa-lg"></i>
					</a>
			    	<ul class="dropdown-menu text-left pull-right">
						<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN" ) OR prc.oAuthor.getAuthorID() eq author.getAuthorID()>
							<!--- Delete Command --->
							<cfif prc.oAuthor.getAuthorID() neq author.getAuthorID()>
								<li><a title="Delete Author" href="javascript:removeAuthor('#author.getAuthorID()#')" class="confirmIt" data-title="<i class='fa fa-trash-o'></i> Delete Author?"><i id="delete_#author.getAuthorID()#" class="fa fa-trash-o fa-lg"></i> Delete</a></li>
							<cfelse>
								<li><a title="Can't Delete Yourself" href="javascript:alert('Can\'t delete yourself buddy!')" class="textRed"><i id="delete_#author.getAuthorID()#" class="fa fa-trash-o fa-lg"></i> Can't Delete</a></li>
							</cfif>
							<!--- Edit Command --->
							<li><a href="#event.buildLink(prc.xehAuthorEditor)#/authorID/#author.getAuthorID()#" title="Edit #author.getName()#"><i class="fa fa-edit fa-lg"></i> Edit</a></li>
					
							<!--- Export --->
							<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN,TOOLS_EXPORT" )>
							<li class="dropdown-submenu pull-left">
								<a href="javascript:null"><i class="fa fa-download fa-lg"></i> Export</a>
								<ul class="dropdown-menu text-left">
									<li><a href="#event.buildLink(linkto=prc.xehExport)#/authorID/#author.getAuthorID()#.json" target="_blank"><i class="fa fa-code"></i> as JSON</a></li>
									<li><a href="#event.buildLink(linkto=prc.xehExport)#/authorID/#author.getAuthorID()#.xml" target="_blank"><i class="fa fa-sitemap"></i> as XML</a></li>
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
	#prc.oPaging.renderit(foundRows=prc.authorCount, link=prc.pagingLink, asList=true)#
<cfelse>
	<span class="label label-info">Total Records: #prc.authorCount#</span>
</cfif>

</cfoutput>