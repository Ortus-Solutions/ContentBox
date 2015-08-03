<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	// pointers
	$authorForm 	= $( "##authorForm" );
	$authorUsername = $authorForm.find( "##username" );
	
	// initialize validator and add a custom form submission logic
	$authorForm.validate();
    
	// Custom username unique validator
    $.validator.addMethod( 'username', function( value, element ) {
       if(value.length && value == "#prc.author.getUsername()#" ){
			return true;
		}
		// verify username
		if( isUsernameFound(value) ){
			return false;
		}
		return true;
    }, "The username you entered already exists, try a new one!" );
	
	<cfif prc.author.isLoaded()>
    $( "##authorPasswordForm" ).validate();
    $.validator.addMethod( 'password', function( value, element ) {
        return (value==$( "[name=password]" ).val()) ? true : false;
    }, 'Passwords need to match' );
	// Setup Permissions
	$permissionsTab = $( "##permissionsTab" );
	</cfif>
	
} );
function isUsernameFound(username){
	var usernameFound = false;
	$.ajax( {
		url:'#event.buildLink(prc.xehUsernameCheck)#',
		data: {username: username},
		async:false,
		success: function(data){
			usernameFound = data;
		},
		dataType:"json"
	} );
	return usernameFound;
}
<cfif prc.author.isLoaded()>
function loadPermissions(){
	$permissionsTab.load('#event.buildLink(prc.xehAuthorPermissions)#/authorID/'+#prc.author.getAuthorID()#);
}
</cfif>
</script>
</cfoutput>