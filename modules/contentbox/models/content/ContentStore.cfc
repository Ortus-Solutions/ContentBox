/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * I represent a content value store
 */
component
	persistent        ="true"
	entityname        ="cbContentStore"
	table             ="""cb_contentStore"""
	batchsize         ="25"
	cachename         ="cbContentStore"
	cacheuse          ="read-write"
	extends           ="BaseContent"
	joinColumn        ="""contentID"""
	discriminatorValue="ContentStore"
{

	/* *********************************************************************
	 **							PROPERTIES
	 ********************************************************************* */

	/**
	 * The internal description of the contentstore item
	 */
	property
		name   ="description"
		column ="""description"""
		notnull="false"
		length ="500"
		default="";

	/**
	 * The ordering numeric sequence
	 */
	property
		name     ="order"
		column   ="""order"""
		notnull  ="false"
		ormtype  ="integer"
		default  ="0"
		dbdefault="0";

	/* *********************************************************************
	 **							CONSTRAINTS
	 ********************************************************************* */

	this.constraints[ "description" ] = { required : false, size : "1..500" };
	this.constraints[ "order" ]       = { required : false, type : "numeric" };

	/* *********************************************************************
	 **							CONSTRUCTOR
	 ********************************************************************* */

	function init(){
		super.init();

		variables.categories      = [];
		variables.customFields    = [];
		variables.renderedContent = "";
		variables.allowComments   = false;
		variables.description     = "";
		variables.createdDate     = now();
		variables.contentType     = "ContentStore";
		variables.order           = 0;

		appendToMemento( [ "description", "order" ], "defaultIncludes" );
		appendToMemento( [], "defaultExcludes" );

		return this;
	}

	/* *********************************************************************
	 **							PUBLIC FUNCTIONS
	 ********************************************************************* */

	/**
	 * Get a flat representation of this entry but for UI response format which
	 * restricts the data being generated.
	 * @slugCache Cache of slugs to prevent infinite recursions
	 * @showComments Show comments in memento or not
	 * @showCustomFields Show comments in memento or not
	 * @showParent Show parent in memento or not
	 * @showChildren Show children in memento or not
	 * @showCategories Show categories in memento or not
	 * @showRelatedContent Show related Content in memento or not
	 */
	struct function getResponseMemento(
		required array slugCache   = [],
		boolean showAuthor         = true,
		boolean showComments       = true,
		boolean showCustomFields   = true,
		boolean showParent         = true,
		boolean showChildren       = true,
		boolean showCategories     = true,
		boolean showRelatedContent = true
	){
		arguments.properties = listToArray( "description" );
		var result           = super.getResponseMemento( argumentCollection = arguments );

		return result;
	};

	/**
	 * Wipe primary key, and descendant keys, and prepare for cloning of entire hierarchies
	 * @author.hint The author doing the cloning
	 * @original.hint The original content object that will be cloned into this content object
	 * @originalService.hint The ContentBox content service object
	 * @publish.hint Publish pages or leave as drafts
	 * @originalSlugRoot.hint The original slug that will be replaced in all cloned content
	 * @newSlugRoot.hint The new slug root that will be replaced in all cloned content
	 */
	BaseContent function prepareForClone(
		required any author,
		required any original,
		required any originalService,
		required boolean publish,
		required any originalSlugRoot,
		required any newSlugRoot
	){
		// description
		setDescription( arguments.original.getDescription() );
		// do core
		return super.prepareForClone( argumentCollection = arguments );
	}

}
