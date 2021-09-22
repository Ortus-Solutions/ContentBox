<cfoutput>
<cfif prc.oCurrentAuthor.checkPermission( "EDITORS_CACHING" )>
	<div class="panel panel-default">

		<div class="panel-heading">
			<h4 class="panel-title">
				<a class="accordion-toggle collapsed block" data-toggle="collapse" data-parent="##accordion" href="##cachesettings">
					<i class="fas fa-database"></i> Cache Settings
				</a>
			</h4>
		</div>

		<div id="cachesettings" class="panel-collapse collapse">
			<div class="panel-body">

				<div class="form-group">
					<label for="cache">
						<i class="fas fa-file-code"></i> Cache Content Output:
					</label>
					#html.select(
						name          : "cache",
						options       : "Yes,No",
						selectedValue : yesNoFormat( prc.oContent.getCache() ),
						class         : "form-control input-sm"
					)#
				</div>

				<div class="form-group">
					<label for="cache">
						<i class="fas fa-stopwatch"></i> Cache Timeout (0=Use Global Setting)
					</label>
					#html.inputField(
						type      : "numeric",
						name      : "cacheTimeout",
						bind      : prc.oContent,
						title     : "Enter the number of minutes to cache your content, 0 means use global default setting",
						class     : "form-control",
						size      : "10",
						maxlength : "100"
					)#
				</div>

				<div class="form-group">
					<label for="cache">
						<i class="fas fa-flushed"></i> Idle Timeout (0=Use Global Setting)
					</label>
					#html.inputField(
						type      : "numeric",
						name      : "cacheLastAccessTimeout",
						bind      : prc.oContent,
						title     : "Enter the number of minutes for an idle timeout for your content, 0 means use global default setting",
						class     : "form-control",
						size      : "10",
						maxlength : "100"
					)#
				</div>
			</div>
		</div>
	</div>
	</cfif>
</cfoutput>