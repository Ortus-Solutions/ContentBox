/**
* This is the BlogBox UI helper class that is injected by the BBRequest interceptor
*/
component extends="coldbox.system.Plugin" accessors="true" singleton{
	
	// DI
	property name="categoryService"		inject="id:categoryService@bb";
	property name="entryService"		inject="id:entryService@bb";
	property name="authorService"		inject="id:authorService@bb";
	property name="commentService"		inject="id:commentService@bb";

	/************************************** settings *********************************************/
	
	// get blogbox settings
	function setting(required key,value){
		var prc = getRequestCollection(private=true);		
		
		// return setting if it exists
		if( structKeyExists(prc.bbSettings, arguments.key) ){
			return prc.bbSettings[ key ];
		}
		// default value
		if( structKeyExists(arguments,"value") ){
			return arguments.value;
		}
		// else throw exception
		throw(message="Setting requested: #arguments.key# not found",detail="Settings keys are #structKeyList(prc.bbSettings)#",type="BlogBox.BBHelper.InvalidSetting");
	}
	
	// custom html
	function customHTML(required slug){
		return setting("bb_html_" & arguments.slug);
	}
	
	/************************************** root methods *********************************************/
	
	// get layout root, where your layout is in the blogbox ui
	function layoutRoot(){
		var prc = getRequestCollection(private=true);		
		return prc.bbLayoutRoot;
	}
	
	// get site root, the defined entry point for your blog via the module configuration  
	function siteRoot(){
		var prc = getRequestCollection(private=true);		
		return prc.bbEntryPoint;
	}
	
	/************************************** site properties *********************************************/

	// site name
	function siteName(){ return setting("bb_site_name"); }
	// site tagline
	function siteTagLine(){ return setting("bb_site_tagline"); }
	// site description
	function siteDescription(){ return setting("bb_site_description"); }
	// site keywords
	function siteKeywords(){ return setting("bb_site_keywords"); }
	
	/************************************** events *********************************************/
	
	// event announcements, funky for whitespace reasons
	function event(required state,struct data=structNew()) output="true"{announceInterception(arguments.state,arguments.data);}
	
	/************************************** link methods *********************************************/
	
	// get Home Link
	function linkHome(){
		return getRequestContext().buildLink(linkto=siteRoot());
	}
	
	// get RSS link
	function linkRSS(category=""){
		var xehRSS = siteRoot() & ".rss";
		return getRequestContext().buildLink(linkto=xehRSS);
	}
	
	// get Category Link
	function linkCategory(slug){
		var xehCategory = siteRoot() & "/category/" & arguments.slug;
		return getRequestContext().buildLink(linkto=xehCategory);
	}
	
	// get Search link
	function linkSearch(){
		var xehSearch = siteRoot() & ".blog.search";
		return getRequestContext().buildLink(linkto=xehSearch);
	}
	
	// get entry link
	function linkEntry(entry){
		var xehEntry = siteRoot() & "/#arguments.entry.getSlug()#";
		return getRequestContext().buildLink(linkTo=xehEntry);
	}
	
	// create entry category links
	function quickCategoryLinks(entry){
		var e = arguments.entry;
		
		// check if it has categories
		if( NOT e.hasCategories() ){ return ""; }
		
		var cats 	= e.getCategories();
		var catList = [];
		
		// iterate and create links
		for(var x=1; x lte arrayLen(cats); x++){
			var link = '<a href="#linkCategory(cats[x].getSlug())#" title="Filter entries by ''#cats[x].getCategory()#''">#cats[x].getCategory()#</a>';
			arrayAppend( catList, link );
		}
		
		// return list of links
		return arrayToList( catList );
	}
	
	/************************************** PRIVATE *********************************************/

}