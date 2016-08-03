<cfoutput>
<!--- Custom JS --->
<script>
$(document).ready(function() {
	$pagesPager = $( "##pages_pager" );
	$pagesPager.find( "tr:even" ).addClass( "even" );
	// quick look
	$pagesPager.find( "tr" ).bind( "contextmenu",function(e) {
		if (e.which === 3) {
			if( $(this).attr('data-contentID') != null ){
				openRemoteModal('#event.buildLink(prc.xehPageQuickLook)#/contentID/' + $(this).attr('data-contentID'));
				e.preventDefault();
			}
		}
	} );
	<!---If admin and also if sorting is enabled --->
	<cfif prc.oAuthor.checkPermission( "PAGES_ADMIN" ) AND prc.pagePager_sorting>
	$( "##pages_pager" ).tableDnD( {
		onDragClass: "selected",
		onDragStart : function(table,row){
			$(row).css( "cursor","grab" );
			$(row).css( "cursor","-moz-grabbing" );
			$(row).css( "cursor","-webkit-grabbing" );
		},
		onDrop: function(table, row){
			$(row).css( "cursor","progress" );
			var newRulesOrder  =  $(table).tableDnDSerialize();
			var rows = table.tBodies[0].rows;
			$.post('#event.buildLink(prc.xehPageOrder)#',{newRulesOrder:newRulesOrder,tableID:'pages_pager'},function(){
				for (var i = 0; i < rows.length; i++) {
					var oID = '##' + rows[i].id + '_order';
					$(oID).html(i+1);
				}
				$(row).css( "cursor","move" );
			} );
		}
	} );
	</cfif>
} );
function pagerLink(page){
	$( "##pagePagerLoader" ).fadeIn( "fast" );
	$('##pagerPages')
		.load('#event.buildLink(prc.xehPagePager)#?pagePager_pagination=#prc.pagePager_pagination#&pager_authorID=#prc.pagePager_authorID#&pager_parentID=#prc.pagePager_parentID#&pagePager_sorting=#prc.pagePager_sorting#&page=' + page, 
		function() {
			$( "##pagePagerLoader" ).fadeOut();
			hideAllTooltips();
			activateTooltips();
	} );
}
<cfif prc.oAuthor.checkPermission( "PAGES_ADMIN" )>
function changeOrder(contentID,order,direction){
	// img change
	$('##order'+direction+'_'+contentID).removeClass( "icon-remove-sign" ).addClass( "fa fa-spinner fa-spin" );
	// change order
	$.post('#event.buildLink(prc.xehPageOrder)#',{contentID:contentID,order:order},function(){
		hideAllTooltips();
		pagerLink(#rc.page#);
	} );
}
</cfif>
</script>
</cfoutput>