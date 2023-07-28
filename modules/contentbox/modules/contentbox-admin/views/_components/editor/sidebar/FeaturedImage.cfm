<cfoutput>
<cfif prc.oCurrentAuthor.hasPermission( "EDITORS_FEATURED_IMAGE" )>
	<div class="panel panel-default">
		<div class="panel-heading">
			<h4 class="panel-title">
				<a
					class="accordion-toggle collapsed block"
					data-toggle="collapse"
					data-parent="##accordion"
					href="##featuredImagePanel">
					<i class="fas fa-photo-video"></i> Featured Image
				</a>
			</h4>
		</div>
		<div
			id="featuredImagePanel"
			class="panel-collapse collapse">
			<div class="panel-body">
				<div class="form-group text-center">
					<!--- Select and Cancel Buttons --->
					<button
						class="btn btn-primary"
						onclick="loadAssetChooser( 'featuredImageCallback' )"
						type="button"
					>
						Select Image
					</button>
					<!--- Featured Image Selection --->
					<div
						class="<cfif !len( prc.oContent.getFeaturedImage() )>hide</cfif> form-group"
						id="featuredImageControls"
					>
						#html.hiddenField(
							name 		= "featuredImage",
							bind 		= prc.oContent
						)#

						<!--- Image Preview --->
						<div class="m10">
							<cfif len( prc.oContent.getFeaturedImage() )>
								<img id="featuredImagePreview" src="#prc.oContent.getFeaturedImageURL()#" class="img-thumbnail" height="75">
								<p class="text-muted" id="featuredImageURL"><small>#prc.oContent.getFeaturedImageURL()#</small></p>
							<cfelse>
								<img id="featuredImagePreview" class="img-thumbnail" height="75">
							</cfif>
						</div>

						<!--- Clear Image --->
						<a class="btn btn-danger" href="javascript:cancelFeaturedImage()">Clear Image</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	</cfif>
</cfoutput>
