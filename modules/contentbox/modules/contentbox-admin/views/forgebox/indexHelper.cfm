<cfoutput>
<script>
$(document).ready(function() {
	// pointers
	$forgeBoxInstall = $( "##forgeBoxInstall" ); 
	$downloadURL = $forgeBoxInstall.find( "##downloadURL" );
	// Div Filter
	$( "##entryFilter" ).keyup(
		_.debounce(
            function(){
              	$.uiDivFilter( $( ".forgeBox-entrybox" ), this.value );
            },
            300
        )
	)
	$( ".forge-box-page-btn" ).on( "click", function() {
		loadForgeBox( $(this).data( "page" ) );
	} );
	// tool tips
	activateTooltips();
} );
function installEntry( id, downloadURL ){
	$( "##"+id ).html( '<div class="text-center"><i class="fa fa-circle-notch fa-spin fa-lg"></i><br/>Please wait, installing from ForgeBox...</div>' );
	$downloadURL.val( downloadURL );
	$forgeBoxInstall.submit();
	return true;
}
function loadForgeBox( page ){
	var params = { typeslug: '#rc.typeslug#', installDir: '#rc.installDir#', returnURL: '#rc.returnURL#', orderBY: "#rc.orderBY#"};

	if ( !isNaN( page ) ) {
		params.startrow = ( page - 1 ) * 25;
		params.page = page;
	}

	$forgebox.html( '<div class="text-center"><i class="fa fa-spinner fa-spin fa-lg icon-4x"></i><br/>Please wait, connecting to ForgeBox...</div>' );
	$forgebox.load( '#event.buildLink( prc.xehForgeBox )#?' + $.param( params ) );
}
</script>
</cfoutput>