component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	property name="settingService"			inject="id:settingService@cb";
	
	
	/**
	* Constructor
	*/
	StatsService function init(){
		// init it
		super.init(entityName="cbStats", useQueryCaching=false);
		return this;
	}
	
	

	function isUserAgentABot(){
		var userAgent = LCase( CGI.http_user_agent );
		var arr = ListToArray(settingService.getSetting('cb_content_bot_regex'), chr(13));
		
		for(var i=1; i LTE ArrayLen(arr); i=i+1){
			var found = reMatch(arr[i], userAgent);
			if(ArrayLen(found) > 0) return true;
		}

		return false;
	}
	
	/**
	* Update the content hits
	* @contentID.hint The content id to update
	*/
	public function syncUpdateHits(required contentID){
		if(settingService.getSetting('cb_content_hit_count')) {
			try {
				if(settingService.getSetting('cb_content_hit_ignore_bots') OR !isUserAgentABot()) {
					var q = new Query(sql="UPDATE cb_stats SET hits = hits + 1 WHERE FK_contentID = #arguments.contentID#").execute();
					if(q.getPrefix().RECORDCOUNT eq 0)
						var q = new Query(sql="INSERT INTO cb_stats (hits,FK_contentID) VALUES (1, #arguments.contentID#)").execute();
				}
			} catch (any e) {
			}
		}
		return this;
	}
}