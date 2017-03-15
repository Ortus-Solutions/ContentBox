<cfoutput>
<div class="modal-dialog modal-lg" role="document" >
	<div class="modal-content">
		<div class="modal-header">

			<div class="row">
				<div class="col-md-3">
					<h3 style="margin: 9px 0;"><i class="fa fa-eye fa-lg"></i>&nbsp; <span class="header-title">Responsive Previews</span></h3>
				</div>
				<div class="col-md-6 text-center">
					<div class="btn-group" role="group" aria-label="Preview Resizer" style="min-width: 200px">
						<button href="javascript:void( 0 )" 
								role="group" 
								title="Desktop View"
								onclick="setPreviewSize( this ); return false;" 
								class="btn btn-primary btn-sm"
						>
							<i class="fa fa-2x fa-desktop"></i>
						</button>
						<button href="javascript:void( 0 )" 
								role="group" 
								title="Tablet View"
								onclick="setPreviewSize( this, 768 ); return false;" 
								class="btn btn-info btn-sm"
						>
							<i class="fa fa-2x fa-tablet"></i>
						</button>
						<button href="javascript:void( 0 )" 
								role="group" 
								title="Horizontal Tablet View"
								onclick="setPreviewSize( this, 1024 ); return false;" 
								class="btn btn-info btn-sm"
						>
							<i class="fa fa-2x fa-tablet fa-rotate-90"></i>
						</button>
						<button href="javascript:void( 0 )" 
								role="group" 
								title="Phone View"
								onclick="setPreviewSize( this, 320 ); return false;" 
								class="btn btn-info btn-sm"
						>
							<i class="fa fa-2x fa-mobile"></i>
						</button>
						<button href="javascript:void( 0 )" 
								role="group" 
								title="Horizontal Phone View"
								onclick="setPreviewSize( this, 568 ); return false;" 
								class="btn btn-info btn-sm"
						>
							<i class="fa fa-2x fa-mobile fa-rotate-90"></i>
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
				#html.hiddenField( name="parentPage", value=rc.parentPage )#
			#html.endForm()#
			
			<!--- hidden iframe for preview --->
			<iframe id="previewFrame" name="previewFrame" width="100%" scrolling="auto" style="border: 1px solid ##eaeaea"></iframe>
		</div>
	</div>
</div>
</cfoutput>