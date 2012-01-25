<cfscript>
function $safe(str){ return urlEncodedFormat(arguments.str); }
function $validIDName(str){return JSStringFormat( html.slugify( arguments.str )); }
function $getBackPath(inPath){
	arguments.inPath = replace(arguments.inPath,"\","/","all");
	var lFolder = listLast( arguments.inPath,"/" );
	return URLEncodedFormat( left( arguments.inPath, len(arguments.inPath) - len(lFolder) ) );
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
	URLOut=replacenocase(URLOut,"//","/","all");
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
	
	//disable it
	$selectButton.attr("disabled",true);
	// history
	fbSelectHistory = "";
});
function fbRefresh(){
	$fileLoaderBar.slideDown();
	$fileBrowser.parent().load( '#event.buildLink(prc.xehBrowser)#', {path:'#prc.safeCurrentRoot#'},function(){
		$fileLoaderBar.slideUp();
	});
}
function fbDrilldown(inPath){
	if( inPath == null ){ inPath = ""; }
	$fileLoaderBar.slideDown();
	$fileBrowser.parent().load( '#event.buildLink(prc.xehBrowser)#', {path:inPath},function(){
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
		$.post('#event.buildLink(prc.xehRename)#',{name:newName,path:target.attr("data-fullURL")},function(data){
			if( data.errors ){ alert(data.messages); }
			fbRefresh();
		},"json");
	}
}
<!--- Create Folders --->
<cfif prc.settings.createFolders>
function fbNewFolder(){
	var dName = prompt("Enter the new directory name?");
	if( dName != null){
		$fileLoaderBar.slideDown();
		$.post('#event.buildLink(prc.xehNewFolder)#',{dName:dName,path:'#prc.safeCurrentRoot#'},function(data){
			if( data.errors ){ alert(data.messages); }
			fbRefresh();
		},"json");
	}
}
</cfif>
<!--- Remove Stuff --->
<cfif prc.settings.deleteStuff>
function fbDelete(){
	var sPath = $selectedItem.val();
	if( !sPath.length ){ alert("Please select a file-folder first."); return; }
	if( confirm("Are you sure you want to remove the selected file/folder? This is irreversible!") ){
		$fileLoaderBar.slideDown();
		$.post('#event.buildLink(prc.xehRemove)#',{path:sPath},function(data){
			if( data.errors ){ alert(data.messages); }
			fbRefresh();
		},"json");
	}
}
</cfif>
<!--- Download --->
<cfif prc.settings.allowDownload>
function fbDownload(){
	var sPath = $selectedItem.val();
	var sType = $selectedItemType.val();
	if( !sPath.length || sType == "dir" ){ alert("Please select a file first."); return; }
	// Trigger the download
	$("##downloadIFrame").attr("src","#event.buildLink(prc.xehDownload)#?path="+ escape(sPath) );
}
</cfif>
<!--- CallBack --->
<cfif len(rc.callback)>
function fbChoose(){
	var sPath = $selectedItemURL.val();
	var sURL = $selectedItemURL.val();
	var sType = $selectedItemType.val();
	#rc.callback#( sPath,sURL,sType );
}
</cfif>
</script>
<!--- Uploads Scripts --->
<cfif prc.settings.allowUploads>
<script type="text/javascript">
$(document).ready(function() {
  $('##file_upload').uploadify({
    'uploader'  : '#prc.modRoot#/includes/uploadify/uploadify.swf',
    'cancelImg' : '#prc.modRoot#/includes/uploadify/cancel.png',
   	'script'    : '#event.buildLink(prc.xehUpload)#?folder=#prc.safeCurrentRoot#&#$safe(session.URLToken)#',
    'auto'      : true,
	'multi'  	: #prc.settings.uploadify.multi#,
	fileDesc	: '#prc.settings.uploadify.fileDesc#',
    fileExt		: '#prc.settings.uploadify.fileExt#',
	<cfif isNumeric( prc.settings.uploadify.sizeLimit )>
	sizeLimit	: #prc.settings.uploadify.sizeLimit#,
	</cfif>
	onAllComplete: function(event, data){
		//alert(data.filesUploaded + ' file(s) uploaded successfully!');
		$("##uploadBar").slideUp();
		fbRefresh();
	}
	<cfif len( prc.settings.uploadify.customJSONOptions )>#prc.settings.uploadify.customJSONOptions#</cfif>
	});
});
function fbUpload(){
	$("##uploadBar").slideToggle();
}
</script>
</cfif>
</cfoutput>