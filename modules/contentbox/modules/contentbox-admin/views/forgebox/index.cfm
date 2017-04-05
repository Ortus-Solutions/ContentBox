<cfoutput>
#html.startForm( name="forgeBoxInstall", action=prc.xehForgeBoxInstall )#

	#html.hiddenField( name="installDir", 	value=rc.installDir )#
	#html.hiddenField( name="returnURL", 	value=rc.returnURL )#
	#html.hiddenField( name="downloadURL" )#

	<cfif prc.errors>
		#getModel( "messagebox@cbMessagebox" ).renderit()#
	<cfelse>
		<!--- Title --->
		<h2>
			#prc.entriesTitle# - #prc.entries.totalRecords# record(s)
		</h2>

		<!--- Instructions --->
		<p>
			Here is a listing of all the ForgeBox contributions for <span class="label label-info">#rc.typeSlug#</span>.  
			Not all entries can be installed automatically for you. If not, please visit the entry and download it manually or use 
			<a href="https://www.ortussolutions.com/products/commandbox" target="_blank">CommandBox CLI</a> to install it.
			You can find our code repository ForgeBox online at <a href="https://www.forgebox.io" target="_blank">www.forgebox.io</a>.
		</p>

		<!--- Filter Bar --->
		<div class="well well-sm">
			
			<div class="filterBar">

				<div class="btn-group btn-sm pull-right">
				    <a class="btn btn-sm btn-primary dropdown-toggle" data-toggle="dropdown" href="##">
				    	<i class="fa fa-sort"></i> Sort By
				    	<span class="caret"></span>
				    </a>
				   
				    <ul class="dropdown-menu">
				    	<li>
				    		<a href="javascript:loadForgeBox( 'popular' )"><i class="fa fa-thumbs-up"></i> Popularity</a>
				    	</li>
						<li>
							<a href="javascript:loadForgeBox( 'recent' )"><i class="fa fa-calendar"></i> Recently Updated</a>
						</li>
						<li>
							<a href="javascript:loadForgeBox( 'new' )"><i class="fa fa-gift"></i> New Stuff</a>
						</li>
				    </ul>

			    </div>

				<div class="form-group form-inline no-margin">
					#html.textField(
						name 		= "entryFilter",
						size 		= "30",
						class 		= "form-control",
						placeholder = "Quick Filter"
					)#
				</div>
			</div>
		</div>
		<!--- Entries --->
		<cfloop array="#prc.entries.results#" index="thisEntry">
		<div class="forgeBox-entrybox clearfix" id="entry_#thisEntry.entryID#">

			<!--- Ratings --->
			<div class="pull-right">
				Rating:
				<cfif thisEntry.avgRating eq 0>
					<span class="label label-warning">None</span>
				<cfelse>
					#repeatString( "<i class='fa fa-star text-warning'></i>", thisEntry.avgRating )#
				</cfif>
			</div>

			<!--- Info --->
			<h3>
				#encodeForHTML( thisEntry.title )#
				<small><a href="https://www.forgebox.io/view/#thisEntry.slug#" target="_blank" title="Open in ForgeBox"><i class="fa fa-external-link"></i></a></small>
			</h3>
			<p>#encodeForHTML( thisEntry.summary )#</p>
			<p><i class="fa fa-terminal"></i> <code>box install #thisEntry.slug#</code></p>
			
			<!--- Description --->
			<cfif len( thisEntry.description )>
				<a href="##entry_description_#thisEntry.entryID#" class="btn btn-primary btn-sm" role="button" data-toggle="modal"><i class="fa fa-plus"></i> Read Description</a>
				<!--- Modal --->
				<div id="entry_description_#thisEntry.entryID#" 
					 class="modal fade"
					 tab-index="-1"
					 role="dialog"
				>
					<div class="modal-dialog modal-lg" role="document" >
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
								<h4>Description</h4>
							</div>
							<div class="modal-body">
								<cfif listFindNoCase( "markdown,md", thisEntry.descriptionFormat )>
								#prc.markdown.toHTML( thisEntry.description )#
								<cfelse>
								#encodeForHTML( thisEntry.description )#
								</cfif>
							</div>
							<div class="modal-footer">
								<button class="btn btn-danger" data-dismiss="modal" aria-hidden="true">Close</button>
							</div>
						</div>
					</div>
				</div><br/>
			</cfif>

			<!--- Install Instructions --->
			<cfif len(thisEntry.installinstructions)>
				<a href="##entry_ii_#thisEntry.entryID#" role="button" class="btn btn-primary btn-sm"  data-toggle="modal"><i class="fa fa-plus"></i> Read Installation Instructions</a>
				<!--- Modal --->
				<div id="entry_ii_#thisEntry.entryID#" 
					 class="modal fade"
					 tab-index="-1"
					 role="dialog"
				>
					<div class="modal-dialog modal-lg" role="document" >
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
								<h3>Installation Instructions</h3>
							</div>
							<div class="modal-body">
								<cfif listFindNoCase( "markdown,md", thisEntry.installinstructionsFormat )>
								#prc.markdown.toHTML( thisEntry.installinstructions )#
								<cfelse>
								#encodeForHTML( thisEntry.installinstructions )#
								</cfif>
							</div>
							<div class="modal-footer">
								<button class="btn btn-danger" data-dismiss="modal" aria-hidden="true">Close</button>
							</div>
						</div>
					</div>
				</div><br/>
			</cfif>
			<!--- Changelog --->
			<cfif len(thisEntry.changelog)>
				<a href="##entry_cl_#thisEntry.entryID#" role="button" class="btn btn-primary btn-sm" data-toggle="modal"><i class="fa fa-plus"></i> Read Changelog</a>
				<!--- Modal --->
				<div id="entry_cl_#thisEntry.entryID#" 
					 class="modal fade"
					 tab-index="-1"
					 role="dialog"
				>
					<div class="modal-dialog modal-lg" role="document" >
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
								<h3>Changelog</h3>
							</div>
							<div class="modal-body">
								<cfif listFindNoCase( "markdown,md", thisEntry.changelogFormat )>
								#prc.markdown.toHTML( thisEntry.changelog )#
								<cfelse>
								#encodeForHTML( thisEntry.changelog )#
								</cfif>
							</div>
							<div class="modal-footer">
								<button class="btn btn-danger" data-dismiss="modal" aria-hidden="true">Close</button>
							</div>
						</div>
					</div>
				</div><br/>
			</cfif>
			<br/>

			<!--- Download & Install --->
			<div class="forgebox-download">
				<cfif findnocase( ".zip", thisEntry.latestVersion.downloadURL ) AND
					  findnocase( "http", thisEntry.latestVersion.downloadURL )
				>
					<a href="javascript:installEntry( 'entry_#thisEntry.entryID#', '#JSStringFormat( thisEntry.latestVersion.downloadURL )#' )" class="btn btn-sm btn-danger">
					   	<span>Download & Install</span>
					</a>
				<cfelse>
					<div class="alert alert-warning"><i class="fa fa-exclamation fa-lg"></i> No download detected, manual install only!</div>
				</cfif>	
			</div>

			<!--- Info --->
			<p>
				<label class="inline">By: </label> 
					<a title="Open Profile" href="https://www.forgebox.io/user/#thisEntry.user.username#" target="_blank">#thisEntry.user.username#</a> |
				<label class="inline">Last Update: </label> #dateFormat( thisEntry.updateddate, "mmm dd yyyy" )# |
				<label class="inline">Downloads: </label> #numberFormat( thisEntry.downloads )# |
				<label class="inline">Installs: </label> #numberFormat( thisEntry.installs )#
			</p>
		</div>
		</cfloop>
	</cfif>
#html.endForm()#
</cfoutput>