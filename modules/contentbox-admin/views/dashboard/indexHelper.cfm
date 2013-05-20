<cfoutput>
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
 	$("##latestEntries").load( '#event.buildLink( prc.xehLatestEntries )#' );
	$("##latestPages").load( '#event.buildLink( prc.xehLatestPages )#' );
	$("##latestNews").load( '#event.buildLink( prc.xehLatestNews )#' );
	$("##latestComments").load( '#event.buildLink( prc.xehLatestComments )#' );
	$("##latestSnapshot").load( '#event.buildLink( prc.xehLatestSnapshot )#' );
});
function deleteInstaller(){
	deleteModule( '#event.buildLink(prc.xehDeleteInstaller)#', "installerCheck" );
}
function deleteDSNCreator(){
	deleteModule( '#event.buildLink(prc.xehDeleteDSNCreator)#', "dsnCreatorCheck" );
}
function deleteModule(link, id){
	$.post( link, {}, function(data){
		if( data.ERROR ){
			alert( data.MESSAGE );
		} 
		else{
			$( "##" + id ).html( data.MESSAGE ).delay( 2000 ).fadeOut();
		}
	},
	"JSON");
}
</script>
</cfoutput>