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