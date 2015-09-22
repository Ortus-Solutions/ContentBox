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

		<!--- ContentBoxEvent --->
		#cb.event("cbui_beforeHeadEnd")#
	</head>
	<body>
		<!--- ContentBoxEvent --->
		#cb.event("cbui_afterBodyStart")#
		
		#cb.quickView(view='_header')#
		
		
			<!--- <cfif not getPlugin("messagebox").isEmpty()>
				<div class="row-fluid">
					<div class="span12">
						#cb.getPlugin("messagebox").renderit()#
					</div>
				</div>
			</cfif> --->

			<!--- breadcrumbs only if not home page. --->
			<!---<cfif cb.getCurrentPage().getSlug() NEQ cb.getHomePage()>
				<div class="row">
					<div class="col-sm-12">
						<div class="breadcrumb"><a href="#cb.linkHome()#">Home</a> #cb.breadCrumbs(separator="<span class='divider'>/</span>")#</div>
					</div>
				</div>
			</cfif>--->

				
			<!--- ContentBoxEvent --->
			#cb.event("cbui_beforeContent")#

			<!--- Content --->
			#renderView()#

			<!--- ContentBoxEvent --->
			#cb.event("cbui_afterContent")#
			

			#cb.quickView(view='_footer')#


	</body>

	<!-- Placed at the end of the document so the pages load faster -->
	<script type="text/javascript" src="#cb.themeRoot()#/bower_components/jquery/dist/jquery.min.js"></script>
	<script type="text/javascript" src="#cb.themeRoot()#/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
</html>
</cfoutput>