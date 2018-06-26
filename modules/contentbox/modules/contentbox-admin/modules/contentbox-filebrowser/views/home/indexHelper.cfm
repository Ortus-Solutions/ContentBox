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
	// reinitialize tooltip after refresh, do a try in case we are in Popup mode.
	try{
		$('[data-toggle="tooltip"]').tooltip();
	} catch( e ){}
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
	$listFolder			= $fileBrowser.find( "##listFolder" );
	$quickView			= $fileBrowser.find( "##quickViewBar" );
	$quickViewContents	= $fileBrowser.find( "##quickViewBarContents" );
	//disable it
	$selectButton.attr( "disabled",true);
	// history
	fbSelectHistory = [];
	// context menus
    $.contextMenu({
        selector: '.files', 
        callback: function(key, options) {
            var m = "clicked: " + key;
            window.console && console.log(m) || alert(m); 
        },
        items: {
            "Quick view": {name: "#$r( "quickview@fb" )#", icon: "fa-edit", callback: function(){
            	return fbQuickView();
            }},
            "Rename": {name: "#$r( "rename@fb" )#", icon: "fa-terminal", callback: function(){
            	return fbRename();
            }},
           "Delete": {name: "#$r( "delete@fb" )#", icon: "fa-times", callback: function(){
           	return fbDelete();
           }},
            "Download": {name: "#$r( "download@fb" )#", icon: "fa-download", callback: function(){
            	return fbDownload();
            }},
            "URL": {name: "URL", icon: "fa-link", callback: function(){
            	return fbUrl();
            }},
			<cfif !len( rc.callback )>
            "sep1": "---------",
            "edit": {name: "#$r( "edit@fb" )#", icon: "fa-edit", callback: function(){
            	return fbEdit();
            }},
            "info": {name: "#$r( "info@fb" )#", icon: "fa-info", callback: function(){
            	return fbInfo();
            }}
            </cfif>
        }
    });
    $.contextMenu({
        selector: '.folders', 
        callback: function(key, options) {
            var m = "clicked: " + key;
            window.console && console.log(m) || alert(m); 
        },
        items: {
            "Rename": {name: "Rename", icon: "fa-terminal", callback: function(){
            	return fbRename();
            }},
           "Delete": {name: "Delete", icon: "fa-times", callback: function(){
           	return fbDelete();
           }}
        }
    });
    $('.files,.folders').on('click contextmenu', function(e){
		// history cleanup
		if(!e.ctrlKey){
			$selectedItemType.val('');
			$selectedItemID.val('');
			$selectedItem.val('');
			$selectedItemURL.val('');
			for (var i in fbSelectHistory) {
				$( "##" + fbSelectHistory[i] ).removeClass( "selected" );
			}
			fbSelectHistory = [];
		}
		// highlight selection
		var $sItem = $(this);
		$sItem.addClass( "selected" );
		if($selectedItemType.val() != ''){
			var selectedDataType = $selectedItemType.val();
			$selectedItemType.val( selectedDataType + ',' + $sItem.attr( "data-type" ) );
		}else{
			$selectedItemType.val( $sItem.attr( "data-type" ) );
		}
		if($selectedItemID.val() != ''){
			var selectedIds = $selectedItemID.val();
			$selectedItemID.val( selectedIds + ',' + $sItem.attr( "id" ) );
		}else{
			$selectedItemID.val( $sItem.attr( "id" ) );
		}
		// save selection
		if($selectedItem.val() != ''){
			var selectedFiles = $selectedItem.val();
			$selectedItem.val( selectedFiles + ',' + $sItem.attr( "data-fullURL" ) );
		}else{
			$selectedItem.val( $sItem.attr( "data-fullURL" ) );
		}
		if($selectedItemURL.val() != ''){
			var selectedURL = $selectedItemURL.val();
			$selectedItemURL.val( selectedURL + ',' + $sItem.attr( "data-relURL" ) );
		}else{
			$selectedItemURL.val( $sItem.attr( "data-relURL" ) );
		}
		// history set
		fbSelectHistory.push($sItem.attr( "id" ));
		// status text
		$statusText.text( $sItem.attr( "data-name" )+' ('+ $sItem.attr( "data-size" )+'KB '+$sItem.attr( "data-lastModified" )+')');
		// enable selection button
		$selectButton.attr( "disabled", false );

    })  

	//$fileBrowser.find( ".files" ).contextmenu( { target : '##fbContextMenu' } );
	//$fileBrowser.find( ".folders" ).contextmenu( { target : '##fbContextMenuDirectories' } );
	// Sorting
	$sorting.change(function(){ fbRefresh(); } );
	// Quick div filter
	$fileBrowser.find( "##fbQuickFilter" ).keyup(function(){
		$.uiDivFilter( $( ".filterDiv" ), this.value);
	} )

} );
function noMultiSelectAction(){
	if( fbSelectHistory.length != 1 ){ alert( '#$r( "jsmessages.no_multi_select@fb" )#' ); return true; }
}
function fbListTypeChange( listType,file ){
	$listType.val( listType );
	$listFolder.val( file);
	fbRefresh();
}
function fbRefresh(){
	$('.tooltip').remove();
	$fileLoaderBar.slideDown();
	$fileBrowser.load( '#event.buildLink( prc.xehFBBrowser )#',
		{ path:'#prc.fbSafeCurrentRoot#', sorting:$sorting.val(), listType: $listType.val(),listFolder
		:$listFolder.val() },
		function(){
			$fileLoaderBar.slideUp();
		} );
}
function fbDrilldown( inPath ){
	$('.tooltip').remove();
	if( inPath == null ){ inPath = ""; }
	$fileLoaderBar.slideDown();
	$fileBrowser.load( '#event.buildLink( prc.xehFBBrowser )#', { path : inPath },function(){
		$fileLoaderBar.slideUp();
	} );
}
function fbQuickView(){
	if(noMultiSelectAction()){return;};
	// check selection
	var sPath = $selectedItem.val();
	if( !sPath.length ){ alert( '#$r( "jsmessages.select@fb" )#' ); return; }
	// get ID
	var thisID 	= $selectedItemID.val();
	var target 	= $( "##"+thisID);
	// only images
	if( target.attr( "data-quickview" ) == "false" ){ alert( '#$r( "jsmessages.quickview_only_images@fb" )#' ); return; }
	// show it
	var imgURL = "#event.buildLink( prc.xehFBDownload )#?path="+ encodeURIComponent( target.attr( "data-fullURL" ) );
	$('.imagepreview').attr('src', imgURL);
	openModal( $( "##modalPreview" ), 500 );
}
function fbRename(){
	if(noMultiSelectAction()){return;};
	// check selection
	var sPath = $selectedItem.val();
	if( !sPath.length ){ alert( '#$r( "jsmessages.select@fb" )#' ); return; }
	// get ID
	var thisID 		= $selectedItemID.val();
	var target 		= $( "##"+thisID);
	// prompt for new name
	bootbox.prompt( { 	title: '#$r( "jsmessages.newname@fb" )#', 
						inputType: "text", 
						value: target.attr( "data-name" ), 
						callback: function(result){
							// do renaming if prompt not empty
							if( result != null){
								$fileLoaderBar.slideDown();
								$.post( '#event.buildLink( prc.xehFBRename )#', 
									    { name : result, path : target.attr( "data-fullURL" ) },
									    function( data ){
											if( data.errors ){ alert( data.messages ); }
											fbRefresh();
								}, "json" );
							}
						}
	});

}
function fbUrl(){
	if(noMultiSelectAction()){return;};
	// check selection
	var sPath = $selectedItem.val();
	if( !sPath.length ){ alert( '#$r( "jsmessages.select@fb" )#' ); return; }
	// get ID
	var thisID 		= $selectedItemID.val();
	var target 		= $( "##"+thisID);
	// prompt the URL
	bootbox.prompt( { 	title: 'URL:', 
						inputType: "text", 
						value: "#event.buildLink( '' )#" + target.attr( "data-relurl" ).substring(1), 
						callback: function(result){}
	});

}
function fbEdit(){
	if(noMultiSelectAction()){return;};
	// check selection
	var sPath = $selectedItem.val();
	if( !sPath.length ){ alert( '#$r( "jsmessages.select@fb" )#' ); return; }
	// get ID
	var thisID 		= $selectedItemID.val();
	var target 		= $( "##"+thisID);
	// only images
	if( target.attr( "data-quickview" ) == "false" ){ alert( '#$r( "jsmessages.quickview_only_images@fb" )#' ); return; }
	openRemoteModal( "#event.buildLink( 'cbFileBrowser.editor.index' )#",{
		imageName:target.attr( "data-name" ), 
		imageSrc:target.attr( "data-relUrl" ), 
		imagePath:target.attr( "data-fullUrl" )
	}, $( window ).width() - 200, $( window ).height() - 200 );
}
function fbInfo(){
	if(noMultiSelectAction()){return;};
	// check selection
	var sPath = $selectedItem.val();
	if( !sPath.length ){ alert( '#$r( "jsmessages.select@fb" )#' ); return; }
	// get ID
	var thisID 		= $selectedItemID.val();
	var target 		= $( "##"+thisID);
	// Show info
	openRemoteModal( "#event.buildLink( 'cbFileBrowser.editor.info' )#",{
		fileName:target.attr( "data-name" ), 
		fileSrc:target.attr( "data-relUrl" ), 
		filePath:target.attr( "data-fullUrl" )
	}, $( window ).width() - 200, $( window ).height() - 200 );
}
<!--- Create Folders --->
<cfif prc.fbSettings.createFolders>
function fbNewFolder(){

	bootbox.prompt( '#$r( "jsmessages.newdirectory@fb" )#', function(result){
		if( result != null){
			$fileLoaderBar.slideDown();
			$.post( '#event.buildLink( prc.xehFBNewFolder )#',
					{ dName : result, path : '#prc.fbSafeCurrentRoot#' },
					function( data ){
						if( data.errors ){ alert( data.messages ); }
						fbRefresh();
			},"json" );
		}
	});
}
</cfif>
<!--- Remove Stuff --->
<cfif prc.fbSettings.deleteStuff>
function fbDelete(){
	var sPath = $selectedItem.val();
	if( !sPath.length ){ alert( '#$r( "jsmessages.select@fb" )#' ); return; }

	bootbox.confirm({
	    message: '#$r( "jsmessages.delete_confirm@fb" )#',
	    buttons: {
	        confirm: {
	            label: 'Yes',
	            className: 'btn-success'
	        },
	        cancel: {
	            label: 'No',
	            className: 'btn-danger'
	        }
	    },
	    callback: function (result) {
			if( result ){
				$fileLoaderBar.slideDown();
				$.post( '#event.buildLink( prc.xehFBRemove )#',
						{ path : sPath },
						function( data ){
							if( data.errors ){ alert(data.messages); }
							fbRefresh();
				},"json" );
			}
	    }
	});


}
</cfif>
<!--- Download --->
<cfif prc.fbSettings.allowDownload>
function fbDownload(){
	var sPath = ($selectedItem.val() != "") ? $selectedItem.val().split(',') :[];
	var sType = $selectedItemType.val();
	if( !sPath.length ){
		alert( '#$r( "jsmessages.select@fb" )#' ); return;
	} else if ( sType == "dir" ){ 	
		alert( '#$r( "jsmessages.downloadFolder@fb" )#' ); return;
	}	
	// Trigger the download
	$( "##downloadIFrame" ).attr( "src","#event.buildLink( prc.xehFBDownload )#?path="+ encodeURIComponent(sPath) );
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
$( document ).ready( function(){
	// show upload button
	$( "##file_uploader" ).on( "change", function() {
		if( $( this ).val().length !=0 ){
			$( "##file_uploader_button" ).removeClass( "hidden" ); 
		}else{
			$( "##file_uploader_button" ).addClass( "hidden" ); 
		}
	} );

	$( '##file_uploader_button' ).on('click', function(){
		var iframe  = $( '##upload-iframe' );
		var form    = $( '##upload-form' );
		var field   = $( '##filewrapper' );
		var wrapper = $( '##manual_upload_wrapper' );
		wrapper.append( '<p id="upload_message"><i class="fa fa-spinner fa-spin fa-2x fa-fw"></i> Uploading your file...</p>' );
		// move to target form
		field.appendTo( form );
		field.hide();
		// submit the form; it's target is the iframe, so AJAX-ish upload style
		form.submit();
		// handle load method of iframe
		iframe.load(function(){
			// try to get JSON response from server in textfield
			var results = $.parseJSON( iframe.contents().text() );
			if( !results.errors ) {
				fbRefresh();
			} else {
				wrapper.append( "<div class='alert alert-danger'>" + results.messages + "</div>" );	
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
		url: '#event.buildLink( prc.xehFBUpload )#',
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
			console.log(progress)
			$.data( file ).find( '.progress' ).width( progress );
			//console.log( "uploading progress" + progress );
		}
	} );
	// Progress template
	var template = '<div class="preview">'+
						'<span class="fileHolder"></span>'+
						'<div class="progressHolder">'+
					        '<div class="progress progress-striped active">'+
					            '<div class="progress-bar progress-bar-info" style="width: 0%;"></div>'+
					        '</div>'+
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