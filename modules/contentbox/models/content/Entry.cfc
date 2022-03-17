/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * I am a blog entry entity that is amazing
 */
component
	persistent        ="true"
	entityname        ="cbEntry"
	table             ="cb_entry"
	batchsize         ="25"
	cachename         ="cbEntry"
	cacheuse          ="read-write"
	extends           ="BaseContent"
	joinColumn        ="contentID"
	discriminatorValue="Entry"
{

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

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

	/* *********************************************************************
	 **							CONSTRUCTOR
	 ********************************************************************* */

	/**
	 * constructor
	 */
	function init(){
		appendToMemento( [ "excerpt" ], "defaultIncludes" );
		appendToMemento( [], "defaultExcludes" );

		super.init();

		variables.categories      = [];
		variables.customFields    = [];
		variables.renderedContent = "";
		variables.renderedExcerpt = "";
		variables.createdDate     = now();
		variables.contentType     = "Entry";

		return this;
	}

	/* *********************************************************************
	 **							PUBLIC FUNCTIONS
	 ********************************************************************* */

	/**
	 * has excerpt
	 */
	boolean function hasExcerpt(){
		return len( getExcerpt() ) GT 0;
	}

	/**
	 * Render excerpt
	 */
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
		// Original cloning!
		if ( arguments.original.hasExcerpt() ) {
			setExcerpt( arguments.original.getExcerpt() );
		}
		// do core cloning
		return super.clone( argumentCollection = arguments );
	}

}
