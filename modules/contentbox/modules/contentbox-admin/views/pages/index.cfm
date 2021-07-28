﻿<cfoutput>
<div class="row">
	<div class="col-md-12">
		<h1 class="h1">
			<i class="fa fa-sitemap"></i> #prc.oCurrentSite.getName()#
			<span id="pagesCountContainer"></span>
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
		<!--- pageForm --->
		#html.startForm(name="pageForm",action=prc.xehPageRemove)#
			#html.hiddenField(name="contentStatus",value="" )#
			#html.hiddenField(name="contentID",value="" )#
			<div class="panel panel-default">
				<div class="panel-heading">
					<div class="row">

						<div class="col-md-6 col-xs-4">
							<div class="form-group form-inline no-margin">
								#html.textField(
									name        = "searchContent",
									class       = "form-control rounded quicksearch",
									placeholder = "Quick Search"
								)#
							</div>
						</div>

						<div class="col-md-6 col-xs-8">
							<div class="text-right">
								<cfif prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
									<div class="btn-group">
								    	<button class="btn dropdown-toggle btn-info" data-toggle="dropdown">
											Bulk Actions <span class="caret"></span>
										</button>
								    	<ul class="dropdown-menu">
								    		<cfif prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN" )>
								    			<li class="mb5">
								    				<a href="javascript:contentListHelper.bulkRemove()"
								    					class="confirmIt"
														data-title="Delete Selected Categories?"
														data-message="This will delete the categories and associations, are you sure?"
													>
														<i class="far fa-trash-alt fa-lg"></i> Delete Selected
													</a>
												</li>

												<li class="mb5">
													<a href="javascript:contentListHelper.bulkChangeStatus( 'draft' )">
														<i class="fas fa-ban fa-lg"></i> Draft Selected
													</a>
												</li>

												<li class="mb5">
													<a href="javascript:contentListHelper.bulkChangeStatus( 'publish' )">
														<i class="fas fa-satellite-dish fa-lg"></i> Publish Selected
													</a>
												</li>
											</cfif>

											<cfif prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN,TOOLS_IMPORT" )>
								    			<li class="mb5">
													<a href="javascript:importContent()">
														<i class="fas fa-file-import fa-lg"></i> Import
													</a>
								    			</li>
											</cfif>

											<cfif prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN,TOOLS_EXPORT" )>
												<li class="mb5">
													<a href="#event.buildLink( prc.xehPageExportAll )#.json" target="_blank">
														<i class="fas fa-file-export fa-lg"></i> Export All
													</a>
												</li>
												<li>
													<a href="javascript:contentListHelper.exportSelected( '#event.buildLink( prc.xehPageExportAll )#' )">
														<i class="fas fa-file-export fa-lg"></i> Export Selected
													</a>
												</li>
											</cfif>

											<li class="mb5">
												<a href="javascript:contentListHelper.resetBulkHits()">
													<i class="fas fa-recycle fa-lg"></i> Reset Hits Selected
												</a>
											</li>

											<li class="mb5">
												<a href="javascript:contentListHelper.contentShowAll()">
													<i class="fas fa-list"></i> Show All
												</a>
											</li>
								    	</ul>
								    </div>
									<button
										class="btn btn-primary"
										onclick="return to( '#event.buildLink( prc.xehPageEditor )#/parentID/' + getParentContentID() )"
										>
										Create Page
									</button>
								</cfif>
							</div>
						</div>
					</div>
				</div>
				<div class="panel-body">
					<!--- content container --->
    				<div id="contentTableContainer">
    					<p class="text-center">
							<i id="pageLoader" class="fa fa-spinner fa-spin fa-lg icon-4x"></i>
						</p>
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
					#html.startForm(name="pageFilterForm", action=prc.xehPageSearch, class="form-vertical",role="form" )#
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
		<div class="panel panel-default">
		    <div class="panel-heading">
		        <h3 class="panel-title"><i class="fab fa-medrt"></i> Help Tips</h3>
		    </div>
		    <div class="panel-body">
		    	<ul class="tipList list-unstyled">
					<li><i class="far fa-lightbulb fa-lg"></i> Right click on a row to activate quick look!</li>
					<li><i class="far fa-lightbulb fa-lg"></i> Cloning does not copy comments or version history</li>
				</ul>
		    </div>
		</div>
	</div>
</div>

<!--- Clone Dialog --->
<cfif prc.oCurrentAuthor.checkPermission( "PAGES_EDITOR,PAGES_ADMIN" )>
	#renderView(
		view 			= "_tags/dialog/clone",
		args 			= {
			title        : "Page Cloning",
			infoMsg      : "",
			action       : prc.xehPageClone,
			titleLabel   : "Title",
			publishLabel : "Publish all pages in hierarchy?",
			publishInfo  : "By default all cloned pages are published as drafts.",
			statusName   : "pageStatus"
		},
		prePostExempt 	= true
	)#
</cfif>

<!--- Import Dialog --->
<cfif prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN,TOOLS_IMPORT" )>
	#renderView(
		view 			= "_tags/dialog/import",
		args 			= {
			title       : "Import Pages",
			contentArea : "page",
			action      : prc.xehPageImport,
			contentInfo : "Choose the ContentBox <strong>JSON</strong> pages file to import. The creator of the page is matched via their <strong>username</strong> and
                page overrides are matched via their <strong>slug</strong>.
                If the importer cannot find the username from the import file in your installation, then it will ignore the record."
		},
		prePostExempt 	= true
	)#
</cfif>
</cfoutput>