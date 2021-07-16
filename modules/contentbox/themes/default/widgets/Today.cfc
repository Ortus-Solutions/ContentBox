/**
 * A widget that shows you today's date.
 */
component extends="contentbox.models.ui.BaseWidget" singleton {

	function init(){
		// Widget Properties
		setName( "Today" );
		setVersion( "1.0.0" );
		setDescription( "A widget to show today's date" );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "https://www.ortussolutions.com" );
		setIcon( "info" );

		return this;
	}

	/**
	 * Gives you todays date according to format
	 *
	 * @showTime Shows the time as well
	 * @dateMask The date part mask
	 * @timeMask The time part mask
	 */
	any function renderIt(
		boolean showTime = true,
		dateMask         = "full",
		timeMask         = "full"
	){
		var rightNow = now();
		var results  = dateTimeFormat( rightNow, arguments.dateMask );

		return ( arguments.showTime ? results & timeFormat( rightNow, arguments.timeMask ) : results );
	}

}
