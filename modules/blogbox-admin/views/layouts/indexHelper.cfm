<cfscript>
	function getWidgetLocation(fileName){
		return "widgets." & ripExtension(arguments.fileName);
	};
	function ripExtension(filename){
		return reReplace(arguments.filename,"\.[^.]*$","");
	}
</cfscript>