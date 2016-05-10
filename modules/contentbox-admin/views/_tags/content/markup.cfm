<cfoutput>
    <div id="contentToolBar">
        <!--- editor selector --->
        <cfif prc.oAuthor.checkPermission( "EDITORS_EDITOR_SELECTOR" )>
            <div class="btn-group btn-group-sm">
                <a class="btn btn-info btn-sm dropdown-toggle" data-toggle="dropdown" href="##">
                    <i class="fa fa-keyboard-o"></i>
                    Editor
                    <span class="caret"></span>
                </a>
                <ul class="dropdown-menu">
                    <cfloop array="#prc.editors#" index="thisEditor">
                        <li>
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
            name="markup", 
            value=args.content.isLoaded() ? args.content.getMarkup() : prc.defaultMarkup
        )#
        <div class="btn-group btn-group-sm">
            <a class="btn btn-info btn-sm dropdown-toggle" data-toggle="dropdown" href="##">
                <i class="fa fa-code"></i>
                Markup : <span id="markupLabel">#args.content.isLoaded() ? args.content.getMarkup() : prc.defaultMarkup#</span>
                <span class="caret"></span>
            </a>
            <ul class="dropdown-menu">
                <cfloop array="#prc.markups#" index="thismarkup">
                    <li>
                        <a href="javascript:switchMarkup( '#thismarkup#' )">#thismarkup#</a>
                    </li>
                </cfloop>
            </ul>
        </div>
        <div class="btn-group btn-group-sm" id="contentAutoSave">
            <a class="btn btn-info btn-sm dropdown-toggle autoSaveBtn" data-toggle="dropdown" href="##">
                <i class="fa fa-save"></i>
                Auto Saved
                <span class="caret"></span>
            </a>
            <ul class="dropdown-menu autoSaveMenu">

            </ul>
        </div>

        <!---Right References Panel --->
        <div class="pull-right">
            <a href="javascript:previewContent()" class="btn btn-sm btn-info" title="Quick Preview (ctrl+p)" data-keybinding="ctrl+p">
                <i class="fa fa-eye fa-lg"></i>
            </a>
        </div>
    </div>
</cfoutput>