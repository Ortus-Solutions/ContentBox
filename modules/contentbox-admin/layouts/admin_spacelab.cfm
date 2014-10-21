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
        <meta name="description" content="">
        <!--- Viewport for scaling --->
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
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
        <!---Minify global CSS includes--->
        <cfscript>
            cssFiles = [
                // Bootstrap core CSS
                "#prc.cbroot#/includes/spacelab/plugins/bootstrap/css/bootstrap.min.css",
                // custom admintheme files
                //"#( len( prc.adminThemeService.getCurrentTheme().getCSS() ) ? prc.adminThemeService.getCurrentTheme().getCSS() & ',' : '')#",
                // fonts from font awesome
                "#prc.cbroot#/includes/spacelab/css/font-awesome.min.css",
                // css animate
                "#prc.cbroot#/includes/spacelab/css/animate.css",
                // fileupload
                "#prc.cbroot#/includes/css/bootstrap-fileupload.css",
                // modal
                "#prc.cbroot#/includes/css/bootstrap-modal-bs3patch.css",
                "#prc.cbroot#/includes/css/bootstrap-modal.css",
                // datepicker
                "#prc.cbroot#/includes/css/bootstrap-datepicker.css",
                // datatables
                "#prc.cbroot#/includes/spacelab/plugins/dataTables/css/dataTables.css",
                // toastr
                "#prc.cbroot#/includes/css/toastr.min.css",
                // custom styles for spacelab
                "#prc.cbroot#/includes/spacelab/css/main.css"
            ];
            jsFiles = [
                // modernizr for feature detection
                "#prc.cbroot#/includes/spacelab/js/modernizr-2.6.2.min.js",
                // jquery main
                "#prc.cbroot#/includes/spacelab/js/jquery-1.10.2.min.js",
                // bootstrap js
                "#prc.cbroot#/includes/spacelab/plugins/bootstrap/js/bootstrap.min.js",
                // spacelab js
                "#prc.cbroot#/includes/spacelab/js/application.js",
                // fileupload
                "#prc.cbroot#/includes/js/bootstrap-fileupload.js",
                // modal
                "#prc.cbroot#/includes/js/bootstrap-modalmanager.js",
                "#prc.cbroot#/includes/js/bootstrap-modal.js",
                // datepicker
                "#prc.cbroot#/includes/js/bootstrap-datepicker.js",
                // cookie helper
                "#prc.cbroot#/includes/js/jquery.cookie.js",
                // validation
                "#prc.cbroot#/includes/spacelab/plugins/validation/js/jquery.validate.min.js",
                // jwerty
                "#prc.cbroot#/includes/js/jwerty.js",
                // datatables
                "#prc.cbroot#/includes/spacelab/plugins/dataTables/js/jquery.dataTables.js",
                "#prc.cbroot#/includes/spacelab/plugins/dataTables/js/dataTables.bootstrap.js",
                // table filter
                "#prc.cbroot#/includes/js/jquery.uitablefilter.js",
                // drag and drop
                "#prc.cbroot#/includes/js/jquery.tablednd_0_7.js",
                // toastr
                "#prc.cbroot#/includes/js/toastr.min.js",
                // custom admintheme js
                "#( len( prc.adminThemeService.getCurrentTheme().getJS() ) ? prc.adminThemeService.getCurrentTheme().getJS() & ',' : '')#",
                // main ContentBox scripts
                "#prc.cbroot#/includes/js/contentbox.js"
            ];
        </cfscript>
        #cb.minify( assets=arrayToList( cssFiles ), location="#prc.cbroot#/includes/cache" )#
        #cb.minify( assets=arrayToList( jsFiles ), location="#prc.cbroot#/includes/cache" )#
        <!--- CKEditor Separate --->
        <script src="#prc.cbroot#/includes/ckeditor/ckeditor.js"></script>
        <script src="#prc.cbroot#/includes/ckeditor/adapters/jquery.js"></script>
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
        <!-- Fonts -->
        <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,900,300italic,400italic,600italic,700italic,900italic' rel='stylesheet' type='text/css'>
        <link href='http://fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!--[if lt IE 9]>
        <script src="assets/js/html5shiv.js"></script>
        <script src="assets/js/respond.min.js"></script>
        <![endif]-->
        <!--- cbadmin Event --->
        #announceInterception("cbadmin_beforeHeadEnd")#
    </head>
    <body class="animated">
        <!--- cbadmin Event --->
        #announceInterception("cbadmin_afterBodyStart")#
        <section id="container">
            <header id="header">
                <!--logo start-->
                <div class="brand">
                    <a href="index.html" class="logo">#prc.cbSettings.cb_site_name#</a>
                </div>
                <!--logo end-->
                <div class="toggle-navigation toggle-left">
                    <button type="button" class="btn btn-default" id="toggle-left" data-toggle="tooltip" data-placement="right" title="Toggle Navigation">
                        <i class="fa fa-bars"></i>
                    </button>
                </div>
                <div class="user-nav">
                    <ul>
                        #prc.adminMenuService.generateUtilsMenu()#
                        #prc.adminMenuService.generateSupportMenu()#
                        <li class="profile-photo">
                            #getMyPlugin( plugin="Avatar",module="contentbox" ).renderAvatar( email=prc.oAuthor.getEmail(),size="40", class="img-circle" )#
                        </li>
                        #prc.adminMenuService.generateProfileMenu()#
                        <li class="notifications">
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
            <aside class="sidebar">
                <div id="leftside-navigation" class="nano">
                    <!--- Main Generated Menu --->
                    #prc.adminMenuService.generateMenu()#
                </div>
            </aside>
            <!--sidebar left end-->
            <!--main content start-->
            <section class="main-content-wrapper">
                <section id="main-content">
                    <!--- cbadmin event --->
                    #announceInterception("cbadmin_beforeContent")#
                    <!--- Main Content --->
                    #renderView()#
                    <!--- cbadmin event --->
                    #announceInterception("cbadmin_afterContent")#
                </section>
            </section>
            <!--main content end-->
            <!--- Footer --->
        #renderView( view="_tags/footer", module="contentbox-admin" )#
            <!--sidebar right start-->
            <aside class="sidebarRight">
                <div id="rightside-navigation ">
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
            </aside>
            <!--sidebar right end-->
        </section>  
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
                        <span id="confirmItLoader" class="hide"><i class="icon-spinner icon-spin icon-large icon-2x"></i></span>
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
                <i class="fa fa-spinner fa fa-spin icon-large icon-4x"></i>
            </div>
        </div>
    </body>
</html>
</cfoutput>