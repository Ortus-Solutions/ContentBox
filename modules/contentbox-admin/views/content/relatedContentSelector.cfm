<cfoutput>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3>Select Related Content</h3>
</div>
<div class="modal-body">
#html.startForm(name="relatedContentSelectorForm")#

    <!--- Loader --->
    <div class="loaders floatRight" id="relatedContentSelectorLoader">
        <i class="icon-spinner icon-spin icon-large"></i>
    </div>

    <!--- Content Bar --->
    <div class="well well-small" id="contentBar">

        <!--- Filter Bar --->
        <div class="filterBar">
            <div>
                #html.label(field="contentSearch",content="Quick Search:",class="inline")#
                #html.textField(name="contentSearch",size="30",class="textfield",value=rc.search)#
            </div>
        </div>
    </div>

    <!--- Render tables out --->
    <div id="contentContainer">
    #renderView(view="content/relatedContentResults", module="contentbox-admin")#
    </div>


#html.endForm()#
</div>
<!--- Button Bar --->
<div class="modal-footer">
    <button class="btn" onclick="closeRemoteModal()"> Close </button>
</div>
</cfoutput>