/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License" );
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
* Import a blogcfc database into contentbox
*/
component implements="contentbox.models.importers.ICBImporter" {

	property name="categoryService" inject="id:categoryService@contentbox";
	property name="entryService" inject="id:entryService@contentbox";
	property name="pageService" inject="id:pageService@contentbox";
	property name="statsService" inject="id:statsService@contentbox";
	property name="authorService" inject="id:authorService@contentbox";
	property name="roleService" inject="id:roleService@contentbox";
	property name="commentService" inject="id:commentService@contentbox";
	property name="customFieldService" inject="id:customFieldService@contentbox";
	property name="log" inject="logbox:logger:{this}";
	property name="interceptorService" inject="coldbox:interceptorService";
	property name="settingService" inject="id:settingService@contentbox";
	property name="bCrypt" inject="BCrypt@BCrypt";

	// ------------------------------------------------------------------------------------------------
	// Constructor
	// ------------------------------------------------------------------------------------------------
	blogcfcImporter function init(){
		return this;
	}

	// ------------------------------------------------------------------------------------------------
	// Import from blogcfc blog, returns the string console.
	// ------------------------------------------------------------------------------------------------
	function execute(
		required dsn,
		dsnUsername     = "",
		dsnPassword     = "",
		defaultPassword = "",
		required roleID,
		tableprefix = ""
	){
		var authorMap     = {};
		var catMap        = {};
		var entryMap      = {};
		var slugMap       = {};
		var defaultAuthor = {};

		log.info( "Starting import process: #arguments.toString()#" );

		try {
			// Import categories
			var qCategories = new Query(
				datasource = arguments.dsn,
				username   = arguments.dsnUsername,
				password   = arguments.dsnPassword,
				sql        = "select categoryid, categoryname, categoryalias, blog FROM tblBlogCategories"
			).execute().getResult();
			for ( var x = 1; x lte qCategories.recordcount; x++ ) {
				var props = {
					category : qCategories.categoryName[ x ],
					slug     : qCategories.categoryAlias[ x ]
				};
				var cat = categoryService.new( properties = props );
				entitySave( cat );
				log.info( "Imported category: #props.category#" );
				catMap[ qCategories.categoryId[ x ] ] = cat.getCategoryID();
			}
			log.info( "Categories imported successfully!" );

			log.info( "Starting to import Authors...." );
			// Get the default role
			var defaultRole = roleService.get( arguments.roleID );

			// Import Authors
			var qAuthors = new Query(
				datasource = arguments.dsn,
				username   = arguments.dsnUsername,
				password   = arguments.dsnPassword,
				sql        = "select username, password, name from tblUsers"
			).execute().getResult();
			for ( var x = 1; x lte qAuthors.recordcount; x++ ) {
				var props = {
					email     : qAuthors.username[ x ],
					username  : qAuthors.username[ x ],
					password  : bcrypt.hashPassword( defaultPassword ),
					isActive  : 1,
					firstName : listFirst( qAuthors.name[ x ], " " ),
					lastName  : trim(
						replaceNoCase(
							qAuthors.name[ x ],
							listFirst( qAuthors.name[ x ], " " ),
							""
						)
					)
				};

				var author = authorService.findWhere( { username : qAuthors.username[ x ] } );
				if ( isNull( author ) ) {
					author = authorService.new( properties = props );
				}

				author.setRole( defaultRole );
				entitySave( author );
				log.info( "Imported author: #props.firstName# #props.lastName#" );
				authorMap[ qAuthors.username[ x ] ] = author.getAuthorID();

				// Save first author found from blogCFC as the default author.
				if ( x == 1 ) {
					defaultAuthor = author;
				}
			}
			log.info( "Authors imported successfully!" );

			log.info( "Starting to import Pages...." );

			try {
				var qPages = new Query(
					datasource = arguments.dsn,
					username   = arguments.dsnUsername,
					password   = arguments.dsnPassword,
					sql        = "select id, blog, title, alias, body from tblblogpages"
				).execute().getResult();

				for ( var x = 1; x lte qPages.recordcount; x++ ) {
					var props = {
						title         : qPages.title[ x ],
						slug          : qPages.alias[ x ],
						content       : qPages.body[ x ],
						publishedDate : now(),
						createdDate   : now(),
						isPublished   : true,
						allowComments : false,
						layout        : "pages"
					};
					var page = pageService.new( properties = props );

					// blogCFC has no concept of authored pages, so we grab the first author we find from blogCFC
					// This may need revising later.
					page.addNewContentVersion(
						content   = props.content,
						changelog = "Imported content",
						author    = defaultAuthor
					);
					page.setCreator( defaultAuthor );
					entitySave( page );
				}
				log.info( "Pages imported" );
			} catch ( any e ) {
				log.info( "Error Importing Pages - Version might support Pages" );
			}

			log.info( "Starting to import Entries...." );
			// Import Entries
			var q = new Query(
				datasource = arguments.dsn,
				username   = arguments.dsnUsername,
				password   = arguments.dsnPassword,
				sql        = "
				                  select id, title, body, posted, morebody, alias, username, blog, allowcomments, enclosure,
				                  		filesize, mimetype, views, released, mailed, summary, subtitle, keywords, duration
									from tblBlogEntries
									"
			).execute().getResult();
			for ( var x = 1; x lte q.recordcount; x++ ) {
				var published     = true;
				var commentStatus = true;
				if ( !trim( q.released[ x ] ) ) {
					published = false;
				}
				if ( !q.allowComments[ x ] ) {
					commentSatus = false;
				}

				var importedBody = q.Body[ x ] & q.moreBody[ x ];
				interceptorService.announce( "preImportEntry", { post : importedBody } );
				importedBody = findImages( importedBody );
				importedBody = convertContent( importedBody );
				interceptorService.announce( "postImportEntry", { post : importedBody } );

				var props = {
					title         : q.title[ x ],
					slug          : q.alias[ x ],
					content       : importedBody,
					excerpt       : q.Body[ x ],
					publishedDate : q.posted[ x ],
					createdDate   : q.posted[ x ],
					isPublished   : published,
					allowComments : commentStatus,
					hits          : q.views[ x ]
				};

				var entry = entryService.new( properties = props );
				var oStat = statsService.new( { hits : props.hits } );
				oStat.setRelatedContent( entry );
				entry.setStats( oStat );
				entry.addNewContentVersion(
					content   = props.content,
					changelog = "Imported content",
					author    = authorService.get( authorMap[ q.username[ x ] ] )
				);
				entry.setCreator( authorService.get( authorMap[ q.username[ x ] ] ) );

				// entry categories
				var thisSQL = "
					select		tblBlogCategories.categoryname,categoryId
					from		tblBlogEntries
					inner join	tblBlogEntriesCategories ON tblBlogEntries.id = tblBlogEntriesCategories.entryidfk
					inner join	tblBlogCategories ON tblBlogEntriesCategories.categoryidfk = tblBlogCategories.categoryid
					where		tblBlogEntriesCategories.entryidfk = '#q.id[ x ]#'
				";
				var qCategories = new Query(
					datasource = arguments.dsn,
					username   = arguments.dsnUsername,
					password   = arguments.dsnPassword,
					sql        = thisSQL
				).execute().getResult();
				var aCategories = [];
				for ( var y = 1; y lte qCategories.recordcount; y++ ) {
					arrayAppend( aCategories, categoryService.get( catMap[ qCategories.categoryId[ y ] ] ) );
				}
				entry.setCategories( aCategories );
				entitySave( entry );

				// Categories won't save in ContentBox Express without this flush :/
				ormFlush();

				log.info( "Starting to import Entry Comments...." );
				// Import entry comments
				var qComments = new Query(
					datasource = arguments.dsn,
					username   = arguments.dsnUsername,
					password   = arguments.dsnPassword,
					sql        = "select * from tblBlogComments where entryidfk = '#q.id[ x ]#'"
				).execute().getResult();

				for ( var y = 1; y lte qComments.recordcount; y++ ) {
					var props = {
						content     : qComments.comment[ y ],
						author      : qComments.name[ y ],
						authorEmail : qComments.email[ y ],
						createdDate : qComments.posted[ y ],
						authorIP    : "127.0.0.1",
						isApproved  : qComments.moderated[ y ],
						authorUrl   : qComments.website[ y ]
					};

					var comment = commentService.new( properties = props );
					comment.setRelatedContent( entry );
					entitySave( comment );
					log.info( "Entry Comment imported: #props.authorEmail#" );
				}
				log.info( "Comments imported successfully!" );
				log.info( "Entry imported: #entry.getTitle()#" );
			}
			log.info( "Entries imported successfully!" );
		} catch ( any e ) {
			transaction action="rollback" {
			}
			log.error( "Error importing blog: #e.message# #e.detail#", e );
			rethrow;
		}
		transaction action="commit" {
		}
	}

	// ------------------------------------------------------------------------------------------------
	// Convert blogCFC code blocks to a more uniform approach
	// ------------------------------------------------------------------------------------------------
	private string function convertContent( required string content ){
		if ( findNoCase( "<code>", arguments.content ) and findNoCase( "</code>", arguments.content ) ) {
			var counter = findNoCase( "<code>", arguments.content );
			while ( counter gte 1 ) {
				var codeblock = reFindNoCase(
					"(?s)(.*)(<code>)(.*)(</code>)(.*)",
					arguments.content,
					1,
					1
				);
				if ( arrayLen( codeblock.len ) gte 6 ) {
					var codeportion = mid(
						arguments.content,
						codeblock.pos[ 4 ],
						codeblock.len[ 4 ]
					);
					if ( len( trim( codeportion ) ) ) {
						var result = "[code]#codeportion#[/code]";
						result     = htmlCodeFormat( result );
					}
					var newbody = mid( arguments.content, 1, codeblock.len[ 2 ] ) & result & mid(
						arguments.content,
						codeblock.pos[ 6 ],
						codeblock.len[ 6 ]
					);
					arguments.content = newBody;
					counter           = findNoCase( "<code>", arguments.content, counter );
				} else {
					counter = 0;
				}
			}
		}
		return arguments.content;
	}

	// ------------------------------------------------------------------------------------------------
	// find all images in a given entry and save them to the media manager
	// ------------------------------------------------------------------------------------------------
	private string function findImages( required string content ){
		var images    = reMatchNoCase( "(?i)src=""[^>]*[^>](.*)(gif|jpg|png)""\1", arguments.content );
		var images1   = reMatchNoCase( "(?i)href=""[^>]*[^>](.*)(gif|jpg|png)""\1", arguments.content );
		var pattern   = createObject( "java", "java.util.regex.Pattern" );
		var exp       = "(?<=\=\"" )([^""])+(?=\"" )";
		var mediaPath = expandPath( settingService.getSetting( "cb_media_directoryRoot" ) );
		var newUrl    = "/__media/blogImages/";

		// Create a directory in the Media Manager for all the blog entry images
		if ( !directoryExists( mediaPath & "\blogImages" ) ) {
			log.info( "Creating BlogImages folder for Media Manager...." );
			directoryCreate( mediaPath & "\blogImages" );
		}

		if ( arrayLen( images ) ) {
			var imagePaths = [];
			for ( var item in images ) {
				var matcher = pattern.compile( exp ).matcher( item );
				while ( matcher.find() ) {
					var urlObj   = matcher.group();
					var fileName = listLast( matcher.group(), "/" );

					var httpService = new http();
					httpService.setMethod( "get" );
					httpService.setUrl( urlObj );
					httpService.setTimeOut( 45 );
					httpService.setGetAsBinary( "yes" );
					var result = httpService.send().getPrefix();
					fileWrite( mediaPath & "\blogImages\" & fileName, result.fileContent );
					arguments.content = replaceNoCase( arguments.content, urlObj, newUrl & fileName );
				}
			}
		}

		if ( arrayLen( images1 ) ) {
			var imagePaths = [];
			for ( var item in images1 ) {
				var matcher = pattern.compile( exp ).matcher( item );
				while ( matcher.find() ) {
					var urlObj   = matcher.group();
					var fileName = listLast( matcher.group(), "/" );

					var httpService = new http();
					httpService.setMethod( "get" );
					httpService.setUrl( urlObj );
					httpService.setTimeOut( 45 );
					httpService.setGetAsBinary( "yes" );
					var result = httpService.send().getPrefix();
					fileWrite( mediaPath & "\blogImages\" & fileName, result.fileContent );
					arguments.content = replaceNoCase( arguments.content, urlObj, newUrl & fileName );
				}
			}
		}

		return arguments.content;
	}

}
