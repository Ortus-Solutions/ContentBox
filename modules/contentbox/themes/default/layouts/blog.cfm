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
		<meta name="generator" 	 content="ContentBox powered by ColdBox" />
		<meta name="robots" 	 content="index,follow" />
		<meta name="description" content="">
		<meta name="author" content="">
		<!--- Meta per page or index --->
		<cfif cb.isEntryView() AND len(cb.getCurrentEntry().getHTMLDescription())>
			<meta name="description" content="#cb.getCurrentEntry().getHTMLDescription()#" />
		<cfelse>
			<meta name="description" content="#HTMLEditFormat( cb.siteDescription() )#" />
		</cfif>
		<cfif cb.isEntryView() AND len(cb.getCurrentEntry().getHTMLKeywords())>
			<meta name="keywords" 	 content="#cb.getCurrentEntry().getHTMLKeywords()#" />
		<cfelse>
			<meta name="keywords" 	 content="#cb.siteKeywords()#" />
		</cfif>

		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />

		<!--- Base HREF For SES URLs based on ColdBox--->
		<base href="#getSetting('htmlBaseURL')#" />

		<link rel="stylesheet" href="#cb.themeRoot()#/includes/css/bootstrap/swatches/#lcase(cb.themeSetting('cbBootswatchTheme','default'))#/skin.css?v=1" />
		<!--- Bootstrap --->
		<link rel="stylesheet" href="#cb.themeRoot()#/includes/css/bootstrap/swatches/#lcase(cb.themeSetting('cbBootswatchTheme','default'))#/bootstrap.min.css?v=1" />
		
		<!--- Font Awesome --->
		<link rel="stylesheet" href="#cb.themeRoot()#/includes/css/font-awesome/font-awesome.min.css?v=1" />
		<link rel="stylesheet" href="#cb.themeRoot()#/includes/css/font-awesome/font-awesome-ie7.min.css?v=1" />

		<!--- Minify & Cache Our Assets --->
		<cfif 1 is 0 and cb.themeSetting('minifyCacheAssets',true)>
			<!--- Use LESS --->
			<cfif cb.themeSetting('useLESS',true)>
				#cb.minify(assets="#cb.themeRoot()#/includes/css/less/blog.less,#cb.themeRoot()#/includes/css/less/messagebox.less,#cb.themeRoot()#/includes/css/less/paging.less,#cb.themeRoot()#/includes/css/less/breadcrumbs.less", location="#cb.themeRoot()#/includes/css")#
			<cfelse>
				#cb.minify(assets="#cb.themeRoot()#/includes/css/main.css", location="#cb.themeRoot()#/includes/css")#
			</cfif>
		<cfelse>
			<!--- Include our unminified, unLESSified, non cached version of the stylesheet --->
			<link rel="stylesheet" href="#cb.themeRoot()#/includes/css/main.css?v=1" />
		</cfif>

		<!--- RSS Stuff --->
		<link rel="alternate" type="application/rss+xml" title="Recent Updates" href="#cb.linkRSS()#" />
		<cfif cb.isEntryView()>
			<link rel="alternate" type="application/rss+xml" title="Entry's Recent Comments" href="#cb.linkRSS(comments=true,entry=cb.getCurrentEntry())#" />
		</cfif>

		<!--- ContentBoxEvent --->
		#cb.event("cbui_beforeHeadEnd")#
	</head>
	<body>
		<!--- ContentBoxEvent --->
		#cb.event("cbui_afterBodyStart")#
		
		#cb.quickView(view='_header')#
		<section id="body-main">
			<div class="container">
				<div class="row">
					<div class="col-sm-12">
						<!--- ContentBoxEvent --->
						#cb.event("cbui_beforeContent")#
	
						<!--- Content --->
						#renderview()#
	
						<!--- ContentBoxEvent --->
						#cb.event("cbui_afterContent")#
					</div>
				</div>
	
				
				</div>
		</section>
		#cb.quickView(view='_footer')#
	</body>

	<!-- Placed at the end of the document so the pages load faster -->
	<script type="text/javascript" src="#cb.themeRoot()#/bower_components/jquery/dist/jquery.min.js"></script>
	<script type="text/javascript" src="#cb.themeRoot()#/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
</html>
</cfoutput>