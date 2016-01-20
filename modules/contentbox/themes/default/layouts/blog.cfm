<cfoutput>
<!--- Global Layout Arguments --->
<cfparam name="args.print" 		default="false">
<cfparam name="args.sidebar" 	default="true">
<!DOCTYPE html>
<html lang="en">
<head>
	<!--- Page Includes --->
	#cb.quickView( "_blogIncludes" )#

	<!--- ContentBoxEvent --->
	#cb.event( "cbui_beforeHeadEnd" )#
</head>
<body>
	<!--- ContentBoxEvent --->
	#cb.event( "cbui_afterBodyStart" )#
	
	<!--- Header --->
	#cb.quickView( view='_header' )#

	<!--- Main Body --->
	<section id="body-main">
		<div class="container">
			<div class="row">
				<div class="col-sm-12">
					<!--- ContentBoxEvent --->
					#cb.event( "cbui_beforeContent" )#

					<!--- Main View --->
					#cb.mainView( args=args )#

					<!--- ContentBoxEvent --->
					#cb.event( "cbui_afterContent" )#
				</div>
			</div>
		</div>
	</section>
	#cb.quickView( view='_footer' )#
	
	<!--- ContentBoxEvent --->
	#cb.event( "cbui_beforeBodyEnd" )#
</body>
</html>
</cfoutput>