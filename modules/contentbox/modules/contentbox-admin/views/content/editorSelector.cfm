<cfoutput>
	<div class="modal-dialog modal-lg" role="document" >

		<div class="modal-content">

			<div class="modal-header">
				<!--- Close --->
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
					&times;
				</button>
				<h3>
					<!--- Title --->
					<i class="fas fa-link"></i> Insert #prc.contentType#
					<!--- Loader --->
					<span class="loaders" id="contentLoader">
						<i class="fa fa-circle-notch fa-spin"></i>
					</span>
				</h3>
			</div>

			<div class="modal-body">
				#html.startForm( name="contentSelectorForm" )#

					<!--- Filter --->
					<div class="form-group">
						<div class="input-group input-group-sm">
							<input
								type="text"
								class="form-control rounded"
								placeholder="Quick Filter"
								aria-describedby="sizing-addon3"
								name="contentSearch"
								id="contentSearch"
								value ="#rc.search#"
							>
							<span
								class="input-group-addon cursor-pointer"
								id="sizing-addon3"
								title="Clear Search"
								onclick="clearSearch()"
							>
								<i class="far fa-times-circle fa-lg"></i>
							</span>
						</div>
					</div>

					<!--- Render tables out --->
					<div id="contentContainer">
						#renderView(
							view 			= "content/editorSelectorEntries",
							prePostExempt 	= true
						)#
					</div>

				#html.endForm()#
			</div>

			<!--- Button Bar --->
			<div class="modal-footer">
				<button class="btn btn-default" onclick="closeRemoteModal()"> Close </button>
			</div>
		</div>
	</div>
	</cfoutput>