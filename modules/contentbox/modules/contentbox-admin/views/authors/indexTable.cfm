<cfoutput>
<!--- authors --->
<table name="authors" id="authors" class="table table-striped table-hover table-condensed" width="100%">
	<thead>
		<tr>
			<th id="checkboxHolder" class="{sorter:false} text-center" width="15"><input type="checkbox" onClick="checkAll(this.checked,'authorID')"/></th>
			<th>Name</th>
			<th>Email</th>
			<th>Role</th>
			<th>Last Login</th>
			<th width="65" class="text-center {sorter: false}">Actions</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#prc.authors#" index="author">
		<tr
			<cfif !author.getIsActive()>
				class="danger"
			</cfif>
			data-authorID="#author.getAuthorID()#" >
			<!--- check box --->
			<td class="text-center">
				<input type="checkbox" name="authorID" id="authorID" value="#author.getAuthorID()#" />
			</td>
			<td>
				<cfif prc.oAuthor.getAuthorID() eq author.getAuthorID()>
					<i class="fa fa-star fa-lg textOrange" title="That's you!"></i>
				</cfif>
				#getModel( "Avatar@cb" ).renderAvatar( email=author.getEmail(), size="30" )#
				<!--- Display Link if Admin Or yourself --->
				<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN" ) OR prc.oAuthor.getAuthorID() eq author.getAuthorID()>
					<a href="#event.buildLink(prc.xehAuthorEditor)#/authorID/#author.getAuthorID()#" title="Edit #author.getName()#">#author.getName()#</a>
				<cfelse>
					#author.getName()#
				</cfif>
			</td>
			<td>#author.getEmail()#</td>
			<td>#author.getRole().getRole()#</td>
			<td>#author.getDisplayLastLogin()#</td>
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
							<li><a href="#event.buildLink(linkto=prc.xehExport)#/authorID/#author.getAuthorID()#.json" target="_blank"><i class="fa fa-download"></i> Export as JSON</a></li>
							<li><a href="#event.buildLink(linkto=prc.xehExport)#/authorID/#author.getAuthorID()#.xml" target="_blank"><i class="fa fa-download"></i> Export as XML</a></li>
							</cfif>
						<cfelse>
							<li><a href="javascript:void(0)"><em>No available actions</em></a></li>
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