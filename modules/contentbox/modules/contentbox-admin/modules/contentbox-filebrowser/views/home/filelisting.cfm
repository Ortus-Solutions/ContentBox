<cfscript>
	/**
	 * --------------------------------------------------------------------------
	 * CODLFUSION HELPER METHODS
	 * --------------------------------------------------------------------------
	 */
	function $getBackPath( inPath ){
		arguments.inPath = replace( arguments.inPath, "\", "/", "all" );
		var lFolder = listLast( arguments.inPath, "/" );
		return URLEncodedFormat( left( arguments.inPath, len( arguments.inPath ) - len( lFolder ) ) );
	}
	function $getUrlRelativeToPath( required basePath, required filePath, encodeURL=false ){
		var URLOut = "";
		var strURLOut = "/";
		var arrPath = [];
		var p = "";
		URLOut = replace( replacenocase( arguments.filePath, arguments.basePath, "/", "one" ), "\", "/", "all" );
		if ( arguments.encodeURL ){
			arrPath=listtoarray( URLOut, "/" );
			for( p in arrPath ){
				strURLOut = listAppend( strURLOut, replacenocase( urlencodedformat( p ), "%2e", ".", "all" ), "/" );
			}
			URLOut = strURLOut;
		}
		URLOut = replacenocase( URLOut, "//", "", "all" );
		return URLOut;
	}
	function $getURLMediaPath( required fbDirRoot, required filePath ){
		var URLOut = replaceNoCase( arguments.filePath, arguments.fbDirRoot, "", "all" );
		if( len( URLOut ) ){
			URLOut = prc.fbSettings.mediaPath & URLOut;
		}
		return URLOut;
	}
	function validQuickView( ext ){
		return ( listFindNoCase( "png,jpg,jpeg,bmp,gif", arguments.ext ) ? true : false );
	}
	function getImageFile( ext ){
		switch( arguments.ext ){
			case "doc" : case "docx" : case "pages" : { return "word.png"; }
			case "ppt" : case "pptx" : case "keynote" : { return "ppt.png"; }
			case "xls" : case "xlsx" : case "numbers" : { return "xls.png"; }
			case "pdf" : { return "pdf.png"; }
			case "png": case "jpg" : case "jpeg" : case "gif" : case "bmp" : { return "Picture.png"; }
			case "cfc": case "cfm" : case "cfml" : { return "coldfusion.png"; }
			case "html" : case "htm" : case "aspx" : case "asp" : case "php" : case "rb" : case "py" : case "xml" :{ return "code.png"; }
			default : return "file.png";
		}
	}
</cfscript>
<cfoutput>
<div class="clear-both">
	<!--- Current Root --->
	<input type="hidden" name="fbRoot" id="fbRoot" value="#prc.fbSafeCurrentRoot#">

	<!--- Event --->
	#announce( "fb_preFileListing" )#

	<!--- Messagebox --->
	#cbMessageBox().renderit()#

	<!--- Location Bar --->
	<div id="locationBar" class="clear-both mb10 well well-sm">
		#announce( "fb_preLocationBar" )#
		<cfset crumbDir = "">
		<cfset rootPath = replaceNoCase( prc.fbCurrentRoot, prc.fbSettings.directoryRoot, "" )>
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
		(#prc.fbqListing.recordCount# #$r( "items@fb" )#)
		#announce( "fb_postLocationBar" )#
	</div>

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
				<cfcontinue>
			</cfif>

			<!--- Include Filters --->
			<cfif NOT reFindNoCase( prc.fbNameFilter, prc.fbqListing.name )><cfcontinue></cfif>

			<!--- ID Name of the div --->
			<cfset validIDName = encodeForHTMLAttribute( replace( prc.fbqListing.name, ".", "_" ) ) >

			<!--- URL used for selection --->
			<cfset plainURL = prc.fbCurrentRoot & "/" & prc.fbqListing.name>
			<cfset relURL = $getUrlRelativeToPath( prc.fbwebRootPath, plainURL )>
			<cfset mediaURL = ( ( prc.fbSettings.useMediaPath ) ? $getURLMediaPath( prc.fbDirRoot, plainURL ) : relURL )>

			<!--- ************************************************* --->
			<!--- GRID --->
			<!--- ************************************************* --->
			<cfif prc.fbPreferences.listType eq "grid">
				<!---Grid Listing --->
				<div class="fbItemBox filterDiv rounded">
					<div class="fbItemBoxPreview">

						<!--- ************************************************* --->
						<!--- DIRECTORY --->
						<!--- ************************************************* --->
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
						<!--- ************************************************* --->
						<!--- FILES --->
						<!--- ************************************************* --->
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
									onDblclick="fbChoose()"
							>
								<!--- Preview --->
								<cfif validQuickView( listLast( prc.fbQListing.name, "." ) )>
									<img
										src="#event.buildLink( prc.xehFBDownload )#?path=#plainURL#"
										border="0"
										alt="quickview"
										class="mt5"
										style="max-width: 140px; max-height: 100px"
									>
								<cfelse>
									<img
										src="#prc.fbModRoot#/includes/images/bigfile.png"
										border="0"
										class="mt5"
										alt="file"
									>
								</cfif>

								<!--- FileName --->
								<div class="mt5">
									#prc.fbqListing.name#
								</div>

								<!--- File Size --->
								<div class="text-muted mt5">
									(#numberFormat( prc.fbqListing.size / 1024 )# kb)
								</div>
							</div>
						</cfif>
					</div>
				</div>
			<!--- ************************************************* --->
			<!--- LISTING --->
			<!--- ************************************************* --->
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
							onDblclick="fbChoose()"
						>
						<img
							src="#prc.fbModRoot#/includes/images/#getImageFile( listLast( prc.fbQListing.name, "." ) )#"
							border="0"
							alt="file">
						#prc.fbqListing.name#
					</div>
				</cfif>
			</cfif>
		</cfloop>
	<cfelse>
		<em>#$r( "emptydirectory@fb" )#</em>
	</cfif>

	#announce( "fb_postFileListing" )#
</div>
<script>
( () => {
	// activate tooltips
	$( '[data-toggle="tooltip"]' ).tooltip();

	// Build out the context menus for files
    $.contextMenu({
        selector: '.files',
        callback: ( key, options ) => {
            var m = "clicked: " + key;
            window.console && console.log( m ) || alert( m );
        },
        items: {
            "Quick view": {
				name: "#$r( "quickview@fb" )#",
				callback: () => { return fbQuickView(); }
			},
            "Rename": {
				name: "#$r( "rename@fb" )#",
				callback: () => { return fbRename(); }
			},
           "Delete": {
			   name: "#$r( "delete@fb" )#",
			   callback: () => { return fbDelete(); }
			},
            "Download": {
				name: "#$r( "download@fb" )#",
				callback: () => { return fbDownload(); }
			},
            "URL": {
				name: "URL",
				callback: () => { return fbUrl(); }
			},
            "sep1": "---------",
            "edit": {
				name: "#$r( "edit@fb" )#",
				callback: () => { return fbEdit(); }
			},
            "info": {
				name: "#$r( "info@fb" )#",
				callback: () => { return fbInfo(); }
			}
        }
    });

	// Context menu for folders
    $.contextMenu({
        selector: '.folders',
        callback: ( key, options ) => {
            var m = "clicked: " + key;
            window.console && console.log(m) || alert(m);
        },
        items: {
            "Rename": {
				name: "Rename",
				callback: () => { return fbRename(); }
			},
           "Delete": {
			   name: "Delete", callback: () => { return fbDelete(); }
			}
        }
    });

	$('.files,.folders').on( 'click contextmenu', function( e ){
		// history cleanup
		if( !e.ctrlKey ){
			$selectedItemType.val( '' );
			$selectedItemID.val( '' );
			$selectedItem.val( '' );
			$selectedItemURL.val( '' );
			for ( var i in fbSelectHistory ){
				$( "##" + fbSelectHistory[ i ] ).removeClass( "selected" );
			}
			fbSelectHistory = [];
		}
		// highlight selection
		var $sItem = $( this );
		$sItem.addClass( "selected" );
		if( $selectedItemType.val() != '' ){
			var selectedDataType = $selectedItemType.val();
			$selectedItemType.val( selectedDataType + '||' + $sItem.attr( "data-type" ) );
		}else{
			$selectedItemType.val( $sItem.attr( "data-type" ) );
		}
		if( $selectedItemID.val() != '' ){
			var selectedIds = $selectedItemID.val();
			$selectedItemID.val( selectedIds + '||' + $sItem.attr( "id" ) );
		}else{
			$selectedItemID.val( $sItem.attr( "id" ) );
		}
		// save selection
		if( $selectedItem.val() != '' ){
			var selectedFiles = $selectedItem.val();
			$selectedItem.val( selectedFiles + '||' + $sItem.attr( "data-fullURL" ) );
		}else{
			$selectedItem.val( $sItem.attr( "data-fullURL" ) );
		}
		if( $selectedItemURL.val() != '' ){
			var selectedURL = $selectedItemURL.val();
			$selectedItemURL.val( selectedURL + '||' + $sItem.attr( "data-relURL" ) );
		}else{
			$selectedItemURL.val( $sItem.attr( "data-relURL" ) );
		}
		// history set
		fbSelectHistory.push( $sItem.attr( "id" ) );
		// status text
		$statusText.text( $sItem.attr( "data-name" )+' ('+ $sItem.attr( "data-size" )+'KB '+$sItem.attr( "data-lastModified" )+')');
		// enable selection button
		$selectButton.attr( "disabled", false );
    })

} )();
</script>
</cfoutput>
