/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * I am a cms page entity that totally rocks
 */
component
	persistent        ="true"
	entityname        ="cbPage"
	table             ="cb_page"
	batchsize         ="25"
	cachename         ="cbPage"
	cacheuse          ="read-write"
	extends           ="BaseContent"
	joinColumn        ="contentID"
	discriminatorValue="Page"
{

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	/**
	 * The layout in a theme that will be used to render the page out
	 */
	property
		name   ="layout"
		column ="layout"
		notnull="false"
		length ="200"
		default="";

	/**
	 * The ordering numeric sequence
	 */
	property
		name   ="order"
		column ="order"
		notnull="false"
		ormtype="integer"
		default="0";

	/**
	 * If true, this page is used when building automated menus. Else it is ignored.
	 */
	property
		name   ="showInMenu"
		column ="showInMenu"
		notnull="true"
		ormtype="boolean"
		default="true"
		index  ="idx_showInMenu";

	/**
	 * The excerpt for this page. This can be empty.
	 */
	property
		name   ="excerpt"
		column ="excerpt"
		notnull="false"
		ormtype="text"
		default=""
		length ="8000";

	/* *********************************************************************
	 **							NON PERSISTED PROPERTIES
	 ********************************************************************* */

	property name="renderedExcerpt" persistent="false";

	/* *********************************************************************
	 **							CONSTRAINTS
	 ********************************************************************* */

	this.constraints[ "layout" ]     = { required : false, size : "1..200" };
	this.constraints[ "order" ]      = { required : true, type : "numeric" };
	this.constraints[ "showInMenu" ] = { required : false, type : "boolean" };

	/* *********************************************************************
	 **							CONSTRUCTOR
	 ********************************************************************* */

	function init(){
		appendToMemento( [ "excerpt", "layout", "order", "showInMenu" ], "defaultIncludes" );

		super.init();

		variables.categories      = [];
		variables.customFields    = [];
		variables.renderedContent = "";
		variables.renderedExcerpt = "";
		variables.allowComments   = false;
		variables.createdDate     = now();
		variables.layout          = "pages";
		variables.contentType     = "Page";
		variables.order           = 0;
		variables.showInMenu      = true;

		// INHERITANCE LAYOUT STATIC
		variables.LAYOUT_INHERITANCE_KEY = "-inherit-";

		return this;
	}

	/* *********************************************************************
	 **							PUBLIC FUNCTIONS
	 ********************************************************************* */

	/**
	 * Verifies an excerpt exists in this content object via length checks
	 */
	boolean function hasExcerpt(){
		return len( getExcerpt() ) GT 0;
	}

	any function renderExcerpt(){
		// Check if we need to translate
		if ( NOT len( variables.renderedExcerpt ) ) {
			lock name="contentbox.excerptrendering.#getContentID()#" type="exclusive" throwontimeout="true" timeout="10" {
				if ( NOT len( variables.renderedExcerpt ) ) {
					// render excerpt out, prepare builder
					var builder = createObject( "java", "java.lang.StringBuilder" ).init( getExcerpt() );
					// announce renderings with data, so content renderers can process them
					variables.interceptorService.announce(
						"cb_onContentRendering",
						{ builder : builder, content : this }
					);
					// store processed content
					variables.renderedExcerpt = builder.toString();
				}
			}
		}

		return variables.renderedExcerpt;
	}

	/**
	 * Get the layout or if empty the default convention of "pages"
	 */
	function getLayoutWithDefault(){
		return ( len( getLayout() ) ? getLayout() : "pages" );
	}

	/**
	 * Get layout with layout inheritance, if none found return normal saved layout
	 */
	function getLayoutWithInheritance(){
		var thisLayout = getLayout();
		// check for inheritance and parent?
		if ( thisLayout eq variables.LAYOUT_INHERITANCE_KEY AND hasParent() ) {
			return getParent().getLayoutWithInheritance();
		}
		// Else return the layout
		return thisLayout;
	}

	/**
	 * Wipe primary key, and descendant keys, and prepare for cloning of entire hierarchies
	 *
	 * @author           The author doing the cloning
	 * @original         The original content object that will be cloned into this content object
	 * @originalService  The ContentBox content service object
	 * @publish          Publish pages or leave as drafts
	 * @originalSlugRoot The original slug that will be replaced in all cloned content
	 * @newSlugRoot      The new slug root that will be replaced in all cloned content
	 */
	BaseContent function clone(
		required any author,
		required any original,
		required any originalService,
		required boolean publish,
		required any originalSlugRoot,
		required any newSlugRoot
	){
		// Do page property cloning
		setLayout( arguments.original.getLayout() );
		setShowInMenu( arguments.original.getShowInMenu() );
		// do excerpts
		if ( arguments.original.hasExcerpt() ) {
			setExcerpt( arguments.original.getExcerpt() );
		}
		// do core cloning
		return super.clone( argumentCollection = arguments );
	}

	/**
	 * Verifies if the current page is the current site homepage
	 */
	boolean function isHomepage(){
		if ( !hasSite() ) {
			return false;
		}
		return ( getSite().getHomePage() eq getSlug() );
	}

}
