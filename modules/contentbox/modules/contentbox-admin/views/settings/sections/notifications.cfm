<cfoutput>
<fieldset>
    <legend><i class="fa fa-envelope fa-lg"></i> Notifications</legend>
    <!--- Site Email --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_site_email",
            content="Administrator Email:"
        )#
        <div class="controls">
            <small>The email(s) that receives all notifications from ContentBox.  To specify multiple addresses, separate the addresses with commas.</small><br/>
            #html.inputField(
                name="cb_site_email",
                value=prc.cbSettings.cb_site_email,
                class="form-control",
                required="required",
                title="The email that receives all notifications"
            )#
        </div>
    </div>
    <!--- Outgoing Email --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_site_outgoingEmail",
            content="Outgoing Email:"
        )#
        <div class="controls">
            <small>The email address that sends all emails out of ContentBox.</small><br/>
            #html.inputField(
                name="cb_site_outgoingEmail",
                required="required",
                value=prc.cbSettings.cb_site_outgoingEmail,
                class="form-control",
                title="The email that sends all email notifications out",
                type="email"
            )#
        </div>
    </div>
    <!--- Notification on User Create --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_notify_author",
            content="<i class='fa fa-user'></i> Send a notification when a user has been created or removed:"
        )#
        <div class="controls">
            #html.radioButton( 
                name="cb_notify_author",
                checked=prc.cbSettings.cb_notify_author,
                value=true
            )# Yes
            #html.radioButton( 
                name="cb_notify_author",
                checked=not prc.cbSettings.cb_notify_author,
                value=false
            )# No
        </div>
    </div>    
    <!--- Notification on Entry Create --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_notify_entry",
            content="<i class='fa fa-quote-left'></i> Send a notification when a blog entry has been created or removed:"
        )#
        <div class="controls">
            #html.radioButton( 
                name="cb_notify_entry",
                checked=prc.cbSettings.cb_notify_entry,
                value=true
            )# Yes
            #html.radioButton( 
                name="cb_notify_entry",
                checked=not prc.cbSettings.cb_notify_entry,
                value=false
            )# No
        </div>
    </div>
    <!--- Notification on Page Create --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_notify_page",
            content="<i class='fa fa-file'></i> Send a notification when a page has been created or removed:"
        )#
        <div class="controls">
            #html.radioButton( 
                name="cb_notify_page",
                checked=prc.cbSettings.cb_notify_page,
                value=true
            )# Yes
            #html.radioButton( 
                name="cb_notify_page",
                checked=not prc.cbSettings.cb_notify_page,
                value=false
            )# No
        </div>
    </div>
    <!--- Notification on ContentStore Create --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_notify_contentstore",
            content="<i class='fa fa-hdd-o'></i> Send a notification when a content store object has been created or removed:"
        )#
        <div class="controls">
            #html.radioButton( 
                name="cb_notify_contentstore",
                checked=prc.cbSettings.cb_notify_contentstore,
                value=true 
            )# Yes
            #html.radioButton( 
                name="cb_notify_contentstore",
                checked=not prc.cbSettings.cb_notify_contentstore,
                value=false 
            )# No
        </div>
    </div>
</fieldset>
</cfoutput>