<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	$("##pages").tablesorter();
	$("##pageFilter").keyup(function(){
		$.uiTableFilter( $("##pages"), this.value );
	});
	// quick look
	$("##pages").find("tr").bind("contextmenu",function(e) {
	    if (e.which === 3) {
	    	if($(this).attr('data-pageID') != null) {
				openRemoteModal('#event.buildLink(prc.xehPageQuickLook)#/pageID/' + $(this).attr('data-pageID'));
				e.preventDefault();
			}
	    }
	});
	<cfif prc.oAuthor.checkPermission("PAGES_ADMIN")>
	$("##pages").tableDnD({
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
function remove(pageID){
	// img change
	$('##delete_'+pageID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
	$("##pageID").val( pageID );
	$("##pageForm").submit();
}
</script>
</cfoutput>