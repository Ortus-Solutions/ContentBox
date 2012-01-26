function fbCKSelect(sPath,sURL,sType){
	if( !sPath.length || sType == "dir" ){ alert("Please select a file first."); return; }
	var funcNum = getUrlParam('CKEditorFuncNum');
	window.opener.CKEDITOR.tools.callFunction(funcNum, sURL);
	window.close();
}

function getUrlParam(paramName)
{
  var reParam = new RegExp('(?:[\?&]|&amp;)' + paramName + '=([^&]+)', 'i') ;
  var match = window.location.search.match(reParam) ;

  return (match && match.length > 1) ? match[1] : '' ;
}