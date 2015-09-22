module.exports = function( grunt ){

	// Default
	grunt.registerTask( "default", [ "watch" ] );

	// Build All
	grunt.registerTask( "all", [ "css", "js", "jslib", "copy" ] );

	// CSS Task
	grunt.registerTask( "css", [
		"clean:revcss", 		//clean old rev css
		"bower_concat:css",		//bower concat
		"concat:css", 			//concat css 
		"cssmin:css",			//min css
		"clean:combinedcss",	//clean concat css
		"rev:css",				//create cache buster
		"clean:mincss",			//clean min css
		"injector:css"			//inject css
	] );

	// custom js task
	grunt.registerTask( "js", [
		"clean:revjs",			//clean old rev js
		"jshint", 				//js lint
		"concat:js", 			//concat js 
		"uglify:js",			//min js
		"clean:combinedjs", 	//clean combined js
		"rev:js",				//create cache buster
		"clean:minjs",			//clean min js
		"injector:js"			//inject js
	] );

	// js library task
	grunt.registerTask( "jslib", [
		"clean:revjslib",
		"bower_concat:js",
		"concat:jslib",
		"uglify:jslib",
		"clean:combinedjslib",
		"rev:jslib",
		"clean:minjslib",
		"injector:jslib"
	]);

	// Config
	grunt.initConfig( {
		// read configs
		pkg : grunt.file.readJSON( "package.json" ),

		// Bower Concat
		bower_concat : {
			css : { 
				cssDest : 'includes/css/bower.css',
				mainFiles : {
					'bootstrap' : 'dist/css/bootstrap.css',
					'navgoco' : 'src/jquery.navgoco.css'
				}
			},
		  	js 	: { 
		  		dest  	: 'includes/jslib/bower.js', 
		  		exclude : [ "jquery" ],
		  		mainFiles :{
		  			'navgoco' : 'src/jquery.navgoco.js'
		  		}
		  	}
		},

		// Copy UI Fonts to destination
		copy : {
			fonts : {
				files : [
					{ 
						expand 	: true, 
						src 	: 'bower_components/components-font-awesome/fonts/**',
						dest 	: 'includes/fonts',
						flatten : true,
						filter 	: 'isFile'
					},
					{ 
						expand 	: true, 
						src 	: 'bower_components/bootstrap/fonts/**',
						dest 	: 'includes/fonts',
						flatten : true,
						filter 	: 'isFile'
					}
				]
			}
		},

		// Concat Task
		concat : {
			css : {
	        	files : {
	            	"includes/css/ba.css" : [
	            		"includes/css/bower.css",
	            		"includes/css/src/animate.css",
	            		"includes/css/src/main.css",
	            		"includes/css/src/overrides.css"
	            	]
				} 
			},
			js : {
	        	files : {
	            	"includes/js/ba.js" : [
	            		"includes/js/**/*.js"
	            	]
				}
			},
			jslib : {
				files : {
					"includes/jslib/ba.js" : [
						"bower_components/jquery/dist/jquery.js",
	            		"includes/jslib/bower.js",
	            		"includes/jslib/wizard/loader.min.js",
	            		"includes/jslib/theme.js"
					]
				}
			}
		}, // end concat

		// CSS Min
		cssmin : {
			css : {
				files : { "includes/css/ba.min.css" : [ "includes/css/ba.css" ] }
			}
		}, // end css min

		// JS Min
		uglify : {
			options : { 
    			banner : "/* <%= pkg.name %> minified @ <%= grunt.template.today() %> */\n",
    			mangle : false
    		},
			js : {
				files : { "includes/js/ba.min.js" : [ "includes/js/ba.js"	] }
			},
			jslib : {
				files : { "includes/jslib/ba.min.js" : [ "includes/jslib/ba.js"	] }
			}
		},

		// Cache Busting
		rev : {
			css : {
				files : { src : [ "includes/css/ba.min.css" ] }
			},
			js 	: {
				files : { src : [ "includes/js/ba.min.js" ] }
			},
			jslib 	: {
				files : { src : [ "includes/jslib/ba.min.js" ] }
			}
		}, // end cache busting

		// Cleanup
		clean : {
			// css
			combinedcss : { src : [ "includes/css/ba.css", "includes/css/bower.css" ] },
			mincss 		: { src : [ "includes/css/ba.min.css" ] },
			revcss 		: { src : [ "includes/css/*ba.min.css" ] },
			// js
			combinedjs  	: { src : [ "includes/js/ba.js" ] },
			combinedjslib  	: { src : [ "includes/jslib/ba.js", "includes/jslib/bower.js" ] },
			minjs 			: { src : [ "includes/js/ba.min.js" ] },
			minjslib		: { src : [ "includes/jslib/ba.min.js" ] },
			revjs 			: { src : [ "includes/js/*ba.min.js" ] },
			revjslib		: { src : [ "includes/jslib/*ba.min.js" ] }
		},

		// Watch
		watch : {
			css : {
				files : [ "includes/css/src/*.css" ],
				tasks : [ "css" ]
			},
			js : {
				files : [ 
					"includes/js/services/*.js", 
					"includes/js/controllers/*.js", 
					"includes/js/app.js",
					"includes/js/routing.js",
					"includes/js/directives.js",
					"includes/js/bootstrap.js"
				],
				tasks : [ "js" ]
			},
			bower : {
				files : [ "bower.json" ],
				tasks : [ "main" ]
			},
			tests : {
				files : [ 'tests/specs/**/*.cfc', 'models/**/*.cfc' ],
				options : {
					livereload : true
				}
			}
		},

		// Injector
		injector : {
			css : {
				files : { "views/includes.cfm" : [ "includes/css/*ba.min.css" ]	}
			},
			jslib : {
				options : { starttag : "<!-- injector:jslib -->" },
				files : { "views/includes.cfm" : [ "includes/jslib/*ba.min.js" ] }
			},
			js : {
				files : { "views/includes.cfm" : [ "includes/js/*ba.min.js" ] }
			}
		},

		// JS Hint
		jshint : {
			options : { 
				curly 	: true,
				eqeqeq  : true,
				eqnull 	: true,
				browser : true,
				devel 	: true,
				sub  	: true,
				globals : {
					jQuery 	: true,
					$ 		: true,
					module 	: true,
					angular : true
				},
				ignores : [ "*.ba.min.js" ]
			},
			all : [ "Gruntfile.js", 'includes/js/**/*.js' ]			
		},

	} );

	// Load Tasks
	require( 'matchdep' )
		.filterDev( 'grunt-*' )
		.forEach( grunt.loadNpmTasks );
};
