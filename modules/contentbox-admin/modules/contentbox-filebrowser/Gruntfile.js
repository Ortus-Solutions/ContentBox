module.exports = function( grunt ){

	// Default
	grunt.registerTask( "default", [ "watch" ] );

	// Build All
	grunt.registerTask( "all", [ "css", "js" ] );

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
		"bower_concat:js",		//bower concat
		"concat:js", 			//concat js 
		"uglify:js",			//min js
		"clean:combinedjs", 	//clean combined js
		"rev:js",				//create cache buster
		"clean:minjs",			//clean min js
		"injector:js"			//inject js
	] );

	// Config
	grunt.initConfig( {
		// read configs
		pkg : grunt.file.readJSON( "package.json" ),

		// Bower Concat
		bower_concat : {
			css : { 
				cssDest : 'includes/css/bower.css',
				mainFiles : {}
			},
		  	js 	: { 
		  		dest  	: 'includes/js/bower.js', 
		  		exclude : [ "jquery" ],
		  		mainFiles :{
		  		}
		  	}
		},

		// Concat Task
		concat : {
			css : {
	        	files : {
	            	"includes/css/fb.css" : [
	            		"includes/css/bower.css",
	            		"includes/css/src/jquery.contextMenu.css",
	            		"includes/css/src/main.css"
	            	]
				} 
			},
			js : {
	        	files : {
	            	"includes/js/fb.js" : [
	            		"includes/js/bower.js",
	            		"includes/js/src/*.js"
	            	]
				}
			}
		}, // end concat

		// CSS Min
		cssmin : {
			css : {
				files : { "includes/css/fb.min.css" : [ "includes/css/fb.css" ] }
			}
		}, // end css min

		// JS Min
		uglify : {
			options : { 
    			banner : "/* <%= pkg.name %> minified @ <%= grunt.template.today() %> */\n",
    			mangle : false
    		},
			js : {
				files : { "includes/js/fb.min.js" : [ "includes/js/fb.js"	] }
			}
		},

		// Cache Busting
		rev : {
			css : {
				files : { src : [ "includes/css/fb.min.css" ] }
			},
			js 	: {
				files : { src : [ "includes/js/fb.min.js" ] }
			}
		}, // end cache busting

		// Cleanup
		clean : {
			// css
			combinedcss : { src : [ "includes/css/fb.css", "includes/css/bower.css" ] },
			mincss 		: { src : [ "includes/css/fb.min.css" ] },
			revcss 		: { src : [ "includes/css/*fb.min.css" ] },
			// js
			combinedjs  	: { src : [ "includes/js/fb.js", "includes/js/bower.js" ] },
			minjs 			: { src : [ "includes/js/fb.min.js" ] },
			revjs 			: { src : [ "includes/js/*fb.min.js" ] },
		},

		// Watch
		watch : {
			css : {
				files : [ "includes/css/src/*.css" ],
				tasks : [ "css" ]
			},
			js : {
				files : [ 
					"includes/js/src/*.js"
				],
				tasks : [ "js" ]
			},
			bower : {
				files : [ "bower.json" ],
				tasks : [ "all" ]
			}
		},

		// Injector
		injector : {
			options : {
				transform : function( filepath, index, length ){
					return 'addAsset( "#prc.fbModRoot#' + filepath + ' ");';
				},
				starttag : "//injector:{{ext}}//",
				endtag : "//endinjector//"
			},
			css : {
				files : { 
					"handlers/Home.cfc"	: [ "includes/css/*fb.min.css" ]
				}
			},
			js : {
				files : { 
					"handlers/Home.cfc"	: [ "includes/js/*fb.min.js" ]
				}
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
			all : [ "Gruntfile.js", 'includes/js/src/*.js' ]			
		},

	} );

	// Load Tasks
	require( 'matchdep' )
		.filterDev( 'grunt-*' )
		.forEach( grunt.loadNpmTasks );
};