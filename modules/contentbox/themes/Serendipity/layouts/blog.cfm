<cfoutput>
	<!--- Global Layout Arguments --->
	<cfparam name="args.print" 		default="false" />
	<cfparam name="args.sidebar" 	default="true" />

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

			#cb.quickView( "_header" )#

			<!--- ContentBoxEvent --->
			#cb.event( "cbui_beforeContent" )#

			<!--- Main View --->
			#cb.mainView( args=args )#

			<button onclick="topFunction()" title="Back to top" class="btn btn-primary hidden" id="goToTop"> <span class="visually-hidden">Back to top</span>&uarr;</button>
			
			<!--- ContentBoxEvent --->
			#cb.event( "cbui_afterContent" )#

			<!--- ContentBoxEvent --->
			#cb.event( "cbui_beforeBodyEnd" )#

			<script type="application/javascript">
				// When the user scrolls down 20px from the top of the document, show the button
				var mybutton = document.getElementById("goToTop");
				window.onscroll = function() {scrollFunction()};

				function scrollFunction() {
				if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
					mybutton.classList.remove("hidden");
					mybutton.classList.add("show")
					} else {
						mybutton.classList.remove("show");
						mybutton.classList.add("hidden");	
					}
				}

				// When the user clicks on the button, scroll to the top of the document
				function topFunction() {
					document.body.scrollTop = 0;
					document.documentElement.scrollTop = 0;
				}
				
			</script>
		</body>
	</html>
</cfoutput>