<cfoutput>
<div class="modal-dialog modal-lg" role="document" >
	<div class="modal-content">

		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		    <h3>
		    	<i class="far fa-eye fa-lg"></i>
		    	Version: <span class="label label-info">#prc.contentVersion.getVersion()#</span>
		    	Active:
		    	<span class="label # prc.contentVersion.getIsActive() ? 'label-success' : 'label-danger'#">
		    		#yesNoFormat( prc.contentVersion.getIsActive() )#
		    	</span>
		    </h3>
		</div>

		<div class="modal-body">

			<div>

				<!--- Nav Tabs --->
				<ul class="nav nav-tabs" role="tablist">
					<li role="presentation" class="active">
						<a href="##preview" aria-controls="preview" role="tab" data-toggle="tab">Preview</a>
					</li>
					<li role="presentation">
						<a href="##code" aria-controls="code" role="tab" data-toggle="tab">Code</a>
					</li>
				</ul>

				<!--- Tab Panes --->
				<div class="tab-content m10">
					<div role="tabpanel" class="tab-pane active" id="preview">
						#prc.contentVersion.renderContent()#
					</div>
					<div role="tabpanel" class="tab-pane" id="code">
						<textarea class="form-control" rows="20">#prc.contentVersion.getContent()#</textarea>
					</div>
				</div>

			</div>
		</div>

		<!--- Button Bar --->
		<div class="modal-footer">
			<button class="btn btn-default" onclick="closeRemoteModal()"> Close </button>
		</div>

	</div>
</div>
</cfoutput>