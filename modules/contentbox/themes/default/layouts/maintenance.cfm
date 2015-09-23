<cfparam name="args.sidebar" default="true">
<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
	<!--- Page Includes --->
	#cb.quickView( "_pageIncludes" )#

	<!--- ContentBoxEvent --->
	#cb.event( "cbui_beforeHeadEnd" )#
</head>
<body>
	<!--- ContentBoxEvent --->
	#cb.event( "cbui_afterBodyStart" )#

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
	#cb.event( "cbui_beforeContent" )#

	<!--- Main View --->
	#cb.mainView( args=args )#

	<!--- ContentBoxEvent --->
	#cb.event( "cbui_afterContent" )#
	
	<!--- ContentBoxEvent --->
	#cb.event( "cbui_beforeBodyEnd" )#	
</body>
<!-- Placed at the end of the document so the pages load faster -->
<script type="text/javascript" src="#cb.themeRoot()#/bower_components/jquery/dist/jquery.min.js"></script>
<script type="text/javascript" src="#cb.themeRoot()#/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
</html>
</cfoutput>