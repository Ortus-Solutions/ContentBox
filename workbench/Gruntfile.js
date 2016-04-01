module.exports = function(grunt) {
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		watch: {

			recompile: {
				files:[ 'Gruntfile.js', 'require.build.js' ],
				tasks:[ 'sass:dist','sass:distTheme', 'uglify:libraries', 'uglify:contentboxJS', 'copy:js', 'copy:fonts', 'copy:css', 'copy:plugins' ]	
			},

			sass: {
				files: ['devincludes/scss/*.{scss,sass}','devincludes/scss/**/*.{scss,sass}','devincludes/scss/**/**/*.{scss,sass}'],
				tasks: ['sass:dist','sass:distTheme']
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

		sass: {
			options: {
				sourceMap: true,
				outputStyle: 'compressed'
			},
			dist: {
				files: {
					'../modules/contentbox-admin/includes/css/relax.css': 'devincludes/scss/relax.scss',
				}
			},
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
			libraries:{
				options:{
					preserveComments: true,
					banner: '/*! ContentBox Consolidated Open Source Javascript Libraries. Generated: <%= grunt.template.today("dd-mm-yyyy") %> */\n\n'
				},

				files: {

					//Libraries which are included in the HTML <head>
					'../modules/contentbox-admin/includes/js/preLib.js':
					[
				      	"bower_components/jquery/dist/jquery.min.js"
						,"bower_components/jquery.cookie/jquery.cookie.js"
						,"bower_components/jquery-validation/dist/jquery.validate.min.js"
						,"bower_components/bootstrap-sass/assets/javascripts/bootstrap.min.js"
						,"bower_components/underscore/underscore-min.js"
						,"bower_components/moment/min/moment-with-locales.min.js"
						,"devincludes/vendor/modernizr.min.js"
					],

					//Libraries which are brought in before the </body> end
					'../modules/contentbox-admin/includes/js/postLib.js':
					[
				      	"bower_components/jquery-i18n-properties/jquery.i18n.properties.min.js"
				      	,"bower_components/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"
						,"bower_components/es6-shim/es6-shim.min.js"
				      	,"bower_components/switchery/dist/switchery.min.js"
						,"bower_components/Scrollify/jquery.scrollify.min.js"
						,"bower_components/toastr/toastr.min.js"
						,"bower_components/navgoco/src/jquery.navgoco.min.js"
						,"bower_components/Bootstrap-Confirmation/bootstrap-confirmation.js"
						,"bower_components/bootstrap-contextmenu/bootstrap-contextmenu.js"
						,"bower_components/jquery-nestable/jquery.nestable.js"
						,"bower_components/TableDnD/dist/jquery.tablednd.min.js"
						,"bower_components/jwerty/jwerty.js"
						,"bower_components/jquery.metadata/jquery.metadata.js"
						,"bower_components/lz-string/libs/lz-string.min.js"
						,"bower_components/raphael/raphael-min.js" 
						,"bower_components/jquery-i18n-properties/jquery.i18n.properties.min.js"
						,"devincludes/vendor/bootstrap-modalmanager.js"
						,"bower_components/clockpicker/dist/bootstrap-clockpicker.min.js"
					]
				}

			},

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
		* Libraries with JS and/or CSS, but w/o SCSS support
		**/
		copy: {
		  fonts:{
		  	//Fonts to be copied over - will replace distribution fonts directory
		  	files: [ {
		  		expand: true,
		  		cwd: 'devincludes/',
		  		src: [ 
					"fonts/**"
		  		],
		  		dest: '../modules/contentbox-admin/includes/'	
		  	}]
		  },
		  css: {
		  	files: [
			      // Single CSS files to copy from bower
			      {
			      	expand: true,
			      	flatten:true, 
			      	cwd: 'bower_components/', 
			      	src: [
			      		'animate.css/animate.css'
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

		  js:{
		  	// Single Javascript files to copy from bower
		  	files: [ {
		  		expand: true,
		  		flatten:true,
		  		cwd: 'bower_components/',
		  		src: [ 
					"respond/dest/respond.min.js",
					"html5shiv/dist/html5shiv.min.js"
		  		],
		  		dest: '../modules/contentbox-admin/includes/js/'	
		  	}]
		  },

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
					'morris/**',
					'ratings/**',
					'sortNestable/**',
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
		      //Bootstrap Modal Extensions
		      {
		      	expand: true,
		      	cwd: 'bower_components/bootstrap-modal/', 
		      	src: [
		      		'css/**',
		      		'js/**',
		      		'img/**'
		      	], 
		      	dest: '../modules/contentbox-admin/includes/plugins/bootstrap-modal/'
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
		      //Bootstrap Fileinput
		      {
		      	expand: true,
		      	cwd: 'bower_components/bootstrap-fileinput/', 
		      	src: [
		      		'css/**',
		      		'js/**',
		      		'img/**'
		      	], 
		      	dest: '../modules/contentbox-admin/includes/plugins/bootstrap-fileinput/'
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
		      //jQuery Tablesorter
		      {
		      	expand: true,
		      	cwd: 'bower_components/tablesorter/dist/', 
		      	src: [
		      		'css/**',
		      		'js/**'
		      	], 
		      	dest: '../modules/contentbox-admin/includes/plugins/tablesorter/'
		      },

		      //jQuery Star Rating
		      {
		      	expand: true,
		      	flatten: true,
		      	cwd: 'bower_components/jquery-star-rating/src/', 
		      	src: [
		      		'rating.css',
		      		'rating.js'
		      	], 
		      	dest: '../modules/contentbox-admin/includes/plugins/jquery-star-rating/'
		      }
		    ],
		  },
		}

	});
	grunt.loadNpmTasks('grunt-sass');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.loadNpmTasks('grunt-contrib-copy');
	grunt.registerTask('default', ['sass:dist','sass:distTheme', 'uglify:libraries' , 'uglify:contentboxJS', 'copy:css', 'copy:js', 'copy:fonts', 'copy:plugins', 'watch']);
	
};