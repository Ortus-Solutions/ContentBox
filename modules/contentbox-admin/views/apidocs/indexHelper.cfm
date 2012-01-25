<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$("##apislug").change(function() {
		$this = $(this);
		to('#event.buildLink(prc.xehAPIDocs)#/index/apislug/'+$this.val());
	});
});
</script>
</cfoutput>