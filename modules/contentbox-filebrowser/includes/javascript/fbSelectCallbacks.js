/**
 *********************************************************************************
 * Copyright since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.coldbox.org | www.luismajano.com | www.ortussolutions.com
 *********************************************************************************
 * This callbacks js is used to place common editor, OS software callbacks so they
 * can be reused.  You can also modify it to add your own.
 */

/**
 * CKEditor Call Back
 * @param sPath
 * @param sURL
 * @param sType
 */
function fbCKSelect( sPath, sURL, sType ){
	if( !sPath.length || sType == "dir" ){ 
        alert( "Please select a file first." ); 
        return; 
    }
	var funcNum = getUrlParam( 'CKEditorFuncNum' );
	window.opener.CKEDITOR.tools.callFunction(funcNum, sURL);
	window.close();
}


function getUrlParam(paramName){
  var reParam = new RegExp('(?:[\?&]|&amp;)' + paramName + '=([^&]+)', 'i') ;
  var match = window.location.search.match(reParam) ;
  return (match && match.length > 1) ? match[1] : '' ;
}
/**
 * Generic close callback
 */
function fbGenericClose(){
	window.close();
}
/**
 * Testing select calback
 * @param path
 * @param rPath
 * @param type
 */
function fbTestChoose(path, rPath, type){
	alert("Path: " + path + '\n URL: ' + rPath + '\n Type: ' + type);
}
function fbTestCancel(){
	alert('Cancel Called');
}