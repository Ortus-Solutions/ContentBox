<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	// tables references
	$pages = $("##pages");
	// sorting
	$pages.dataTable({
		"paging": false,
		"info": false,
		"searching": false
	});
	// activate confirmations
	activateConfirmations();
	// activate tooltips
	activateTooltips();
	// quick look
	activateQuickLook( $pages, '#event.buildLink(prc.xehPageQuickLook)#/contentID/' );
	// Popovers
	activateInfoPanels();
	
	<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
	// Drag and drop hierarchies
	$pages.tableDnD({
		onDragClass: "selected",
		onDragStart : function(table,row){
			this.movedHash = $(table).tableDnDSerialize();
			$(row).css("cursor","grab");
			$(row).css("cursor","-moz-grabbing");
			$(row).css("cursor","-webkit-grabbing");
		},
		onDrop: function(table, row){
			var newRulesOrder = $(table).tableDnDSerialize();
			// only move if hash is diff
			if( this.movedHash == newRulesOrder ){ return; }
			// do the move, its a diff hash
			var rows = table.tBodies[0].rows;
			$(row).css("cursor","progress");
			$.post('#event.buildLink(prc.xehPageOrder)#', { newRulesOrder:newRulesOrder }, function(){
				for (var i = 0; i < rows.length; i++) {
					var oID = '##' + rows[i].id + '_order';
					$(oID).html(i+1);
				}
				$(row).css("cursor","move");
			});
		}
	});
	</cfif>
});
</script>
</cfoutput>