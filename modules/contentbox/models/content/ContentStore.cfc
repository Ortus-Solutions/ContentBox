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
	table             ="cb_contentStore"
	batchsize         ="25"
	cachename         ="cbContentStore"
	cacheuse          ="read-write"
	extends           ="BaseContent"
	joinColumn        ="contentID"
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
		column ="description"
		notnull="false"
		length ="500"
		default="";

	/**
	 * The ordering numeric sequence
	 */
	property
		name     ="order"
		column   ="order"
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
		appendToMemento( [ "description", "order" ], "defaultIncludes" );
		appendToMemento( [], "defaultExcludes" );

		super.init();

		variables.categories      = [];
		variables.customFields    = [];
		variables.renderedContent = "";
		variables.allowComments   = false;
		variables.description     = "";
		variables.createdDate     = now();
		variables.contentType     = "ContentStore";
		variables.order           = 0;

		return this;
	}

	/* *********************************************************************
	 **							PUBLIC FUNCTIONS
	 ********************************************************************* */

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
		// original cloning!
		setDescription( arguments.original.getDescription() );
		setOrder( arguments.original.getOrder() + 1 );
		// do core cloning
		return super.clone( argumentCollection = arguments );
	}

}
