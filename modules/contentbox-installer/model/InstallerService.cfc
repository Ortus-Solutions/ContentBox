/**
* Installs ContentBox
*/
component accessors="true"{
	
	// DI
	property name="authorService" 	inject="id:authorService@cb";
	property name="settingService" 	inject="id:settingService@cb";
	property name="categoryService" inject="categoryService@cb";
	property name="entryService"	inject="entryService@cb";
	property name="commentService"	inject="commentService@cb";
	
	InstallerService function init(){
		return this;
	}
	
	function execute(required setup) transactional{
		// create Author
		var author = createAuthor( setup );
		// create All Settings
		createSettings( setup );
		// Do we create sample data?
		if( setup.getpopulateData() ){
			createSampleData( setup, author );
		}
		// ContentBox is now online, mark it:
		settingService.activateCB();
	}
	
	function createAuthor(required setup){
		// First start by creating user
		var oAuthor = authorService.new(properties=setup.getUserData());
		oAuthor.setIsActive( true );
		authorService.saveAuthor( oAuthor );
		
		return oAuthor;
	}
	
	function createSettings(required setup){
		
		// Create Settings
		var settings = {
			// User Input Settings
			"cb_site_name" = setup.getSiteName(),
			"cb_site_email" = setup.getSiteEmail(),
			"cb_site_tagline" = setup.getSiteTagLine(),
			"cb_site_description" = setup.getSiteDescription(),
			"cb_site_keywords" = setup.getSiteKeyWords(),
			"cb_site_outgoingEmail" = setup.getSiteOutgoingEmail(),
			"cb_site_homepage" = "cbBlog",
			
			// Paging Defaults
			"cb_paging_maxrows" = 20,
			"cb_paging_bandgap" = 5,
			"cb_paging_maxentries" = 10,
			"cb_paging_maxRSSComments" = 10,
			
			// Gravatar
			"cb_gravatar_display" = true,
			"cb_gravatar_rating" = "PG",
			
			// Dashboard Settings
			"cb_dashboard_recentEntries" = 5,
			"cb_dashboard_recentPages" = 5,
			"cb_dashboard_recentComments" = 5,
			
			// Comment Settings
			"cb_comments_whoisURL" = "http://whois.arin.net/ui/query.do?q",
			"cb_comments_maxDisplayChars" = 500,
			"cb_comments_enabled" = true,
			"cb_comments_urltranslations" = true,
			"cb_comments_moderation" = true,
			"cb_comments_moderation_whitelist" = true,
			"cb_comments_notify" = true,
			"cb_comments_moderation_notify" = true,
			"cb_comments_notifyemails" = "",
			"cb_comments_moderation_blacklist" = "",
			"cb_comments_moderation_blockedlist" = "",
			"cb_comments_captcha" = true,
			
			// Notifications
			"cb_notify_author" = false,
			"cb_notify_entry" = true,
			"cb_site_layout" = "default",
			
			// RSS Feeds
			"cb_rss_cachingTimeout" = 60,
			"cb_rss_maxEntries" = 10,
			"cb_rss_caching" = false,
			"cb_rss_maxComments" = 10,
			"cb_rss_cachingTimeoutIdle" = 15,
			"cb_rss_cacheName" = "Template"
		};
		
		// Create setting objects and save
		var aSettings = [];
		for(var key in settings){
			var props = {name=key,value=settings[key]};
			arrayAppend( aSettings, settingService.new(properties=props) );
		}
		
		settingService.saveAll( aSettings );
	}
	
	function createSampleData(required setup, required author){
		
		// create a few categories
		//categoryService.createCategories("General, ColdFusion, ColdBox");
		
		// create some blog entries
		var entry = entryService.new(properties={
			title = "My first entry",
			slug  = "my-first-entry",
			content = "Hey everybody, this is my first blog entry made from ContentBox.  Isn't this amazing!'",
			publishedDate = now(),
			isPublished = true,
			allowComments = true,
			passwordProtection='',
			HTMLKeywords = "cool,first entry, contentbox",
			HTMLDescription = "The most amazing ContentBox blog entry in the world"
		});
		entry.setAuthor( author );
		
		// good comment
		var comment = commentService.new(properties={
			content = "What an amazing blog entry, congratulations!",
			author = "Awesome Joe",
			authorIP = cgi.REMOTE_ADDR,
			authorEmail = "awesomejoe@gocontentbox.com",
			authorURL = "www.gocontentbox.com",
			isApproved = true
		});
		comment.setEntry( entry );
		entry.addComment( comment );
		
		// nasty comment
		var comment = commentService.new(properties={
			content = "I am some bad words and bad comment not approved",
			author = "Bad Joe",
			authorIP = cgi.REMOTE_ADDR,
			authorEmail = "badjoe@gocontentbox.com",
			authorURL = "www.gocontentbox.com",
			isApproved = false
		});
		comment.setEntry( entry );
		entry.addComment( comment );
		
		// save entry
		entryService.saveEntry( entry );
	}
	
}
