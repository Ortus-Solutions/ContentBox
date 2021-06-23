<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h1 class="h1"><i class="fab fa-html5 fa-lg"></i> Global HTML</h1>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        <!--- messageBox --->
        #cbMessageBox().renderit()#
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        <div class="panel panel-default">
            <div class="panel-body">

				<p class="mb10">
                    The Global HTML allows you to render HTML/CSS/JavaScript in many different locations within the life-cycle of the rendered content in the UI.
				</p>

                <!-- Vertical Nav -->
                <div class="tab-wrapper tab-primary">
                    <!-- Tabs -->
                    <ul class="nav nav-tabs">
                        <li class="active">
                            <a href="##global" data-toggle="tab"><i class="fa fa-globe fa-lg"></i> <span class="hidden-xs">Global Layout</span></a>
                        </li>
                        <li>
                            <a href="##entry" data-toggle="tab"><i class="fas fa-blog fa-lg"></i> <span class="hidden-xs">Blog Entries</span></a>
                        </li>
                        <li>
                            <a href="##comments" data-toggle="tab"><i class="far fa-comments fa-lg"></i> <span class="hidden-xs">Comments</span></a>
                        </li>
                        <li>
                            <a href="##pages" data-toggle="tab"><i class="fas fa-file-alt fa-lg"></i> <span class="hidden-xs">Pages</span></a>
                        </li>
					</ul>

                    #html.startForm(
                        name   : "globalHTMLForm",
                        action : prc.xehSaveHTML,
                        class  : "form-vertical"
                    )#
                        <!-- End Tabs -->
                        <!-- Tab Content -->
                        <div class="tab-content" id="tab-content">
                            <!--- Global HTML Page --->
                            <div class="tab-pane active" id="global">
                                <fieldset>
                                    #html.textarea(
                                        name="cb_html_beforeHeadEnd",
                                        label="Before Head End: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_beforeHeadEnd,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                    #html.textarea(
                                        name="cb_html_afterBodyStart",
                                        label="After Body Start: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_afterBodyStart,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                    #html.textarea(
                                        name="cb_html_beforeBodyEnd",
                                        label="Before Body End: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_beforeBodyEnd,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                    #html.textarea(
                                        name="cb_html_beforeContent",
                                        label="Before Any Content: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_beforeContent,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                    #html.textarea(
                                        name="cb_html_afterContent",
                                        label="After Any Content: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_afterContent,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                    #html.textarea(
                                        name="cb_html_beforeSideBar",
                                        label="Before SideBar: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_beforeSideBar,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                    #html.textarea(
                                        name="cb_html_afterSideBar",
                                        label="After SideBar: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_afterSideBar,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                    #html.textarea(
                                        name="cb_html_afterFooter",
                                        label="After Footer: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_afterFooter,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                </fieldset>
							</div>

                            <!--- Entry --->
                            <div class="tab-pane" id="entry">
                                <fieldset>
                                    #html.textarea(
                                        name="cb_html_preEntryDisplay",
                                        label="Before A Blog Entry: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_preEntryDisplay,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                    #html.textarea(
                                        name="cb_html_postEntryDisplay",
                                        label="After A Blog Entry: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_postEntryDisplay,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                    #html.textarea(
                                        name="cb_html_preIndexDisplay",
                                        label="Before Blog Index: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_preIndexDisplay,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                    #html.textarea(
                                        name="cb_html_postIndexDisplay",
                                        label="After Blog Index: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_postIndexDisplay,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                    #html.textarea(
                                        name="cb_html_preArchivesDisplay",
                                        label="Before Blog Archives: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_preArchivesDisplay,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                    #html.textarea(
                                        name="cb_html_postArchivesDisplay",
                                        label="After Blog Archives: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_postArchivesDisplay,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                </fieldset>
							</div>

                            <!--- Comments --->
                            <div class="tab-pane" id="comments">
                                <fieldset>
                                    #html.textarea(
                                        name="cb_html_preCommentForm",
                                        label="Before The Comment Form: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_preCommentForm,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                    #html.textarea(
                                        name="cb_html_postCommentForm",
                                        label="After The Comment Form: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_postCommentForm,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                </fieldset>
							</div>

                            <!--- Pages --->
                            <div class="tab-pane" id="pages">
                                <fieldset>
                                    #html.textarea(
                                        name="cb_html_prePageDisplay",
                                        label="Before Any Page: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_prePageDisplay,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                    #html.textarea(
                                        name="cb_html_postPageDisplay",
                                        label="After Any Page: ",
                                        rows="6",
                                        class="form-control",
                                        value=prc.cbSiteSettings.cb_html_postPageDisplay,
                                        wrapper="div class=controls",
                                        labelClass="control-label",
                                        groupWrapper="div class=form-group"
                                    )#
                                </fieldset>
                            </div>
                        </div>
                        <!-- End Tab Content -->
                    </div>
					<!-- End Vertical Nav -->

                    <!---Button Bar --->
                    <div class="form-actions">
                        #html.submitButton(
                            value = "Save Global HTML",
                            class = "btn btn-primary"
                        )#
					</div>

                #html.endForm()#
            </div>
        </div>
    </div>
</div>
</cfoutput>