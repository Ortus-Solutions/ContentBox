<cfoutput>
<div id="contentToolBar">

	<!--- editor selector --->
	<cfif prc.oCurrentAuthor.hasPermission( "EDITORS_EDITOR_SELECTOR" )>
		<div class="btn-group btn-group-sm">
			<a class="btn btn-secondary btn-sm dropdown-toggle" data-toggle="dropdown" href="##">
				<i class="fa fa-keyboard-o"></i>
				Editor
				<span class="caret"></span>
			</a>
			<ul class="dropdown-menu">
				<cfloop array="#prc.editors#" index="thisEditor">
					<li <cfif thisEditor.name eq prc.defaultEditor>class="active"</cfif>>
						<a href="javascript:switchEditor( '#thisEditor.name#' )">
							#thisEditor.displayName#
						</a>
					</li>
				</cfloop>
			</ul>
		</div>
	</cfif>

	<!--- markup --->
	#html.hiddenField(
		name	= "markup",
		value	= prc.oContent.isLoaded() ? prc.oContent.getMarkup() : prc.defaultMarkup
	)#

	<div class="btn-group btn-group-sm">
		<a class="btn btn-secondary btn-sm dropdown-toggle" data-toggle="dropdown" href="##">
			<i class="fa fa-code"></i>
			Markup : <span id="markupLabel">#prc.oContent.isLoaded() ? prc.oContent.getMarkup() : prc.defaultMarkup#</span>
			<span class="caret"></span>
		</a>
		<ul class="dropdown-menu">
			<cfloop array="#prc.markups#" index="thismarkup">
				<li <cfif thisMarkup eq prc.oContent.getMarkup()>class="active"</cfif>>
					<a href="javascript:switchMarkup( '#thismarkup#' )">#thismarkup#</a>
				</li>
			</cfloop>
		</ul>
	</div>

	<!--- Auto Save Operations --->
	<div class="btn-group btn-group-sm" id="contentAutoSave">
		<a class="btn btn-secondary btn-sm dropdown-toggle autoSaveBtn" data-toggle="dropdown" href="##">
			<i class="fa fa-save"></i>
			Auto Saved
			<span class="caret"></span>
		</a>
		<ul class="dropdown-menu autoSaveMenu">

		</ul>
	</div>

	<!--- Preview Panel --->
	<div class="pull-right">
		<button onclick="previewContent()" class="btn btn-link btn-sm" title="Quick Preview (ctrl+p)" data-keybinding="ctrl+p" type="button">
			#cbAdminComponent( "ui/CBIcon", { name : "Eye", size : "sm" } )#
			Preview
		</button>
	</div>
</div>
</cfoutput>
