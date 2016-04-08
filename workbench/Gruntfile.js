module.exports = function(grunt) {

	// Register Tasks
	grunt.registerTask( 
		'default', 
		[ 
			'clean:targetIncludes',
			'sass:distTheme', 
			'uglify:libraries', 
			'uglify:contentboxJS',
			'copy:css',
			'copy:js',
			'copy:fonts',
			'copy:plugins',
			'watch'
		]
	);

	// Init grunt config
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		/**
		* Directory watch tasks, which will force individual re-compilations
		**/
		watch: {

			recompile: {
				files:[ 'Gruntfile.js' ],
				tasks:[ 'sass:distTheme', 'uglify:libraries', 'uglify:contentboxJS', 'copy:js', 'copy:fonts', 'copy:css', 'copy:plugins' ]	
			},

			sass: {
				files: ['devincludes/scss/*.{scss,sass}','devincludes/scss/**/*.{scss,sass}','devincludes/scss/**/**/*.{scss,sass}'],
				tasks: ['sass:distTheme']
			},

            contentBoxJS: {
            	files: ['devincludes/js/contentbox/**/*.js'],
            	tasks: ['uglify:contentboxJS']
            },

            vendorJS: {
            	files: ['devincludes/vendor/*.js'],
            	tasks: ['copy:plugins']
            },
		},

		// SCSS Compilation to css
		sass: {
			options: {
				sourceMap: true,
				outputStyle: 'compressed'
			},
			/**
			* Contentbox and Theme SCSS Compilation
			**/
			distTheme: {
			    options: {
			      style: 'expanded',
			      lineNumbers: true, // 1
			      sourcemap: false
			    },
			    files: {
					'../modules/contentbox-admin/includes/css/theme.css': 'devincludes/scss/theme.scss',
					'../modules/contentbox-admin/includes/css/contentbox.css': 'devincludes/scss/contentbox.scss'
				}
			 }
		},

		//uglification/copy of views and pages
		uglify: {

			/**
			* Compiled OSS Libraries
			**/
			libraries:{
				options:{
					preserveComments: true,
					mangle:false,
					banner: '/*! ContentBox Consolidated Open Source Javascript Libraries. Generated: <%= grunt.template.today("dd-mm-yyyy") %> */\n\n'
				},

				files: {

					//Libraries which are included in the HTML <head>
					'../modules/contentbox-admin/includes/js/preLib.js':
					[
				      	"bower_components/jquery/dist/jquery.min.js"
						,"bower_components/jquery.cookie/jquery.cookie.js"
						,"bower_components/jquery-validation/dist/jquery.validate.min.js"
						,"devincludes/vendor/jquery.validate.bootstrap.js"
						,"bower_components/bootstrap-sass/assets/javascripts/bootstrap.min.js"
						,"bower_components/moment/min/moment-with-locales.min.js"
						,"bower_components/lz-string/libs/lz-string.min.js"
						,"devincludes/vendor/modernizr.min.js"
						,"devincludes/js/app.js"
					],

					//Libraries which are brought in before the </body> end
					'../modules/contentbox-admin/includes/js/postLib.js':
					[
				      	"bower_components/bootstrap-modal/js/bootstrap-modalmanager.js"
				      	,"bower_components/bootstrap-modal/js/bootstrap-modal.js"
				      	,"bower_components/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"
						,"bower_components/es6-shim/es6-shim.min.js"
				      	,"bower_components/navgoco/src/jquery.navgoco.min.js"
				      	,"bower_components/switchery/dist/switchery.min.js"
						,"bower_components/raphael/raphael-min.js"
						,"bower_components/morris.js/morris.min.js"
						,"bower_components/clockpicker/dist/bootstrap-clockpicker.min.js"
						,"devincludes/vendor/bootstrap-fileupload.js"
						,"bower_components/jwerty/jwerty.js"
						,"bower_components/datatables/media/js/jquery.dataTables.min.js"
						,"bower_components/datatables/media/js/dataTables.bootstrap.min.js"
						,"devincludes/vendor/jquery.uitablefilter.js"
						,"devincludes/vendor/jquery.uidivfilter.js"
						,"bower_components/TableDnD/dist/jquery.tablednd.min.js"
						,"bower_components/toastr/toastr.min.js"
						,"bower_components/Bootstrap-Confirmation/bootstrap-confirmation.js"
						,"bower_components/jquery-nestable/jquery.nestable.js"
					]
				}

			},
			/**
			* ContentBox Custom JS Compiliation
			**/
			contentboxJS: {
			 	options: {
			  	beautify: true,
			  	mangle: false,
			  	compress: false,
			    // the banner is inserted at the top of the output
			    banner: '/*! Copyright <%= grunt.template.today("yyyy") %> - Ortus Solutions (Compiled: <%= grunt.template.today("dd-mm-yyyy") %>) */\n'
			  	},
			  	files: [{
		          expand: true,
			      cwd: 'devincludes/js',
		          src: 'contentbox/**/*.js',
		          dest: '../modules/contentbox-admin/includes/js/'
			    }]
		    }
		},

		/**
		* Libraries with JS and/or CSS w/o SCSS support - migrated to their respective project plugin directories
		**/
		copy: {
		  //Fonts to be copied over - will *replace* distribution fonts directory
		  fonts:{
		  	files: [ {
		  		expand: true,
		  		cwd: 'devincludes/',
		  		src: [ 
					"fonts/**"
		  		],
		  		dest: '../modules/contentbox-admin/includes/'	
		  	}]
		  },
		  // Single CSS files to copy from bower
		  css: {
		  	files: [
			      {
			      	expand: true,
			      	flatten:true, 
			      	cwd: 'bower_components/', 
			      	src: [
			      		'animate.css/animate.css'
			      		,'morris.js/morris.css'
			      		,'bootstrap-modal/css/bootstrap-modal-bs3patch.css'
			      		,'bootstrap-modal/css/bootstrap-modal.css'
			      	], 
			      	dest: '../modules/contentbox-admin/includes/css/',
			      },
			      {
			      	expand: true,
			      	flatten:true, 
			      	cwd: 'devincludes/', 
			      	src: [
			      		'vendor/*.css'
			      	], 
			      	dest: '../modules/contentbox-admin/includes/css/',
			      }
		      ]
		  },

		  /**
		  * Individual Javascript files migrated to project /includes/js 
		  **/
		  js:{
		  	// Single Javascript files to copy from bower
		  	files: [ 
			  	{
			  		expand: true,
			  		flatten:true,
			  		cwd: 'bower_components/',
			  		src: [ 
						"respond/dest/respond.min.js",
						"html5shiv/dist/html5shiv.min.js"
			  		],
			  		dest: '../modules/contentbox-admin/includes/js/'	
			  	},

			  	//Extra version of jQuery for CB FileBrowser
			  	{
			  		expand: true,
			  		flatten:true,
			  		cwd: 'bower_components/',
			  		src: [ 
						"jquery/dist/jquery.min.js"
			  		],
			  		dest: '../modules/contentbox-admin/includes/js/'	
			  	}
		  	]
		  },
		  /**
		  * Compiled Plugins migrated to project /includes/plugins/
		  **/
		  plugins: {
		    files: [
		      //legacy JS
		      {
		      	expand: true,
		      	flatten:true, 
		      	cwd: 'devincludes/', 
		      	src: [
		      		'vendor/*.js'
		      	], 
		      	dest: '../modules/contentbox-admin/includes/js/',
		      },
		      //Legacy Plugins
		      {
		      	expand: true,
		      	cwd: 'devincludes/plugins/', 
		      	src: [
		      		'bootstrap-slider/**',
					'bootstrap-wysihtml5/**',
					'c3Chart/**',
					'chartjs/**',
					'countTo/**',
					'flot/**',
					'fullcalendar/**',
					'gmaps/**',
					'icheck/**',
					'jvectormap/**',
					'mask/**',
					'messenger/**',
					'todo/**',
					'validation/**',
					'waypoints/**',
					'weather/**',
					'wizard/**'
		      	], 
		      	dest: '../modules/contentbox-admin/includes/plugins/',
		      },

		      // CKEditor
		      {
		      	expand: true,
		      	cwd: 'bower_components/', 
		      	src: [
		      		'ckeditor/plugins/**',
		      		'ckeditor/adapters/**',
		      		'ckeditor/skins/**',
		      		'ckeditor/lang/**',
		      		'ckeditor/*.js',
		      		'ckeditor/*.css',
		      	], 
		      	dest: '../modules/contentbox-admin/includes/plugins/',
		      },
		      //ContentBox CKEditor Plugins
		      {
		      	expand: true,
		      	cwd: 'devincludes/plugins/ckeditor/plugins/', 
		      	src: [
		      		'**'
		      	], 
		      	dest: '../modules/contentbox-admin/includes/plugins/ckeditor/plugins/',
		      },
		      //DataTables
		      {
		      	expand: true,
		      	cwd: 'bower_components/datatables/media/', 
		      	src: [
		      		'**'
		      	], 
		      	dest: '../modules/contentbox-admin/includes/plugins/dataTables/'
		      },
		      //Bootstrap DatePicker
		      {
		      	expand: true,
		      	cwd: 'bower_components/bootstrap-datepicker/dist/', 
		      	src: [
		      		'css/**',
		      		'js/**',
		      		'locales/**'
		      	], 
		      	dest: '../modules/contentbox-admin/includes/plugins/bootstrap-datepicker/'
		      },
		      //Bootstrap Clockpicker
		      {
		      	expand: true,
		      	flatten: true,
		      	cwd: 'bower_components/clockpicker/dist/', 
		      	src: [
		      		'bootstrap-clockpicker.min.js',
		      		'bootstrap-clockpicker.min.css'
		      	], 
		      	dest: '../modules/contentbox-admin/includes/plugins/clockpicker/',
		      	filter: 'isFile'
		      },
		      //jQuery Star Rating
		      {
		      	expand: true,
		      	flatten: true,
		      	cwd: 'bower_components/jquery-star-rating/min/', 
		      	src: [
		      		'rating.css',
		      		'rating.js'
		      	], 
		      	dest: '../modules/contentbox-admin/includes/plugins/jquery-star-rating/'
		      }
		    ],
		  },
		},
		/**
		* Directory Resets for Compiled Scripts - Clears the directories below in preparation for recompile
		* Only runs on on initial Grunt startup.  If removing plugins, you will need to restart Grunt
		**/
		clean:{
			options: {
		      force: true
		    },
		    targetIncludes: [ 
				'../modules/contentbox-admin/includes/plugins',
				'../modules/contentbox-admin/includes/fonts',
				'../modules/contentbox-admin/includes/css',
				'../modules/contentbox-admin/includes/js'
			]
		} 

	});

	// Load tasks
	// Load Tasks
	require( 'matchdep' )
		.filterDev( 'grunt-*' )
		.forEach( grunt.loadNpmTasks );
};