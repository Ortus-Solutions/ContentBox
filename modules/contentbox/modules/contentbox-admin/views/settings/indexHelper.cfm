<cfoutput>
<style>
.CodeMirror, .CodeMirror-scroll {
	height: 200px;
	min-height: 200px;
}
</style>
<script>
document.addEventListener( "DOMContentLoaded", () => {
	// Slider Label Binders by convention, expecting an ID_label field
	$( "input.slider" ).on( "slide", function( slideEvt ){
		$( "##" + slideEvt.target.id + "_label" ).text( slideEvt.value );
	});
	// Load all MDEditors for .mde classes
	var mdEditors =  {};
	$( ".mde" ).each( function(){
		mdEditors[ $( this ).prop( "id" ) ] = new SimpleMDE( {
			element 		: this,
			autosave 		: { enabled : false },
			promptURLs 		: true,
			tabSize 		: 2,
			forceSync 		: true,
			placeholder 	: 'Type here...',
			spellChecker 	: false
		} );
	} );
} );
function emailTest(){
	$( "##emailTestDiv" ).html( "" );
	$( "##iTest" ).addClass( "fa-spin" );
	$.post('#event.buildLink( prc.xehEmailTest )#',
		{
		  cb_site_mail_server : $( "##cb_site_mail_server" ).val(),
		  cb_site_mail_username : $( "##cb_site_mail_username" ).val(),
		  cb_site_mail_password : $( "##cb_site_mail_password" ).val(),
		  cb_site_mail_smtp : $( "##cb_site_mail_smtp" ).val(),
		  cb_site_mail_tls : $( "##cb_site_mail_tls" ).val(),
		  cb_site_mail_ssl : $( "##cb_site_mail_ssl" ).val(),
		  cb_site_outgoingEmail : $( "##cb_site_outgoingEmail" ).val()
		},
		function(data){
			if( data.ERROR ){
				var eMessages = $.map(data.ERRORARRAY, function(val,index) {
				     return val;
				} ).join( ", " );
				$( "##emailTestDiv" ).html( "Error sending test email: " + eMessages );
			}
			else{
				$( "##emailTestDiv" ).html('<div class="alert alert-success">Test email sent to ' + $( "##cb_site_outgoingEmail" ).val() + ', please verify you received it.</div>');
			}
			$( "##iTest" ).removeClass( "fa-spin" );
		},
		"JSON"
	);
	return false;
}
function chooseAdapter( adapter ){
	$( "##settingsForm" ).find( "##cb_search_adapter" ).val( adapter );
}
</script>
</cfoutput>
