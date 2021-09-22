<cfoutput>
<div id="contentToolBar">

	<!--- editor selector --->
	<cfif prc.oCurrentAuthor.checkPermission( "EDITORS_EDITOR_SELECTOR" )>
		<div class="btn-group btn-group-sm">
			<a class="btn btn-info btn-sm dropdown-toggle" data-toggle="dropdown" href="##">
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
		<a class="btn btn-info btn-sm dropdown-toggle" data-toggle="dropdown" href="##">
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
		<a class="btn btn-info btn-sm dropdown-toggle autoSaveBtn" data-toggle="dropdown" href="##">
			<i class="far fa-save"></i>
			Auto Saved
			<span class="caret"></span>
		</a>
		<ul class="dropdown-menu autoSaveMenu">

		</ul>
	</div>

	<!--- Preview Panel --->
	<div class="pull-right">
		<a href="javascript:previewContent()" class="btn btn-sm btn-info" title="Quick Preview (ctrl+p)" data-keybinding="ctrl+p">
			<i class="far fa-eye fa-lg"></i>
		</a>
	</div>
</div>
</cfoutput>