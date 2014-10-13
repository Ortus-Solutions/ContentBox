<cfoutput>
<div class="row">
	<div class="col-md-12">
		<h1 class="h1"><i class="fa fa-quote-left"></i> Blog Entries</h1>
	</div>
</div>
<div class="row">
	<div class="col-md-8">
		<!--- MessageBox --->
		#getPlugin( "MessageBox" ).renderit()#
		<!---Import Log --->
		<cfif flash.exists( "importLog" )>
			<div class="consoleLog">#flash.get( "importLog" )#</div>
		</cfif>
		<!--- Info Bar --->
		<cfif NOT prc.cbSettings.cb_comments_enabled>
			<div class="alert alert-info">
				<i class="fa fa-exclamation icon-large"></i>
				Comments are currently disabled site-wide!
			</div>
		</cfif>
		#html.startForm(name="entryForm",action=prc.xehEntryRemove)#
			#html.hiddenField(name="contentStatus",value="")#
			#html.hiddenField(name="contentID",value="")#
			<div class="panel panel-default">
				<div class="panel-heading">
					<div class="row">
						<div class="col-md-6">
							<div class="form-group form-inline no-margin">
								#html.label(field="entrySearch",content="Quick Search:",class="inline control-label")#
								#html.textField( name="entrySearch",class="form-control" )#
							</div>
						</div>
						<div class="col-md-6">
							<div class="pull-right">
								<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT")>
									<div class="btn-group btn-group-sm">
								    	<a class="btn dropdown-toggle btn-info" data-toggle="dropdown" href="##">
											Global Actions <span class="caret"></span>
										</a>
								    	<ul class="dropdown-menu">
								    		<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN")>
												<li>
													<a href="javascript:bulkRemove()" class="confirmIt"
												data-title="Delete Selected Entries?" data-message="This will delete the entries, are you sure?">
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
											<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN,TOOLS_IMPORT")>
												<li>
													<a href="javascript:importContent()"><i class="fa fa-upload"></i> Import
													</a>
												</li>
												</cfif>
												<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN,TOOLS_EXPORT")>
													<li class="dropdown-submenu">
														<a href="##"><i class="fa fa-download icon-large"></i> Export All</a>
														<ul class="dropdown-menu text-left">
															<li>
																<a href="#event.buildLink(linkto=prc.xehEntryExportAll)#.json" target="_blank"><i class="fa fa-code"></i> as JSON
																</a>
															</li>
															<li>
																<a href="#event.buildLink(linkto=prc.xehEntryExportAll)#.xml" target="_blank"><i class="fa-fa-sitemap"></i> as XML
																</a>
															</li>
														</ul>
													</li>
											</cfif>
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
    					<p class="text-center"><i id="entryLoader" class="icon-spinner icon-spin icon-large icon-4x"></i></p>
    				</div>
				</div>
			</div>
		#html.endForm()#
	</div>
	<div class="col-md-4">
		<div class="panel panel-primary">
			<div class="panel-heading">
				<h3 class="panel-title"><i class="fa fa-filter"></i> Filters</h3>
			</div>
			<div class="panel-body">
				<div id="filterBox">
					#html.startForm(name="entryFilterForm", action=prc.xehEntrySearch, class="form-vertical",role="form")#
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
						<a class="btn btn-sm" href="javascript:resetFilter( true )">Reset</a>
					#html.endForm()#
				</div>
			</div>
		</div>
		<div class="panel panel-default">
		    <div class="panel-heading">
		        <h3 class="panel-title"><i class="fa fa-medkit"></i> Help Tips</h3>
		    </div>
		    <div class="panel-body">
		    	<ul class="tipList unstyled">
					<li><i class="fa fa-lightbulb-o"></i> Right click on a row to activate quick look!</li>
					<li><i class="fa fa-lightbulb-o"></i> Sorting is only done within your paging window</li>
					<li><i class="fa fa-lightbulb-o"></i> Quick Filtering is only for viewed results</li>
				</ul>
		    </div>
		</div>
	</div>
</div>

<!--- Clone Dialog --->
<cfif prc.oAuthor.checkPermission("ENTRIES_EDITOR,ENTRIES_ADMIN")>
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
<cfif prc.oAuthor.checkPermission("ENTRIES_ADMIN,TOOLS_IMPORT")>
	<cfscript>
		dialogArgs = {
			title = "Import Blog Entries",
			contentArea = "entry",
			action = prc.xehEntryImport
		};
	</cfscript>
	#renderView( view="_tags/dialog/import", args=dialogArgs )#
</cfif>
</cfoutput>