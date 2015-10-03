<cfoutput>
<div class="row">
	<div class="col-md-12">
		<h1 class="h1"><i class="fa fa-quote-left"></i> Blog Entries</h1>
	</div>
</div>
<div class="row">
	<div class="col-md-9">
		<!--- MessageBox --->
		#getModel( "messagebox@cbMessagebox" ).renderit()#
		<!---Import Log --->
		<cfif flash.exists( "importLog" )>
			<div class="consoleLog">#flash.get( "importLog" )#</div>
		</cfif>
		<!--- Info Bar --->
		<cfif NOT prc.cbSettings.cb_comments_enabled>
			<div class="alert alert-info">
				<i class="fa fa-exclamation fa-lg"></i>
				Comments are currently disabled site-wide!
			</div>
		</cfif>
		#html.startForm(name="entryForm",action=prc.xehEntryRemove)#
			#html.hiddenField(name="contentStatus",value="" )#
			#html.hiddenField(name="contentID",value="" )#
			<div class="panel panel-default">
				<div class="panel-heading">
					<div class="row">
						<div class="col-md-6">
							<div class="form-group form-inline no-margin">
								#html.textField( 
									name="entrySearch",
									class="form-control",
									placeholder="Quick Search"
								)#
							</div>
						</div>
						<div class="col-md-6">
							<div class="pull-right">
								<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
									<div class="btn-group btn-group-sm">
								    	<a class="btn dropdown-toggle btn-info" data-toggle="dropdown" href="##">
											Bulk Actions <span class="caret"></span>
										</a>
								    	<ul class="dropdown-menu">
								    		<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN" )>
												<li>
													<a href="javascript:bulkRemove()" class="confirmIt"
												data-title="<i class='fa fa-trash-o'></i> Delete Selected Entries?" data-message="This will delete the entries, are you sure?">
														<i class="fa fa-trash-o"></i> Delete selected
													</a>
												</li>
												<li>
													<a href="javascript:bulkChangeStatus('draft')"><i class="fa fa-ban"></i> Draft Selected
													</a>
												</li>
												<li>
													<a href="javascript:bulkChangeStatus('publish')"><i class="fa fa-check"></i> Publish Selected
													</a>
												</li>
											</cfif>
											<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN,TOOLS_IMPORT" )>
												<li>
													<a href="javascript:importContent()"><i class="fa fa-upload"></i> Import
													</a>
												</li>
												</cfif>
												<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN,TOOLS_EXPORT" )>
												<li>
													<a href="#event.buildLink(linkto=prc.xehEntryExportAll)#.json" target="_blank"><i class="fa fa-download"></i> Export All as JSON
													</a>
												</li>
												<li>
													<a href="#event.buildLink(linkto=prc.xehEntryExportAll)#.xml" target="_blank"><i class="fa fa-download"></i> Export All as XML
													</a>
												</li>
											</cfif>
											<li><a href="javascript:resetBulkHits()"><i class="fa fa-refresh"></i> Reset Hits Selected</a></li>
											<li>
												<a href="javascript:contentShowAll()"><i class="fa fa-list"></i> Show All
												</a>
											</li>
								    	</ul>
								    </div>
								</cfif>
								<button class="btn btn-primary btn-sm" onclick="return to('#event.buildLink(linkTo=prc.xehEntryEditor)#');">Create Entry</button>
							</div>
						</div>
					</div>
				</div>
				<div class="panel-body">
					<!--- entries container --->
    				<div id="entriesTableContainer">
    					<p class="text-center"><i id="entryLoader" class="fa fa-spinner fa-spin fa-lg icon-4x"></i></p>
    				</div>
				</div>
			</div>
		#html.endForm()#
	</div>
	<div class="col-md-3">
		<div class="panel panel-primary">
			<div class="panel-heading">
				<h3 class="panel-title"><i class="fa fa-filter"></i> Filters</h3>
			</div>
			<div class="panel-body">
				<div id="filterBox">
					#html.startForm(name="entryFilterForm", action=prc.xehEntrySearch, class="form-vertical",role="form" )#
						<!--- Authors --->
						<div class="form-group">
					        <label for="fAuthors" class="control-label">Authors:</label>
							<div class="controls">
								<select name="fAuthors" id="fAuthors" class="form-control input-sm valid">
									<option value="all" selected="selected">All Authors</option>
									<cfloop array="#prc.authors#" index="author">
									<option value="#author.getAuthorID()#">#author.getName()#</option>
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
								<option value="#author.getAuthorID()#">#author.getName()#</option>
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
						<a class="btn btn-info btn-sm" href="javascript:contentFilter()">Apply Filters</a>
						<a class="btn btn-sm btn-default" href="javascript:resetFilter( true )">Reset</a>
					#html.endForm()#
				</div>
			</div>
		</div>
		<div class="panel panel-default">
		    <div class="panel-heading">
		        <h3 class="panel-title"><i class="fa fa-medkit"></i> Help Tips</h3>
		    </div>
		    <div class="panel-body">
		    	<ul class="tipList list-unstyled">
					<li><i class="fa fa-lightbulb-o"></i> Right click on a row to activate quick look!</li>
				</ul>
		    </div>
		</div>
	</div>
</div>

<!--- Clone Dialog --->
<cfif prc.oAuthor.checkPermission( "ENTRIES_EDITOR,ENTRIES_ADMIN" )>
	<cfscript>
		dialogArgs = {
			title = "Entry Cloning",
			infoMsg = "By default, all internal links are updated for you as part of the cloning process.",
			action = prc.xehEntryClone,
			titleLabel = "Please enter the new entry title",
			publishLabel="Publish entry?",
			publishInfo = "By default all cloned entries are published as drafts.",
			statusName = "entryStatus"
		};
	</cfscript>
	#renderView( view="_tags/dialog/clone", args=dialogArgs )#
</cfif>
<cfif prc.oAuthor.checkPermission( "ENTRIES_ADMIN,TOOLS_IMPORT" )>
	<cfscript>
		dialogArgs = {
			title = "Import Blog Entries",
			contentArea = "entry",
			action = prc.xehEntryImport,
			contentInfo = "Choose the ContentBox <strong>JSON</strong> entries file to import. The creator of the entry is matched via their <strong>username</strong> and 
                entry overrides are matched via their <strong>slug</strong>.
                If the importer cannot find the username from the import file in your installation, then it will ignore the record."
		};
	</cfscript>
	#renderView( view="_tags/dialog/import", args=dialogArgs )#
</cfif>
</cfoutput>
