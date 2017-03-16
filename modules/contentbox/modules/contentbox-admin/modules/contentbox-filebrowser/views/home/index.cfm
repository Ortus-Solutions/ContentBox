<!-----------------------------------------------------------------------
********************************************************************************
Copyright since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
----------------------------------------------------------------------->
<cfoutput>
<div class="panel panel-default" id="FileBrowser" >

	<!--- Panel Heading: Tool Bar --->
	<div class="panel-heading" id="FileBrowser-heading">
	#html.startForm( name="filebrowser", class="form-inline", onkeypress="return event.keyCode != 13;" )#
		#announceInterception( "fb_preTitleBar" )#

		<div class="btn-group btn-group-sm" role="group">
		  <a href="javascript:fbRefresh()" class="btn btn-info" title="#$r( "refresh@fb" )#">
		  	<i class="fa fa-refresh"></i>
		  </a>
		  <a href="javascript:fbDrilldown()" class="btn btn-info" title="#$r( "home@fb" )#">
		  	<i class="fa fa-home"></i>
		  </a>
		</div>

		<div class="btn-group btn-group-sm" role="group">
		  <a href="javascript:fbNewFolder()" class="btn btn-info" title="#$r( "newFolder@fb" )#">
		  	<i class="fa fa-folder-open-o"></i>
		  </a>
		  <a href="javascript:fbRename()" class="btn btn-info" title="#$r( "rename@fb" )#">
		  	<i class="fa fa-terminal"></i>
		  </a>
		  <a href="javascript:fbDelete()" class="btn btn-info" title="#$r( "delete@fb" )#">
		  	<i class="fa fa-times"></i>
		  </a>
		  <a href="javascript:fbUpload()" class="btn btn-info" title="#$r( "upload@fb" )#">
		  	<i class="fa fa-upload"></i>
		  </a>
		  <a href="javascript:fbDownload()" class="btn btn-info" title="#$r( "download@fb" )#">
		  	<i class="fa fa-download"></i>
		  </a>
		  <a href="javascript:fbQuickView()" class="btn btn-info" title="#$r( "quickview@fb" )#">
		  	<i class="fa fa-camera"></i>
		  </a>
		</div>

		<div class="btn-group btn-group-sm" role="group">
		  <a href="javascript:fbListTypeChange('listing')" class="btn btn-info" title="#$r( "filelisting@fb" )#">
		  	<i class="fa fa-list-ul"></i>
		  </a>
		  <a href="javascript:fbListTypeChange('grid')" class="btn btn-info" title="#$r( "gridlisting@fb" )#">
		  	<i class="fa fa-th"></i>
		  </a>
		</div>

		<!---Grid or listing --->
		<div class="form-group">
			<!--- Sorting --->
			#html.label( field="fbSorting", content=$r( "sortby@fb" ))#
			#html.select( name="fbSorting", class="form-input", options=$r( "sortoptions@fb" ), selectedValue=prc.fbPreferences.sorting)#
		</div>
		<div class="form-group">
			<!--- Quick Filter --->
			#html.label( field="fbQuickFilter", content=$r( "quickfilter@fb" ) )#
			#html.textField( name="fbQuickFilter", class="form-input" )#
		</div>
		#html.hiddenField( name="listType", value=prc.fbPreferences.listType )#

		<h3 class="panel-title actions"><strong>#prc.fbSettings.title#</strong></h3>

		<!---event --->
		#announceInterception( "fb_postTitleBar" )#
	#html.endForm()#
	</div>
	<!---/ end panel heading --->

	<div class="panel-body" id="FileBrowser-body">

		<!--- ContextMenus --->
		<div id="fbContextMenu">
			<ul class="dropdown-menu" role="menu">
				<li>
					<a href="javascript:fbQuickView()"><i class="fa fa-camera"></i> #$r( "quickview@fb" )#</a>
				</li>
				<cfif len( rc.callback )>
				<li>
					<a href="javascript:fbChoose()"><i class="fa fa-check"></i> #$r( "select@fb" )#</a>
				</li>
				</cfif>
				<li>
					<a href="javascript:fbRename()"><i class="fa fa-terminal"></i> #$r( "rename@fb" )#</a>
				</li>
				<cfif prc.fbSettings.deleteStuff>
				<li>
					<a href="javascript:fbDelete()"><i class="fa fa-times"></i> #$r( "delete@fb" )#</a>
				</li>
				</cfif>
				<cfif prc.fbSettings.allowDownload>
				<li>
					<a href="javascript:fbDownload()"><i class="fa fa-download"></i> #$r( "download@fb" )#</a>
				</li>
				</cfif>
				<li>
					<a href="javascript:fbUrl()"><i class="fa fa-link"></i> URL</a>
				</li>
			</ul>
		</div>
		<div id="fbContextMenuDirectories">
			<ul class="dropdown-menu">
				<cfif len( rc.callback )>
				<li>
					<a href="javascript:fbChoose()"><i class="fa fa-check"></i> #$r( "select@fb" )#</a>
				</li>
				</cfif>
				<li>
					<a href="javascript:fbRename()"><i class="fa fa-terminal"></i> #$r( "rename@fb" )#</a>
				</li>
				<cfif prc.fbSettings.deleteStuff>
				<li>
					<a href="javascript:fbDelete()"><i class="fa fa-times"></i> #$r( "delete@fb" )#</a>
				</li>
				</cfif>
			</ul>
		</div>

		<!--- UploadBar --->
		<div id="uploadBar">
			#announceInterception( "fb_preUploadBar" )#

			<div id="manual_upload_wrapper" style="text-align:left;">
				<div class="fileupload fileupload-new" data-provides="fileupload" id="filewrapper">
					<div class="input-append textfield">
						<div class="uneditable-input span3">
							<i class="icon-file fileupload-exists"></i> <span class="fileupload-preview"></span>
						</div>
						<span class="btn btn-file">
							<span class="fileupload-new">Select file</span>
							<span class="fileupload-exists">Change</span>
							<input type="file" name="FILEDATA" id="file_uploader" />
							#html.hiddenField(name="validated",value="false" )#
							#html.hiddenField(name="overwrite",id="overwrite",value="false" )#
						</span>
						<a href="##" class="btn btn-info btn-sm fileupload-exists" data-dismiss="fileupload">Remove</a>
						<span id="file_uploader_button" class="btn btn-primary btn-sm">Upload</span>
					</div>
				</div>
			</div>
			#announceInterception( "fb_postUploadBar" )#
		</div>

		<!--- QuickViewBar --->
		<div id="quickViewBar">
			<img id="fbCloseButton" src="#prc.fbModRoot#/includes/images/x.png" alt="close"/>
			#announceInterception( "fb_preQuickViewBar" )#
			<div id="quickViewBarContents"></div>
			#announceInterception( "fb_postQuickViewBar" )#
		</div>

		<!--- Uploader Message --->
		<div id="uploaderHelp">#$r( "dragdrop@fb" )#</div>
		
		<!--- Show the File Listing --->
		<div id="fileListing">
			
			<!---Clear Fix --->
			<div style="clear:both"></div>
			
			<!---Upload Message Bar --->
			<div id="fileUploaderMessage">#$r( "dropupload@fb" )#</div>
			
			#announceInterception( "fb_preFileListing" )#
			<!--- Messagebox --->
			#getModel( "messagebox@cbMessagebox" ).renderit()#

			<!--- Display back links --->
			<cfif prc.fbCurrentRoot NEQ prc.fbDirRoot>
				<cfif prc.fbPreferences.listType eq "grid">
					<div class="fbItemBox">
						<div class="fbItemBoxPreview">
							<a href="javascript:fbDrilldown('#$getBackPath(prc.fbCurrentRoot)#')" title="#$r( "back@fb" )#"><img src="#prc.fbModRoot#/includes/images/directory.png" border="0"  alt="Folder"></a>
							<br>
							<a href="javascript:fbDrilldown('#$getBackPath(prc.fbCurrentRoot)#')" title="Go Back"> <- #$r( "back@fb" )#
							</a>
						</div>
					</div>
				<cfelse>
					<a href="javascript:fbDrilldown('#$getBackPath(prc.fbCurrentRoot)#')" title="#$r( "back@fb" )#"><img src="#prc.fbModRoot#/includes/images/folder.png" border="0"  alt="Folder"></a>
					<a href="javascript:fbDrilldown('#$getBackPath(prc.fbCurrentRoot)#')" title="#$r( "back@fb" )#">..</a><br>
				</cfif>
			</cfif>
			
			<!--- Keep count of the excluded items from the display, so we can adjust the item count in the status bar --->
			<cfset excludeCounter = 0>
			
			<!--- Display directories --->
			<cfif prc.fbqListing.recordcount>
				<cfloop query="prc.fbqListing">
	
					<!--- Skip Exclude Filters --->
					<cfset skipExcludes = false>
					<cfloop array="#listToArray( prc.fbSettings.excludeFilter )#" index="thisFilter">
						<cfif reFindNoCase( thisFilter, prc.fbqListing.name )>
							<cfset skipExcludes = true><cfbreak>
						</cfif>
					</cfloop>
					<cfif skipExcludes>
						<cfset excludeCounter++>
						<cfcontinue>
					</cfif>
	
					<!--- Include Filters --->
					<cfif NOT reFindNoCase( prc.fbNameFilter, prc.fbqListing.name )><cfcontinue></cfif>
	
					<!--- ID Name of the div --->
					<cfset validIDName = $validIDName( prc.fbqListing.name ) >
					<!--- URL used for selection --->
					<cfset plainURL = prc.fbCurrentRoot & "/" & prc.fbqListing.name>
					<cfset relURL = $getUrlRelativeToPath( prc.fbwebRootPath, plainURL )>
					<cfset mediaURL = ( ( prc.fbSettings.useMediaPath ) ? $getURLMediaPath( prc.fbDirRoot, plainURL ) : relURL )>
	
					<!---Grid or List --->
					<cfif prc.fbPreferences.listType eq "grid">
						<!---Grid Listing --->
						<div class="fbItemBox filterDiv">
							<div class="fbItemBoxPreview">
								<!--- Directory or File --->
								<cfif prc.fbqListing.type eq "Dir">
									<!--- Folder --->
									<div id="#validIDName#"
										 onClick="fbSelect('#validIDName#','#JSStringFormat( plainURL )#')"
										 onContextMenu="fbSelect('#validIDName#','#JSStringFormat( plainURL )#')"
										 class="folders"
										 data-type="dir"
										 data-name="#prc.fbqListing.Name#"
										 data-fullURL="#plainURL#"
										 data-relURL="#relURL#"
										 data-lastModified="#dateformat( prc.fbqListing.dateLastModified, 'yyyy-mm-dd' )# #timeformat( prc.fbqListing.dateLastModified, 'hh:mm:ss tt' )#"
										 data-size="#numberFormat( prc.fbqListing.size / 1024 )#"
										 data-quickview="false"
										 onDblclick="fbDrilldown('#JSStringFormat( plainURL )#')">
										<a href="javascript:fbDrilldown('#JSStringFormat( plainURL )#')"><img src="#prc.fbModRoot#/includes/images/directory.png" border="0"  alt="Folder"></a>
										<br/>
										#prc.fbqListing.name#
									</div>
								<cfelseif prc.fbSettings.showFiles>
									<!--- Display the DiV --->
									<div id="#validIDName#"
										 class="files"
										 data-type="file"
										 data-name="#prc.fbqListing.Name#"
										 data-fullURL="#plainURL#"
										 data-relURL="#mediaURL#"
										 data-lastModified="#dateformat( prc.fbqListing.dateLastModified, 'yyyy-mm-dd' )# #timeformat( prc.fbqListing.dateLastModified, 'hh:mm:ss tt' )#"
										 data-size="#numberFormat( prc.fbqListing.size / 1024 )#"
										 data-quickview="#validQuickView( listLast( prc.fbQListing.name, "." ) )#"
										 onClick="fbSelect('#validIDName#','#JSStringFormat( plainURL )#')"
										 onContextMenu="fbSelect('#validIDName#','#JSStringFormat( plainURL )#')"
										 <cfif len( rc.callback )>
										 onDblclick="fbChoose()"
										 </cfif> >
										<cfif validQuickView( listLast( prc.fbQListing.name, "." ) )>
											<img src="#event.buildLink(prc.xehFBDownload)#?path=#plainURL#" border="0" alt="quickview" style="max-width: 140px; max-height: 100px">
										<cfelse>
											<img src="#prc.fbModRoot#/includes/images/bigfile.png" border="0"  alt="file">
										</cfif>
										<br/>
										#prc.fbqListing.name# <br/>
										(#numberFormat( prc.fbqListing.size / 1024 )# kb)
									</div>
								</cfif>
							</div>
						</div>
					<!--- list --->
					<cfelse>
						<!--- Directory or File --->
						<cfif prc.fbqListing.type eq "Dir">
							<!--- Folder --->
							<div id="#validIDName#"
								 onClick="fbSelect('#validIDName#','#JSStringFormat( plainURL )#')"
								 onContextMenu="fbSelect('#validIDName#','#JSStringFormat( plainURL )#')"
								 class="folders filterDiv"
								 data-type="dir"
								 data-name="#prc.fbqListing.Name#"
								 data-fullURL="#plainURL#"
								 data-relURL="#relURL#"
								 data-lastModified="#dateformat( prc.fbqListing.dateLastModified, 'yyyy-mm-dd' )# #timeformat( prc.fbqListing.dateLastModified, 'hh:mm:ss tt' )#"
								 data-size="#numberFormat( prc.fbqListing.size / 1024 )#"
								 data-quickview="false"
								 onDblclick="fbDrilldown('#JSStringFormat( plainURL )#')">
								<a href="javascript:fbDrilldown('#JSStringFormat( plainURL )#')"><img src="#prc.fbModRoot#/includes/images/folder.png" border="0"  alt="Folder"></a>
								#prc.fbqListing.name#
							</div>
						<cfelseif prc.fbSettings.showFiles>
							<!--- Display the DiV --->
							<div id="#validIDName#"
								 class="files filterDiv"
								 data-type="file"
								 data-name="#prc.fbqListing.Name#"
								 data-fullURL="#plainURL#"
								 data-relURL="#mediaURL#"
								 data-lastModified="#dateformat( prc.fbqListing.dateLastModified, 'yyyy-mm-dd' )# #timeformat( prc.fbqListing.dateLastModified, 'hh:mm:ss tt' )#"
								 data-size="#numberFormat( prc.fbqListing.size / 1024 )#"
								 data-quickview="#validQuickView( listLast( prc.fbQListing.name, "." ) )#"
								 onClick="fbSelect('#validIDName#','#JSStringFormat( plainURL )#')"
								 onContextMenu="fbSelect('#validIDName#','#JSStringFormat( plainURL )#')"
								 <cfif len( rc.callback )>
								 onDblclick="fbChoose()"
								 </cfif> >
								<img src="#prc.fbModRoot#/includes/images/#getImageFile(listLast( prc.fbQListing.name, "." ))#" border="0"  alt="file">
								#prc.fbqListing.name#
							</div>
						</cfif>
					</cfif>
				</cfloop>
			<cfelse>
				<em>#$r( "emptydirectory@fb" )#</em>
			</cfif>
			#announceInterception( "fb_postFileListing" )#
		</div> <!--- end fileListing --->

	</div> <!--- end panel-body --->

	<div class="panel-footer" id="FileBrowser-footer">

		<!--- Location Bar --->
		<div id="locationBar">
			#announceInterception( "fb_preLocationBar" )#
			
			<cfset crumbDir = "">
			<cfloop list="#prc.fbCurrentRoot#" delimiters="/" index="crumb">
				<cfif crumbDir neq "">
					&nbsp;<i class="fa fa-chevron-right text-info"></i>&nbsp;
				</cfif>	
				<cfset crumbDir = crumbDir & crumb & "/">
				<cfif ( !prc.fbSettings.traversalSecurity OR findNoCase(prc.fbSettings.directoryRoot, crumbDir ) )>
					<a href="javascript:fbDrilldown('#JSStringFormat( crumbDir )#')">#crumb#</a>
				<cfelse>
					#crumb#
				</cfif>		
			</cfloop>
				
			(#prc.fbqListing.recordCount-excludeCounter# #$r( "items@fb" )#)
			#announceInterception( "fb_postLocationBar" )#
		</div>

 		<!--- The Bottom Bar --->
		<div class="bottomBar">
			#announceInterception( "fb_preBottomBar" )#

			<!--- Loader Bar --->
			<div id="loaderBar">
				<i class="fa fa-circle-o-notch fa-spin"></i> #$r( "common.loading@cbcore" )#
			</div>

			<!--- Status Text --->
			<div id="statusText"></div>

			<!--- Download IFrame --->
			<cfif prc.fbSettings.allowDownload>
			<iframe id="downloadIFrame" src="" style="display:none; visibility:hidden;"></iframe>
			</cfif>

			<!--- Selected Item & Type --->
			<input type="hidden" name="selectedItem" id="selectedItem" value="">
			<input type="hidden" name="selectedItemURL" id="selectedItemURL" value="">
			<input type="hidden" name="selectedItemID" id="selectedItemID" value="">
			<input type="hidden" name="selectedItemType" id="selectedItemType" value="file">

			<div id="statusButtons">
				<!--- Cancel Button --->
				<cfif len( rc.cancelCallback )>
					<input type="button" class="btn btn-danger btn-sm" id="bt_cancel" value="#$r( "cancel@fb" )#" onClick="#rc.cancelCallback#()"> &nbsp;
				</cfif>

				<!--- Select Item --->
				<cfif len( rc.callback )>
				<input type="button" class="btn btn-info btn-sm" id="bt_select"  value="#$r( "choose@fb" )#" onClick="fbChoose()" disabled="true" title="#$r( "choose.title@fb" )#">
				</cfif>
			</div>

			#announceInterception( "fb_postBottomBar" )#
		</div>
	</div>

</div> <!--- end panel FileBrowser --->

<!--- Hidden upload iframe --->
<iframe name="upload-iframe" id="upload-iframe" style="display: none"></iframe>
<form id="upload-form" name="upload-form" enctype="multipart/form-data" method="POST" target="upload-iframe" action="#event.buildLink( prc.xehFBUpload )#?#$safe( session.URLToken )#&folder=#prc.fbSafeCurrentRoot#">
	<input type="hidden" name="path" value='#prc.fbSafeCurrentRoot#' />
	<input type="hidden" name="manual" value="true" />
</form>
<!---Cancel: #rc.cancelCallBack#, Choose: #rc.callBack#
<cfdump var="#flash.getScope()#">--->
</cfoutput>