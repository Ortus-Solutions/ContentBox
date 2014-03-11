<cfoutput>
    <!--- menus --->
    <table name="menu" id="menu" class="tablesorter table table-hover" width="98%">
        <thead>
            <tr>
                <th id="checkboxHolder" class="{sorter:false}" width="20"><input type="checkbox" onClick="checkAll(this.checked,'contentID')"/></th>
                <th>Name</th>
                <th>Slug</th>
                <th width="100" class="center">No. Children</th>
                <th width="100" class="center {sorter:false}">Actions</th>
            </tr>
        </thead>
        
        <tbody>
            <cfloop array="#prc.menus#" index="menu">
            <tr id="contentID-#menu.getMenuID()#" data-contentID="#menu.getMenuID()#">
                <!--- check box --->
                <td>
                    <input type="checkbox" name="menuID" id="menuID" value="#menu.getMenuID()#" />
                </td>
                <td>
                    <cfif prc.oAuthor.checkPermission("MENUS_ADMIN")>
                        <a href="#event.buildLink(prc.xehMenuEditor)#/menuID/#menu.getMenuID()#" title="Edit menu">#menu.getTitle()#</a>
                    <cfelse>
                        #menu.getTitle()#
                    </cfif>
                </td>
                <td>#menu.getSlug()#</td>
                <td class="center">#arrayLen( menu.getMenuItems() )#</td>
                <td class="center">
                    <div class="btn-group">
                        <a class="btn dropdown-toggle" data-toggle="dropdown" href="##" title="Menu Actions">
                            <i class="icon-cogs icon-large"></i>
                        </a>
                        <ul class="dropdown-menu text-left pull-right">
                            <cfif prc.oAuthor.checkPermission("MENUS_ADMIN")>
                                <!--- Delete Command --->
                                <li>
                                    <a title="Delete Menu" href="javascript:remove('#menu.getmenuID()#', 'menuID')" class="confirmIt" data-title="Delete Menu?"><i class="icon-trash icon-large" id="delete_#menu.getMenuID()#"></i> Delete</a>
                                </li>
                                <!--- Edit Command --->
                                <li>
                                    <a title="Edit Menu" href="#event.buildLink( prc.xehMenuEditor )#/menuID/#menu.getMenuID()#"><i class="icon-edit icon-large"></i> Edit</a>
                                </li>
                                <cfif prc.oAuthor.checkPermission("TOOLS_EXPORT")>
                                    <!--- Export --->
                                    <li class="dropdown-submenu pull-left">
                                        <a href="##"><i class="icon-download icon-large"></i> Export</a>
                                        <ul class="dropdown-menu text-left">
                                            <li><a href="#event.buildLink(linkto=prc.xehMenuExport)#/menuID/#menu.getMenuID()#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
                                            <li><a href="#event.buildLink(linkto=prc.xehMenuExport)#/menuID/#menu.getMenuID()#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
                                        </ul>
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
    <!--- Paging --->
    <cfif !rc.showAll>
        #prc.pagingPlugin.renderit(foundRows=prc.menuCount, link=prc.pagingLink, asList=true)#
        <cfelse>
        <span class="label label-info">Total Records: #prc.menuCount#</span>
    </cfif>
</cfoutput>