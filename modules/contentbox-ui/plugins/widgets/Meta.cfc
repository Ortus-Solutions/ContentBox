/**
* A cool basic widget that shows some ContentBox meta links
*/
component extends="contentbox.model.ui.BaseWidget" singleton{

	Meta function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setPluginName("Meta");
		setPluginVersion("1.0");
		setPluginDescription("A cool basic widget that shows some ContentBox meta links");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("www.ortussolutions.com");

		return this;
	}

	/**
	* Show the ContentBox Meta Links
	* @dropdown.hint Display as a dropdown or a list, default is list
	* @title.hint The title to show before the dropdown or list, defaults to H2
	* @titleLevel.hint The H{level} to use, by default we use H2
	*/
	any function renderIt(boolean dropdown=false, string title="ContentBox",string titleLevel="2"){
		var rString	= "";

		// build links accordingly to authentication
		if( securityService.getAuthorSession().isLoggedIn() ){
			var links = [
				{link=cb.linkAdmin(), title="Site Admin"},
				{link=cb.linkAdminLogout(), title="Logout"}
			];
		}
		else{
			var links = [
				{link=cb.linkAdminLogin(), title="Login"}
			];
		}
		arrayAppend(links, {link=cb.linkRSS(), title="Entries RSS"} );
		arrayAppend(links, {link=cb.linkRSS(comments=true), title="Comments RSS"} );
		arrayAppend(links, {link="http://www.gocontentbox.org", title="ContentBox"} );

		saveContent variable="rString"{
			// title
			if( len(arguments.title) ){ writeOutput("<h#arguments.titleLevel#>#arguments.title#</h#arguments.titleLevel#>"); }
			// Build Type
			if( arguments.dropdown ){
				writeoutput( buildDropDown( links ) );
			}
			else{
				writeoutput( buildList( links ) );
			}
		}

		return rString;
	}

	private function buildDropDown(links){
		var rString = "";

		saveContent variable="rString"{
			writeOutput('<select name="meta" id="meta" onchange="window.location=this.value")><option value="##">ContentBox Links</option>');
			// iterate and create
			for(var x=1; x lte arrayLen( arguments.links ); x++){
				writeOutput('<option value="#links[x].link#">#links[x].title#</option>');
			}
			// close ul
			writeOutput("</select>");
		}
		return rString;
	}

	private function buildList(links){
		var rString = "";

		saveContent variable="rString"{
			writeOutput('<ul id="meta">');
			// iterate and create
			for(var x=1; x lte arrayLen( arguments.links ); x++){
				writeOutput('<li class="archives"><a href="#links[x].link#">#links[x].title#</a></li>');
			}
			// close ul
			writeOutput("</ul>");
		}
		return rString;
	}

}
