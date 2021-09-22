<cfscript>
function getContentTypeIconCls( contentType ) {
	var iconCls = "";
	switch( arguments.contentType ) {
		case 'Page':
			iconCls = "fas fa-file";
			break;
		case 'Entry':
			iconCls = "fas fa-blog";
			break;
		case 'ContentStore':
			iconCls = "far fa-hdd";
			break;
		default:
			break;
	}
	return iconCls;
}
</cfscript>
<cfoutput>
<!--- Custom Javascript --->
<script>
( () => {
	// Shared Pointers
	$relatedContentSelectorForm    = $( "##relatedContentSelectorForm" );
	$relatedContentSelectorLoader  = $relatedContentSelectorForm.find( "##relatedContentLoader" );
	// keyup quick search
	$( "##contentSearch" ).keyup(
		_.debounce(
			function(){
				var $this 	= $( this );
				var clearIt = ( $this.val().length > 0 ? false : true );
				$relatedContentSelectorLoader.fadeIn( "fast" );
				loadContentTabs( {
					search 	: $this.val(),
					clear 	: clearIt
				} );
			},
			300
		)
	);

	// prevent enter submisson
	$( "##contentSearch" ).keydown(function( e ){
		if( e.keyCode == 13 ) {
			e.preventDefault();
			return false;
		}
	} );

	// handler for tabbed content
	$( '##contentTypes a' ).click(function( e ) {
		e.preventDefault();
		$( this ).tab( 'show' );
	} )

	<cfif len( rc.search )>
		$( "##contentSearch" ).focus();
	</cfif>

	// fire off requests for individual tabs...should be dynamically evaluated in the future, I think
	loadContentTabs();
} )();

function loadContentTabs( params ){
	var inParams = params || {};
	loadContentTypeTab( 'Page', inParams );
	loadContentTypeTab( 'Entry', inParams );
	loadContentTypeTab( 'ContentStore', inParams );
}

function clearSearch(){
	$( '##contentSearch' ).val( '' );
	loadContentTabs();
}

/**
 * Generic method for making an AJAX request for tabbed related content
 * @param {String} contentType The content type to restrict the results to
 * @param {Object} params Optional hash of params to send along with the request
 */
function loadContentTypeTab( contentType, params ) {
	var url = '#event.buildLink( prc.xehRelatedContentSelector )#?excludeIDs=#rc.excludeIDs#&contentType=' + contentType;
	$( '##' + contentType ).load(
		url,
		params,
		function( data ) {
			$relatedContentSelectorLoader.fadeOut();
		}
	);
}

/**
 * Handler for pager links; has additional contentType argument to determine which pager/tab combo is currently active
 * @param {Number} page The clicked "page"
 * @param {String} contentType The contentType to restrict results to
 */
function pagerLink( page, contentType ){
	$relatedContentSelectorLoader.fadeIn( "fast" );
	var url = '#event.buildLink(prc.xehRelatedContentSelector )#?excludeIDs=#rc.excludeIDs#&contentType=' + contentType + '&page=' + page;
	$( '##' + contentType ).load( url, function( data ) {
		$relatedContentSelectorLoader.fadeOut();
	} );
}
</script>
</cfoutput>
