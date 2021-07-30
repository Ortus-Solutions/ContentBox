module.exports = function( grunt ) {

	// Register Tasks
	grunt.registerTask(
		"default", [
			"clean:targetIncludes", // clean target
			"css", // run css tasks
			"js", // run js tasks
			"watch" // start a watcher
		]
	);

	grunt.registerTask(
		"js", [
			"clean:js", // clean targets
			"clean:plugins", // clean plugins
			"concat", // concat everything
			"terser",
			"copy:js", // Copy standalone libs
			"copy:plugins", // Copy plugins
		]
	);

	grunt.registerTask(
		"css", [
			"clean:css", // clean target
			"copy:fonts", //copy fonts
			"sass:distTheme", // sass compilation
			"cssmin", // css minifications
			"clean:themecss" // cleanup combined css
		]
	);

	// Init grunt config
	grunt.initConfig( {
		pkg   : grunt.file.readJSON( "package.json" ),
		/**
         * Directory watch tasks, which will force individual re-compilations
         **/
		watch : {

			recompile : {
				files : [
					"Gruntfile.js",
					"package.json",
					"resources/plugins/**"
				],
				tasks : [ "default" ]
			},

			css : {
				files : [
					"resources/scss/*.{scss,sass}",
					"resources/scss/**/*.{scss,sass}",
					"resources/scss/**/**/*.{scss,sass}",
					"resources/vendor/css/*.css"
				],
				tasks : [ "css" ]
			},

			libsjs : {
				files : [ "resources/vendor/js/*.js" ],
				tasks : [ "js" ]
			},

			appjs : {
				files : [ "resources/js/**/*.js" ],
				tasks : [
					"concat:appjs",
					"terser:appjs"
				]
			}
		},

		/**
         * SCSS Compilation to css
         */
		sass : {
			options   : { sourceMap: false },
			/**
             * Contentbox and Theme SCSS Compilation
             **/
			distTheme : { files: { "../modules/contentbox/modules/contentbox-admin/includes/css/theme.css": "resources/scss/theme.scss" } }
		},

		/**
         * CSS Min
         * Minifies the theme + vendor css
         */
		cssmin : {
			options : { sourceMap: true },
			target  : {
				files : {
					"../modules/contentbox/modules/contentbox-admin/includes/css/contentbox.min.css" : [
						// THEME
						"../modules/contentbox/modules/contentbox-admin/includes/css/theme.css",
						// APP COMPONENTS
						"app_modules/animate.css/animate.css",
						"app_modules/switchery/dist/switchery.min.css",
						"app_modules/morris.js/morris.css",
						"app_modules/datatables/media/css/dataTables.bootstrap.css",
						"app_modules/bootstrap-datepicker/dist/css/bootstrap-datepicker3.min.css",
						"app_modules/clockpicker/dist/bootstrap-clockpicker.css",
						"app_modules/bootstrap-toggle/css/bootstrap-toggle.min.css",
						"app_modules/seiyria-bootstrap-slider/dist/css/bootstrap-slider.min.css",
						// Media Manager Components
						"node_modules/jquery-contextmenu/dist/jquery.contextMenu.min.css",
						"node_modules/Jcrop/css/Jcrop.min.css",
						// VENDOR CSS
						"resources/vendor/css/*.css"
					]
				}
			}
		},

		/**
         * Concat JS
         */
		concat : {

			// ContentBox App Libraries
			appjs : {
				files : {
					"../modules/contentbox/modules/contentbox-admin/includes/js/contentbox-app.js"     : [ "resources/js/*.js" ],
					"../modules/contentbox/modules/contentbox-admin/includes/js/contentbox-editors.js" : [
						"resources/js/editors/editors.js",
						"resources/js/editors/autosave.js"
					]
				}
			},

			// Pre Lib: Libraries which are brough in the <head> section
			prejs : {
				src : [
					// YARN/NPM Libraries
					// ES6 compatibility for the browser since we are not using webpack yet: For objects and functions only, not syntax
					"app_modules/es6-shim/es6-shim.min.js",
					// HTML5 shim detection
					"resources/vendor/js/modernizr.min.js",
					// AlpineJS : Will replace majority of js files below
					"node_modules/alpinejs/dist/cdn.js",
					// Jquery
					"app_modules/jquery/dist/jquery.min.js",
					// Moment: Used by the Editors JS: Refactor in the future to JavaScript API
					"node_modules/moment/min/moment.min.js",
					// For autosaving and js cookies on editors
					"app_modules/jquery.cookie/jquery.cookie.js",
					// Form validation
					"app_modules/jquery-validation/dist/jquery.validate.min.js",
					// Bootstrap js plugins
					"app_modules/bootstrap-sass/assets/javascripts/bootstrap.min.js",
					// String compression utility: Used by autosave features
					"app_modules/lz-string/libs/lz-string.min.js",
					// Global utility
					"app_modules/lodash/dist/lodash.min.js",
					// Navigation History
					"app_modules/history.js/scripts/bundled/html4+html5/jquery.history.js",
					// Date picker
					"app_modules/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js",
					"app_modules/clockpicker/dist/bootstrap-clockpicker.min.js",
					// Theme navigation
					"app_modules/navgoco/src/jquery.navgoco.min.js",
					// Theme navigation
					"app_modules/switchery/dist/switchery.min.js",
					// Charting Libraries
					"app_modules/raphael/raphael.js",
					"app_modules/morris.js/morris.min.js",
					// Keyboard shortcuts
					"app_modules/jwerty/jwerty.js",
					// Data tables
					"app_modules/datatables/media/js/jquery.dataTables.min.js",
					"app_modules/datatables/media/js/dataTables.bootstrap.min.js",
					// Table drag and drop
					"app_modules/TableDnD/dist/jquery.tablednd.min.js",
					// Toaster notifications
					"app_modules/toastr/toastr.min.js",
					// Bootstrap modal confirmations
					"app_modules/Bootstrap-Confirmation/bootstrap-confirmation.js",
					// Drag & drop hierarchical list with mouse and touch compatibility
					"app_modules/jquery-nestable/jquery.nestable.js",
					// on/off Toggles
					"app_modules/bootstrap-toggle/js/bootstrap-toggle.min.js",
					// setting sliders
					"app_modules/seiyria-bootstrap-slider/dist/bootstrap-slider.min.js",
					// MEDIAMANAGER: BootBox used by media manager
					"node_modules/bootbox/dist/bootbox.min.js",
					// MEDIAMANAGER:  FileDrop used by media manager
					"resources/vendor/js/jquery.filedrop.js",
					// MEDIAMANAGER: Context Menu used by media manager
					"node_modules/jquery-contextmenu/dist/jquery.contextMenu.min.js",
					// MEDIAMANAGER: Jcropping editor
					"node_modules/Jcrop/js/Jcrop.min.js",
					// Static Libraries
					"resources/vendor/js/jquery.validate.bootstrap.js",
					// File Uploads components
					"resources/vendor/js/bootstrap-fileupload.js",
					// Luis Majano's div and table filters
					"resources/vendor/js/jquery.uidivfilter.js",
					"resources/vendor/js/jquery.uitablefilter.js"
				],
				dest : "../modules/contentbox/modules/contentbox-admin/includes/js/contentbox-pre.js"
			}

		},

		/**
         * Use terser to compress/minify es6+
         */
		terser : {
			// Options
			options : {
				ecma     : 2018,
				compress : {
					defaults : true,
					ecma     : 2018
				},
				mangle : true
			},

			// ContentBox App
			appjs : {
				files : {
					"../modules/contentbox/modules/contentbox-admin/includes/js/contentbox-app.min.js"     : [ "../modules/contentbox/modules/contentbox-admin/includes/js/contentbox-app.js" ],
					"../modules/contentbox/modules/contentbox-admin/includes/js/contentbox-editors.min.js" : [ "../modules/contentbox/modules/contentbox-admin/includes/js/contentbox-editors.js" ]
				}
			},

			// JS Libraries
			libraries : { files: { "../modules/contentbox/modules/contentbox-admin/includes/js/contentbox-pre.min.js": [ "../modules/contentbox/modules/contentbox-admin/includes/js/contentbox-pre.js" ] } }
		},

		/**
         * Libraries with JS and/or CSS w/o SCSS support - migrated to their respective project plugin directories
         **/
		copy : {
			//Fonts to be copied over - will *replace* distribution fonts directory
			fonts : {
				files : [
					{
						expand  : true,
						flatten : true,
						src     : "app_modules/font-awesome-sass/assets/fonts/font-awesome/**",
						filter  : "isFile",
						dest    : "../modules/contentbox/modules/contentbox-admin/includes/fonts/font-awesome"
					},
					{
						expand  : true,
						flatten : true,
						src     : "app_modules/bootstrap-sass/assets/fonts/bootstrap/**",
						filter  : "isFile",
						dest    : "../modules/contentbox/modules/contentbox-admin/includes/fonts/bootstrap"
					}
				]
			},

			/**
             * Individual Javascript files migrated to project /includes/js
             **/
			js : {
				files : [
					// Extra version of jQuery for CB FileBrowser
					{
						expand  : true,
						flatten : true,
						cwd     : "app_modules/",
						src     : [ "jquery/dist/jquery.min.js" ],
						dest    : "../modules/contentbox/modules/contentbox-admin/includes/js/"
					}
				]
			},

			/**
             * Compiled Plugins moved to /includes/plugins/
             * These are loaded not on every page but determined by certain conditions
             **/
			plugins : {
				files : [
					// CKEditor
					{
						expand : true,
						cwd    : "app_modules/",
						src    : [
							"ckeditor/plugins/**",
							"ckeditor/adapters/**",
							"ckeditor/skins/moono-lisa/**",
							"ckeditor/lang/**",
							"ckeditor/ckeditor.js",
							"ckeditor/styles.js",
							"ckeditor/*.css",
						],
						dest : "../modules/contentbox/modules/contentbox-admin/modules/contentbox-ckeditor/includes/",
					},
					// ContentBox CKEditor Config + Plugins
					{
						expand : true,
						cwd    : "resources/plugins/ckeditor/",
						src    : [ "**" ],
						dest   : "../modules/contentbox/modules/contentbox-admin/modules/contentbox-ckeditor/includes/ckeditor",
					},
					// AutoSave
					{
						expand : true,
						cwd    : "resources/plugins/autosave",
						src    : [ "**" ],
						dest   : "../modules/contentbox/modules/contentbox-admin/includes/plugins/autosave",
					},
					// Simple MDE Editor
					{
						expand : true,
						cwd    : "app_modules/simplemde/dist",
						src    : [ "**" ],
						dest   : "../modules/contentbox/modules/contentbox-admin/modules/contentbox-markdowneditor/includes/simplemde",
					},
				],
			}, // end plugins
		}, // end copy task

		/**
         * Directory Resets for Compiled Scripts - Clears the directories below in preparation for recompile
         * Only runs on on initial Grunt startup.  If removing plugins, you will need to restart Grunt
         **/
		clean : {
			options        : { force: true },
			targetIncludes : [
				"../modules/contentbox/modules/contentbox-admin/includes/plugins",
				"../modules/contentbox/modules/contentbox-admin/includes/fonts",
				"../modules/contentbox/modules/contentbox-admin/includes/css",
				"../modules/contentbox/modules/contentbox-admin/includes/js",
				"../modules/contentbox/modules/contentbox-admin/modules/contentbox-ckeditor/includes",
				"../modules/contentbox/modules/contentbox-admin/modules/contentbox-markdowneditor/includes"
			],
			css      : [ "../modules/contentbox/modules/contentbox-admin/includes/css" ],
			themecss : [ "../modules/contentbox/modules/contentbox-admin/includes/css/theme.css" ],
			js       : [ "../modules/contentbox/modules/contentbox-admin/includes/js" ],
			plugins  : [ "../modules/contentbox/modules/contentbox-admin/includes/plugins" ]
		}

	} );

	// Load Tasks
	require( "matchdep" )
		.filterDev( "grunt-*" )
		.forEach( grunt.loadNpmTasks );
};