component{

	function seed( schema, query ){

		var defaultSettings = {
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
			"cb_content_bot_regex"                  : "Google|msnbot|Rambler|Yahoo|AbachoBOT|accoona|AcioRobot|ASPSeek|CocoCrawler|Dumbot|FAST-WebCrawler|GeonaBot|Gigabot|Lycos|MSRBOT|Scooter|AltaVista|IDBot|eStyle|Scrubby",
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
		}.reduce( ( results, key, value ) => {
			results.append( {
				settingID : createUUID(),
				createdDate : now(),
				modifiedDate: now(),
				isDeleted : 0,
				name : key,
				value : value,
				isCore : 1,
				FK_siteID : javacast( "null", "" )
			} );
			return results;
		}, [] );

		query.newQuery()
			.from( "cb_setting" )
			.insert( defaultSettings );

		systemOutput( "√ Settings seeded", true );
	}

}
