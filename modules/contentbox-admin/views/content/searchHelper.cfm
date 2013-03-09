<cfscript>
	function linkEditContent(required content){
		var linkto = "";
		if( arguments.content.getContentType() eq "entry" ){ 
			linkto = prc.xehBlogEditor; 
		}
		else if( arguments.content.getContentType() eq "page" ){ 
			linkto = prc.xehPagesEditor; 
		}
		return event.buildLink(linkto=linkto, queryString="contentID=#arguments.content.getContentID()#");
	}
</cfscript>