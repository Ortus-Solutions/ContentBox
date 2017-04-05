<cfoutput>
<div class="modal-dialog modal-lg" role="document" >
	<div class="modal-content">
		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3><i class="fa fa-quote-left"></i> Link To A ContentBox Entry</h3>
		</div>
		<div class="modal-body">
			#html.startForm(name="entryEditorSelectorForm" )#

				<!--- Loader --->
				<div class="loaders floatRight" id="entryLoader">
					<i class="fa fa-spinner fa-spin fa-lg"></i>
				</div>

				<!--- Content Bar --->
			    <div class="form-group well">
			        #html.label(field="entrySearch",content="Quick Search:",class="control-label" )#
			        #html.textField(name="entrySearch",size="30",class="form-control",value=rc.search)#
			    </div>

				<!--- Render tables out --->
				<div id="entriesContainer">
				#renderView(view="entries/editorSelectorEntries", module="contentbox-admin" )#
				</div>


			#html.endForm()#
		</div>
		<!--- Button Bar --->
		<div class="modal-footer">
			<button class="btn" onclick="closeRemoteModal()"> Close </button>
		</div>
	</div>
</div>
</cfoutput>