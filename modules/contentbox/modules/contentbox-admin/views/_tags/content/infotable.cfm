<cfoutput>
<div class="panel panel-default">
                        
    <div class="panel-heading">
        <h4 class="panel-title">
            <a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##pageinfo">
                <i class="fa fa-info-circle fa-lg"></i> Info
            </a>
        </h4>
    </div>

    <div id="pageinfo" class="panel-collapse collapse in">
        <div class="panel-body">
            <!--- Persisted Info --->
            <table class="table table-hover table-condensed table-striped size12">
                <tr>
                    <th class="col-md-4">Created By:</th>
                    <td class="col-md-8">
                        <a href="mailto:#args.content.getCreatorEmail()#">#args.content.getCreatorName()#</a>
                    </td>
                </tr>

                <tr>
                    <th class="col-md-4">Created On:</th>
                    <td class="col-md-8">
                        #args.content.getDisplayCreatedDate()#
                    </td>
                </tr>

                <tr>
                    <th class="col-md-4">Published On:</th>
                    <td class="col-md-8">
                        #args.content.getDisplayPublishedDate()#
                    </td>
                </tr>

                <tr>
                    <th class="col-md-4">Version:</th>
                    <td class="col-md-8">
                        #args.content.getActiveContent().getVersion()#
                    </td>
                </tr>

                <tr>
                    <th class="col-md-4">Last Edit By:</th>
                    <td class="col-md-8">
                        <a href="mailto:#args.content.getAuthorEmail()#">#args.content.getAuthorName()#</a>
                    </td>
                </tr>

                <tr>
                    <th class="col-md-4">Last Edit On:</th>
                    <td class="col-md-8">
                        #args.content.getActiveContent().getDisplayCreatedDate()#
                    </td>
                </tr>

                <cfif args.content.hasChild()>
                <tr>
                    <th class="col-md-4">Child Pages:</th>
                    <td class="col-md-8">
                        #args.content.getNumberOfChildren()#
                    </td>
                </tr>
                </cfif>

                <tr>
                    <th class="col-md-4">Views:</th>
                    <td class="col-md-8">
                        #args.content.getNumberOfHits()#
                    </td>
                </tr>

                <tr>
                    <th class="col-md-4">Comments:</th>
                    <td class="col-md-8">
                        #args.content.getNumberOfComments()#
                    </td>
                </tr>

            </table>
        </div>
    </div>
</div>
</cfoutput>