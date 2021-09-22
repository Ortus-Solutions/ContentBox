<cfoutput>
<!--- Custom JS --->
<script>
document.addEventListener( "DOMContentLoaded", () => {
	// Root elements
	$pagerLoader 	= $( "##contentPager_#prc.contentPager_id#_loader" );
	$pagerTable 	= $( "##contentPager_#prc.contentPager_id#_table" );
	// Activate even classes
	$pagerTable.find( "tr:even" ).addClass( "even" );
	// Activate quick look
	$pagerTable.find( "tr" ).bind( "contextmenu",function( e ) {
		if ( e.which === 3 ) {
			if( $( this ).attr( 'data-contentID' ) != null ){
				openRemoteModal(
					'#event.buildLink( prc.xehContentPagerQuickLook )#/contentID/' + $( this ).attr( 'data-contentID' )
				);
				e.preventDefault();
			}
		}
	} );
} );
function pagerLink( page ){
	$pagerLoader.fadeIn( "fast" );
	$pagerTable
		.load(
			"#event.buildLink( prc.xehContentPager )#",
			{
				contentPager_pagination : "#prc.contentPager_pagination#",
				contentPager_authorID	: "#prc.contentPager_authorID#",
				contentPager_parentID	: "#prc.contentPager_parentID#",
				contentPager_page 		: page
			},
			function() {
				$pagerLoader.fadeOut();
				hideAllTooltips();
				activateTooltips();
			}
		);
}
</script>
</cfoutput>