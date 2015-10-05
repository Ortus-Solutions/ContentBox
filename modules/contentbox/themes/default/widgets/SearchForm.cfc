/**
* Simple widget to generate a search form

All widgets inherit the following properties available to you:

property name="categoryService"			inject="id:categoryService@cb";
property name="entryService"			inject="id:entryService@cb";
property name="pageService"				inject="id:pageService@cb";
property name="contentService"			inject="id:contentService@cb";
property name="contentVersionService"	inject="id:contentVersionService@cb";
property name="authorService"			inject="id:authorService@cb";
property name="commentService"			inject="id:commentService@cb";
property name="customHTMLService"		inject="id:customHTMLService@cb";
property name="cb"						inject="id:CBHelper@cb";
property name="securityService" 		inject="id:securityService@cb";
property name="html"					inject="coldbox:plugin:HTMLHelper";
*/
component extends="contentbox.models.ui.BaseWidget" singleton{
	
	SearchForm function init(controller){
		// Init parent
		super.init( arguments.controller );
		
		// Widget Properties
		setName("SearchForm");
		setVersion("1.0");
		setDescription("Simple widget to generate a search form");
		setAuthor("Tropicalista");
		setAuthorURL("http://www.tropicalseo.net");
		setForgeBoxSlug("");
		
		return this;
	}

	/**
	* This is the main renderit method you will need to implement in concrete widgets
	*/
	any function renderIt(string type="content", string label="Search for", string title="", string titleLevel="2", string placeholder="", string querycss="", string buttoncss="", string formcss=""){
		var rString	= "";
		var event = getRequestContext();

		// Check type
		if( !reFindNoCase("^(content|blog)$",arguments.type) ){
			throw(message="Invalid type for search form", detail="Valid types are: content or blog", type="InvalidSearchType");
		}
		// Action
		var action = cb.linkContentSearch();
		if( arguments.type eq "blog" ){
			action = cb.linkSearch();
		}
		// Check incoming query
		local.q = event.getValue( "q", "" );

		// generate recent comments
		saveContent variable="rString"{
			writeOutput('
			#html.startForm(name="searchForm", action=cb.linkSearch(), class=arguments.formcss)#
			    <div class="input-group">
					#html.textField(name="q", placeholder="Search", value=local.q, class="form-control")#
			      <span class="input-group-btn">
			        <button class="btn btn-primary" type="submit"><i class="fa fa-search"></i></button>
			      </span>
			    </div>
			#html.endForm()#
			');
		}

		return rString;
	}
	
}