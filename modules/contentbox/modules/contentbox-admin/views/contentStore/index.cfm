<cfoutput>
<div class="row">
	<div class="col-md-12">
		<h1 class="h1">
			<i class="far fa-hdd"></i> Content Store
			<span id="contentCountContainer"></span>
		</h1>
	</div>
</div>

<div class="row">
	<div class="col-md-9">
		<!--- MessageBox --->
		#cbMessageBox().renderit()#

		<!---Import Log --->
		<cfif flash.exists( "importLog" )>
			<div class="consoleLog">#flash.get( "importLog" )#</div>
		</cfif>

		<!--- Info Bar --->
		<cfif NOT prc.cbSiteSettings.cb_comments_enabled>
			<div class="alert alert-info">
				<i class="fa fa-exclamation fa-lg"></i>
				Comments are currently disabled site-wide!
			</div>
		</cfif>

		#html.startForm(
			name   = "contentForm",
			action = prc.xehContentRemove
		)#
			#html.hiddenField(
				name	= "contentStatus",
				value	= ""
			)#
			#html.hiddenField(
				name	= "contentID",
				value	= ""
			)#
			<div class="panel panel-default">
				<div class="panel-heading">
					<div class="row">

						<div class="col-md-6 col-xs-4">
							<div class="form-group form-inline no-margin">
								#html.textField(
									name        = "contentSearch",
									class       = "form-control rounded quicksearch",
									placeholder = "Quick Search"
								)#
							</div>
						</div>

						<div class="col-md-6">
							<div class="text-right">
								<cfif prc.oCurrentAuthor.checkPermission( "CONTENTSTORE_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
									<div class="btn-group">
								    	<button class="btn dropdown-toggle btn-info" data-toggle="dropdown">
											Bulk Actions <span class="caret"></span>
										</button>
								    	<ul class="dropdown-menu">
								    		<cfif prc.oCurrentAuthor.checkPermission( "CONTENTSTORE_ADMIN" )>
												<li>
													<a href="javascript:contentListHelper.bulkRemove()" class="confirmIt"
													data-title="<i class='far fa-trash-alt fa-lg'></i> Delete Selected Content?" data-message="This will delete the content, are you sure?">
														<i class="far fa-trash-alt fa-lg"></i> Delete Selected
													</a>
												</li>
												<li>
													<a href="javascript:contentListHelper.bulkChangeStatus('draft')">
														<i class="fas fa-ban fa-lg"></i> Draft Selected
													</a>
												</li>
												<li>
													<a href="javascript:contentListHelper.bulkChangeStatus('publish')">
														<i class="fas fa-satellite-dish fa-lg"></i> Publish Selected
													</a>
												</li>
											</cfif>
											<cfif prc.oCurrentAuthor.checkPermission( "CONTENTSTORE_ADMIN,TOOLS_IMPORT" )>
												<li>
													<a href="javascript:importContent()">
														<i class="fas fa-file-import fa-lg"></i> Import
													</a>
												</li>
											</cfif>
											<cfif prc.oCurrentAuthor.checkPermission( "CONTENTSTORE_ADMIN,TOOLS_EXPORT" )>
												<li>
													<a href="#event.buildLink ( prc.xehContentExportAll )#.json" target="_blank">
														<i class="fas fa-file-export fa-lg"></i> Export All
													</a>
												</li>
												<li>
													<a href="javascript:contentListHelper.exportSelected( '#event.buildLink( prc.xehContentExportAll )#' )">
														<i class="fas fa-file-export fa-lg"></i> Export Selected
													</a>
												</li>
											</cfif>
											<li>
												<a href="javascript:contentListHelper.contentShowAll()">
													<i class="fas fa-list fa-lg"></i> Show All
												</a>
											</li>
								    	</ul>
								    </div>
								</cfif>
								<a
									class="btn btn-primary text-white"
									href="#event.buildLink( prc.xehContentEditor & "/parentId/" & encodeForHTMLAttribute( rc.parent ) )#"
								>
									Create Content
								</a>
							</div>
						</div>
					</div>
				</div>
				<div class="panel-body">
					<!--- table container --->
    				<div id="contentTableContainer">
    					<p class="text-center"><i id="entryLoader" class="fa fa-spinner fa-spin fa-lg icon-4x"></i></p>
    				</div>
				</div>
			</div>
		#html.endForm()#
	</div>
	<div class="col-md-3">
		<div class="panel panel-primary">
			<div class="panel-heading">
				<h3 class="panel-title"><i class="fas fa-filter"></i> Filters</h3>
			</div>
			<div class="panel-body">
				<div id="filterBox">
					#html.startForm(name="contentFilterForm", action=prc.xehContentSearch, class="form-vertical",role="form" )#
						<!--- Authors --->
						<div class="form-group">
					        <label for="fAuthors" class="control-label">Authors:</label>
							<div class="controls">
								<select name="fAuthors" id="fAuthors" class="form-control input-sm valid">
									<option value="all" selected="selected">All Authors</option>
									<cfloop array="#prc.authors#" index="author">
									<option value="#author.getAuthorID()#">#author.getFullName()#</option>
									</cfloop>
								</select>
							</div>
					    </div>
					    <!--- Creators --->
					    <div class="form-group">
							<label for="fCreators" class="control-label">Creators: </label>
							<select name="fCreators" id="fCreators" class="form-control input-sm" title="Filter on who created content">
								<option value="all" selected="selected">All Creators</option>
								<cfloop array="#prc.authors#" index="author">
								<option value="#author.getAuthorID()#">#author.getFullName()#</option>
								</cfloop>
							</select>
						</div>
						<!--- Categories --->
						<div class="form-group">
					        <label for="fCategories" class="control-label">Categories:</label>
					        <div class="controls">
								<select name="fCategories" id="fCategories" class="form-control input-sm valid">
									<option value="all">All Categories</option>
									<option value="none">Uncategorized</option>
									<cfloop array="#prc.categories#" index="category">
									<option value="#category.getCategoryID()#">#category.getCategory()#</option>
									</cfloop>
								</select>
					        </div>
					    </div>
						<!--- Status --->
						<div class="form-group">
					        <label for="fStatus" class="control-label">Status:</label>
					        <div class="controls">
					            <select name="fStatus" id="fStatus" class="form-control input-sm valid">
									<option value="any">Any Status</option>
									<option value="true">Published</option>
									<option value="false">Draft</option>
								</select>
					        </div>
					    </div>

						<div class="text-center">
							<a class="btn btn-sm btn-default" href="javascript:contentListHelper.resetFilter( true )">Reset</a>
							<a class="btn btn-primary btn-sm" href="javascript:contentListHelper.contentFilter()">Apply</a>
						</div>
					#html.endForm()#
				</div>
			</div>
		</div>
	</div>
</div>
<!--- Clone Dialog --->
<cfif prc.oCurrentAuthor.checkPermission( "CONTENTSTORE_EDITOR,CONTENTSTORE_ADMIN" )>
	#renderView(
		view 			= "_tags/dialog/clone",
		args 			= {
			title        : "Content Store Cloning",
			infoMsg      : "",
			action       : prc.xehContentClone,
			titleLabel   : "Title",
			publishLabel : "Publish",
			publishInfo  : "By default all cloned items are published as drafts."
		},
		prePostExempt 	= true
	)#
</cfif>

<!--- Import Dialog --->
<cfif prc.oCurrentAuthor.checkPermission( "CONTENTSTORE_ADMIN,TOOLS_IMPORT" )>
	#renderView(
		view 			= "_tags/dialog/import",
		args 			= {
			title       : "Import Content",
			contentArea : "content",
			action      : prc.xehContentImport,
			contentInfo : "Choose the ContentBox <strong>JSON</strong> content store file to import. The creator of the content is matched via their <strong>username</strong> and
                contenet overrides are matched via their <strong>slug</strong>.
                If the importer cannot find the username from the import file in your installation, then it will ignore the record."
		},
		prePostExempt 	= true
	)#
</cfif>
</cfoutput>