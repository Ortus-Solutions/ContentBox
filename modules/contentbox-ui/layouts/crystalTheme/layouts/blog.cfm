<cfoutput>
<!DOCTYPE html>
<html lang="en">
  <head>
  	<title>
    <cfif cb.isEntryView()>
		#cb.getCurrentEntry().getTitle()#
	<cfelse>
		#cb.siteName()# - #cb.siteTagLine()#
	</cfif>
	</title>
	<meta charset="utf-8">
	<meta name="generator" 	 content="ContentBox powered by ColdBox" />
	<meta name="robots" 	 content="index,follow" />
    <meta name="description" content="">
    <meta name="author" content="">
	<!--- Meta per page or index --->
	<cfif cb.isEntryView() AND len(cb.getCurrentEntry().getHTMLDescription())>
	<meta name="description" content="#cb.getCurrentEntry().getHTMLDescription()#" />
	<cfelse>
	<meta name="description" content="#cb.siteDescription()#" />
	</cfif>
	<cfif cb.isEntryView() AND len(cb.getCurrentEntry().getHTMLKeywords())>
	<meta name="keywords" 	 content="#cb.getCurrentEntry().getHTMLKeywords()#" />
	<cfelse>
	<meta name="keywords" 	 content="#cb.siteKeywords()#" />
	</cfif>

	<!--- Base HREF For SES URLs based on ColdBox--->
	<base href="#getSetting('htmlBaseURL')#/" />
<!---    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->--->

	<!--- styles --->
<!---    <style type="text/css">
      body {
        padding-top: 60px;
        padding-bottom: 40px;
      }
      .sidebar-nav {
        padding: 9px 0;
      }
    </style>--->

	<link href="#cb.layoutRoot()#/includes/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
	<!---<link href="#cb.layoutRoot()#/includes/css/bootstrap-responsive.min.css" rel="stylesheet" type="text/css" />--->
	<link href="#cb.layoutRoot()#/includes/css/new-style.css" rel="stylesheet" type="text/css" />

	<!--- RSS Stuff --->
<!---	<link rel="alternate" type="application/rss+xml" title="Recent Updates" href="#cb.linkRSS()#" />
	<cfif cb.isEntryView()>
		<link rel="alternate" type="application/rss+xml" title="Entry's Recent Comments" href="#cb.linkRSS(comments=true,entry=cb.getCurrentEntry())#" />
	</cfif>
	<!--- Le fav and touch icons --->
    <link rel="shortcut icon" href="#cb.layoutRoot()#/includes/img/favicon.ico">
    <link rel="apple-touch-icon" href="#cb.layoutRoot()#/includes/img/apple-touch-icon.png">
    <link rel="apple-touch-icon" sizes="72x72" href="#cb.layoutRoot()#/includes/img/apple-touch-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="114x114" href="#cb.layoutRoot()#/includes/img/apple-touch-icon-114x114.png">

	<!--- javascript --->
	<script type="text/javascript" src="#cb.layoutRoot()#/includes/js/jquery.js"></script>
	<script type="text/javascript" src="#cb.layoutRoot()#/includes/js/bootstrap.min.js"></script>--->

	<!--- ContentBoxEvent --->
	#cb.event("cbui_beforeHeadEnd")#

  <body class="page page-id-75 page-parent page-template-default header-image content-sidebar">
	<!--- ContentBoxEvent --->
	#cb.event("cbui_afterBodyStart")#

    <div class="container">
      <div class="row">

	    #cb.quickView(view='header')#

	  	<!--- ContentBoxEvent --->
		#cb.event("cbui_beforeContent")#

		<div id="inner">
			<!--- Content --->
			#renderView()#
		</div>

		<!--- ContentBoxEvent --->
		#cb.event("cbui_afterContent")#


      </div>


      <!---<footer>
      	<!--- ContentBoxEvent --->
        <p>#cb.event("cbui_footer")#</p>
      </footer>--->

	  <!---#cb.quickView(view='footer')#--->

    </div>

  </body>
</html>
</cfoutput>