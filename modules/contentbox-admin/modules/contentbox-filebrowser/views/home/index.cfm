<!-----------------------------------------------------------------------
********************************************************************************
Copyright since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
----------------------------------------------------------------------->
<cfoutput>
<div id="FileBrowser">
	#html.startForm( name="filebrowser" )#
	<div id="container">

		<!--- Roots
		<div style="float:right;margin-right:3px">
			<strong>Volumes:</strong>
			<select name="roots" id="roots" onChange="javascript:doEventNOUI('#rc.xehBrowser#','FileBrowser',{computerRoot:this.value} )" style="width:50px">
				<cfloop from="1" to="#arrayLen(rc.roots)#" index="i">
				<option value="#urlEncodedFormat(rc.roots[i].getAbsolutePath())#" <cfif rc.roots[i].getAbsolutePath() eq rc.computerRoot>selected=selected</cfif>>#rc.roots[i].getAbsolutePath()#</option>
				</cfloop>
			</select>
		</div>
		--->

		<!--- Your Current Location --->
		<div id="titleBar">
			#announceInterception( "fb_preTitleBar" )#
			<div id="title">#prc.fbSettings.title#</div>

			<!--- Refresh --->
			<a href="javascript:fbRefresh()" title="#r( "refresh@fb" )#"><img src="#prc.fbModRoot#/includes/images/arrow_refresh.png"  border="0"></a>&nbsp;&nbsp;

			<!--- Home --->
			<a href="javascript:fbDrilldown()" title="#r( "home@fb" )#"><img src="#prc.fbModRoot#/includes/images/home.png"  border="0"></a>&nbsp;&nbsp;

			<!--- New Folder --->
			<cfif prc.fbSettings.createFolders>
			<a href="javascript:fbNewFolder()" title="#r( "newfolder@fb" )#"><img src="#prc.fbModRoot#/includes/images/folder_new.png" border="0"></a>&nbsp;&nbsp;
			</cfif>

			<!--- Rename --->
			<a href="javascript:fbRename()" title="#r( "rename@fb" )#"><img src="#prc.fbModRoot#/includes/images/rename.png" border="0"></a>&nbsp;&nbsp;

			<!--- Delete --->
			<cfif prc.fbSettings.deleteStuff>
			<a href="javascript:fbDelete()" title="#r( "delete@fb" )#"><img src="#prc.fbModRoot#/includes/images/cancel.png"  border="0"></a>&nbsp;&nbsp;
			</cfif>

			<!--- Upload --->
			<cfif prc.fbSettings.allowUploads>
			<a href="javascript:fbUpload()" title="#r( "upload@fb" )#"><img src="#prc.fbModRoot#/includes/images/upload.png"  border="0"></a>&nbsp;&nbsp;
			</cfif>

			<!--- Download --->
			<cfif prc.fbSettings.allowDownload>
			<a href="javascript:fbDownload()" title="#r( "download@fb" )#"><img src="#prc.fbModRoot#/includes/images/download.png"  border="0"></a>&nbsp;&nbsp;
			</cfif>

			<!--- Quick View --->
			<a href="javascript:fbQuickView()" title="#r( "quickview@fb" )#"><img src="#prc.fbModRoot#/includes/images/camera.png"  border="0"></a>&nbsp;&nbsp;

			<!--- Sorting --->
			#html.label( field="fbSorting", content=r( "sortby@fb" ))#
			#html.select( name="fbSorting", options=r( "sortoptions@fb" ), selectedValue=prc.fbPreferences.sorting)#

			<!--- Quick Filter --->
			#html.label( field="fbQuickFilter", content=r( "quickfilter@fb" ) )#
			#html.textField( name="fbQuickFilter", size="20" )#

			<!---Grid or listing --->
			&nbsp;
			<a href="javascript:fbListTypeChange('listing')" title="#r( "filelisting@fb" )#" <cfif prc.fbPreferences.listType eq "listing">class="listTypeOn"</cfif>><img src="#prc.fbModRoot#/includes/images/text-list-icon.png"  border="0"></a>&nbsp;&nbsp;
			<a href="javascript:fbListTypeChange('grid')" title="#r( "gridlisting@fb" )#" <cfif prc.fbPreferences.listType eq "grid">class="listTypeOn"</cfif>><img src="#prc.fbModRoot#/includes/images/horizontal-list-icon.png"  border="0"></a>&nbsp;&nbsp;
			#html.hiddenField( name="listType", value=prc.fbPreferences.listType )#

			<!---event --->
			#announceInterception( "fb_postTitleBar" )#
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
						<a href="##" class="btn fileupload-exists" data-dismiss="fileupload">Remove</a>
						<span id="file_uploader_button" class="btn btn-primary">Upload</span>
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
		<div id="uploaderHelp">#r( "dragdrop@fb" )#</div>
			
		<!--- Show the File Listing --->
		<div id="fileListing">
			
			<!---Clear Fix --->
			<div style="clear:both"></div>
			
			<!---Upload Message Bar --->
			<div id="fileUploaderMessage">#r( "dropupload@fb" )#</div>
			
			#announceInterception( "fb_preFileListing" )#
			<!--- Messagebox --->
			#getModel( "messagebox@cbMessagebox" ).renderit()#

			<!--- Display back links --->
			<cfif prc.fbCurrentRoot NEQ prc.fbDirRoot>
				<cfif prc.fbPreferences.listType eq "grid">
					<div class="fbItemBox">
						<div class="fbItemBoxPreview">
							<a href="javascript:fbDrilldown('#$getBackPath(prc.fbCurrentRoot)#')" title="#r( "back@fb" )#"><img src="#prc.fbModRoot#/includes/images/directory.png" border="0"  alt="Folder"></a>
							<br>
							<a href="javascript:fbDrilldown('#$getBackPath(prc.fbCurrentRoot)#')" title="Go Back"> <- #r( "back@fb" )#
							</a>
						</div>
					</div>
				<cfelse>
					<a href="javascript:fbDrilldown('#$getBackPath(prc.fbCurrentRoot)#')" title="#r( "back@fb" )#"><img src="#prc.fbModRoot#/includes/images/folder.png" border="0"  alt="Folder"></a>
					<a href="javascript:fbDrilldown('#$getBackPath(prc.fbCurrentRoot)#')" title="#r( "back@fb" )#">..</a><br>
				</cfif>
			</cfif>

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
				<cfif skipExcludes><cfcontinue></cfif>

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
									 class="folders"
									 data-type="dir"
									 data-name="#prc.fbqListing.Name#"
									 data-fullURL="#plainURL#"
									 data-relURL="#relURL#"
									 data-lastModified="#prc.fbqListing.dateLastModified#"
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
									 data-lastModified="#prc.fbqListing.dateLastModified#"
									 data-size="#numberFormat( prc.fbqListing.size / 1024 )#"
									 data-quickview="#validQuickView( listLast( prc.fbQListing.name, "." ) )#"
									 onClick="fbSelect('#validIDName#','#JSStringFormat( plainURL )#')"
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
							 class="folders filterDiv"
							 data-type="dir"
							 data-name="#prc.fbqListing.Name#"
							 data-fullURL="#plainURL#"
							 data-relURL="#relURL#"
							 data-lastModified="#prc.fbqListing.dateLastModified#"
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
							 data-lastModified="#prc.fbqListing.dateLastModified#"
							 data-size="#numberFormat( prc.fbqListing.size / 1024 )#"
							 data-quickview="#validQuickView( listLast( prc.fbQListing.name, "." ) )#"
							 onClick="fbSelect('#validIDName#','#JSStringFormat( plainURL )#')"
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
			<em>#r( "emptydirectory@fb" )#</em>
			</cfif>
			#announceInterception( "fb_postFileListing" )#
		</div> <!--- end fileListing --->
		
		<!--- Location Bar --->
		<div id="locationBar">
			#announceInterception( "fb_preLocationBar" )#
			#replace( prc.fbCurrentRoot, "/", '&nbsp;<img class="divider" src="#prc.fbModRoot#/includes/images/bullet_go.png" alt="arrow" />&nbsp;', "all" )#
			(#prc.fbqListing.recordCount# #r( "items@fb" )#)
			#announceInterception( "fb_postLocationBar" )#
		</div>

		<!--- The Bottom Bar --->
		<div class="bottomBar">
			#announceInterception( "fb_preBottomBar" )#

			<!--- Loader Bar --->
			<div id="loaderBar">
				<img src="#prc.fbModRoot#/includes/images/ajax-loader.gif" />
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
					<input type="button" id="bt_cancel" value="#r( "cancel@fb" )#" onClick="#rc.cancelCallback#()"> &nbsp;
				</cfif>

				<!--- Select Item --->
				<cfif len( rc.callback )>
				<input type="button" id="bt_select"  value="#r( "choose@fb" )#" onClick="fbChoose()" disabled="true" title="#r( "choose.title@fb" )#">
				</cfif>
			</div>

			#announceInterception( "fb_postBottomBar" )#
		</div>

	</div>
	#html.endForm()#
	<!--- ContextMenus --->
	<ul id="fbContextMenu" class="contextMenu">
		<li class="quickview">
			<a href="##quickview">#r( "quickview@fb" )#</a>
		</li>
		<cfif len( rc.callback )>
		<li class="select">
			<a href="##select">#r( "select@fb" )#</a>
		</li>
		</cfif>
		<li class="rename">
			<a href="##rename">#r( "rename@fb" )#</a>
		</li>
		<cfif prc.fbSettings.deleteStuff>
		<li class="delete">
			<a href="##delete">#r( "delete@fb" )#</a>
		</li>
		</cfif>
		<cfif prc.fbSettings.allowDownload>
		<li class="download">
			<a href="##download">#r( "download@fb" )#</a>
		</li>
		</cfif>
		<li class="link">
			<a href="##url">URL</a>
		</li>
	</ul>
	<ul id="fbContextMenuDirectories" class="contextMenu">
		<cfif len( rc.callback )>
		<li class="select">
			<a href="##select">#r( "select@fb" )#</a>
		</li>
		</cfif>
		<li class="rename">
			<a href="##rename">#r( "rename@fb" )#</a>
		</li>
		<cfif prc.fbSettings.deleteStuff>
		<li class="delete">
			<a href="##delete">#r( "delete@fb" )#</a>
		</li>
		</cfif>
	</ul>
</div>
<iframe name="upload-iframe" id="upload-iframe" style="display: none"></iframe>
<form id="upload-form" name="upload-form" enctype="multipart/form-data" method="POST" target="upload-iframe" action="#event.buildLink( prc.xehFBUpload )#?#$safe( session.URLToken )#&folder=#prc.fbSafeCurrentRoot#">
	<input type="hidden" name="path" value='#prc.fbSafeCurrentRoot#' />
	<input type="hidden" name="manual" value="true" />
</form>
<!---Cancel: #rc.cancelCallBack#, Choose: #rc.callBack#
<cfdump var="#flash.getScope()#">--->

</cfoutput>