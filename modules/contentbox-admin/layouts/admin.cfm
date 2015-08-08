<cfoutput>
#html.doctype()#
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!-->
<html class="no-js">
<!--<![endif]-->
    <head>
        <!--- charset --->
        <meta charset="utf-8" />
        <!--- IE Stuff --->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <!--- Robots --->
        <meta name="robots" content="noindex,nofollow" />
        <!--- SES --->
        <base href="#cb.siteBaseURL()#" />
        <!--- Title --->
        <title>#prc.cbSettings.cb_site_name# - ContentBox Administrator</title>
        <!--- Description --->
        <meta name="description" content="ContentBox Modular CMS - Admin">
        <!--- Viewport for scaling --->
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

        <!--- ********************************************************************* --->
        <!---                           FAVICONS                                    --->
        <!--- ********************************************************************* --->

        <!--- Favicon --->
        <link href="#prc.cbroot#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
        <!--- For non-Retina iPhone, iPod Touch, and Android 2.2+ devices: --->
        <link href="#prc.cbroot#/includes/images/ContentBox-Circle-57.png" rel="apple-touch-icon"/>
        <!--- For first-generation iPad: --->
        <link href="#prc.cbroot#/includes/images/ContentBox-Circle-72.png" rel="apple-touch-icon" sizes="72x72"/>
        <!--- For iPhone 4 with high-resolution Retina display: --->
        <link href="#prc.cbroot#/includes/images/ContentBox-Circle-114.png" rel="apple-touch-icon" sizes="114x114"/>
        <!-- Favicon -->
        <link href="#prc.cbroot#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
        
        <!--- ********************************************************************* --->
        <!---                           CSS THEME                                   --->
        <!--- ********************************************************************* --->

        <!-- Bootstrap core CSS -->
        <link href="#prc.cbroot#/includes/spacelab/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
        <!-- fonts from font awesome -->
        <link href="#prc.cbroot#/includes/spacelab/css/font-awesome.min.css" rel="stylesheet" />
        <!-- css animate -->
        <link href="#prc.cbroot#/includes/spacelab/css/animate.css" rel="stylesheet" />
        <!-- Switchery -->
    	<link rel="stylesheet" href="#prc.cbroot#/includes/spacelab/plugins/switchery/switchery.min.css">
        <!-- spacelab theme-->
        <link href="#prc.cbroot#/includes/spacelab/css/main.css" rel="stylesheet" />
        
        <!--- ********************************************************************* --->
        <!---                          CONTENTBOX                                   --->
        <!--- ********************************************************************* --->

        <!-- datatables -->
        <link href="#prc.cbroot#/includes/spacelab/plugins/dataTables/css/dataTables.css" rel="stylesheet" />
        <!-- morris -->
        <link href="#prc.cbroot#/includes/spacelab/plugins/morris/css/morris.css" rel="stylesheet" />
        <!-- toastr -->
        <link href="#prc.cbroot#/includes/css/toastr.min.css" rel="stylesheet" />
        <!-- file upload -->
        <link href="#prc.cbroot#/includes/css/bootstrap-fileupload.css" rel="stylesheet" />
        <!-- modal -->
        <link href="#prc.cbroot#/includes/css/bootstrap-modal-bs3patch.css" rel="stylesheet" />
        <link href="#prc.cbroot#/includes/css/bootstrap-modal.css" rel="stylesheet" />
        <!-- datepicker -->
        <link href="#prc.cbroot#/includes/css/bootstrap-datepicker.css" rel="stylesheet" />
        <!-- clockpicker -->
        <link href="#prc.cbroot#/includes/spacelab/plugins/clockpicker/bootstrap-clockpicker.min.css" rel="stylesheet" />
        <!-- custom contentbox css -->
        <link href="#prc.cbroot#/includes/css/contentbox.css" rel="stylesheet" />
        
        <!--- ********************************************************************* --->
        <!---                           JAVASCRIPT                                  --->
        <!--- ********************************************************************* --->

        <!-- modernizr for feature detection -->
        <script src="#prc.cbroot#/includes/spacelab/js/modernizr.min.js"></script>
        <!-- jquery main -->
        <script src="#prc.cbroot#/includes/spacelab/js/jquery.min.js"></script>
        <!-- bootstrap js -->
        <script src="#prc.cbroot#/includes/spacelab/plugins/bootstrap/js/bootstrap.min.js"></script>
        <!-- Navigation -->
        <script src="#prc.cbroot#/includes/spacelab/plugins/navgoco/jquery.navgoco.min.js"></script>
        <script src="#prc.cbroot#/includes/spacelab/plugins/switchery/switchery.min.js"></script>
        <!-- morris graphs -->
        <script src="#prc.cbroot#/includes/spacelab/plugins/morris/js/raphael-min.js"></script>
        <script src="#prc.cbroot#/includes/spacelab/plugins/morris/js/morris.min.js"></script>
        <!-- spacelab js -->
        <script src="#prc.cbroot#/includes/spacelab/js/application.js"></script>

        <!--- ********************************************************************* --->
        <!---                          CONTENTBOX JAVASCRIPT                        --->
        <!--- ********************************************************************* --->

        <!-- clock picker -->
        <script src="#prc.cbroot#/includes/spacelab/plugins/clockpicker/bootstrap-clockpicker.min.js"></script>
        <!-- file upload -->
        <script src="#prc.cbroot#/includes/js/bootstrap-fileupload.js"></script>
       	<!-- modal -->
        <script src="#prc.cbroot#/includes/js/bootstrap-modalmanager.js"></script>
        <script src="#prc.cbroot#/includes/js/bootstrap-modal.js"></script>
        <!-- datepicker -->
        <script src="#prc.cbroot#/includes/js/bootstrap-datepicker.js"></script>
        <!-- cookie helper -->
        <script src="#prc.cbroot#/includes/js/jquery.cookie.js"></script>
        <!-- validation -->
        <script src="#prc.cbroot#/includes/spacelab/plugins/validation/js/jquery.validate.min.js"></script>
        <!-- jwerty -->
        <script src="#prc.cbroot#/includes/js/jwerty.js"></script>
        <!-- datatables -->
        <script src="#prc.cbroot#/includes/spacelab/plugins/dataTables/js/jquery.dataTables.js"></script>
        <script src="#prc.cbroot#/includes/spacelab/plugins/dataTables/js/dataTables.bootstrap.js"></script>
        <!-- table filter -->
        <script src="#prc.cbroot#/includes/js/jquery.uitablefilter.js"></script>
        <!-- drag and drop -->
        <script src="#prc.cbroot#/includes/js/jquery.tablednd_0_7.js"></script>
        <!-- toastr -->
        <script src="#prc.cbroot#/includes/js/toastr.min.js"></script>
        <!-- main ContentBox scripts -->
        <script src="#prc.cbroot#/includes/js/contentbox.js"></script>

        <!--- CKEditor Separate --->
        <script src="#prc.cbroot#/includes/ckeditor/ckeditor.js"></script>
        <script src="#prc.cbroot#/includes/ckeditor/adapters/jquery.js"></script>

        <!--- ********************************************************************* --->
        <!---                           A-LA-CARTE                                  --->
        <!--- ********************************************************************* --->

        <cfscript>
            cssList = listToArray( event.getValue( "cssAppendList", "", true ) );
            for( css in cssList ) {
                addAsset( "#prc.cbroot#/includes/css/#css#.css" );
            }
            fullCssList = listToArray( event.getValue( "cssFullAppendList", "", true ) );
            for( css in fullCssList ) {
                addAsset( "#css#.css" );
            }
            jsList = listToArray( event.getValue( "jsAppendList", "", true ) );
            for( js in jsList ) {
                addAsset( "#prc.cbroot#/includes/js/#js#.js" );
            }
            fullJSList = listToArray( event.getValue( "jsFullAppendList", "", true ) );
            for( js in fullJSList ) {
                addAsset( "#js#.js" );
            }
        </cfscript>

        <!--- ********************************************************************* --->
        <!---                           FONTS 	                                    --->
        <!--- ********************************************************************* --->

        <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,900,300italic,400italic,600italic,700italic,900italic' rel='stylesheet' type='text/css'>
        <link href='http://fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>

        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!--[if lt IE 9]>
        <script src="#prc.cbroot#/includes/spacelab/js/html5shiv.js"></script>
        <script src="#prc.cbroot#/includes/spacelab/js/respond.min.js"></script>
        <![endif]-->
        <!--- cbadmin Event --->
        #announceInterception( "cbadmin_beforeHeadEnd" )#
    </head>
    <body class="off-canvas">
        <!--- cbadmin Event --->
        #announceInterception( "cbadmin_afterBodyStart" )#
        <section id="container">
            <header id="header">

                <!--logo start-->
                <div class="brand text-center">
                    <a data-keybinding="ctrl+shift+d"  href="#event.buildLink( prc.xehDashboard )#" class="logo" title="Dashboard ctrl+shift+d" data-placement="right">
                        <img src="#prc.cbRoot#/includes/images/ContentBox_90.png"/>
                    </a>
                </div>

                <!--logo end-->
                <div class="toggle-navigation toggle-left">
                    <a onclick="app.toggleMenuLeft()" class="btn btn-default options toggle" id="toggle-left" data-toggle="tooltip" data-placement="right" title="Toggle Navigation (ctrl+shift+n)" data-keybinding="ctrl+shift+n">
                    	<i class="fa fa-bars"></i>
                    </a>
                </div>
                <div class="user-nav">
                    <ul>
                    	<!--- View Site --->
                    	<li class="" data-placement="right" title="Visit Site">
                    		<a class="btn btn-default options toggle" href="#event.buildLink( prc.cbEntryPoint )#" target="_blank">
                    			<i class="fa fa-home"></i>
                    		</a>
                    	</li>
                    	<!--- New Quick Links --->
				    	<cfif prc.oAuthor.checkPermission( "PAGES_ADMIN,PAGES_EDITOR,ENTRIES_ADMIN,ENTRIES_EDITOR,AUTHOR_ADMIN,MEDIAMANAGER_ADMIN" )>
				    	<li class="dropdown settings" title="Create New..." data-name="create-new" data-placement="right">
				    		<button data-toggle="dropdown" class="dropdown-toggle btn btn-default options toggle" onclick="javascript:void( null )">
				    			<i class="fa fa-plus"></i>
				    		</button>
							<ul class="dropdown-menu animated fadeInDown">
								<cfif prc.oAuthor.checkPermission( "PAGES_ADMIN,PAGES_EDITOR" )>
									<li>
										<a data-keybinding="ctrl+shift+p" href="#event.buildLink( prc.xehPagesEditor )#" title="ctrl+shift+P">
											<i class="fa fa-file-o"></i> New Page
										</a>
									</li>
								</cfif>
								<cfif !prc.cbSettings.cb_site_disable_blog AND prc.oAuthor.checkPermission( "ENTRIES_ADMIN,ENTRIES_EDITOR" )>
									<li>
										<a data-keybinding="ctrl+shift+b" href="#event.buildLink( prc.xehBlogEditor )#" title="ctrl+shift+B">
											<i class="fa fa-quote-left"></i> New Entry
										</a>
									</li>
								</cfif>
								<cfif prc.oAuthor.checkPermission( "CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR" )>
									<li>
										<a data-keybinding="ctrl+shift+t" href="#event.buildLink( prc.xehContentStoreEditor )#" title="ctrl+shift+t">
											<i class="fa fa-hdd-o"></i> New Content Store
										</a>
									</li>
								</cfif>
								<cfif prc.oAuthor.checkPermission( "AUTHOR_ADMIN" )>
									<li>
										<a data-keybinding="ctrl+shift+u" href="#event.buildLink( prc.xehAuthorEditor )#" title="ctrl+shift+U">
											<i class="fa fa-user"></i> New User
										</a>
									</li>
								</cfif>
								<cfif prc.oAuthor.checkPermission( "MEDIAMANAGER_ADMIN" )>
									<li>
										<a data-keybinding="ctrl+shift+m" href="#event.buildLink( prc.xehMediaManager )#" title="ctrl+shift+M">
											<i class="fa fa-picture-o"></i> New Media
										</a>
									</li>
								</cfif>
								<cfif prc.oAuthor.checkPermission( "MENUS_ADMIN" )>
									<li>
										<a data-keybinding="ctrl+shift+m" href="#event.buildLink( prc.xehMenuManager )#" title="ctrl+shift+U">
											<i class="fa fa-list"></i> New Menu
										</a>
									</li>
								</cfif>
							</ul>
						</li>
						</cfif>
                    	
                    	<!--- Utils --->
                        #prc.adminMenuService.generateUtilsMenu()#
                       	
                       	<!--- Support Menu --->
                        #prc.adminMenuService.generateSupportMenu()#
                        
                        <!--- Profile --->
                        <li class="profile-photo">
                            #getModel( "Avatar@cb" ).renderAvatar( email=prc.oAuthor.getEmail(), size="35", class="img-circle" )#
                        </li>
                        #prc.adminMenuService.generateProfileMenu()#
                        
                        <!--- Notifications --->
                        <li class="dropdown messages">
                            <span class="badge badge-danager animated bounceIn" id="new-messages">5</span>
                            <div class="toggle-navigation toggle-right">
                                <button type="button" class="btn btn-default" id="toggle-right">
                                    <i class="fa fa-bullhorn"></i>
                                </button>                        
                            </div>
                        </li>
                    </ul>
                </div>
            </header>

            <!--sidebar left start-->
            <nav class="sidebar sidebar-left">
            	<h5 class="sidebar-header">Navigation</h5>
                <!--- Main Generated Menu --->
                #prc.adminMenuService.generateMenu()#
            </nav>
            <!--sidebar left end-->
            
            <!--main content start-->
            <section class="main-content-wrapper">
                <section id="main-content">
                    <!--- cbadmin event --->
                    #announceInterception( "cbadmin_beforeContent" )#
                    <!--- Main Content --->
                    #renderView()#
                    <!--- cbadmin event --->
                    #announceInterception( "cbadmin_afterContent" )#
                </section>
            </section>
            <!--main content end-->

         	<!--- Footer --->
        	#renderView( view="_tags/footer", module="contentbox-admin" )#
        </section>  

        <!--sidebar right start-->
        <div class="sidebarRight">
	        <div id="rightside-navigation">
	            <div class="sidebar-heading"><i class="fa fa-bullhorn"></i> Notifications</div>
                    <div class="sidebar-title">system</div>
                    <div class="list-contacts">
                        <cfif prc.oAuthor.checkPermission( "SYSTEM_TAB" ) AND prc.installerCheck.installer>
                            <div class="list-item">
                                <div class="list-item-image">
                                    <i class="fa fa-warning img-circle"></i>
                                </div>
                                <div class="list-item-content">
                                    <h4>
                                        Installer Module
                                        <span class="actions dropdown pull-right">
                                            <button class="fa fa-cog dropdown-toggle" data-toggle="dropdown"></button>
                                            <ul class="dropdown-menu dropdown-menu-right" role="menu">
                                                <li role="presentation">
                                                    <a role="menuitem" href="javascript:void(0);" tabindex="-1" onclick="deleteInstaller()">
                                                        <i class="fa fa-trash-o"></i> Delete Installer
                                                    </a>
                                                </li>
                                            </ul>
                                        </span>
                                    </h4>
                                    <p>The installer module still exists! Please delete it from your server as leaving it online is a security risk.</p>
                                </div>
                            </div>
                        </cfif>
                        <cfif prc.oAuthor.checkPermission( "SYSTEM_TAB" ) AND prc.installerCheck.dsncreator>
                            <div class="list-item">
                                <div class="list-item-image">
                                    <i class="fa fa-warning img-circle"></i>
                                </div>
                                <div class="list-item-content">
                                    <h4>
                                        DSN Creator Module
                                        <span class="actions dropdown pull-right">
                                            <button class="fa fa-cog dropdown-toggle" data-toggle="dropdown"></button>
                                            <ul class="dropdown-menu dropdown-menu-right" role="menu">
                                                <li role="presentation">
                                                    <a role="menuitem" href="javascript:void(0);" tabindex="-1" onclick="deleteDSNCreator()">
                                                        <i class="fa fa-trash-o"></i> Delete DSN Creator
                                                    </a>
                                                </li>
                                            </ul>
                                        </span>
                                    </h4>
                                    <p>The DSN creator module still exists! Please delete it from your server as leaving it online is a security risk.</p>
                                </div>
                            </div>
                        </cfif>
                    </div>
                </div>
	        </div>
	    </div>
        <!--sidebar right end-->

        <!--- ConfirmIt modal --->
        <div id="confirmIt" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="confirmItTitle" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <!--header-->
                    <div class="modal-header">
                        <!--if dismissable-->
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title" id="confirmItTitle">Are you sure?</h4>
                    </div>
                    <!--body-->
                    <div class="modal-body">
                        <p id="confirmItMessage">Are you sure you want to perform this action?</p>
                    </div>
                    <!-- footer -->
                    <div class="modal-footer">
                        <span id="confirmItLoader" class="hide"><i class="fa fa-spinner fa-spin fa-lg fa-2x"></i></span>
                        <span id="confirmItButtons">
                            <button class="btn" data-dismiss="modal" aria-hidden="true"><i class="icon-remove"></i> Cancel</button>
                            <button class="btn btn-danger" data-action="confirm"><i class="icon-check"></i>  Confirm </button>
                        </span>
                    </div>
                </div>
            </div>
        </div>
        <div id="modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
            <div class="modal-header">
                <h3>Loading...</h3>
            </div>
            <div class="modal-body" id="remoteModelContent">
                <i class="fa fa-spinner fa fa-spin fa-lg icon-4x"></i>
            </div>
        </div>
    </body>
</html>
</cfoutput>