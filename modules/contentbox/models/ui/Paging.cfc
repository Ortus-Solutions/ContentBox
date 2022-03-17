/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 *
 * COLDBOX SETTINGS
 * - `PagingMaxRows` : The maximum number of rows per page.
 * - `PagingBandGap` : The maximum number of pages in the page carrousel
 *
 * CSS SETTINGS:
 * - `.pagingTabs` - The div container
 * - `.pagingTabsTotals` - The totals
 * - `.pagingTabsCarrousel` - The carrousel
 *
 * To use. You must use a "page" variable to move from page to page.
 * ex: index.cfm?event=users.list&page=2
 *
 * In your handler you must calculate the boundaries to push into your paging query.
 *
 * <pre>
 * rc.boundaries = getInstance( "Paging@contentbox" ).getBoundaries()
 * </pre>
 *
 * Returns a struct:
 * - `[startrow]` : the startrow to use
 * - `[maxrow]` : the max row in this recordset to use.
 *
 * Ex: [startrow=11][maxrow=20] if we are using a PagingMaxRows of 10
 *
 * To RENDER:
 *
 * <pre>
 * #getInstance( "Paging@contentbox" ).renderit( FoundRows, link )#
 * </pre>
 *
 * `FoundRows` = The total rows found in the recordset
 * `link` = The link to use for paging, including a placeholder for the page @page@
 * ex: index.cfm?event=users.list&page=@page@
 *
 * @author Luis Majano
 */
component accessors="true" {

	// DI
	property name="controller" inject="coldbox";

	// Properties
	property name="pagingMaxRows";
	property name="PagingBandGap";

	/**
	 * Constructor
	 *
	 * @settingService        The ContentBox setting service
	 * @settingService.inject settingService@contentbox
	 */
	function init( required settingService ){
		// Setup Paging Properties
		setPagingMaxRows( arguments.settingService.getSetting( "cb_paging_maxrows" ) );
		setPagingBandGap( arguments.settingService.getSetting( "cb_paging_bandgap" ) );

		// Return instance
		return this;
	}

	/**
	 * Calculate the startrow and maxrow
	 *
	 * @pagingMaxRows You can override the paging max rows here
	 * @page          Which page to bound on, we look into the request context for a `page` if not passed.
	 *
	 * @return struct of { startrow:numeric, maxrow:numeric }
	 */
	struct function getBoundaries( numeric pagingMaxRows, numeric page ){
		var boundaries = { "startrow" : 1, "maxrow" : 0 };
		var event      = getController().getRequestService().getContext();
		var maxRows    = !isNull( arguments.pagingMaxRows ) ? arguments.pagingMaxRows : getPagingMaxRows();

		arguments.page = isNull( arguments.page ) ? event.getValue( "page", 1 ) : arguments.page;

		boundaries.startrow = ( arguments.page * maxrows - maxRows ) + 1;
		boundaries.maxrow   = boundaries.startrow + maxRows - 1;

		return boundaries;
	}

	/**
	 * Render the pagination tabs UI
	 *
	 * @foundRows     The rows found in the collection to build the pagination for.
	 * @link          The link to use, you must place the `@page@` place holder so the link can be created correctly. ex: /data/page/@page@
	 * @pagingMaxRows You can override the paging max rows here
	 * @asList        Render the UI as a list of pagination or tabs
	 * @page          The page we are on, if not passed, we look into the request context for a `page` variable.
	 */
	function renderIt(
		required numeric foundRows,
		required link,
		numeric pagingMaxRows,
		boolean asList = false,
		numeric page
	){
		var event        = getController().getRequestService().getContext();
		var currentPage  = isNull( arguments.page ) ? event.getValue( "page", 1 ) : arguments.page;
		var pagingTabsUI = "";
		var maxRows      = !isNull( arguments.pagingMaxRows ) ? arguments.pagingMaxRows : getPagingMaxRows();
		var bandGap      = getPagingBandGap();
		var theLink      = arguments.link;
		var pageFrom     = 0;
		var pageTo       = 0;
		var pageIndex    = 0;

		// Only page if records found
		if ( arguments.foundRows > 0 ) {
			// Calculate Total Pages
			var totalPages = ceiling( arguments.foundRows / maxRows );

			if ( currentPage gt totalPages ) {
				getController().relocate( url: replace( theLink, "@page@", totalPages ) );
			}

			savecontent variable="pagingTabsUI" {
				include "Paging.cfm";
			}
		}

		return pagingTabsUI;
	}

}
