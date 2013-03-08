<cfoutput>
<!--- Custom Javascript --->
<script type="text/javascript">
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