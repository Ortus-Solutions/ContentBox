<cfoutput>
#html.startForm( name="notificationsSettingsForm", action=prc.xehSaveSettings )#
<fieldset>
    <legend><i class="far fa-bell fa-lg"></i> Notifications</legend>
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
        	#html.checkbox(
				name    = "cb_notify_author_toggle",
				data	= { toggle: 'toggle', match: 'cb_notify_author' },
				checked	= prc.cbSettings.cb_notify_author
			)#
			#html.hiddenField(
				name	= "cb_notify_author",
				value	= prc.cbSettings.cb_notify_author
			)#
        </div>
    </div>
    <!--- Notification on Entry Create --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_notify_entry",
            content="<i class='fas fa-blog'></i> Send a notification when a blog entry has been created or removed:"
        )#
        <div class="controls">
        	#html.checkbox(
				name    = "cb_notify_entry_toggle",
				data	= { toggle: 'toggle', match: 'cb_notify_entry' },
				checked	= prc.cbSettings.cb_notify_entry
			)#
			#html.hiddenField(
				name	= "cb_notify_entry",
				value	= prc.cbSettings.cb_notify_entry
			)#
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
        	#html.checkbox(
				name    = "cb_notify_page_toggle",
				data	= { toggle: 'toggle', match: 'cb_notify_page' },
				checked	= prc.cbSettings.cb_notify_page
			)#
			#html.hiddenField(
				name	= "cb_notify_page",
				value	= prc.cbSettings.cb_notify_page
			)#
        </div>
    </div>
    <!--- Notification on ContentStore Create --->
    <div class="form-group">
        #html.label(
            class="control-label",
            field="cb_notify_contentstore",
            content="<i class='far fa-hdd'></i> Send a notification when a content store object has been created or removed:"
        )#
        <div class="controls">
        	#html.checkbox(
				name    = "cb_notify_contentstore_toggle",
				data	= { toggle: 'toggle', match: 'cb_notify_contentstore' },
				checked	= prc.cbSettings.cb_notify_contentstore
			)#
			#html.hiddenField(
				name	= "cb_notify_contentstore",
				value	= prc.cbSettings.cb_notify_contentstore
			)#
        </div>
    </div>
</fieldset>
<!--- Button Bar --->
<div class="form-actions mt20">
	#html.submitButton( value="Save Settings", class="btn btn-danger" )#
</div>

#html.endForm()#
</cfoutput>