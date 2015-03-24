/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
* 
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	property name="settingService"		inject="id:settingService@cb";
	property name="cb"					inject="cbhelper@cb";
	
	/**
	* Constructor
	*/
	LoginTracker function init(){
		// init it
		super.init(entityName="cbLoginAttempts");
		return this;
	}
	/*
	*	Perform Setup, uses settingsService
	*/
	void function onDIComplete(){
		//make default settings in DB if not there
		this.setup();
	}	
	
	/*
	* Always load entry for current username and IP address
	*/
	function loadEntry(event, interceptData, buffer){
		var prc = event.getCollection(private = true);
		var ip = '127.0.0.1'; //cgi.REMOTE_ADDR
		this.reset(); //reset login attempts, before entry is loaded
		this.truncate(); //truncate table
		//check it is local.. there can be a load balanced server env.
		if(ip eq '127.0.1.1'){
			var reqHead = GetHttpRequestData();
			if(structKeyExists(reqHead,'headers') and structKeyExists(reqHead.headers,'x-cluster-client-ip')){
				ip = reqHead.headers['x-cluster-client-ip'];
			}
		}
		//if for request
		prc.ip = ip;
		//username, if not there make a unique key
		prc.username = event.getValue('username',createUUID());
		//predefine user entry and ip entry
		prc.ipEntry = findWhere({value=prc.ip});
		prc.UsernameEntry = findWhere({value=prc.username});
	}
	/*
	*	If logins fails, add entry to database with username and IP
	*/
	void function cbadmin_onBadLogin(event){
		//if disabled, we do not track bad logins
		if(!settingService.findWhere( { name = 'cb_security_login_blocker'} ).getValue())
			return;
		this.loadEntry(event);
		var rc = event.getCollection();
		var prc = event.getCollection(private = true);
		//make or update entry for IP 
		if(!isNull(prc.ipEntry)){
			prc.ipEntry.setAttempts(prc.ipEntry.getAttempts()+1);
		}else{
			prc.ipEntry = new();
			prc.ipEntry.setValue(prc.ip);
		}
		prc.ipEntry.setcreatedDate(now());
		save(entity = prc.ipEntry);

		//make or update entry for IP 
		if(!isNull(prc.UsernameEntry)){
			prc.UsernameEntry.setAttempts(prc.UsernameEntry.getAttempts()+1);
		}else{
			prc.UsernameEntry = new();
			prc.UsernameEntry.setValue(prc.username);
		}
		prc.UsernameEntry.setcreatedDate(now());
		save(entity = prc.UsernameEntry);		
	}	
	/*
	*	Before login is done, check if user or IP has been blocked
	*/
	void function cbadmin_preLogin(event, interceptData, buffer){
		this.loadEntry(event);
		var prc = event.getCollection(private=true);
		// do checks to prevent login
		var isBlocked = false;
		//which reason?
		var byIP = false;
		
		//get setting of max allowed logins
		var max_Attempts = settingService.findWhere( { name = 'cb_security_max_Attempts'} ).getValue();
		//do checks
		if(!isNull(prc.UsernameEntry)){
			if(this.isBlocked(prc.UsernameEntry)){
				isBlocked = true;
			}
		}
		if(!isNull(prc.ipEntry)){
			if(this.isBlocked(prc.ipEntry)){
				isBlocked = true;
				byIP = true;
			}
		}
		if(isblocked){
			if(!byIP)
				getPlugin("MessageBox").warn(  cb.r( "messages.user_blocked@security" ));
			else
				getPlugin("MessageBox").warn(  cb.r( "messages.ip_blocked@security" ));
			// Relocate
			setNextEvent( "#prc.cbAdminEntryPoint#.security.login" );			
		}
	}
	public boolean function isblocked(LoginAttempts attempts){
		var max_Attempts = settingService.findWhere( { name = 'cb_security_max_Attempts'} ).getValue();
		var max_blockTime = settingService.findWhere( { name = 'cb_security_blocktime'} ).getValue(); 
		if(arguments.attempts.getAttempts() gte max_Attempts and (datediff('n',arguments.attempts.getCreatedDate(),now()) lte max_blockTime))
			return true;
		else
			return false;
	}
	
	/*
	* Used for admin listing, include blocked state. Not stored in DB
	*/
	public array function getAll(){
		var allEntries = list(sortOrder="attempts",asQuery=false);
		for(var e in allEntries){
			if(this.isBlocked(e))
				e.setIsBlocked(true);
		}
		return allEntries;
		
	}
	
	void function cbadmin_onLogin(event, interceptData, buffer){
		//if disabled, we do not track logins
		if(!settingService.findWhere( { name = 'cb_security_login_blocker'} ).getValue())
			return;
		var prc = event.getCollection(private=true);

		if(isNull(prc.UsernameEntry)){
			prc.UsernameEntry = new();
			prc.UsernameEntry.setValue(prc.username);
		}
		if(!isNull(prc.IPEntry)){
			prc.ipEntry.setcreatedDate(now());
			save(entity = prc.IPEntry);
		}		
		prc.UsernameEntry.setlastLoginSuccessIP(prc.ip);
		prc.UsernameEntry.setcreatedDate(now());
		prc.UsernameEntry.setAttempts(0);
		save(entity = prc.UsernameEntry);
		
	}
			
	function getLastLogins(max = 5){
		var hql = "from cbLoginAttempts where lastLoginSuccessIP != '' ";
		return executeQuery( query=hql, asQuery = false , max= arguments.max);
	}
	
	
	/*
	*	Truncate table, purge entries that are expired
	*/
	private void function truncate(){
		//get entries over table limit
		var entries = list(offset=settingService.findWhere( { name = 'cb_security_max_auth_logs'} ).getValue(), sortorder = "LoginAttemptsID DESC", asQuery = false);
		for(var e in entries){
			deleteByID(e.getLoginAttemptsID());
		}
			
	}
	/*
	* Reset login attempts if the time limit is reached
	*/
	private void function reset(){
		//reset entries older than Limit
		var hql = "update cbLoginAttempts set attempts = 0 WHERE DATEDIFF(MINUTE,getdate(),createdDate)*-1 >:min ";
		var params = {};
		params["min"] = settingService.findWhere( { name = 'cb_security_blocktime'} ).getValue();
		// run
		executeQuery( query=hql, params=params, asQuery=false );
	}	
	 
	/*
	* Add Settings to DB needed to handle logins
	*
	*/
	private void function setup(){
		var defaultSettings = ArrayNew(1);
		arrayAppend(defaultSettings,{name="cb_security_login_blocker",value=true });// activates/deactivates this feature
		arrayAppend(defaultSettings,{name="cb_security_max_Attempts",value=5 }); 	// how many invalid logins from same IP to block login threshold 
		arrayAppend(defaultSettings,{name="cb_security_blocktime",value=5 }); 		// The number of minutes to block the user from that IP
		arrayAppend(defaultSettings,{name="cb_security_max_auth_logs",value=500 });	//cb_security_max_auth_logs
		for(var defSet in defaultSettings){
			var setting = settingService.findWhere( { name = defSet.name } );
			// if no key, then create it for this ContentBox installation
			if( isNull( setting ) ){
				setting = settingService.new();
				setting.setValue( javaCast( "string", defSet.value ) );
				setting.setName( defSet.name );
				settingService.save(entity=setting);
			}
		}
	}

}