/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A widget that renders sub pages according to where it is rendered.
 */
component extends="contentbox.models.ui.BaseWidget" singleton {

	function init(){
		// Widget Properties
		setName( "SubPageMenu" );
		setVersion( "1.0" );
		setDescription( "A widget that renders sub pages according to where it is rendered." );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "https://www.ortussolutions.com" );
		setIcon( "list" );
		setCategory( "Content" );
		return this;
	}

	/**
	 * Renders a ContentBox sub page menu according to where it is rendered
	 *
	 * @page                    Optional page to create sub page menu for, else look for current page, this can be a page object or a page slug
	 * @excludes                The list of pages to exclude from the menu
	 * @type                    The type of menu, valid choices are: ul,ol,li,none
	 * @typeClass               The class to apply to the top level type HTML element
	 * @separator               Used if type eq none, to separate the list of href's
	 * @showNone                Shows a 'No Sub Pages' message or not
	 * @levels.hint             The number of levels to nest hierarchical pages, by default it does only 1 level, * does all levels
	 * @elementClass.hint       The CSS class(es) to attach to the menu <li> element
	 * @parentClass.hint        The CSS class(es) to attach to the menu <li> element when it has nested elements, by default it is 'parent'
	 * @activeClass.hint        The CSS class(es) to attach to the menu <li> element when that element is the current page you are on, by default it is 'active'
	 * @activeShowChildren.hint If true, then we will show the children of the active menu element, else we just show the active element
	 */
	any function renderIt(
		string page,
		string excludes,
		string type                = "ul",
		string typeClass           = "",
		string separator           = "",
		boolean showNone           = true,
		numeric levels             = 1,
		elementClass               = "",
		parentClass                = "parent",
		activeClass                = "active",
		boolean activeShowChildren = false
	){
		return variables.cb.subPageMenu( argumentCollection = arguments );
	}

	/**
	 * Return an array of slug lists, the @ignore annotation means the ContentBox widget editors do not use it only used internally.
	 *
	 * @cbignore
	 */
	array function getSlugList(){
		return variables.pageService.getAllFlatSlugs();
	}

}
