<!-----------------------------------------------------------------------
********************************************************************************
Copyright since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
----------------------------------------------------------------------->
<cfoutput>
<script>
function noMultiSelectAction(){
	if( fbSelectHistory.length != 1 ){ alert( '#$r( "jsmessages.no_multi_select@fb" )#' ); return true; }
}

function fbRefresh(){
	$( '.tooltip' ).remove();
	$fileLoaderBar.slideDown();
	$fileListing.load(
		'#event.buildLink( prc.xehFBBrowser )#',
		{
			path       : $( "##fbRoot" ).val(),
			sorting    : $sorting.val(),
			listType   : $listType.val(),
			listFolder : $listFolder.val()
		},
		function(){
			$fileLoaderBar.slideUp();
		} );
}
function fbDrilldown( inPath ){
	$('.tooltip').remove();
	if( inPath == null ){ inPath = ""; }
	$fileLoaderBar.slideDown();
	$fileListing.load( '#event.buildLink( prc.xehFBBrowser )#', { path : inPath },function(){
		$fileLoaderBar.slideUp();
	} );
}
function fbQuickView(){
	// Clear out the preview
	$( '.imagepreview' ).attr( 'src', '' );

	// Abort if in multi select
	if( noMultiSelectAction() ){
		return;
	};

	// check selection
	var sPath = $selectedItem.val();
	if( !sPath.length ){
		alert( '#$r( "jsmessages.select@fb" )#' );
		return;
	}

	// get ID
	var thisID 	= $selectedItemID.val();
	var target 	= $( "##" + thisID );

	// only images
	if( target.attr( "data-quickview" ) == "false" ){
		alert( '#$r( "jsmessages.quickview_only_images@fb" )#' );
		return;
	}

	// show it
	var imgURL = "#event.buildLink( prc.xehFBDownload )#?path="+ encodeURIComponent( target.attr( "data-fullURL" ) );
	$( '.imagepreview' ).attr( 'src', imgURL );
	openModal( $( "##modalPreview" ), 500 );
}
function fbRename(){
	// Abort if in multi select
	if( noMultiSelectAction() ){
		return;
	};
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
	// Abort if in multi select
	if( noMultiSelectAction() ){
		return;
	};
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
	// Abort if in multi select
	if( noMultiSelectAction() ){
		return;
	};
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
	// Abort if in multi select
	if( noMultiSelectAction() ){
		return;
	};
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

function fbListTypeChange( listType, file ){
	// deselect button
	let identifier = "##" + $listType.val() + $listFolder.val();
	$( identifier ).removeClass( "btn-default" ).addClass( "btn-more" );

	$listType.val( listType );
	$listFolder.val( file );
	fbVerifyActiveView();
	fbRefresh();
}

<!--- Create Folders --->
<cfif prc.fbSettings.createFolders>
function fbNewFolder(){
	bootbox.prompt( '#$r( "jsmessages.newdirectory@fb" )#', function(result){
		if( result != null){
			$fileLoaderBar.slideDown();
			$.post( '#event.buildLink( prc.xehFBNewFolder )#',
					{ dName : result, path : $( "##fbRoot" ).val() },
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
	            label: 'DELETE',
	            className: 'btn-danger'
	        },
	        cancel: {
	            label: 'Cancel',
	            className: 'btn-default'
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
<cfif len( rc.callback )>
function fbChoose(){
	var sPath = $selectedItem.val();
	var sURL = $selectedItemURL.val();
	var sType = $selectedItemType.val();
	#encodeForJavaScript( rc.callback )#( sPath,sURL,sType );
}
<cfelse>
function fbChoose(){}
</cfif>

fbInit = () => {

	// reinitialize tooltip after refresh, do a try in case we are in Popup mode.
	try{
		$( '[data-toggle="tooltip"]' ).tooltip();
	} catch( e ){

	}

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

	// Sorting
	$sorting.change( function(){ fbRefresh(); } );

	// fbQuickViewdiv filter
	$fileBrowser.find( "##fbQuickFilter" ).keyup(function(){
		$.uiDivFilter( $( ".filterDiv" ), this.value);
	} );

	// Grid or List
	fbVerifyActiveView();

	// UPLOADS

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

		fbRefresh();
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
	        path: function(){
				return document.getElementById( "fbRoot" ).value;
			}
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
			$fileListing.removeClass( "fileListingUploading" );
			$.data( file ).addClass( 'done' );
			if( response.ERRORS ){
				alert( response.MESSAGES );
			}
			fbRefresh();
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
			//console.log( "root : " + $( "##fbRoot" ).val() );
			//console.log( "uploading starting " + file );
			fbinitUploadFile( file );
		},
		progressUpdated: function( i, file, progress ) {
			//console.log(progress)
			//console.log( "uploading progress... " + progress );
			$.data( file ).find( '.progress' ).width( progress );
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

	fbDrilldown();

	fbInited = true;
}

<cfif event.isAjax()>
( ()=> fbInit() )();
<cfelse>
	document.addEventListener( 'DOMContentLoaded', fbInit );
</cfif>
</script>
</cfoutput>
