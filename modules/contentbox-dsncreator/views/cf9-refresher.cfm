<cfoutput>
<cfsetting showdebugoutput="false">
<cfset assetRoot = "../../contentbox-admin">
<!DOCTYPE html>
<html>
<!--============================Head============================-->
<head>
	<!--- Title --->
    <title>ContentBox Datasource Wizard</title>
	<script>
		function refreshit(){
			var t=setTimeout( "reloadit()",8000);
		}
		function reloadit(){
			window.location.reload();
		}
	</script>
</head>
<!--============================Body============================-->
<body onload="refreshit()">
	<h1>Creating Datasource...</h1>
	<p>
		Please wait as we configure the system for operation (About 8-10 seconds), be patient now!
	</p>
	<p>
		<img src="#assetRoot#/includes/images/ajax-loader-blue.gif" alt="loader" />
	</p>
</body>
<!--End Body-->
</html>
</cfoutput>