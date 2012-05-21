<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	// global ids
	$pageForm = $("##pageForm");
	$pages	  = $("##pages");
	// sorting and filtering
	$("##pages").tablesorter();
	$("##pageFilter").keyup(function(){
		$.uiTableFilter( $pages, this.value );
	});
	// quick look
	$pages.find("tr").bind("contextmenu",function(e) {
	    if (e.which === 3) {
	    	if($(this).attr('data-contentID') != null) {
				openRemoteModal('#event.buildLink(prc.xehPageQuickLook)#/contentID/' + $(this).attr('data-contentID'));
				e.preventDefault();
			}
	    }
	});
	<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
	$pages.tableDnD({
		onDragClass: "selected",
		onDragStart : function(table,row){
			$(row).css("cursor","grab");
			$(row).css("cursor","-moz-grabbing");
			$(row).css("cursor","-webkit-grabbing");
		},
		onDrop: function(table, row){
			$(row).css("cursor","progress");
			var newRulesOrder  =  $(table).tableDnDSerialize();
			var rows = table.tBodies[0].rows;
			$.post('#event.buildLink(prc.xehPageOrder)#',{newRulesOrder:newRulesOrder},function(){
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
function remove(contentID){
	if( contentID != null ){
		$('##delete_'+contentID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
		checkByValue('contentID',contentID);		
	}
	$pageForm.submit();
}
function clonePage(contentID, title){
	var newTitle = prompt("Please Enter The New Page Title", title);
	if (newTitle != null) {
		to("#event.buildLink(prc.xehPageClone)#?title=" + title + "&contentID=" + contentID);
	}
}
function bulkChangeStatus(status, contentID){
	$pageForm.attr("action","#event.buildlink(linkTo=prc.xehPageBulkStatus)#");
	$pageForm.find("##contentStatus").val( status );
	if( contentID != null ){
		$('##status_'+recordID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
		checkByValue('contentID',contentID);	
	}
	$pageForm.submit();
}
</script>
</cfoutput>