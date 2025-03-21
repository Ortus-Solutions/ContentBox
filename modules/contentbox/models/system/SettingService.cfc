/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Setting Service for ContentBox apps.
 * All settings are cached as a struct constructed using the following format:
 * - global : { name : value } // global settings
 * - sites : {
 * 		slug : { name : value }
 * }
 */
component
	extends  ="cborm.models.VirtualEntityService"
	accessors="true"
	threadsafe
	singleton
{

	// DI properties
	property name="siteService" inject="siteService@contentbox";
	property name="cachebox" inject="cachebox";
	property name="moduleSettings" inject="coldbox:setting:modules";
	property name="appName" inject="coldbox:setting:appName";
	property name="contentboxSettings" inject="coldbox:moduleSettings:contentbox";
	property name="log" inject="logbox:logger:{this}";

	/**
	 * The cache provider name to use for settings caching. Defaults to 'template' cache.
	 * This can also be set in the global ContentBox settings page to any CacheBox cache.
	 */
	property name="cacheProviderName" default="template";

	/**
	 * Bit that detects if CB has been installed or not
	 */
	property
		name   ="CBReadyFlag"
		default="false"
		type   ="boolean";

	// Global Setting Defaults
	this.DEFAULTS = {
		// ContentBox Global Version
		"cb_version"                            : "@version.number@+@build.number@",
		// Installation security salt
		"cb_salt"                               : hash( createUUID() & getTickCount() & now(), "SHA-512" ),
		// Global Notifications
		"cb_site_email"                         : "",
		"cb_notify_author"                      : "true",
		"cb_notify_entry"                       : "true",
		"cb_notify_page"                        : "true",
		"cb_notify_contentstore"                : "true",
		// Outgoing email
		"cb_site_outgoingEmail"                 : "",
		// Blog Entry Point
		"cb_site_blog_entrypoint"               : "blog",
		// Caching
		"cb_site_settings_cache"                : "template",
		// Security Settings
		"cb_security_min_password_length"       : "8",
		"cb_security_password_reset_expiration" : "60",
		"cb_security_login_blocker"             : "true",
		"cb_security_max_attempts"              : "5",
		"cb_security_blocktime"                 : "5",
		"cb_security_max_auth_logs"             : "500",
		"cb_security_latest_logins"             : "10",
		"cb_security_rate_limiter"              : "true",
		"cb_security_rate_limiter_logging"      : "true",
		"cb_security_rate_limiter_count"        : "4",
		"cb_security_rate_limiter_duration"     : "1",
		"cb_security_rate_limiter_bots_only"    : "true",
		"cb_security_rate_limiter_message"      : "<p>You are making too many requests too fast, please slow down and wait {duration} seconds</p>",
		"cb_security_rate_limiter_redirectURL"  : "",
		"cb_security_2factorAuth_force"         : "false",
		"cb_security_2factorAuth_provider"      : "email",
		"cb_security_2factorAuth_trusted_days"  : "30",
		"cb_security_login_signout_url"         : "",
		"cb_security_login_signin_text"         : "",
		// Admin settings
		"cb_admin_ssl"                          : "false",
		"cb_admin_quicksearch_max"              : "5",
		"cb_admin_theme"                        : "contentbox-default",
		// Paging Defaults
		"cb_paging_maxrows"                     : "20",
		"cb_paging_bandgap"                     : "5",
		"cb_paging_maxentries"                  : "10",
		"cb_paging_maxRSSComments"              : "10",
		// Gravatar
		"cb_gravatar_display"                   : "true",
		"cb_gravatar_rating"                    : "PG",
		// Dashboard Settings
		"cb_dashboard_recentEntries"            : "5",
		"cb_dashboard_recentPages"              : "5",
		"cb_dashboard_recentComments"           : "5",
		"cb_dashboard_recentcontentstore"       : "5",
		"cb_dashboard_newsfeed"                 : "https://www.ortussolutions.com/blog/rss",
		"cb_dashboard_newsfeed_count"           : "5",
		"cb_dashboard_welcome_title"            : "Dashboard",
		"cb_dashboard_welcome_body"             : "",
		// Global Comment Settings
		"cb_comments_whoisURL"                  : "http://whois.arin.net/ui/query.do?q",
		// Mail Settings
		"cb_site_mail_server"                   : "",
		"cb_site_mail_username"                 : "",
		"cb_site_mail_password"                 : "",
		"cb_site_mail_smtp"                     : "25",
		"cb_site_mail_tls"                      : "false",
		"cb_site_mail_ssl"                      : "false",
		// RSS Feeds
		"cb_rss_maxEntries"                     : "10",
		"cb_rss_maxComments"                    : "10",
		"cb_rss_caching"                        : "true",
		"cb_rss_cachingTimeout"                 : "60",
		"cb_rss_cachingTimeoutIdle"             : "15",
		"cb_rss_cacheName"                      : "Template",
		"cb_rss_title"                          : "RSS Feed by ContentBox",
		"cb_rss_generator"                      : "ContentBox by Ortus Solutions",
		"cb_rss_copyright"                      : "Ortus Solutions, Corp (www.ortussolutions.com)",
		"cb_rss_description"                    : "ContentBox RSS Feed",
		"cb_rss_webmaster"                      : "",
		// Content Caching and options
		"cb_content_caching"                    : "true",
		"cb_entry_caching"                      : "true",
		"cb_contentstore_caching"               : "true",
		"cb_content_cachingTimeout"             : "60",
		"cb_content_cachingTimeoutIdle"         : "15",
		"cb_content_cacheName"                  : "Template",
		"cb_page_excerpts"                      : "true",
		"cb_content_uiexport"                   : "true",
		"cb_content_cachingHeader"              : "true",
		// Content Hit Tracking
		"cb_content_hit_count"                  : "true",
		"cb_content_hit_ignore_bots"            : "false",
		"cb_content_bot_regex"                  : "Googlebot(?:[\/-](\w+))?|AdsBot-Google(?:-(\w+)|[^-]?) |Feedfetcher-Google|Mediapartners-Google|Mediapartners \(Googlebot\)|APIs-Google|Google-InspectionTool|Storebot-Google|GoogleOther|bingbot|Slurp|[wW]get|LinkedInBot|Python-urllib|python-requests|aiohttp|httpx|libwww-perl|httpunit|Nutch|Go-http-client|phpcrawl|msnbot|jyxobot|FAST-WebCrawler|FAST Enterprise Crawler|BIGLOTRON|Teoma|convera|seekbot|Gigabot|Gigablast|exabot|ia_archiver|GingerCrawler|webmon |HTTrack|grub\.org|UsineNouvelleCrawler|antibot|netresearchserver|speedy|fluffy|findlink|msrbot|panscient|yacybot|AISearchBot|ips-agent|tagoobot|MJ12bot|woriobot|yanga|buzzbot|mlbot|yandex\.com\/bots|purebot|Linguee Bot|CyberPatrol|voilabot|Baiduspider|citeseerxbot|spbot|twengabot|postrank|Turnitin|scribdbot|page2rss|sitebot|linkdex|Adidxbot|ezooms|dotbot|Mail\.RU_Bot|discobot|heritrix|findthatfile|europarchive\.org|NerdByNature\.Bot|(sistrix|SISTRIX) [cC]rawler|Ahrefs(Bot|SiteAudit)|fuelbot|CrunchBot|IndeedBot|mappydata|woobot|ZoominfoBot|PrivacyAwareBot|Multiviewbot|SWIMGBot|Grobbot|eright|Apercite|semanticbot|Aboundex|domaincrawler|wbsearchbot|summify|CCBot|edisterbot|SeznamBot|ec2linkfinder|gslfbot|aiHitBot|intelium_bot|facebookexternalhit|Yeti|RetrevoPageAnalyzer|lb-spider|Sogou|lssbot|careerbot|wotbox|wocbot|ichiro|DuckDuckBot|lssrocketcrawler|drupact|webcompanycrawler|acoonbot|openindexspider|gnam gnam spider|web-archive-net\.com\.bot|backlinkcrawler|coccoc|integromedb|content crawler spider|toplistbot|it2media-domain-crawler|ip-web-crawler\.com|siteexplorer\.info|elisabot|proximic|changedetection|arabot|WeSEE:Search|niki-bot|CrystalSemanticsBot|rogerbot|360Spider|psbot|InterfaxScanBot|CC Metadata Scaper|g00g1e\.net|GrapeshotCrawler|urlappendbot|brainobot|fr-crawler|binlar|SimpleCrawler|Twitterbot|cXensebot|smtbot|bnf\.fr_bot|A6-Indexer|ADmantX|Facebot|OrangeBot\/|memorybot|AdvBot|MegaIndex|SemanticScholarBot|ltx71|nerdybot|xovibot|BUbiNG|Qwantify|archive\.org_bot|Applebot|TweetmemeBot|crawler4j|findxbot|S[eE][mM]rushBot|yoozBot|lipperhey|Y!J|Domain Re-Animator Bot|AddThis|Screaming Frog SEO Spider|MetaURI|Scrapy|Livelap[bB]ot|OpenHoseBot|CapsuleChecker|collection@infegy\.com|IstellaBot|DeuSu\/|betaBot|Cliqzbot\/|MojeekBot\/|netEstate NE Crawler|SafeSearch microdata crawler|Gluten Free Crawler\/|Sonic|Sysomos|Trove|deadlinkchecker|Slack-ImgProxy|Embedly|RankActiveLinkBot|iskanie|SafeDNSBot|SkypeUriPreview|Veoozbot|Slackbot|redditbot|datagnionbot|Google-Adwords-Instant|adbeat_bot|WhatsApp|contxbot|pinterest\.com\/bot|electricmonk|GarlikCrawler|BingPreview\/|vebidoobot|FemtosearchBot|Yahoo Link Preview|MetaJobBot|DomainStatsBot|mindUpBot|Daum\/|Jugendschutzprogramm-Crawler|Xenu Link Sleuth|Pcore-HTTP|moatbot|KosmioBot|[pP]ingdom|AppInsights|PhantomJS|Gowikibot|PiplBot|Discordbot|TelegramBot|Jetslide|newsharecounts|James BOT|Bark[rR]owler|TinEye|SocialRankIOBot|trendictionbot|Ocarinabot|epicbot|Primalbot|DuckDuckGo-Favicons-Bot|GnowitNewsbot|Leikibot|LinkArchiver|YaK\/|PaperLiBot|Digg Deeper|dcrawl|Snacktory|AndersPinkBot|Fyrebot|EveryoneSocialBot|Mediatoolkitbot|Luminator-robots|ExtLinksBot|SurveyBot|NING\/|okhttp|Nuzzel|omgili|PocketParser|YisouSpider|um-LN|ToutiaoSpider|MuckRack|Jamie's Spider|AHC\/|NetcraftSurveyAgent|Laserlikebot|^Apache-HttpClient|AppEngine-Google|Jetty|Upflow|Thinklab|Traackr\.com|Twurly|Mastodon|http_get|DnyzBot|botify|007ac9 Crawler|BehloolBot|BrandVerity|check_http|BDCbot|ZumBot|EZID|ICC-Crawler|ArchiveBot|^LCC |filterdb\.iss\.net\/crawler|BLP_bbot|BomboraBot|Buck\/|Companybook-Crawler|Genieo|magpie-crawler|MeltwaterNews|Moreover|newspaper\/|ScoutJet|(^| )sentry\/|StorygizeBot|UptimeRobot|OutclicksBot|seoscanners|Hatena|Google Web Preview|MauiBot|AlphaBot|SBL-BOT|IAS crawler|adscanner|Netvibes|acapbot|Baidu-YunGuanCe|bitlybot|blogmuraBot|Bot\.AraTurka\.com|bot-pge\.chlooe\.com|BoxcarBot|BTWebClient|ContextAd Bot|Digincore bot|Disqus|Feedly|Fetch\/|Fever|Flamingo_SearchEngine|FlipboardProxy|g2reader-bot|G2 Web Services|imrbot|K7MLWCBot|Kemvibot|Landau-Media-Spider|linkapediabot|vkShare|Siteimprove\.com|BLEXBot\/|DareBoost|ZuperlistBot\/|Miniflux\/|Feedspot|Diffbot\/|SEOkicks|tracemyfile|Nimbostratus-Bot|zgrab|PR-CY\.RU|AdsTxtCrawler|Datafeedwatch|Zabbix|TangibleeBot|google-xrawler|axios|Amazon CloudFront|Pulsepoint|CloudFlare-AlwaysOnline|Cloudflare-Healthchecks|Cloudflare-Traffic-Manager|CloudFlare-Prefetch|Cloudflare-SSLDetector|https:\/\/developers\.cloudflare\.com\/security-center\/|Google-Structured-Data-Testing-Tool|WordupInfoSearch|WebDataStats|HttpUrlConnection|ZoomBot|VelenPublicWebCrawler|MoodleBot|jpg-newsbot|outbrain|W3C_Validator|Validator\.nu|W3C-checklink|W3C-mobileOK|W3C_I18n-Checker|FeedValidator|W3C_CSS_Validator|W3C_Unicorn|Google-PhysicalWeb|Blackboard|ICBot\/|BazQux|Twingly|Rivva|Experibot|awesomecrawler|Dataprovider\.com|GroupHigh\/|theoldreader\.com|AnyEvent|Uptimebot\.org|Nmap Scripting Engine|2ip\.ru|Clickagy|Caliperbot|MBCrawler|online-webceo-bot|B2B Bot|AddSearchBot|Google Favicon|HubSpot|Chrome-Lighthouse|HeadlessChrome|CheckMarkNetwork\/|www\.uptime\.com|Streamline3Bot\/|serpstatbot\/|MixnodeCache\/|^curl|SimpleScraper|RSSingBot|Jooblebot|fedoraplanet|Friendica|NextCloud|Tiny Tiny RSS|RegionStuttgartBot|Bytespider|Datanyze|Google-Site-Verification|TrendsmapResolver|tweetedtimes|NTENTbot|Gwene|SimplePie|SearchAtlas|Superfeedr|feedbot|UT-Dorkbot|Amazonbot|SerendeputyBot|Eyeotabot|officestorebot|Neticle Crawler|SurdotlyBot|LinkisBot|AwarioSmartBot|AwarioRssBot|RyteBot|FreeWebMonitoring SiteChecker|AspiegelBot|NAVER Blog Rssbot|zenback bot|SentiBot|Domains Project\/|Pandalytics|VKRobot|bidswitchbot|tigerbot|NIXStatsbot|Atom Feed Robot|[Cc]urebot|PagePeeker\/|Vigil\/|rssbot\/|startmebot\/|JobboerseBot|seewithkids|NINJA bot|Cutbot|BublupBot|BrandONbot|RidderBot|Taboolabot|Dubbotbot|FindITAnswersbot|infoobot|Refindbot|BlogTraffic\/\d\.\d+ Feed-Fetcher|SeobilityBot|Cincraw|Dragonbot|VoluumDSP-content-bot|FreshRSS|BitBot|^PHP-Curl-Class|Google-Certificates-Bridge|centurybot|Viber|e\.ventures Investment Crawler|evc-batch|PetalBot|virustotal|(^| )PTST\/|minicrawler|Cookiebot|trovitBot|seostar\.co|IonCrawl|Uptime-Kuma|Seekport|FreshpingBot|Feedbin|CriteoBot|Snap URL Preview Service|Better Uptime Bot|RuxitSynthetic|Google-Read-Aloud|Valve\/Steam|OdklBot\/|GPTBot|ChatGPT-User|OAI-SearchBot|YandexRenderResourcesBot\/|LightspeedSystemsCrawler|ev-crawler\/|BitSightBot\/|woorankreview\/|Google-Safety|AwarioBot|DataForSeoBot|Linespider|WellKnownBot|A Patent Crawler|StractBot|search\.marginalia\.nu|YouBot|Nicecrawler|Neevabot|BrightEdge Crawler|SiteCheckerBotCrawler|TombaPublicWebCrawler|CrawlyProjectCrawler|KomodiaBot|KStandBot|CISPA Webcrawler|MTRobot|hyscore\.io|AlexandriaOrgBot|2ip bot|Yellowbrandprotectionbot|SEOlizer|vuhuvBot|INETDEX-BOT|Synapse|t3versionsBot|deepnoc|Cocolyzebot|hypestat|ReverseEngineeringBot|sempi\.tech|Iframely|MetaInspector|node-fetch|lkxscan|python-opengraph|OpenGraphCheck|developers\.google\.com\/\+\/web\/snippet|SenutoBot|MaCoCu|NewsBlur|inoreader|NetSystemsResearch|PageThing|WordPress\/|PhxBot|ImagesiftBot|Expanse|InternetMeasurement|^BW\/|GeedoBot|Audisto Crawler|PerplexityBot\/|[cC]laude[bB]ot|Monsidobot|GroupMeBot|Vercelbot|vercel-screenshot|facebookcatalog\/|meta-externalagent\/|meta-externalfetcher\/|AcademicBotRTU|KeybaseBot|Lemmy|CookieHubScan|Hydrozen\.io|HTTP Banner Detection|SummalyBot|MicrosoftPreview\/",
		// Media Manager
		"cb_media_directoryRoot"                : "/contentbox-custom/_content",
		"cb_media_createFolders"                : "true",
		"cb_media_allowDelete"                  : "true",
		"cb_media_allowDownloads"               : "true",
		"cb_media_allowUploads"                 : "true",
		"cb_media_acceptMimeTypes"              : "",
		"cb_media_quickViewWidth"               : "400",
		// HTML5 Media Manager
		"cb_media_html5uploads_maxFileSize"     : "100",
		"cb_media_html5uploads_maxFiles"        : "25",
		// Media Services
		"cb_media_provider"                     : "CFContentMediaProvider",
		"cb_media_provider_caching"             : "true",
		// Editor Manager
		"cb_editors_default"                    : "ckeditor",
		"cb_editors_markup"                     : "HTML",
		"cb_editors_ckeditor_toolbar"           : "[
		{ ""name"": ""document"",    ""items"" : [ ""Source"",""-"",""Maximize"",""ShowBlocks"" ] },
		{ ""name"": ""clipboard"",   ""items"" : [ ""Cut"",""Copy"",""Paste"",""PasteText"",""PasteFromWord"",""-"",""Undo"",""Redo"" ] },
		{ ""name"": ""editing"",     ""items"" : [ ""Find"",""Replace"",""SpellChecker""] },
		{ ""name"": ""forms"",       ""items"" : [ ""Form"", ""Checkbox"", ""Radio"", ""TextField"", ""Textarea"", ""Select"", ""Button"",""HiddenField"" ] },
		""/"",
		{ ""name"": ""basicstyles"", ""items"" : [ ""Bold"",""Italic"",""Underline"",""Strike"",""Subscript"",""Superscript"",""-"",""RemoveFormat"" ] },
		{ ""name"": ""paragraph"",   ""items"" : [ ""NumberedList"",""BulletedList"",""-"",""Outdent"",""Indent"",""-"",""Blockquote"",""CreateDiv"",""-"",""JustifyLeft"",""JustifyCenter"",""JustifyRight"",""JustifyBlock"",""-"",""BidiLtr"",""BidiRtl"" ] },
		{ ""name"": ""links"",       ""items"" : [ ""Link"",""Unlink"",""Anchor"" ] },
		""/"",
		{ ""name"": ""styles"",      ""items"" : [ ""Styles"",""Format"" ] },
		{ ""name"": ""colors"",      ""items"" : [ ""TextColor"",""BGColor"" ] },
		{ ""name"": ""insert"",      ""items"" : [ ""Image"",""Table"",""HorizontalRule"",""Smiley"",""SpecialChar"",""Iframe"",""InsertPre""] },
		{ ""name"": ""contentbox"",  ""items"" : [ ""MediaEmbed"",""cbIpsumLorem"",""cbWidgets"",""cbContentStore"",""cbLinks"",""cbEntryLinks"" ] }
		]",
		"cb_editors_ckeditor_excerpt_toolbar" : "
		[
		{ ""name"": ""document"",    ""items"" : [ ""Source"",""-"",""Maximize"",""ShowBlocks"" ] },
		{ ""name"": ""basicstyles"", ""items"" : [ ""Bold"",""Italic"",""Underline"",""Strike"",""Subscript"",""Superscript""] },
		{ ""name"": ""paragraph"",   ""items"" : [ ""NumberedList"",""BulletedList"",""-"",""Outdent"",""Indent"",""CreateDiv""] },
		{ ""name"": ""links"",       ""items"" : [ ""Link"",""Unlink"",""Anchor"" ] },
		{ ""name"": ""insert"",      ""items"" : [ ""Image"",""Flash"",""Table"",""HorizontalRule"",""Smiley"",""SpecialChar"" ] },
		{ ""name"": ""contentbox"",  ""items"" : [ ""MediaEmbed"",""cbIpsumLorem"",""cbWidgets"",""cbContentStore"",""cbLinks"",""cbEntryLinks"" ] }
		]",
		"cb_editors_ckeditor_extraplugins" : "cbKeyBinding,cbWidgets,cbLinks,cbEntryLinks,cbContentStore,cbIpsumLorem,wsc,mediaembed,insertpre,justify,colorbutton,showblocks,find,div,smiley,specialchar,iframe",
		// Search Settings
		"cb_search_adapter"                : "contentbox.models.search.DBSearch",
		"cb_search_maxResults"             : "20",
		// Site Maintenance
		"cb_site_maintenance_message"      : "<h1>This site is down for maintenance.<br /> Please check back again soon.</h1>",
		"cb_site_maintenance"              : "false",
		// Versioning
		"cb_versions_max_history"          : "",
		"cb_versions_commit_mandatory"     : "false"
	};

	// Site Defaults
	this.SITE_DEFAULTS = {
		// Global HTML: Panel Section
		"cb_html_beforeHeadEnd"              : "",
		"cb_html_afterBodyStart"             : "",
		"cb_html_beforeBodyEnd"              : "",
		"cb_html_beforeContent"              : "",
		"cb_html_afterContent"               : "",
		"cb_html_beforeSideBar"              : "",
		"cb_html_afterSideBar"               : "",
		"cb_html_afterFooter"                : "",
		"cb_html_preEntryDisplay"            : "",
		"cb_html_postEntryDisplay"           : "",
		"cb_html_preIndexDisplay"            : "",
		"cb_html_postIndexDisplay"           : "",
		"cb_html_preArchivesDisplay"         : "",
		"cb_html_postArchivesDisplay"        : "",
		"cb_html_preCommentForm"             : "",
		"cb_html_postCommentForm"            : "",
		"cb_html_prePageDisplay"             : "",
		"cb_html_postPageDisplay"            : "",
		// Site Comment Settings
		"cb_comments_enabled"                : "true",
		"cb_comments_maxDisplayChars"        : "500",
		"cb_comments_notify"                 : "true",
		"cb_comments_moderation_notify"      : "true",
		"cb_comments_notifyemails"           : "",
		"cb_comments_moderation"             : "true",
		"cb_comments_moderation_whitelist"   : "true",
		"cb_comments_moderation_blacklist"   : "",
		"cb_comments_moderation_blockedlist" : "",
		"cb_comments_moderation_expiration"  : "30"
	};

	/**
	 * Constructor
	 */
	SettingService function init(){
		variables.oSystem           = createObject( "java", "java.lang.System" );
		variables.CBReadyFlag       = false;
		variables.cacheProviderName = "template";

		// init it
		super.init( entityName = "cbSetting" );

		return this;
	}

	/**
	 * This method will go over all system settings and make sure that there are no missing default core settings.
	 * If they are, we will create the core settings with the appropriate defaults: this.DEFAULTS
	 */
	SettingService function preFlightCheck(){
		// Log it
		variables.log.info( "> Running ContentBox pre flight checks..." );
		var sTime = getTickCount();

		// Iterate over default core settings and check they exist
		lock
			name          ="contentbox-pre-flight",
			timeout       = "10"
			throwOnTimeout="true"
			type          ="exclusive" {
			// Check what's missing for the global settings
			transaction {
				// Get all core, non-deleted settings
				var loadedSettings = newCriteria()
					.isNull( "site" )
					.isFalse( "isDeleted" )
					.isTrue( "isCore" )
					.withProjections( property: "name" )
					.list( sortOrder = "name" );

				// Verify defaults exist
				this.DEFAULTS
					// only process defaults that do not exist in the database
					.filter( function( key, value ){
						return !arrayContainsNoCase( loadedSettings, arguments.key );
					} )
					// Create the missing global setting
					.each( function( key, value ){
						variables.log.info( "- Missing core setting (#arguments.key#) found in pre-flight, adding it!" );
						entitySave(
							this.new( {
								name   : arguments.key,
								value  : trim( arguments.value ),
								isCore : true
							} )
						);
					} );

				// Get all site core settings in the database
				var dbSiteSettings = newCriteria()
					.isFalse( "isDeleted" )
					.isTrue( "isCore" )
					.joinTo( "site", "site" )
					.withProjections( property: "name,site.slug:siteSlug" )
					.asStruct()
					.list( sortOrder = "site.slug,name" );

				// Get all Sites and process them for core settings
				variables.siteService
					.getAll()
					.each( function( site ){
						var targetSite = arguments.site;
						// Ensure Site Media Folder
						variables.siteService.ensureSiteMediaFolder( targetSite );
						// Setup Site Settings
						this.SITE_DEFAULTS
							// only process defaults that do not exist in the database
							.filter( function( key, value ){
								return arrayFilter( dbSiteSettings, function( item ){
									return (
										arguments.item[ "name" ] == key && arguments.item[ "siteSlug" ] == targetSite.getSlug()
									);
								} ).isEmpty();
							} )
							// Create the missing site setting
							.each( function( key, value ){
								variables.log.info(
									"- Site (#targetSite.getSlug()#) missing setting (#arguments.key#), adding it!"
								);
								entitySave(
									this.new( {
										name   : arguments.key,
										value  : trim( arguments.value ),
										isCore : true,
										site   : targetSite
									} )
								);
							} );
					} );
			}
			// end transaction

			// load cache provider now that everyting is pre-flighted
			loadCacheProviderName();
		}

		variables.log.info( "√ ContentBox pre flight checks done in (#getTickCount() - sTime#)ms!" );

		return this;
	}

	/**
	 * Get a collection (struct) of settings that represent the defaults for a site in ContentBox
	 */
	struct function getSiteSettingDefaults(){
		return this.SITE_DEFAULTS;
	}

	/**
	 * The static key used for caching all the settings of this installation
	 */
	string function getSettingsCacheKey(){
		return "cb-settings-container-#reReplace( variables.appName, "\s", "-", "all" )#";
	}

	/**
	 * Check if the installer is present
	 */
	boolean function isInstallationPresent(){
		if (
			structKeyExists( variables.moduleSettings, "contentbox-installer" ) AND
			directoryExists( variables.moduleSettings[ "contentbox-installer" ].path )
		) {
			return true;
		}

		return false;
	}

	/**
	 * Delete the installer module
	 */
	boolean function deleteInstaller(){
		if (
			structKeyExists( variables.moduleSettings, "contentbox-installer" ) AND
			directoryExists( variables.moduleSettings[ "contentbox-installer" ].path )
		) {
			directoryDelete( variables.moduleSettings[ "contentbox-installer" ].path, true );
			return true;
		}
		return false;
	}

	/**
	 * Check if contentbox has been installed by checking if there are no settings and no cb_active ONLY
	 * If the query comes back with active, it will not run it again.
	 */
	boolean function isCBReady(){
		// Short circuit caching
		if ( variables.CBReadyFlag ) {
			return true;
		}

		// Not active yet, discover it
		var thisCount = newCriteria().isEq( "name", "cb_active" ).count();

		// Store it
		if ( thisCount > 0 ) {
			variables.CBReadyFlag = true;
		}

		return ( thisCount > 0 ? true : false );
	}

	/**
	 * Mark cb as ready to serve
	 */
	SettingService function activateCB(){
		save( this.new( { name : "cb_active", value : "true" } ) );
		return this;
	}

	/**
	 * Get a global setting
	 *
	 * @name         The name of the seting
	 * @defaultValue The default value if setting not found.
	 *
	 * @return The setting value or default value if not found
	 *
	 * @throws SettingNotFoundException
	 */
	function getSetting( required name, defaultValue ){
		var allSettings = getAllSettings();

		// verify it exists
		if ( structKeyExists( allSettings, arguments.name ) ) {
			return allSettings[ arguments.name ];
		}

		// default value
		if ( !isNull( arguments.defaultValue ) ) {
			return arguments.defaultValue;
		}

		// nothing we can do
		throw(
			message: "Setting #arguments.name# not found in settings collection",
			detail : "Registered settings are: #structKeyList( allSettings )#",
			type   : "SettingNotFoundException"
		);
	}

	/**
	 * Get a site setting
	 *
	 * @siteSlug     The site to get the setting from
	 * @name         The name of the seting
	 * @defaultValue The default value if setting not found.
	 *
	 * @return The setting value or default value if not found
	 *
	 * @throws SettingNotFoundException
	 */
	function getSiteSetting( required siteSlug, required name, defaultValue ){
		var allSettings = getAllSiteSettings( arguments.siteSlug );

		// verify it exists
		if ( structKeyExists( allSettings, arguments.name ) ) {
			return allSettings[ arguments.name ];
		}

		// default value
		if ( !isNull( arguments.defaultValue ) ) {
			return arguments.defaultValue;
		}

		// nothing we can do
		throw(
			message: "Site setting #arguments.name# not found in site collection",
			detail : "Registered settings are: #structKeyList( allSettings )#",
			type   : "SettingNotFoundException"
		);
	}

	/**
	 * Get all global settings
	 *
	 * @force To force clear the cache
	 */
	struct function getAllSettings( boolean force = false ){
		return getSettingsContainer( arguments.force ).global;
	}

	/**
	 * Get all site settings
	 *
	 * @slug  The site slug to use to retrieve the settings
	 * @force To force clear the cache
	 */
	struct function getAllSiteSettings( required siteSlug, boolean force = false ){
		return getSettingsContainer( arguments.force ).sites[ arguments.siteSlug ];
	}

	/**
	 * Get all the default site settings
	 *
	 * @force To force clear the cache
	 */
	struct function getDefaultSiteSettings( boolean force = false ){
		return getSettingsContainer( arguments.force ).sites[ "default" ];
	}

	/**
	 * Get the entire settings container from cache or build it out.
	 *
	 * @force Force build
	 */
	struct function getSettingsContainer( boolean force = false ){
		// Force Clear
		if ( arguments.force ) {
			flushSettingsCache();
		}

		// Get or set
		return getSettingsCacheProvider().getOrSet(
			getSettingsCacheKey(),
			function(){
				log.info( "Settings container not cached, rebuilding from DB!" );
				return buildSettingsContainer();
			},
			7200
		);
	}

	/**
	 * Try to find a setting object by site and name
	 *
	 * @site The site object, this can be null
	 * @name The name of the setting
	 *
	 * @return The setting object or null
	 */
	function findSiteSetting( required site, required name ){
		return newCriteria()
			.isEq( "site", arguments.site )
			.isEq( "name", arguments.name )
			.get();
	}

	/**
	 * Build out a settings container by global and sites.
	 *
	 * @return struct of { global : {}, sites : { slug : {} } }
	 */
	struct function buildSettingsContainer(){
		var allSites  = variables.siteService.getAllFlat();
		var container = { "global" : {}, "sites" : {} };

		// Initialize site setting containers from defaults
		container.sites = arrayReduce(
			allSites,
			function( result, item ){
				result[ item[ "slug" ] ] = duplicate( this.SITE_DEFAULTS );
				return result;
			},
			{}
		);

		// Populate containers from what's on the database now
		newCriteria()
			.isFalse( "isDeleted" )
			.list( sortOrder = "site,name" )
			.each( function( item ){
				if ( item.hasSite() ) {
					// Store the setting
					container.sites[ item.getSite().getSlug() ][ item.getName() ] = item.getValue();
				} else {
					container.global[ item.getName() ] = item.getValue();
				}
			} );

		return container;
	}

	/**
	 * This will store the incoming structure as the settings in cache.
	 * Usually this method is used for major overrides.
	 */
	SettingService function storeSettings( struct settings ){
		// cache them for 5 days, usually app timeout
		getSettingsCacheProvider().set(
			getSettingsCacheKey(),
			arguments.settings,
			7200
		);
		return this;
	}

	/**
	 * flush settings cache for current multi-tenant host
	 */
	SettingService function flushSettingsCache(){
		// Info
		variables.log.info( "Settings Flush Executed!" );
		// Clear out the settings cache
		getSettingsCacheProvider().clear( getSettingsCacheKey() );
		// Re-load cache provider name, in case user changed it
		loadCacheProviderName();
		// Loadup Config Overrides
		loadConfigOverrides();
		// Load Environment Overrides Now, they take precedence
		loadEnvironmentOverrides();
		return this;
	}

	/**
	 * Bulk saving of options using a memento structure of options
	 * This is usually done from the settings display manager
	 *
	 * @memento The struct of settings
	 * @site    Optional site to attach the settings to
	 *
	 * @return SettingService
	 */
	SettingService function bulkSave( struct memento, site ){
		var settings    = isNull( arguments.site ) ? getAllSettings() : getAllSiteSettings( arguments.site.getSlug() );
		var newSettings = [];

		arguments.memento
			// Only save, saveable keys
			.filter( function( key, value ){
				return settings.keyExists( key );
			} )
			// Build out array of settings to save
			.each( function( key, value ){
				var thisSetting = "";
				// Find the setting globally or by site, depending on the context
				if ( isNull( site ) ) {
					thisSetting = findWhere( { name : key } );
				} else {
					thisSetting = findSiteSetting( site, key );
				}

				// Maybe it's a new setting :)
				if ( isNull( thisSetting ) ) {
					thisSetting = new ( { name : key } );
				}

				thisSetting.setValue( toString( value ) );

				// Site mapping
				if ( !isNull( site ) ) {
					thisSetting.setSite( site );
				}

				newSettings.append( thisSetting );
			} );

		// save new settings and flush cache
		saveAll( newSettings );
		flushSettingsCache();

		return this;
	}

	/**
	 * Build file browser settings structure so you can execute multiple containers
	 *
	 * @return struct
	 */
	struct function buildFileBrowserSettings(){
		var cbSettings = getAllSettings();
		var settings   = {
			directoryRoot   : expandPath( cbSettings.cb_media_directoryRoot ),
			createFolders   : cbSettings.cb_media_createFolders,
			deleteStuff     : cbSettings.cb_media_allowDelete,
			allowDownload   : cbSettings.cb_media_allowDownloads,
			allowUploads    : cbSettings.cb_media_allowUploads,
			acceptMimeTypes : cbSettings.cb_media_acceptMimeTypes,
			quickViewWidth  : cbSettings.cb_media_quickViewWidth,
			loadJQuery      : false,
			useMediaPath    : true,
			html5uploads    : {
				maxFileSize : cbSettings.cb_media_html5uploads_maxFileSize,
				maxFiles    : cbSettings.cb_media_html5uploads_maxFiles
			}
		};

		// Base MediaPath
		var mediaPath  = "";
		// add the entry point
		var entryPoint = moduleSettings[ "contentbox-ui" ].entryPoint;
		mediaPath &= ( len( entryPoint ) ? "#entryPoint#/" : "" ) & "__media";
		// Store it
		mediaPath          = ( left( mediaPath, 1 ) == "/" ? mediaPath : "/" & mediaPath );
		settings.mediaPath = mediaPath;

		return settings;
	}

	/**
	 * Setting search with filters
	 *
	 * @search    The search term for the name
	 * @max       The max records
	 * @offset    The offset to tuse
	 * @sortOrder The sort order
	 * @siteID    The site id to filter on
	 *
	 * @return struct of { count, settings }
	 */
	struct function search(
		search    = "",
		max       = 0,
		offset    = 0,
		sortOrder = "name asc",
		siteID    = ""
	){
		var results = { "count" : 0, "settings" : [] };
		var c       = newCriteria()
			// Search Criteria
			.when( len( arguments.search ), function( c ){
				c.like( "name", "%#search#%" );
			} )
			// Site Filter
			.when( len( arguments.siteID ), function( c ){
				c.isEq( "site.siteID", siteID );
			} );

		// run criteria query and projections count
		results.count    = c.count( "settingID" );
		results.settings = c.list(
			offset   : arguments.offset,
			max      : arguments.max,
			sortOrder: arguments.sortOrder
		);

		return results;
	}

	/**
	 * Get all data prepared for export
	 */
	array function getAllForExport(){
		return getAll().map( function( thisItem ){
			return thisItem.getMemento( profile: "export" );
		} );
	}

	/**
	 * Import data from a ContentBox JSON file. Returns the import log
	 *
	 * @importFile The json file to import
	 * @override   Override content if found in the database, defaults to false
	 *
	 * @return The console log of the import
	 *
	 * @throws InvalidImportFormat
	 */
	string function importFromFile( required importFile, boolean override = false ){
		var data      = fileRead( arguments.importFile );
		var importLog = createObject( "java", "java.lang.StringBuilder" ).init(
			"Starting import with override = #arguments.override#...<br>"
		);

		if ( !isJSON( data ) ) {
			throw( message = "Cannot import file as the contents is not JSON", type = "InvalidImportFormat" );
		}

		// deserialize packet: Should be array of { settingID, name, value }
		return importFromData(
			deserializeJSON( data ),
			arguments.override,
			importLog
		);
	}

	/**
	 * Import data from an array of structures or a single structure of data
	 *
	 * @importData A struct or array of data to import
	 * @override   Override content if found in the database, defaults to false
	 * @importLog  The import log buffer
	 *
	 * @return The console log of the import
	 *
	 * @throws InvalidImportFormat
	 */
	string function importFromData(
		required importData,
		boolean override = false,
		importLog
	){
		var allSettings = [];
		var siteService = getWireBox().getInstance( "siteService@contentbox" );

		// if struct, inflate into an array
		if ( isStruct( arguments.importData ) ) {
			arguments.importData = [ arguments.importData ];
		}

		transaction {
			// iterate and import
			for ( var thisSetting in arguments.importData ) {
				// Site Setting or Global Setting
				var oSetting = findWhere( {
					name : thisSetting.name,
					site : isNull( thisSetting.site.siteID ) ? javacast( "null", "" ) : siteService.get(
						thisSetting.site.siteID
					)
				} );
				oSetting = ( isNull( oSetting ) ? new () : oSetting );

				// Check for boolean values
				if ( isSimpleValue( thisSetting.value ) && isBoolean( thisSetting.value ) ) {
					thisSetting.value = toString( thisSetting.value );
				}

				// populate content from data
				getBeanPopulator().populateFromStruct(
					target              : oSetting,
					memento             : thisSetting,
					exclude             : "settingID,site",
					composeRelationships: false
				);

				// Link the site if it exists
				if ( !isNull( thisSetting.site.slug ) ) {
					oSetting.setSite( siteService.getBySlugOrFail( thisSetting.site.slug ) );
				}

				// if new or persisted with override then save.
				if ( !oSetting.isLoaded() ) {
					arguments.importLog.append( "New setting imported: #thisSetting.name#<br>" );
					arrayAppend( allSettings, oSetting );
				} else if ( oSetting.isLoaded() and arguments.override ) {
					arguments.importLog.append( "Persisted setting overriden: #thisSetting.name#<br>" );
					arrayAppend( allSettings, oSetting );
				} else {
					arguments.importLog.append( "Skipping persisted setting: #thisSetting.name#<br>" );
				}
			}
			// end import loop

			// Save them?
			if ( arrayLen( allSettings ) ) {
				saveAll( allSettings );
				arguments.importLog.append( "Saved all imported and overriden settings!" );
			} else {
				arguments.importLog.append(
					"No settings imported as none where found or able to be overriden from the import file."
				);
			}
		}
		// end of transaction

		return arguments.importLog.toString();
	}

	/**
	 * Get the cache provider object to be used for settings
	 *
	 * @return coldbox.system.cache.ICacheProvider
	 */
	function getSettingsCacheProvider(){
		// Return the cache to use
		return cacheBox.getCache( variables.cacheProviderName );
	}

	/**
	 * Load up config overrides
	 */
	function loadConfigOverrides(){
		// Global Settings
		if (
			structKeyExists( variables.contentboxSettings, "settings" )
			&&
			structKeyExists( variables.contentboxSettings.settings, "global" )
		) {
			var settingsContainer = getSettingsContainer();

			// Append and override
			structAppend(
				settingsContainer.global,
				variables.contentboxSettings.settings.global,
				true
			);

			// Store them back in
			storeSettings( settingsContainer );

			// Log it
			variables.log.info(
				"ContentBox global config overrides loaded.",
				variables.contentboxSettings.settings.global
			);
		}

		// TODO: Site Settings
	}

	/**
	 * Load up java environment overrides for ContentBox settings
	 * The pattern to look is `contentbox.{site}.{setting}`
	 * Example: contentbox.default.cb_media_directoryRoot
	 */
	function loadEnvironmentOverrides(){
		var environmentSettings = variables.oSystem.getEnv();
		var overrides           = {};

		// iterate and override
		for ( var thisKey in environmentSettings ) {
			if ( reFindNoCase( "^contentbox\_", thisKey ) ) {
				overrides[ reReplaceNoCase( thisKey, "^contentbox\_", "" ) ] = environmentSettings[ thisKey ];
			}
		}

		// If empty, exit out.
		if ( structIsEmpty( overrides ) ) {
			return;
		}

		// Append and override
		var settingsContainer = getSettingsContainer();

		// Append and override
		structAppend( settingsContainer.global, overrides, true );

		// Store them back in
		storeSettings( settingsContainer );

		// Log it
		variables.log.info( "ContentBox environment overrides loaded.", overrides );
	}

	/******************************** PRIVATE ************************************************/

	/**
	 * Load the cache provider name from DB or default value
	 */
	private SettingService function loadCacheProviderName(){
		// query db for cache name
		var oProvider = newCriteria().isEq( "name", "cb_site_settings_cache" ).get();
		// Check if setting in DB already, else default it
		if ( !isNull( cacheProvider ) ) {
			variables.cacheProviderName = oProvider.getValue();
		} else {
			// default cache provider name
			variables.cacheProviderName = "template";
		}
		return this;
	}

}
