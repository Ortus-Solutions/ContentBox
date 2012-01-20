<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	// pointers
	$authorForm 	= $("##authorForm");
	$authorUsername = $authorForm.find("##username");
	
	// initialize validator and add a custom form submission logic
	$authorForm.validator({grouped:true});
	
	// Custom username unique validator
	$.tools.validator.fn($authorUsername, function(el, value) {
		// verify if same as user
		if(value.length && value == "#prc.author.getUsername()#" ){
			return true;
		}
		// verify username
		if( isUsernameFound(value) ){
			return "The username you entered already exists, try a new one!";
		}
		return true;
	});
	
	<cfif prc.author.isLoaded()>
	$("##authorPasswordForm").validator({grouped:true});
	$.tools.validator.fn("[name=password_confirm]", "Passwords need to match", function(el, value) {
		return (value==$("[name=password]").val()) ? true : false;
	});
	// Setup Permissions
	$permissionsTab = $("##permissionsTab");
	</cfif>
	
});
function isUsernameFound(username){
	var usernameFound = false;
	$.ajax({
		url:'#event.buildLink(prc.xehUsernameCheck)#',
		data: {username: username},
		async:false,
		success: function(data){
			usernameFound = data;
		},
		dataType:"json"
	});
	return usernameFound;
}
<cfif prc.author.isLoaded()>
function loadPermissions(){
	$permissionsTab.load('#event.buildLink(prc.xehAuthorPermissions)#/authorID/'+#prc.author.getAuthorID()#);
}
</cfif>
</script>
</cfoutput>