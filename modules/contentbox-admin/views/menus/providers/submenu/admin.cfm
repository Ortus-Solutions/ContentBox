<cfoutput>
    <div class="row-fluid">
        <div class="control-group span12">
            <label for="submenu" class="control-label">Select Sub-menu:</label>
            <div class="controls">
                <select name="menuSlug" class="textfield input-block-level" required="true" title="Select a submenu" onchange="$( this ).closest( '.dd3-item' ).find( '.dd3-type' ).removeClass( 'btn-danger' ).addClass( 'btn-inverse' )">
                    <option value="">-- Select a Menu --</option>
                    <cfloop array="#args.menus#" index="menu">
                        <option value="#menu.getSlug()#" <cfif args.existingSlug eq menu.getSlug()>selected=true</cfif>>#menu.getTitle()#</option>
                    </cfloop>
                </select>
            </div>
        </div>
    </div>
</cfoutput>