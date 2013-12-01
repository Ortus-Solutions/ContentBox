<cfoutput>
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
		<div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-user icon-large"></i>
				User Management
			</div>
			<!--- Body --->
			<div class="body">
				<!--- MessageBox --->
				#getPlugin("MessageBox").renderit()#
				
				<!---Import Log --->
				<cfif flash.exists( "importLog" )>
				<div class="consoleLog">#flash.get( "importLog" )#</div>
				</cfif>
				
				<!--- AuthorForm --->
				#html.startForm(name="authorForm",action=prc.xehAuthorRemove)#
				<input type="hidden" name="authorID" id="authorID" value="" />
	
				<div class="well well-small">
					<!--- Create Butons --->
					<div class="buttonBar">
						<!---Global --->
						<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT")>
						<div class="btn-group">
					    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
								Global Actions <span class="caret"></span>
							</a>
					    	<ul class="dropdown-menu">
					    		<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN,TOOLS_IMPORT")>
					    		<li><a href="javascript:importContent()"><i class="icon-upload-alt"></i> Import</a></li>
								</cfif>
								<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN,TOOLS_EXPORT")>
					    		<li class="dropdown-submenu">
									<a href="##"><i class="icon-download icon-large"></i> Export All</a>
									<ul class="dropdown-menu text-left">
										<li><a href="#event.buildLink(linkto=prc.xehExportAll)#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
										<li><a href="#event.buildLink(linkto=prc.xehExportAll)#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
									</ul>
								</li>
								</cfif>
					    	</ul>
					    </div>
						</cfif>
						<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN")>
						<button class="btn btn-danger" onclick="return to('#event.buildLink(prc.xehAuthorEditor)#')">Create User</button>
						</cfif>
					</div>
	
					<!--- Filter Bar --->
					<div class="filterBar">
						<div>
							#html.label(field="authorFilter",content="Quick Filter:",class="inline")#
							#html.textField(name="authorFilter",size="30",class="textfield")#
						</div>
					</div>
				</div>
	
				<!--- authors --->
				<table name="authors" id="authors" class="tablesorter table table-striped table-hover" width="98%">
					<thead>
						<tr>
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
						<tr<cfif prc.oAuthor.getAuthorID() eq author.getAuthorID()> class="success"</cfif>>
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
				#prc.pagingPlugin.renderit(foundRows=prc.authorCount, link=prc.pagingLink, asList=true)#

				#html.endForm()#
	
			</div>	<!--- body --->
		</div> <!--- main box --->
	</div>

	<!--- main sidebar --->
	<div class="span3" id="main-sidebar">
		<!--- Search Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-search"></i> User Search
			</div>
			<div class="body">
				<!--- Search Form --->
				#html.startForm(name="authorSearchForm",action=prc.xehAuthorsearch)#
					#html.textField(label="Search:", name="searchAuthor", class="input-block-level", size="16", title="Search authors by name, username or email", value=event.getValue("searchAuthor",""))#
					<button type="submit" class="btn btn-danger">Search</button>
					<button class="btn" onclick="return to('#event.buildLink(prc.xehAuthors)#')">Clear</button>
				#html.endForm()#
			</div>
		</div>
	</div>
</div>

<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN,TOOLS_IMPORT")>
<!---Import Dialog --->
<div id="importDialog" class="modal hide fade">
	<div id="modalContent">
	    <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h3><i class="icon-copy"></i> Import Users</h3>
	    </div>
        #html.startForm(name="importForm", action=prc.xehImportAll, class="form-vertical", multipart=true)#
        <div class="modal-body">
			<p>Choose the ContentBox <strong>JSON</strong> users file to import.</p>
			
			#getMyPlugin( plugin="BootstrapFileUpload", module="contentbox" ).renderIt( 
				name="importFile", 
				required=true
			)#

			<label for="overrideContent">Override Users?</label>
			<small>By default all content that exist is not overwritten.</small><br>
			#html.select(options="true,false", name="overrideContent", selectedValue="false", class="input-block-level",wrapper="div class=controls",labelClass="control-label",groupWrapper="div class=control-group")#
			
			<!---Notice --->
			<div class="alert alert-info">
				<i class="icon-info-sign icon-large"></i> Please note that import is an expensive process, so please be patient when importing.
			</div>
		</div>
        <div class="modal-footer">
            <!--- Button Bar --->
        	<div id="importButtonBar">
          		<button class="btn" id="closeButton"> Cancel </button>
          		<button class="btn btn-danger" id="importButton"> Import </button>
            </div>
			<!--- Loader --->
			<div class="center loaders" id="importBarLoader">
				<i class="icon-spinner icon-spin icon-large icon-2x"></i>
				<br>Please wait, doing some hardcore importing action...
			</div>
        </div>
		#html.endForm()#
	</div>
</div>
</cfif>
</cfoutput>