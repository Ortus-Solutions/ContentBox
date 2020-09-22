<cfoutput>
<div class="modal-dialog modal-lg" role="document" >
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4><span id="widget-title-bar"><i class="fa fa-magic"></i> Select a Widget</span></h4>
        </div>
        <div class="modal-body">
            <div class="widget-detail" id="widget-detail" style="display:none;"></div>
            #renderView(
                view    		= "widgets/widgetList",
				args    		= { mode = "insert", cols = 3 },
				prePostExempt 	= true
            )#
        </div>
        <div class="modal-footer">
            <div class="widget-footer-left">
                <a id="widget-button-back" style="display:none;" href="javascript:void(0);" class="btn btn-primary"><i class="fas fa-chevron-left"></i> Back to Widgets</a>&nbsp;
            </div>
            <div class="widget-footer-right">
                <a id="widget-button-cancel" href="javascript:void(0);" class="btn btn-danger" onclick="closeRemoteModal()">Cancel</a>
        		<button class="btn btn-primary" style="display:none;" id="widget-button-insert">Insert Widget</button>
            </div>
        </div>
    </div>
</div>
</cfoutput>