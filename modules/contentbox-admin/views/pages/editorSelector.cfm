<cfoutput>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	<h3>Link To A ContentBox Page</h3>
</div>
<div class="modal-body">
    #html.startForm(name="pageEditorSelectorForm")#

	<!--- Loader --->
	<div class="loaders floatRight" id="pageLoader">
		<i class="icon-spinner icon-spin icon-large"></i>
	</div>

	<!--- Content Bar --->
	<div class="well well-small" id="contentBar">

		<!--- Filter Bar --->
		<div class="filterBar">
			<div>
				#html.label(field="pageSearch",content="Quick Search:",class="inline")#
				#html.textField(name="pageSearch",size="30",class="textfield",value=rc.search)#
			</div>
		</div>
	</div>

	<!--- Render tables out --->
	<div id="pagesContainer">
	#renderView(view="pages/editorSelectorPages", module="contentbox-admin")#
	</div>

    #html.endForm()#
</div>
<!--- Button Bar --->
<div class="modal-footer">
	<button class="btn" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>