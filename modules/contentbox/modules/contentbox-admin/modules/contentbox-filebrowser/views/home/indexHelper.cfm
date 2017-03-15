<!-----------------------------------------------------------------------
********************************************************************************
Copyright since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
----------------------------------------------------------------------->
<cfscript>
function $safe( str ){ return urlEncodedFormat( arguments.str ); }
function $validIDName( str ){ return JSStringFormat( html.slugify( arguments.str ) ); }
function $getBackPath( inPath ){
	arguments.inPath = replace( arguments.inPath, "\", "/", "all" );
	var lFolder = listLast( arguments.inPath, "/" );
	return URLEncodedFormat( left( arguments.inPath, len( arguments.inPath ) - len( lFolder ) ) );
}
function validQuickView( ext ){
	if( listFindNoCase( "png,jpg,jpeg,bmp,gif", ext ) ){ return "true"; }
	return "false";
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
</cfscript>
<cfoutput>
<!--- *************************************** DYNAMIC JS ******************************--->
<script language="javascript">
$( document ).ready( function() {
	$fileBrowser 		= $( "##FileBrowser" );
	$fileLoaderBar 		= $fileBrowser.find( "##loaderBar" );
	$fileUploaderMessage = $fileBrowser.find( "##fileUploaderMessage" );
	$fileListing 		= $fileBrowser.find( "##fileListing" );
	$selectedItem		= $fileBrowser.find( "##selectedItem" );
	$selectedItemURL	= $fileBrowser.find( "##selectedItemURL" );
	$selectedItemID		= $fileBrowser.find( "##selectedItemID" );
	$selectedItemType	= $fileBrowser.find( "##selectedItemType" );
	$statusText 		= $fileBrowser.find( "##statusText" );
	$selectButton		= $fileBrowser.find( "##bt_select" );
	$sorting			= $fileBrowser.find( "##fbSorting" );
	$listType			= $fileBrowser.find( "##listType" );
	$quickView			= $fileBrowser.find( "##quickViewBar" );
	$quickViewContents	= $fileBrowser.find( "##quickViewBarContents" );
	$quickViewCloseBtn	= $fileBrowser.find( "##fbCloseButton" );
	//disable it
	$selectButton.attr( "disabled",true);
	// history
	fbSelectHistory = "";
	// context menus
	$fileBrowser.find( ".files" ).contextmenu( { target : '##fbContextMenu' } );
	$fileBrowser.find( ".folders" ).contextmenu( { target : '##fbContextMenuDirectories' } );
	// Sorting
	$sorting.change(function(){ fbRefresh(); } );
	$quickViewCloseBtn.click(function(){ fbCloseQuickView(); } );
	// Quick div filter
	$fileBrowser.find( "##fbQuickFilter" ).keyup(function(){
		$.uiDivFilter( $( ".filterDiv" ), this.value);
	} )

} );
function fbCloseQuickView(){
	$quickView.slideUp();
	$quickViewContents.html( '' );
}
function fbListTypeChange( listType ){
	$listType.val( listType );
	fbRefresh();
}
function fbRefresh(){
	$fileLoaderBar.slideDown();
	$fileBrowser.load( '#event.buildLink( prc.xehFBBrowser )#',
		{ path:'#prc.fbSafeCurrentRoot#', sorting:$sorting.val(), listType: $listType.val() },
		function(){
			$fileLoaderBar.slideUp();
		} );
}
function fbDrilldown( inPath ){
	if( inPath == null ){ inPath = ""; }
	$fileLoaderBar.slideDown();
	$fileBrowser.load( '#event.buildLink( prc.xehFBBrowser )#', { path : inPath },function(){
		$fileLoaderBar.slideUp();
	} );
}
function fbSelect( sID, sPath ){
	// history cleanup
	if (fbSelectHistory.length) {
		$( "##" + fbSelectHistory ).removeClass( "selected" );
	}
	// highlight selection
	var $sItem = $( "##" + sID );
	$sItem.addClass( "selected" );
	$selectedItemType.val( $sItem.attr( "data-type" ) );
	$selectedItemID.val( $sItem.attr( "id" ) );
	// save selection
	$selectedItem.val( sPath );
	$selectedItemURL.val( $sItem.attr( "data-relURL" ) );
	// history set
	fbSelectHistory = sID;
	// status text
	$statusText.text( $sItem.attr( "data-name" )+' ('+ $sItem.attr( "data-size" )+'KB '+$sItem.attr( "data-lastModified" )+')');
	// enable selection button
	$selectButton.attr( "disabled", false );
}
function fbQuickView(){
	// check selection
	var sPath = $selectedItem.val();
	if( !sPath.length ){ alert( '#$r( "jsmessages.select@fb" )#' ); return; }
	// get ID
	var thisID 	= $selectedItemID.val();
	var target 	= $( "##"+thisID);
	// only images
	if( target.attr( "data-quickview" ) == "false" ){ alert( '#$r( "jsmessages.quickview_only_images@fb" )#' ); return; }
	// show it
	var imgURL = "#event.buildLink( prc.xehFBDownload )#?path="+ escape( target.attr( "data-fullURL" ) );
	$quickView.slideDown();
	$quickViewContents.html('<img src="'+imgURL+'" style="max-width:#prc.fbSettings.quickViewWidth#px"/>');
}
function fbRename(){
	// check selection
	var sPath = $selectedItem.val();
	if( !sPath.length ){ alert( '#$r( "jsmessages.select@fb" )#' ); return; }
	// get ID
	var thisID 		= $selectedItemID.val();
	var target 		= $( "##"+thisID);
	// prompt for new name
	var newName  = prompt( '#$r( "jsmessages.newname@fb" )#', target.attr( "data-name" ) );
	// do renaming if prompt not empty
	if( newName != null){
		$fileLoaderBar.slideDown();
		$.post( '#event.buildLink( prc.xehFBRename )#', 
			    { name : newName, path : target.attr( "data-fullURL" ) },
			    function( data ){
					if( data.errors ){ alert( data.messages ); }
					fbRefresh();
		}, "json" );
	}
}
function fbUrl(){
	// check selection
	var sPath = $selectedItem.val();
	if( !sPath.length ){ alert( '#$r( "jsmessages.select@fb" )#' ); return; }
	// get ID
	var thisID 		= $selectedItemID.val();
	var target 		= $( "##"+thisID);
	// prompt the URL
	var newName  = prompt( "URL:", "#event.buildLink( '' )#" + target.attr( "data-relurl" ) );
}
<!--- Create Folders --->
<cfif prc.fbSettings.createFolders>
function fbNewFolder(){
	var dName = prompt( '#$r( "jsmessages.newdirectory@fb" )#' );
	if( dName != null){
		$fileLoaderBar.slideDown();
		$.post( '#event.buildLink( prc.xehFBNewFolder )#',
				{ dName : dName, path : '#prc.fbSafeCurrentRoot#' },
				function( data ){
					if( data.errors ){ alert( data.messages ); }
					fbRefresh();
		},"json" );
	}
}
</cfif>
<!--- Remove Stuff --->
<cfif prc.fbSettings.deleteStuff>
function fbDelete(){
	var sPath = $selectedItem.val();
	if( !sPath.length ){ alert( '#$r( "jsmessages.select@fb" )#' ); return; }
	if( confirm( '#$r( "jsmessages.delete_confirm@fb" )#' ) ){
		$fileLoaderBar.slideDown();
		$.post( '#event.buildLink( prc.xehFBRemove )#',
				{ path : sPath },
				function( data ){
					if( data.errors ){ alert(data.messages); }
					fbRefresh();
		},"json" );
	}
}
</cfif>
<!--- Download --->
<cfif prc.fbSettings.allowDownload>
function fbDownload(){
	var sPath = $selectedItem.val();
	var sType = $selectedItemType.val();
	if( !sPath.length ){ 
		alert( '#$r( "jsmessages.select@fb" )#' ); return; 
	} else if ( sType == "dir" ){ 
		alert( '#$r( "jsmessages.downloadFolder@fb" )#' ); return; 
	}
	// Trigger the download
	$( "##downloadIFrame" ).attr( "src","#event.buildLink( prc.xehFBDownload )#?path="+ escape(sPath) );
}
</cfif>
<!--- CallBack --->
<cfif len(rc.callback)>
function fbChoose(){
	var sPath = $selectedItem.val();
	var sURL = $selectedItemURL.val();
	var sType = $selectedItemType.val();
	#rc.callback#( sPath,sURL,sType );
}
</cfif>
</script>
<!--- Uploads Scripts --->
<cfif prc.fbSettings.allowUploads>
<script type="text/javascript">
$(document).ready(function() {
	$( '##file_uploader_button' ).on('click', function() {
		var iframe = $( '##upload-iframe' );
		var form = $( '##upload-form' );
		var field = $( '##filewrapper' );
		var wrapper = $( '##manual_upload_wrapper' );
		wrapper.append( '<p id="upload_message">Uploading your file...</p>' );
		// move to target form
		field.appendTo( form );
		field.hide();
		// submit the form; it's target is the iframe, so AJAX-ish upload style
		form.submit();
		// handle load method of iframe
		iframe.load(function() {
			try {
				// try to get JSON response from server in textfield
				var result = $( iframe.contents().text() );
				var JSON = $.parseJSON( result.val() );
				if( !JSON.ERRORS ) {
					fbRefresh();
				}
			}
			// errors? reset stuff and allow to try again
			catch( e ) {
				$( '##upload_message' ).remove();
				field.prependTo( wrapper );
				field.show();
			}
		} );
	} );
	
	// File drag and drop	
	$( "##FileBrowser-body" ).filedrop( {
		// The name of the $_FILES entry:
		paramname : 'FILEDATA',
		<cfif isNumeric( prc.fbSettings.html5uploads.maxfiles )>
		maxfiles: #prc.fbSettings.html5uploads.maxfiles#,
		</cfif>
		<cfif isNumeric( prc.fbSettings.html5uploads.maxfilesize )>
		maxfilesize: #prc.fbSettings.html5uploads.maxfilesize#, // in mb
		</cfif>
		<cfif len( prc.fbSettings.acceptMimeTypes )>
		allowedfiletypes : "#prc.fbSettings.acceptMimeTypes#".split( "," ),
		</cfif>
		url: '#event.buildLink( prc.xehFBUpload )#?#$safe( session.URLToken )#',
		data: {
	        path: '#prc.fbSafeCurrentRoot#'
	    },
		dragOver: function() {
			$fileListing.addClass( "fileListingUploading" );
			$fileUploaderMessage.fadeIn();
	    },
	    dragLeave: function() {
			$fileListing.removeClass( "fileListingUploading" );
			$fileUploaderMessage.fadeOut(); 
	    },
		drop: function() {
			$fileUploaderMessage.fadeOut();
	    },
		uploadFinished:function(i,file,response){
			$.data(file).addClass('done');
			fbRefresh();
			if( response.ERRORS ){
				alert( response.MESSAGES );
			}
		},
		error: function(err, file) {
			switch(err) {
				case 'BrowserNotSupported':
					alert( '#$r( "jsmessages.browsernotsupported@fb" )#' );
					break;
				case 'TooManyFiles':
					alert( '#$r( resource="jsmessages.toomanyfiles@fb", values=prc.fbSettings.html5uploads.maxfiles )#' );
					break;
				case 'FileTooLarge':
					alert( file.name + ' #$r( resource="jsmessages.toolarge@fb", values=prc.fbSettings.html5uploads.maxfilesize )#');
					break;
				case 'FileTypeNotAllowed':
					alert( file.type + ' #$r( resource="jsmessages.invalidtype@fb", values=prc.fbSettings.acceptMimeTypes )#' );
					break;
				default:
					break;
			}
			$fileListing.removeClass( "fileListingUploading" );
			$fileUploaderMessage.fadeOut(); 
		},
		uploadStarted:function( i, file, len ){
			//console.log( "uploading starting" + file );
			fbinitUploadFile( file );
		},
		progressUpdated: function( i, file, progress ) {
			$.data( file ).find( '.progress' ).width( progress );
			//console.log( "uploading progress" + progress );
		}
	} );
	// Progress template
	var template = '<div class="preview">'+
						'<span class="fileHolder"></span>'+
						'<div class="progressHolder">'+
							'<div class="progress"></div>'+
						'</div>'+
					'</div>';
	// when uploading files
	function fbinitUploadFile( file ){
		var preview = $( template );
		preview.find( ".fileHolder" ).html( "Uploading " + file.name );
		// Append preview
		preview.prependTo( $fileListing );
		// Associating a preview container with the file, using jQuery's $.data()
		$.data( file, preview );
	}
	
} );
function fbUpload(){
	$( "##uploadBar" ).slideToggle();
}
</script>
</cfif>
</cfoutput>