<!-----------------------------------------------------------------------
********************************************************************************
Copyright since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
----------------------------------------------------------------------->
<cfparam name="prc.fbPreferences.listFolder" default="">
<cfoutput>
<cfif prc.widget>
	<h3>ContentBox Media Manager</h3>
</cfif>
<div class="panel panel-default" id="FileBrowser" >

	<!--- Panel Heading: Tool Bar --->
	<div class="panel-heading" id="FileBrowser-heading">
	#html.startForm( name="filebrowser", class="form-inline", onkeypress="return event.keyCode != 13;", onsubmit="event.preventDefault();" )#
		#announceInterception( "fb_preTitleBar" )#

		<div class="btn-group btn-group-sm" role="group">
		  <a href="javascript:fbRefresh()" class="btn btn-info"  data-toggle="tooltip"  data-container="body" title="#$r( "refresh@fb" )#">
		  	<i class="fa fa-refresh"></i>
		  </a>
		  <a href="javascript:fbDrilldown()" class="btn btn-info"  data-toggle="tooltip"  data-container="body" title="#$r( "home@fb" )#">
		  	<i class="fa fa-home"></i>
		  </a>
		</div>

		<div class="btn-group btn-group-sm" role="group">
		  <a onclick="javascript:fbNewFolder();" class="btn btn-info"  data-toggle="tooltip"  data-container="body" title="#$r( "newFolder@fb" )#">
		  	<i class="fa fa-folder-open-o"></i>
		  </a>
		  <a onclick="javascript:fbRename()" class="btn btn-info"  data-toggle="tooltip"  data-container="body" title="#$r( "rename@fb" )#">
		  	<i class="fa fa-terminal"></i>
		  </a>
		  <a onclick="javascript:fbDelete()" class="btn btn-info"  data-toggle="tooltip"  data-container="body" title="#$r( "delete@fb" )#">
		  	<i class="fa fa-times"></i>
		  </a>
		  <a onclick="javascript:fbUpload()" class="btn btn-info"  data-toggle="tooltip"  data-container="body" title="#$r( "upload@fb" )#">
		  	<i class="fa fa-upload"></i>
		  </a>
		  <a onclick="javascript:fbDownload()" class="btn btn-info"  data-toggle="tooltip"  data-container="body" title="#$r( "download@fb" )#">
		  	<i class="fa fa-download"></i>
		  </a>
		  <a onclick="javascript:fbQuickView()" class="btn btn-info"  data-toggle="tooltip"  data-container="body" title="#$r( "quickview@fb" )#">
		  	<i class="fa fa-camera"></i>
		  </a>
		</div>

		<!---Grid or listing --->

		<div class="btn-group btn-group-sm" role="group">
		  <a href="javascript:fbListTypeChange('listing','all')" class="btn btn-info"  data-toggle="tooltip"  data-container="body" title="#$r( "filelisting@fb" )#">
		  	<i class="fa fa-list-ul"></i>
		  </a>
		  <a href="javascript:fbListTypeChange('grid','all')" class="btn btn-info"  data-toggle="tooltip"  data-container="body" title="#$r( "gridlisting@fb" )#">
		  	<i class="fa fa-th"></i>
		  </a>
		</div>

		<!---Grid or listing of Directories--->

		<div class="btn-group btn-group-sm" role="group">
			<a href="javascript:fbListTypeChange('listing','dir')" class="btn btn-info"  data-toggle="tooltip" data-container="body" title="#$r( "directorylistview@fb" )#">
				<i class="fa fa-align-justify"></i>
			</a>
			<a href="javascript:fbListTypeChange('grid','dir')" class="btn btn-info"  data-toggle="tooltip" data-container="body" title="#$r( "directorygridview@fb" )#">
				<i class="fa fa-folder"></i>
			</a>
		</div>

		<div class="form-group">
			<!--- Sorting --->
			#html.label( field="fbSorting", content=$r( "sortby@fb" ))#
			#html.select( name="fbSorting", class="form-control", options=$r( "sortoptions@fb" ), selectedValue=prc.fbPreferences.sorting)#
		</div>
		<div class="form-group pull-right">
			<!--- Quick Filter --->
			#html.label( field="fbQuickFilter", content=$r( "quickfilter@fb" ) )#
			#html.textField( name="fbQuickFilter", class="form-control" )#
		</div>
		#html.hiddenField( name="listType", value=prc.fbPreferences.listType )#
		#html.hiddenField( name="listFolder", value=prc.fbPreferences.listFolder )#

		<!---event --->
		#announceInterception( "fb_postTitleBar" )#
	#html.endForm()#
	</div>
	<!---/ end panel heading --->

	<div class="panel-body" id="FileBrowser-body">

		<!--- UploadBar --->
		<div id="uploadBar">
			#announceInterception( "fb_preUploadBar" )#

			<div class="row">
				<div class="form-group col-md-6">
					<div class="controls" id="manual_upload_wrapper">
		                <div class="fileinput fileinput-new input-group" data-provides="fileinput" id="filewrapper">
		                    <div class="form-control" data-trigger="fileinput" style="height:auto">
		                        <i class="fa fa-file fileinput-exists"></i> <span class="fileinput-filename"></span>
		                    </div>
		                    <span class="input-group-addon btn btn-default btn-file">
		                        <span class="fileinput-new">Select file</span>
		                        <span class="fileinput-exists">Change</span>
									<input type="file" name="FILEDATA" id="file_uploader" />
									#html.hiddenField( name="validated", value="false" )#
									#html.hiddenField( name="overwrite", value="false" )#
		                    </span>
		            		<a href="javascript:void(0)" class="input-group-addon btn btn-default fileinput-exists" data-dismiss="fileinput">Remove</a>
		            	</div>
					</div>
			    </div>
			    <div class="col-md-6 text-left">
					<span id="file_uploader_button" class="btn btn-primary hidden">Upload</span>
			    </div>
			</div>
			#announceInterception( "fb_postUploadBar" )#
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
							<a href="javascript:fbDrilldown('#$getBackPath(prc.fbCurrentRoot)#')" title="#$r( "back@fb" )#">
								<img src="#prc.fbModRoot#/includes/images/directory.png" border="0"  alt="Folder">
							</a>
							<br>
							<a href="javascript:fbDrilldown('#$getBackPath(prc.fbCurrentRoot)#')" title="Go Back"> <- #$r( "back@fb" )#
							</a>
						</div>
					</div>
				<cfelse>
					<a href="javascript:fbDrilldown('#$getBackPath(prc.fbCurrentRoot)#')" title="#$r( "back@fb" )#">
						<img src="#prc.fbModRoot#/includes/images/folder.png" border="0"  alt="Folder">
					</a>
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
								<div id="fb-dir-#validIDName#"
									 onClick="javascript:return false;"
									 class="folders"
									 title="#prc.fbqListing.name#"
									 data-type="dir"
									 data-name="#prc.fbqListing.Name#"
									 data-fullURL="#plainURL#"
									 data-relURL="#relURL#"
									 data-lastModified="#dateFormat( prc.fbqListing.dateLastModified, "medium" )# #timeFormat( prc.fbqListing.dateLastModified, "medium" )#"
									 data-size="#numberFormat( prc.fbqListing.size / 1024 )#"
									 data-quickview="false"
									 onDblclick="fbDrilldown('#JSStringFormat( plainURL )#')">
									<a href="javascript:fbDrilldown('#JSStringFormat( plainURL )#')"><img src="#prc.fbModRoot#/includes/images/directory.png" border="0"  alt="Folder"></a>
									<br/>
									#prc.fbqListing.name#
								</div>
							<cfelseif prc.fbSettings.showFiles>
								<!--- Display the DiV --->
								<div id="fb-file-#validIDName#"
									 class="files"
									 data-type="file"
									 data-name="#prc.fbqListing.Name#"
									 title="#prc.fbqListing.name# (#numberFormat( prc.fbqListing.size / 1024 )# kb)"
									 data-fullURL="#plainURL#"
									 data-relURL="#mediaURL#"
									 data-lastModified="#dateFormat( prc.fbqListing.dateLastModified, "medium" )# #timeFormat( prc.fbqListing.dateLastModified, "medium" )#"
									 data-size="#numberFormat( prc.fbqListing.size / 1024 )#"
									 data-quickview="#validQuickView( listLast( prc.fbQListing.name, "." ) )#"
									 onClick="javascript:return false;"
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
						<div id="fb-dir-#validIDName#"
							 class="folders filterDiv"
							 data-type="dir"
							 data-name="#prc.fbqListing.Name#"
							 data-fullURL="#plainURL#"
							 data-relURL="#relURL#"
							 data-lastModified="#dateFormat( prc.fbqListing.dateLastModified, "medium" )# #timeFormat( prc.fbqListing.dateLastModified, "medium" )#"
							 data-size="#numberFormat( prc.fbqListing.size / 1024 )#"
							 data-quickview="false"
							 onDblclick="fbDrilldown('#JSStringFormat( plainURL )#')">
							<a href="javascript:fbDrilldown('#JSStringFormat( plainURL )#')"><img src="#prc.fbModRoot#/includes/images/folder.png" border="0"  alt="Folder"></a>
							#prc.fbqListing.name#
						</div>
					<cfelseif prc.fbSettings.showFiles>
						<!--- Display the DiV --->
						<div id="fb-file-#validIDName#"
							 class="files filterDiv"
							 data-type="file"
							 data-name="#prc.fbqListing.Name#"
							 data-fullURL="#plainURL#"
							 data-relURL="#mediaURL#"
							 data-lastModified="#dateFormat( prc.fbqListing.dateLastModified, "medium" )# #timeFormat( prc.fbqListing.dateLastModified, "medium" )#"
							 data-size="#numberFormat( prc.fbqListing.size / 1024 )#"
							 data-quickview="#validQuickView( listLast( prc.fbQListing.name, "." ) )#"
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
			<cfset rootPath = replaceNoCase(prc.fbCurrentRoot, prc.fbSettings.directoryRoot, "")>
			/&nbsp;<cfif rootPath neq "">&nbsp;<i class="fa fa-chevron-right text-info"></i>&nbsp;</cfif>
			<cfloop list="#rootPath#" delimiters="/" index="crumb">
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
				<i class="fa fa-circle-notch fa-spin"></i> #$r( "common.loading@cbcore" )#
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
<form 	id="upload-form"
		name="upload-form"
		enctype="multipart/form-data"
		method="POST"
		target="upload-iframe"
		action="#event.buildLink( prc.xehFBUpload )#"
>
	<input type="hidden" name="path" value='#prc.fbSafeCurrentRoot#' />
	<input type="hidden" name="manual" value="true" />
</form>
<!---Cancel: #rc.cancelCallBack#, Choose: #rc.callBack#
<cfdump var="#flash.getScope()#">--->
</cfoutput>