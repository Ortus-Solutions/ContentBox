<cfoutput>
<div class="modal-dialog modal-lg" role="document" >
	<div class="modal-content">
		<div class="modal-header">

			<div class="row">

				<div class="col-md-3">
					<div class="size18">
						<i class="far fa-eye fa-lg"></i>&nbsp;
						<span class="header-title">Responsive Previews</span>
					</div>
				</div>

				<div class="col-md-6 text-center">
					<!--- Responsive Previews --->
					<div class="btn-group" role="group" aria-label="Preview Resizer" style="min-width: 200px">
						<button href="javascript:void( 0 )"
								role="group"
								title="Desktop View"
								onclick="setPreviewSize( this ); return false;"
								class="btn btn-primary btn-sm"
						>
							<i class="fas fa-2x fa-desktop"></i>
						</button>
						<button href="javascript:void( 0 )"
								role="group"
								title="Tablet View"
								onclick="setPreviewSize( this, 768 ); return false;"
								class="btn btn-info btn-sm"
						>
							<i class="fas fa-2x fa-tablet-alt"></i>
						</button>
						<button href="javascript:void( 0 )"
								role="group"
								title="Horizontal Tablet View"
								onclick="setPreviewSize( this, 1024 ); return false;"
								class="btn btn-info btn-sm"
						>
							<i class="fas fa-2x fa-tablet-alt fa-rotate-90"></i>
						</button>
						<button href="javascript:void( 0 )"
								role="group"
								title="Phone View"
								onclick="setPreviewSize( this, 375 ); return false;"
								class="btn btn-info btn-sm"
						>
							<i class="fas fa-2x fa-mobile-alt"></i>
						</button>
						<button href="javascript:void( 0 )"
								role="group"
								title="Horizontal Phone View"
								onclick="setPreviewSize( this, 667 ); return false;"
								class="btn btn-info btn-sm"
						>
							<i class="fas fa-2x fa-mobile-alt fa-rotate-90"></i>
						</button>
					</div>
				</div>
				<div class="col-md-3">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				</div>
			</div>
		</div>

		<div class="modal-body">
			<!---hidden form for preview submit, has to be a form as content can be quite large
				so get operations do not work.
			 --->
			#html.startForm(
				name 	= "previewForm",
				action 	= prc.xehPreview,
				target 	= "previewFrame",
				class 	= "hidden",
				ssl  	=  event.isSSL()
			)#
				#html.hiddenField( name="h", value=prc.h )#
				#html.hiddenField( name="content", value=urlEncodedFormat( rc.content ) )#
				#html.hiddenField( name="contentType", value=rc.contentType )#
				#html.hiddenField( name="layout", value=rc.layout )#
				#html.hiddenField( name="title", value=rc.title )#
				#html.hiddenField( name="slug", value=rc.slug )#
				#html.hiddenField( name="markup", value=rc.markup )#
				#html.hiddenField( name="parentContent", value=rc.parentContent )#
				#html.hiddenField( name="siteID", value=prc.oCurrentSite.getsiteID() )#
			#html.endForm()#

			<!--- hidden iframe for preview --->
			<iframe
				id="previewFrame"
				name="previewFrame"
				width="100%"
				scrolling="auto"
				style="border: 1px solid ##eaeaea"
			></iframe>
		</div>
	</div>
</div>
</cfoutput>