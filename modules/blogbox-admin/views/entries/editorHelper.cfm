<cfscript>
	function toCKDate(inDate){
		return dateFormat(arguments.inDate,"yyyy-mm-dd");
	}
	function ckHour(inDate){
		if( isNull(inDate) ){ inDate = now(); }
		return timeFormat(arguments.inDate,"HH");
	}
	function ckMinute(inDate){
		if( isNull(inDate) ){ inDate = now(); }
		return timeFormat(arguments.inDate,"mm");
	}
</cfscript>