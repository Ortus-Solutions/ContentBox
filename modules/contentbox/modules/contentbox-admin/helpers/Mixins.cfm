<cfscript>
	function cbAdminComponent( required component, struct args = {} ){
		return renderView(
			view 			: "_components/#arguments.component#",
			args 			: arguments.args,
			prePostExempt 	: true
		);
	}
</cfscript>