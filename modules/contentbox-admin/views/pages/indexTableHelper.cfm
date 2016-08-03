<cfoutput>
<script>
$(document).ready(function() {
	// tables references
	$pages = $( "##pages" );
	// datatable
	$pages.dataTable( {
		"paging": false,
		"info": false,
		"searching": false,
		"columnDefs": [
    		{ 
    			"orderable": false, 
    			"targets": '{sorter:false}' 
    		}
  		],
  		"order": []
	} );
	// activate confirmations
	activateConfirmations();
	// activate tooltips
	activateTooltips();
	// quick look
	activateQuickLook( $pages, '#event.buildLink(prc.xehPageQuickLook)#/contentID/' );
	// Popovers
	activateInfoPanels();

	<cfif prc.oAuthor.checkPermission( "PAGES_ADMIN" )>
	// Drag and drop hierarchies
	$pages.tableDnD( {
		dragHandle : ".dragHandle",
		onDragClass: "selected",
		onDragStart : function(table,row){
			var $rowContainer = $( row ).closest( 'tr' );
			this.movedHash = $( table ).tableDnDSerialize();
			$( row ).removeClass( "btn-default" )
				.addClass( "btn-primary" )
				.css( "cursor", "grab" )
				.css( "cursor", "-moz-grabbing" )
				.css( "cursor", "-webkit-grabbing" );
			$rowContainer.addClass( "dotted" );
		},
		onDrop: function( table, row ){
			var newRulesOrder = $( table ).tableDnDSerialize();
			// only move if hash is diff
			if( this.movedHash == newRulesOrder ){ return; }
			// do the move, its a diff hash
			var rows = table.tBodies[ 0 ].rows;
			$( row ).css( "cursor", "progress" );
			//console.log( "order" + newRulesOrder );
			$.post( '#event.buildLink( prc.xehPageOrder )#', { newRulesOrder:newRulesOrder }, function(){
				for( var i = 0; i < rows.length; i++ ) {
					var oID = '##' + rows[ i ].id + '_order';
					$( oID ).html( i + 1 );
				}
				$( row ).css( "cursor", "default" );
			} );
			//console.log( $( row ) );
			$( row ).find( "a.dragHandle" )
				.css( "cursor", "pointer" )
				.removeClass( "btn-primary" )
				.addClass( "btn-default" );
			$( row ).removeClass( "dotted" );
		}
	} );
	</cfif>
} );
</script>
</cfoutput>