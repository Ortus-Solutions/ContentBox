<cfoutput>
<div class="row-fluid">
    <div class="span9" id="main-content">
        <div class="box">
            <!--- Body Header --->
            <div class="header">
                <i class="icon-star icon-large"></i> Subscribers
            </div>
            <!--- Body --->
            <div class="body">
                <!--- MessageBox --->
                #getPlugin("MessageBox").renderit()#
                <ul class="nav nav-tabs" id="contentTypes">
                    <li class="active">
                        <a href="##CommentSubscriptions" data-toggle="tab"><i class="icon-quote-left icon-small" title="Comment Subscriptions"></i> Comment Subscriptions</a>
                    </li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane fade active in" id="CommentSubscriptions">
                        <cfif arrayLen( prc.commentSubscriptions )>
                            <div class="span6">
                                <h3>All Subscriptions</h3>
                                    <!--- comment subscriptions --->
                                    <table name="commentSubscriptions" id="commentSubscriptions" class="tablesorter table table-striped table-hover" width="98%">
                                        <thead>
                                            <tr>
                                                <th>Content</th>     
                                                <th width="75" class="center">Followers</th>
                                            </tr>
                                        </thead>                
                                        <tbody>
                                            <cfloop array="#prc.commentSubscriptions#" index="subscription">
                                            <tr>
                                                <td><a href="#cb.linkContent( subscription[ 'relatedContent' ] )#" target="_blank">#subscription[ "title" ]#</a></td>
                                                <td class="center">#subscription[ "subscriberCount" ]#</td>
                                            </tr>
                                            </cfloop>
                                        </tbody>
                                    </table>
                                
                            </div>
                            <div class="span6">
                                <h3>Top #prc.maxCommentSubscriptions# Comment Subscriptions</h3>
                                <div id="commentchart"></div>
                                <script>
                                    Morris.Donut({
                                        element: 'commentchart',
                                        data: #serializeJSON( prc.topCommentSubscriptions )#,
                                        colors: [
                                            '##f1c40f','##2dcc70','##e84c3d','##0099FF','##993399','##FF9900'
                                        ],
                                        formatter: function ( x ) { 
                                            var pluralized = x>1 ? 's' : '';
                                            return x + " Subscriber" + pluralized;
                                        }
                                    });
                                </script>
                            </div>
                            <cfelse>
                                <p class="label label-info">No subscriptions yet!</p>
                            </cfif>
                    </div>
                </div>            
            </div>  
        </div>
    </div>
    <!--- main sidebar --->    
    <div class="span3" id="main-sidebar">    
        <!--- Filter Box --->
        <div class="small_box">
            <div class="header">
                <i class="icon-bar-chart"></i> Quick Stats
            </div>
            <div class="body">
                <table class="table table-striped table-bordered">
                    <tr>
                        <td><strong>Comment Subscriptions:</strong></td>
                        <td><span class="label label-info">#prc.commentSubscriptionCount#</span></td>
                    </tr>
                    <tr class="info">
                        <td><strong>Unique Subscribers:</strong></td>
                        <td><span class="label label-info">#prc.uniqueSubscriberCount#</span></td>
                    </tr>
                </table>
            </div>
        </div>
    </div>   
</div> 
</cfoutput>