<cfoutput>
<!--- Custom JS --->
<script>
document.addEventListener( "DOMContentLoaded", () => {
	// quick look
	$( "##comments_pager" )
		.find( "tr" )
		.bind( "contextmenu", function( e ){
			if( e.which === 3 ){
				if( $( this ).attr( 'data-commentID' ) != null ){
					openRemoteModal(
						'#event.buildLink( prc.xehCommentPagerQuickLook )#',
						{ commentID: $( this ).attr( 'data-commentID' ) }
					);
					e.preventDefault();
				}
			}
		} );
} );
<cfif prc.oCurrentAuthor.checkPermission( "COMMENTS_ADMIN" )>
function commentPagerChangeStatus( status, recordID ){
	// update icon
	$( "##status_"+ recordID)
		.removeClass( "fa fa-minus-circle" )
		.addClass( "fa fa-spinner fa-spin" );
	// ajax status change
	$.post(
		"#event.buildlink(to=prc.xehCommentPagerStatus)#",
		{
			commentStatus : status,
			commentID     : recordID
		},
		function( data ){
			if( data.ERROR ){
				adminNotifier( "error", data.MESSAGES, 3000 );
			} else {
				adminNotifier( "info", data.MESSAGES );
			}
			hideAllTooltips();
			commentPagerLink( #rc.page# );
		}
	);
}
function commentPagerRemove( recordID ){
	if( !confirm( "Really permanently delete comment?" ) ){ return; }
	$( "##delete_"+ recordID )
		.removeClass( "fa fa-minus-circle" )
		.addClass( "fa fa-spinner fa-spin" );
	// ajax remove change
	$.post(
		"#event.buildlink( prc.xehCommentPagerRemove )#",
		{
			commentID : recordID
		},
		function( data ){
			if( data.ERROR ){
				adminNotifier( "error", data.MESSAGES, 3000 );
			} else {
				adminNotifier( "info", data.MESSAGES );
			}
			hideAllTooltips();
			commentPagerLink( #rc.page# );
	} );
}
</cfif>
function commentPagerLink( page ){
	$( "##commentsPagerLoader" ).fadeIn( "fast" );
	$('##pagerComments')
		.load(
			'#event.buildLink( prc.xehCommentPager )#',
			{
				commentPager_contentID  : '#prc.commentPager_contentID#',
			 	commentPager_max        : '#prc.commentPager_max#',
			 	page                    : page,
			 	commentPager_pagination : '#prc.commentPager_pagination#'
			},
			function() {
				hideAllTooltips();
				$( "##commentsPagerLoader" ).fadeOut();
				activateTooltips();
			}
		);
}
</script>
</cfoutput>