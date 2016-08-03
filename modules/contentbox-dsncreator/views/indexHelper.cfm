<cfoutput>
<script language="javascript">
$( document ).ready(function() {
} );
function showDSNPanel( created ){
	if( created ){
		$( "##dsnPanelCreate" ).hide();
		$( "##dsnPanelExists" ).fadeIn();
	}
	else{
		$( "##dsnPanelExists" ).hide();
		$( "##dsnPanelCreate" ).fadeIn();
	}
}
function verifyDSN(){
	$.ajax( {
		url:'handlers/verifyDSN.cfm',
		data: { dsnName : $( "##dsnName" ).val() },
		success: function( data ){
			if( data.ERROR || !data.EXISTS ){
				$( "##createButton" ).fadeOut();
				alert( "Error verifying datasource: " + data.MESSAGES );
			}
			else{
				$( "##createButton" ).fadeIn();
			}
		},
		dataType:"json"
	} );
}
function verifyData(){
	if( !$( "##dsnCreateName" ).val().length ){
		alert( "Please enter a datsource name" );
		return;
	}
	
	var cfVerified = false;
	// Verify CFML Password First
	$.ajax( {
		url:'handlers/verifyCFML.cfm',
		data: { cfmlPassword : $( "##cfpassword" ).val() },
		success: function(data){
			if( data.ERROR ){
				alert( "Error verifying CFML Administrator password: " + data.MESSAGES );
				cfVerified = false;
			}
			else{
				cfVerified = true;
			}
			
			if( cfVerified ){
				// Verify DSN Does NOT exists
				$.ajax( {
					url:'handlers/verifyDSN.cfm',
					data: { dsnName : $( "##dsnCreateName" ).val() },
					success: function(data){
						if( data.EXISTS ){
							alert( "Datasource " + $( "##dsnCreateName" ).val() + " already exists. Please try another name." );
						}
						else{
							// Lock password and dsn name
							$( "##cfpassword" ).attr( "readonly",true);
							$( "##dsnCreateName" ).attr( "readonly",true);
							// Show creation dialog
							$( "##verifyDataButton" ).fadeOut();
							$( "##createDSNButton" ).fadeIn();
						}
					},
					dataType:"json"
				} );
			}
		},
		dataType:"json"
	} );
	
	
}
</script>
</cfoutput>
