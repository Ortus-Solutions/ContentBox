<cfoutput>
    <fieldset>
        <legend><i class="far fa-comments fa-lg"></i>  Comment Settings</legend>

		<!--- Whois URL --->
		<div class="form-group">
			#html.label(
				field   = "cb_comments_whoisURL",
				content = "Whois Url:",
				class   = "control-label"
			)#

			<div class="controls">
				<p>
					Whois allows you to verify IP Addresses.
				</p>
				#html.textField(
					name="cb_comments_whoisURL",
					value=prc.cbSettings.cb_comments_whoisURL,
					class="form-control",
					size="60",
					wrapper="div class=controls"
				)#
			</div>
		</div>

		<!--- Enable Moderation --->
		<div class="form-group">
			#html.label(
				field   = "cb_comments_moderation",
				content = "Comment Moderation:",
				class   = "control-label"
			)#
			<div class="controls">
				<p>
					All comments will be moderated according to our moderation rules.
				</p>
				#html.checkbox(
					name    = "cb_comments_moderation_toggle",
					data	= { toggle: 'toggle', match: 'cb_comments_moderation' },
					checked	= prc.cbSettings.cb_comments_moderation
				)#
				#html.hiddenField(
					name	= "cb_comments_moderation",
					value	= prc.cbSettings.cb_comments_moderation
				)#
			</div>
		</div>

		<!--- Comment Previous History --->
		<div class="form-group">
			#html.label(
				field 	= "cb_comments_moderation_whitelist",
				content = "Comment author must have a previously approved comment:",
				class   = "control-label"
			)#
			<div class="controls">
				<p>
					If an approved comment is found for the submitting email address, the comment is automatically approved and not moderated.
				</p>
				#html.checkbox(
					name    = "cb_comments_moderation_whitelist_toggle",
					data	= { toggle: 'toggle', match: 'cb_comments_moderation_whitelist' },
					checked	= prc.cbSettings.cb_comments_moderation_whitelist
				)#
				#html.hiddenField(
					name	= "cb_comments_moderation_whitelist",
					value	= prc.cbSettings.cb_comments_moderation_whitelist
				)#
			</div>
		</div>

		<!--- Moderated Keywords --->
		<div class="form-group">
			#html.label(
				field   = "cb_comments_moderation_blacklist",
				content = "Moderated keywords (Affects content, Author IP, or Author Email):",
				class   = "control-label"
			)#
			<div class="controls">
				<p>
					If a comment's content, author ip or email address matches any of these keywords, the comment is automatically moderated. Regular expressions are ok.
				</p>

				#html.textarea(
					name  = "cb_comments_moderation_blacklist",
					value = prc.cbSettings.cb_comments_moderation_blacklist,
					rows  = "8",
					class = "form-control",
					title = "One per line please"
				)#
			</div>
		</div>

		<!--- Blocked Keywords --->
		<div class="form-group">
			#html.label(
				field 	= "cb_comments_moderation_blockedlist",
				content = "Blocked keywords (Affects content, Author IP, or Author Email):"
			)#
			<div class="controls">
				<p>
					If a comment's content, author ip or email address matches any of these keywords, the comment is automatically rejected with no notifications. Regular expressions are ok.
				</p>
				#html.textarea(
					name  = "cb_comments_moderation_blockedlist",
					value = prc.cbSettings.cb_comments_moderation_blockedlist,
					rows  = "8",
					class = "form-control",
					title = "One per line please"
				)#
			</div>
		</div>

		<!--- Auto-Delete Moderated Comments --->
		<div class="form-group">
			#html.label(
				field 	= "cb_comments_moderation_expiration",
				content = "Number of days before auto-deleting moderated comments:"
			)#
			<div class="controls">
				<p>If a comment has been moderated, it will be auto-deleted after the specified number of days (set to 0 to disable auto-deletion).</p><br/>
				#html.inputField(
					name  = "cb_comments_moderation_expiration",
					value = prc.cbSettings.cb_comments_moderation_expiration,
					class = "form-control",
					type  = "number"
				)#
			</div>
		</div>

    </fieldset>
</cfoutput>
