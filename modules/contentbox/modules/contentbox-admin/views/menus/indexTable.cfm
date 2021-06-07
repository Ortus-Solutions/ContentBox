<cfoutput>
	<!--- Entries Count --->
	<input type="hidden" name="menusCount" id="menusCount" value="#prc.menuCount#">

    <!--- menus --->
    <table name="menu" id="menu" class="table table-striped-removed table-hover " width="100%" cellspacing="0">
        <thead>
            <tr>
                <th id="checkboxHolder" class="{sorter:false}" width="20"><input type="checkbox" onClick="checkAll(this.checked,'menuID')"/></th>
                <th>Name</th>
                <th>Slug</th>
                <th width="100" class="text-center">No. Children</th>
                <th width="100" class="text-center {sorter:false}">Actions</th>
            </tr>
        </thead>

        <tbody>
            <cfloop array="#prc.menus#" index="menu">
            <tr id="contentID-#menu.getMenuID()#" data-contentID="#menu.getMenuID()#">
                <!--- check box --->
                <td class="text-center">
                    <input type="checkbox" name="menuID" id="menuID" value="#menu.getMenuID()#" />
                </td>
                <td>
                    <cfif prc.oCurrentAuthor.checkPermission( "MENUS_ADMIN" )>
                        <a href="#event.buildLink(prc.xehMenuEditor)#/menuID/#menu.getMenuID()#" title="Edit menu">#menu.getTitle()#</a>
                    <cfelse>
                        #menu.getTitle()#
                    </cfif>
                </td>
                <td>#menu.getSlug()#</td>
                <td class="text-center">#arrayLen( menu.getMenuItems() )#</td>
                <td class="text-center">
                    <div class="btn-group btn-group-sm">
                        <a class="btn btn-default btn-more dropdown-toggle" data-toggle="dropdown" href="##" title="Menu Actions">
                            <i class="fas fa-ellipsis-v fa-lg"></i>
                        </a>
                        <ul class="dropdown-menu text-left pull-right">
                            <cfif prc.oCurrentAuthor.checkPermission( "MENUS_ADMIN" )>
                                <!--- Delete Command --->
                                <li>
                                    <a title="Delete Menu" href="javascript:remove('#menu.getmenuID()#', 'menuID')" class="confirmIt" data-title="Delete Menu?"><i class="far fa-trash-alt fa-lg" id="delete_#menu.getMenuID()#"></i> Delete</a>
                                </li>
                                <!--- Edit Command --->
                                <li>
                                    <a title="Edit Menu" href="#event.buildLink( prc.xehMenuEditor )#/menuID/#menu.getMenuID()#"><i class="fas fa-pen fa-lg"></i> Edit</a>
                                </li>
                                <cfif prc.oCurrentAuthor.checkPermission( "MENUS_ADMIN,TOOLS_EXPORT" )>
                                    <!--- Export --->
                                    <li>
										<a href="#event.buildLink( prc.xehMenuExport )#/menuID/#menu.getMenuID()#.json" target="_blank">
											<i class="fas fa-file-export fa-lg"></i> Export
										</a>
									</li>
                                </cfif>
                            </cfif>
                        </ul>
                    </div>
                </td>
            </tr>
            </cfloop>
        </tbody>
    </table>
</cfoutput>