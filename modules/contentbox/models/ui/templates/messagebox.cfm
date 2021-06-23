<cfscript>
	switch( msgStruct.type ){
		case "info" : {
			local.cssType = " alert-info";
			local.iconType = "fa fa-info-circle";
			break;
		}
		case "error" : {
			local.cssType = " alert-danger";
			local.iconType = "fa fa-frown-o";
			break;
		}
		case "success" : {
			local.cssType = " alert-success";
			local.iconType = "fa fa-frown-o";
			break;
		}
		case "dark" : {
			local.cssType = " alert-dark";
			local.iconType = "fa fa-frown-o";
			break;
		}
		case "light" : {
			local.cssType = " alert-light";
			local.iconType = "fa fa-frown-o";
			break;
		}
		default : {
			local.cssType = " alert-warning";
			local.iconType = "fa fa-exclamation-triangle";
		}
	}
</cfscript>
<cfoutput>
<div class="alert#local.cssType#" style="min-height: 38px">
	<button type="button" class="close" data-dismiss="alert">&times;</button>
	<i class="#local.iconType# fa-lg fa-2x pull-left"></i>
	<cfif isSimpleValue( msgStruct.message )>
		#msgStruct.message#
	<cfelse>
		#msgStruct.message.toString()#
	</cfif>
</div>
</cfoutput>