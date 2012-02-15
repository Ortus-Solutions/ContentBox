<!-----------------------------------------------------------------------
********************************************************************************
Copyright since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
----------------------------------------------------------------------->
<cfoutput>
<div id="FileBrowser">
	#html.startForm(name="filebrowser")#
	<div id="container">

		<!--- Roots
		<div style="float:right;margin-right:3px">
			<strong>Volumes:</strong>
			<select name="roots" id="roots" onChange="javascript:doEventNOUI('#rc.xehBrowser#','FileBrowser',{computerRoot:this.value})" style="width:50px">
				<cfloop from="1" to="#arrayLen(rc.roots)#" index="i">
				<option value="#urlEncodedFormat(rc.roots[i].getAbsolutePath())#" <cfif rc.roots[i].getAbsolutePath() eq rc.computerRoot>selected=selected</cfif>>#rc.roots[i].getAbsolutePath()#</option>
				</cfloop>
			</select>
		</div>
		--->

		<!--- Your Current Location --->
		<div id="titleBar">
			#announceInterception("fb_preTitleBar")#
			<div id="title">#prc.fbSettings.title#</div>

			<!--- Refresh --->
			<a href="javascript:fbRefresh()" title="Refresh Listing"><img src="#prc.fbModRoot#/includes/images/arrow_refresh.png"  border="0"></a>&nbsp;&nbsp;

			<!--- Home --->
			<a href="javascript:fbDrilldown()" title="Go Home"><img src="#prc.fbModRoot#/includes/images/home.png"  border="0"></a>&nbsp;&nbsp;

			<!--- New Folder --->
			<cfif prc.fbSettings.createFolders>
			<a href="javascript:fbNewFolder()" title="Create Folder"><img src="#prc.fbModRoot#/includes/images/folder_new.png" border="0"></a>&nbsp;&nbsp;
			</cfif>

			<!--- Rename --->
			<a href="javascript:fbRename()" title="Rename File-Folder"><img src="#prc.fbModRoot#/includes/images/rename.png" border="0"></a>&nbsp;&nbsp;

			<!--- Delete --->
			<cfif prc.fbSettings.deleteStuff>
			<a href="javascript:fbDelete()" title="Delete File-Folder"><img src="#prc.fbModRoot#/includes/images/cancel.png"  border="0"></a>&nbsp;&nbsp;
			</cfif>

			<!--- Upload --->
			<cfif prc.fbSettings.allowUploads>
			<a href="javascript:fbUpload()" title="Upload"><img src="#prc.fbModRoot#/includes/images/upload.png"  border="0"></a>&nbsp;&nbsp;
			</cfif>

			<!--- Download --->
			<cfif prc.fbSettings.allowDownload>
			<a href="javascript:fbDownload()" title="Download File"><img src="#prc.fbModRoot#/includes/images/download.png"  border="0"></a>&nbsp;&nbsp;
			</cfif>
			
			<!--- Quick View --->
			<a href="javascript:fbQuickView()" title="QuickView"><img src="#prc.fbModRoot#/includes/images/camera.png"  border="0"></a>&nbsp;&nbsp;
			
			<!--- Sorting --->
			#html.label(field="fbSorting",content="Sort By: ")#
			#html.select(name="fbSorting",options="Name,Size,LastModified",selectedValue=prc.fbPreferences.sorting)#

			<!--- Quick Filter --->
			#html.label(field="fbQuickFilter",content="Quick Filter: ")#
			#html.textField(name="fbQuickFilter",size="20")#

			#announceInterception("fb_postTitleBar")#
		</div>

		<!--- UploadBar --->
		<div id="uploadBar">
			#announceInterception("fb_preUploadBar")#
			<input id="file_upload" name="file_upload" type="file" />
			#announceInterception("fb_postUploadBar")#
		</div>

		<!--- QuickViewBar --->
		<div id="quickViewBar">
			<img id="fbCloseButton" src="#prc.fbModRoot#/includes/images/x.png" alt="close"/>
			#announceInterception("fb_preQuickViewBar")#
			<div id="quickViewBarContents"></div>
			#announceInterception("fb_postQuickViewBar")#
		</div>

		<!--- Show the File Listing --->
		<div id="fileListing">
			#announceInterception("fb_preFileListing")#
			<!--- Messagebox --->
			#getPlugin("MessageBox").renderit()#

			<!--- Display back links --->
			<cfif prc.fbCurrentRoot NEQ prc.fbDirRoot>
				<a href="javascript:fbDrilldown('#$getBackPath(prc.fbCurrentRoot)#')" title="Go Back"><img src="#prc.fbModRoot#/includes/images/folder.png" border="0"  alt="Folder"></a>
				<a href="javascript:fbDrilldown('#$getBackPath(prc.fbCurrentRoot)#')" title="Go Back">..</a><br>
			</cfif>

			<!--- Display directories --->
			<cfif prc.fbqListing.recordcount>
			<cfloop query="prc.fbqListing">

				<!--- Check Name Filter --->
				<cfif NOT reFindNoCase(prc.fbNameFilter, prc.fbqListing.name)> <cfcontinue> </cfif>

				<!--- ID Name of the div --->
				<cfset validIDName = $validIDName( prc.fbqListing.name ) >
				<!--- URL used for selection --->
				<cfset plainURL = prc.fbCurrentRoot & "/" & prc.fbqListing.name>
				<cfset relURL = $getUrlRelativeToPath(prc.fbwebRootPath,plainURL)>

				<!--- Directory or File --->
				<cfif prc.fbqListing.type eq "Dir">
					<!--- Folder --->
					<div id="#validIDName#"
						 onClick="fbSelect('#validIDName#','#JSStringFormat(plainURL)#')"
						 class="folders filterDiv"
						 data-type="dir"
						 data-name="#prc.fbqListing.Name#"
						 data-fullURL="#plainURL#"
						 data-relURL="#relURL#"
						 data-lastModified="#prc.fbqListing.dateLastModified#"
						 data-size="#numberFormat(prc.fbqListing.size/1024)#"
						 data-quickview="false"
						 onDblclick="fbDrilldown('#JSStringFormat(plainURL)#')">
						<a href="javascript:fbDrilldown('#JSStringFormat(plainURL)#')"><img src="#prc.fbModRoot#/includes/images/folder.png" border="0"  alt="Folder"></a>
						#prc.fbqListing.name#
					</div>
				<cfelseif prc.fbSettings.showFiles>
					<!--- Display the DiV --->
					<div id="#validIDName#"
						 class="files filterDiv"
						 data-type="file"
						 data-name="#prc.fbqListing.Name#"
						 data-fullURL="#plainURL#"
						 data-relURL="#relURL#"
						 data-lastModified="#prc.fbqListing.dateLastModified#"
						 data-size="#numberFormat(prc.fbqListing.size/1024)#"
						 data-quickview="#validQuickView( listLast(prc.fbQListing.name,".") )#"
						 onClick="fbSelect('#validIDName#','#JSStringFormat(plainURL)#')">
						<img src="#prc.fbModRoot#/includes/images/#getImageFile(listLast(prc.fbQListing.name,"."))#" border="0"  alt="file">
						#prc.fbqListing.name#
					</div>
				</cfif>
			</cfloop>
			<cfelse>
			<em>Empty Directory.</em>
			</cfif>
			#announceInterception("fb_postFileListing")#
		</div> <!--- end fileListing --->

		<!--- Location Bar --->
		<div id="locationBar">
			#announceInterception("fb_preLocationBar")#
			#replace(prc.fbCurrentRoot,"/",'&nbsp;<img class="divider" src="#prc.fbModRoot#/includes/images/bullet_go.png" alt="arrow" />&nbsp;',"all")#
			(#prc.fbqListing.recordCount# items)
			#announceInterception("fb_postLocationBar")#
		</div>

		<!--- The Bottom Bar --->
		<div class="bottomBar">
			#announceInterception("fb_preBottomBar")#

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
				<cfif len(rc.cancelCallback)>
					<input type="button" id="bt_cancel" value="Cancel" onClick="#rc.cancelCallback#()"> &nbsp;
				</cfif>

				<!--- Select Item --->
				<cfif len(rc.callback)>
				<input type="button" id="bt_select"  value="Choose" onClick="fbChoose()" disabled="true" title="Choose selected file/directory">
				</cfif>
			</div>

			#announceInterception("fb_postBottomBar")#
		</div>

	</div>
	#html.endForm()#
	<!--- ContextMenus --->
	<ul id="fbContextMenu" class="contextMenu">
		<li class="quickview">
			<a href="##quickview">Quick View</a>
		</li>
		<cfif len(rc.callback)>
		<li class="select">
			<a href="##select">Select</a>
		</li>
		</cfif>
		<li class="rename">
			<a href="##rename">Rename</a>
		</li>
		<cfif prc.fbSettings.deleteStuff>
		<li class="delete">
			<a href="##delete">Delete</a>
		</li>
		</cfif>
		<cfif prc.fbSettings.allowDownload>
		<li class="download">
			<a href="##download">Download</a>
		</li>
		</cfif>
	</ul>
	<ul id="fbContextMenuDirectories" class="contextMenu">
		<cfif len(rc.callback)>
		<li class="select">
			<a href="##select">Select</a>
		</li>
		</cfif>
		<li class="rename">
			<a href="##rename">Rename</a>
		</li>
		<cfif prc.fbSettings.deleteStuff>
		<li class="delete">
			<a href="##delete">Delete</a>
		</li>
		</cfif>
	</ul>
</div>

<!---Cancel: #rc.cancelCallBack#, Choose: #rc.callBack#
<cfdump var="#flash.getScope()#">--->

</cfoutput>