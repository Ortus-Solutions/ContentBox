<cfoutput>
<div class="row">
    <div class="col-md-12">
		<h1 class="h1">
			<i class="far fa-star fa-lg"></i> Subscribers
		</h1>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        <!--- MessageBox --->
        #cbMessageBox().renderit()#
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        <div class="panel panel-default">
            <div class="panel-body">
                <!-- Vertical Nav -->
                <div class="tab-wrapper tab-primary">
                    <!-- Tabs -->
                    <ul class="nav nav-tabs" id="contentTypes">
                        <li class="active">
                            <a href="##CommentSubscriptions" data-toggle="tab"><i class="fas fa-blog icon-small" title="Comment Subscriptions"></i> Comment Subscriptions</a>
                        </li>
                    </ul>
                    <!-- End Tabs -->
                    <!-- Tab Content -->
                    <div class="tab-content">
                        <!-- Tab ` -->
                        <div class="tab-pane active" id="CommentSubscriptions">
                            <cfif arrayLen( prc.commentSubscriptions )>
                                <div class="row">
                                    <div class="col-md-6">
                                        <h3>All Subscriptions</h3>
                                            <!--- comment subscriptions --->
                                            <table name="commentSubscriptions" id="commentSubscriptions" class="table table-striped-removed table-hover" >
                                                <thead>
                                                    <tr>
                                                        <th>Content</th>
                                                        <th width="75" class="text-center">Followers</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <cfloop array="#prc.commentSubscriptions#" index="subscription">
                                                    <tr>
                                                        <td><a href="#cb.linkContent( subscription[ 'relatedContent' ] )#" target="_blank">#subscription[ "title" ]#</a></td>
                                                        <td class="text-center">#subscription[ "subscriberCount" ]#</td>
                                                    </tr>
                                                    </cfloop>
                                                </tbody>
                                            </table>

                                    </div>
                                    <div class="col-md-6">
                                        <h3>Top #prc.maxCommentSubscriptions# Comment Subscriptions</h3>
                                        <div id="commentchart"></div>
                                    </div>
                                </div>
                            <cfelse>
                                <p class="label label-info">No subscriptions yet!</p>
                            </cfif>
                        </div>
                    </div>
                    <!-- End Tab Content -->
                </div>
                <!-- End Vertical Nav -->
            </div>
        </div>
    </div>
</div>
</cfoutput>