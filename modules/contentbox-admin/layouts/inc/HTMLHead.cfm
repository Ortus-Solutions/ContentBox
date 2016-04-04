<cfoutput>
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
    <cfif structKeyExists( prc, 'cb_site_name' )>
        <title>#prc.cbSettings.cb_site_name# - ContentBox Administrator</title>        
    </cfif>
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
    <!---                           CSS                                           --->
    <!--- ********************************************************************* --->

    <link rel="stylesheet" href="#prc.cbroot#/includes/css/theme.css"/>
    <link rel="stylesheet" href="#prc.cbroot#/includes/css/contentbox.css"/>


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
    </cfscript>

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="#prc.cbroot#/includes/spacelab/js/html5shiv.min.js"></script>
    <script src="#prc.cbroot#/includes/spacelab/js/respond.min.js"></script>
    <![endif]-->

    <!--- cbadmin Events --->
    <cfif event.getCurrentLayout() EQ 'simple'>
        #announceInterception( "cbadmin_beforeLoginHeadEnd" )#
    <cfelse>
        #announceInterception( "cbadmin_beforeHeadEnd" )#
    </cfif>

    <!---  Blocking JS - Libraries required for in-page JS --->
    <script type="application/javascript" src="#prc.cbroot#/includes/js/preLib.js"></script>
    <script type="application/javascript" src="#prc.cbroot#/includes/js/contentbox/admin.js"></script>

</head>
</cfoutput>