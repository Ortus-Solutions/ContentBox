<cfoutput>
<script>
document.addEventListener( "DOMContentLoaded", () => {
	$importDialog = $( "##importDialog" );

	$ruleForm = $( "##ruleForm" );
	$ruleForm.find( "##rules" ).dataTable( {
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

	$( "##ruleFilter" ).keyup(
		_.debounce(
            function(){
                $.uiTableFilter( $( "##rules" ), this.value );
            },
            300
        )
	);

	<cfif prc.oCurrentAuthor.checkPermission( "SECURITYRULES_ADMIN" )>
	$ruleForm.find( "##rules" ).tableDnD( {
		onDragClass : "selected",
		onDragStart : function( table, row ){
			var $rowContainer = $( row )
				.closest( 'tr' )
				.addClass( "border-dotted opacity-70" );
			this.movedHash = $( table ).tableDnDSerialize();
			$( row )
				.css( "cursor", "grab" )
				.css( "cursor", "-moz-grabbing" )
				.css( "cursor", "-webkit-grabbing" );
		},
		onDrop : function( table, row ){
			var newRulesOrder = $( table ).tableDnDSerialize();
			// only move if hash is diff
			if( this.movedHash == newRulesOrder ){ return; }
			var rows = table.tBodies[ 0 ].rows;
			$( row ).css( "cursor", "progress" );
			$.post(
				'#event.buildLink( prc.xehRuleOrder )#',
				{ newRulesOrder : newRulesOrder },
				function(){
					for ( var i = 0; i < rows.length; i++ ) {
						var oID = '##' + rows[ i ].id + '_order';
						$( oID ).html( i + 1 );
					}
					$( row ).css( "cursor", "pointer" );
					$( row ).removeClass( "border-dotted opacity-70" );
				}
			);
		}
	} );
	</cfif>
} );

<cfif prc.oCurrentAuthor.checkPermission( "SECURITYRULES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
function remove(recordID){
	if( recordID != null ){
		$( "##delete_" + recordID )
			.removeClass( "fa fa-minus-circle" )
			.addClass( "fa fa-spinner fa-spin" );
		$( "##ruleID" ).val( recordID );
	}
	//Submit Form
	$ruleForm.submit();
}
function exportSelected( exportEvent ){
	var selected = [];
	$( "##securityRuleID:checked" ).each( function(){
		selected.push( $( this ).val() );
	} );
	if( selected.length ){
		checkAll( false, 'securityRuleID' );
		window.open( exportEvent + "/securityRuleID/" + selected );
	} else {
		alert( "Please select something to export!" );
	}
}
</cfif>
</script>
</cfoutput>