<cfoutput>
<div class="modal-dialog modal-lg" role="document" >
	<div class="modal-content">
		<div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3><i class="fa fa-file-o"></i> Link To A ContentBox Page</h3>
		</div>
		<div class="modal-body">
		    #html.startForm(name="pageEditorSelectorForm" )#
				<!--- Loader --->
				<div class="loaders floatRight" id="pageLoader">
					<i class="fa fa-spinner fa-spin fa-lg"></i>
				</div>

				<!--- Content Bar --->
			    <div class="form-group well">
			        #html.label(field="pageSearch",content="Quick Search:",class="control-label" )#
			        #html.textField(name="pageSearch",size="30",class="form-control",value=rc.search)#
			    </div>

				<!--- Render tables out --->
				<div id="pagesContainer">
					#renderView(view="pages/editorSelectorPages", module="contentbox-admin" )#
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