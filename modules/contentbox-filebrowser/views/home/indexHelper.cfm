<!-----------------------------------------------------------------------
********************************************************************************
Copyright since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
----------------------------------------------------------------------->
<cfscript>
function $safe(str){ return urlEncodedFormat(arguments.str); }
function $validIDName(str){return JSStringFormat( html.slugify( arguments.str )); }
function $getBackPath(inPath){
	arguments.inPath = replace(arguments.inPath,"\","/","all");
	var lFolder = listLast( arguments.inPath,"/" );
	return URLEncodedFormat( left( arguments.inPath, len(arguments.inPath) - len(lFolder) ) );
}
function validQuickView(ext){
	if( listFindNoCase("png,jpg,jpeg,bmp,gif",ext) ){ return "true"; }
	return "false";
}
function getImageFile(ext){
	switch(arguments.ext){
		case "png": case "jpg" : case "jpeg" : case "gif" : case "bmp" : { return "Picture.png"; }
		case "cfc": case "cfm" : case "cfml" : { return "coldfusion.png"; }
		case "html" : case "htm" : case "aspx" : case "asp" : case "php" : case "rb" : case "py" : case "xml" :{ return "code.png"; }
		default : return "file.png";
	}
}
function $getUrlRelativeToPath(required basePath,required filePath, encodeURL=false) {
	var URLOut="";
	var strURLOut="/";
	var arrPath=[];
	var p = "";
	URLOut=replace(replacenocase(arguments.filePath,arguments.basePath,"/","one"),"\","/","all");
	if (arguments.encodeURL) {
		arrPath=listtoarray(URLOut,"/");
		for(p in arrPath) {
			strURLOut=listAppend(strURLOut,replacenocase(urlencodedformat(p),"%2e",".","all"),"/");
		}
		URLOut=strURLOut;
	}
	URLOut=replacenocase(URLOut,"//","","all");
	return URLOut;
}
</cfscript>
<cfoutput>
<!--- Custom Javascript --->
<script language="javascript">
$(document).ready(function() {
	$fileBrowser 		= $("##FileBrowser");
	$fileLoaderBar 		= $fileBrowser.find("##loaderBar");
	$selectedItem		= $fileBrowser.find("##selectedItem");
	$selectedItemURL	= $fileBrowser.find("##selectedItemURL");
	$selectedItemID		= $fileBrowser.find("##selectedItemID");
	$selectedItemType	= $fileBrowser.find("##selectedItemType");
	$statusText 		= $fileBrowser.find("##statusText");
	$selectButton		= $fileBrowser.find("##bt_select");
	$contextMenu		= $fileBrowser.find("##fbContextMenu");
	$sorting			= $fileBrowser.find("##fbSorting");
	$quickView			= $fileBrowser.find("##quickViewBar");
	$quickViewContents	= $fileBrowser.find("##quickViewBarContents");
	$quickViewCloseBtn	= $fileBrowser.find("##fbCloseButton");
	//disable it
	$selectButton.attr("disabled",true);
	// history
	fbSelectHistory = "";
	// file context menus
	$fileBrowser.find(".files").contextMenu({menu: 'fbContextMenu'}, fbContextActions);
	$fileBrowser.find(".folders").contextMenu({menu: 'fbContextMenuDirectories'}, fbContextActions);
	// Sorting
	$sorting.change(function(){ fbRefresh(); });
	$quickViewCloseBtn.click(function(){ fbCloseQuickView(); });
	// Quick div filter
	$fileBrowser.find("##fbQuickFilter").keyup(function(){
		$.uiDivFilter( $(".filterDiv"), this.value);
	})

});
function fbCloseQuickView(){
	$quickView.slideUp();
	$quickViewContents.html('');
}
function fbContextActions(action,el,pos){
	var $context = $(el);
	fbSelect( $context.attr("id"), $context.attr("data-fullURL") );
	switch(action){
		case "quickview" : fbQuickView(); break;
		case "rename" 	 : fbRename(); break;
		<cfif prc.fbSettings.deleteStuff>
		case "delete" 	 : fbDelete(); break;
		</cfif>
		<cfif prc.fbSettings.allowDownload>
		case "download"  : fbDownload(); break;
		</cfif>
		<cfif len(rc.callback)>
		case "select" 	 : fbChoose(); break;
		</cfif>
	}
}
function fbRefresh(){
	$fileLoaderBar.slideDown();
	$fileBrowser.parent().load( '#event.buildLink(prc.xehFBBrowser)#', {path:'#prc.fbSafeCurrentRoot#',sorting:$sorting.val()},function(){
		$fileLoaderBar.slideUp();
	});
}
function fbDrilldown(inPath){
	if( inPath == null ){ inPath = ""; }
	$fileLoaderBar.slideDown();
	$fileBrowser.parent().load( '#event.buildLink(prc.xehFBBrowser)#', {path:inPath},function(){
		$fileLoaderBar.slideUp();
	});
}
function fbSelect(sID,sPath){
	// history cleanup
	if (fbSelectHistory.length) {
		$("##" + fbSelectHistory).removeClass("selected");
	}
	// highlight selection
	var $sItem = $( "##"+sID );
	$sItem.addClass("selected");
	$selectedItemType.val( $sItem.attr("data-type") );
	$selectedItemID.val( $sItem.attr("id") );
	// save selection
	$selectedItem.val( sPath );
	$selectedItemURL.val( $sItem.attr("data-relURL") );
	// history set
	fbSelectHistory = sID;
	// status text
	$statusText.text( $sItem.attr("data-name")+' ('+ $sItem.attr("data-size")+'KB '+$sItem.attr("data-lastModified")+')');
	// enable selection button
	$selectButton.attr("disabled",false);
}
function fbQuickView(){
	// check selection
	var sPath = $selectedItem.val();
	if( !sPath.length ){ alert("Please select a file-folder first."); return; }
	// get ID
	var thisID 	= $selectedItemID.val();
	var target 	= $("##"+thisID);
	// only images
	if( target.attr("data-quickview") == "false" ){ alert("Quick view only enabled for images"); return; }
	// show it
	var imgURL = "#event.buildLink(prc.xehFBDownload)#?path="+ escape( target.attr("data-fullURL") );
	$quickView.slideDown();
	$quickViewContents.html('<img src="'+imgURL+'" style="max-width:#prc.fbSettings.quickViewWidth#px"/>');
}
function fbRename(){
	// check selection
	var sPath = $selectedItem.val();
	if( !sPath.length ){ alert("Please select a file-folder first."); return; }
	// get ID
	var thisID 		= $selectedItemID.val();
	var target 		= $("##"+thisID);
	// prompt for new name
	var newName  = prompt("Enter the new name?", target.attr("data-name") );
	// do renaming if prompt not empty
	if( newName != null){
		$fileLoaderBar.slideDown();
		$.post('#event.buildLink(prc.xehFBRename)#',{name:newName,path:target.attr("data-fullURL")},function(data){
			if( data.errors ){ alert(data.messages); }
			fbRefresh();
		},"json");
	}
}
<!--- Create Folders --->
<cfif prc.fbSettings.createFolders>
function fbNewFolder(){
	var dName = prompt("Enter the new directory name?");
	if( dName != null){
		$fileLoaderBar.slideDown();
		$.post('#event.buildLink(prc.xehFBNewFolder)#',{dName:dName,path:'#prc.fbSafeCurrentRoot#'},function(data){
			if( data.errors ){ alert(data.messages); }
			fbRefresh();
		},"json");
	}
}
</cfif>
<!--- Remove Stuff --->
<cfif prc.fbSettings.deleteStuff>
function fbDelete(){
	var sPath = $selectedItem.val();
	if( !sPath.length ){ alert("Please select a file-folder first."); return; }
	if( confirm("Are you sure you want to remove the selected file/folder? This is irreversible!") ){
		$fileLoaderBar.slideDown();
		$.post('#event.buildLink(prc.xehFBRemove)#',{path:sPath},function(data){
			if( data.errors ){ alert(data.messages); }
			fbRefresh();
		},"json");
	}
}
</cfif>
<!--- Download --->
<cfif prc.fbSettings.allowDownload>
function fbDownload(){
	var sPath = $selectedItem.val();
	var sType = $selectedItemType.val();
	if( !sPath.length || sType == "dir" ){ alert("Please select a file first."); return; }
	// Trigger the download
	$("##downloadIFrame").attr("src","#event.buildLink(prc.xehFBDownload)#?path="+ escape(sPath) );
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
  $('##file_upload').uploadify({
    'uploader'  : '#prc.fbModRoot#/includes/uploadify/uploadify.swf',
    'cancelImg' : '#prc.fbModRoot#/includes/uploadify/cancel.png',
   	'script'    : '#event.buildLink(prc.xehFBUpload)#?#$safe(session.URLToken)#&folder=#prc.fbSafeCurrentRoot#',
	'scriptData': {path: '#prc.fbSafeCurrentRoot#'},
    'auto'      : true,
	'multi'  	: #prc.fbSettings.uploadify.multi#,
	fileDesc	: '#prc.fbSettings.uploadify.fileDesc#',
    fileExt		: '#prc.fbSettings.uploadify.fileExt#',
	<cfif isNumeric( prc.fbSettings.uploadify.sizeLimit )>
	sizeLimit	: #prc.fbSettings.uploadify.sizeLimit#,
	</cfif>
	onAllComplete: function(event, data){
		//alert(data.filesUploaded + ' file(s) uploaded successfully!');
		$("##uploadBar").slideUp();
		fbRefresh();
	}
	<cfif len( prc.fbSettings.uploadify.customJSONOptions )>#prc.fbSettings.uploadify.customJSONOptions#</cfif>
	});
});
function fbUpload(){
	$("##uploadBar").slideToggle();
}
</script>
</cfif>
</cfoutput>