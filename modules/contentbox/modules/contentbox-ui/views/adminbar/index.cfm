<cfoutput>
<div id="cb-admin-bar">

	<span id="cb-admin-bar-actions">

		<cfif !isNull( args.oContent )>

			<cfif args.oContent.getContentType() == "Page">
			<span class="admin-bar-label">
				Layout: #args.oContent.getLayout()#
			</span>
			</cfif>

			<cfif args.oContent.getAllowComments()>
			<span class="admin-bar-label">
				Comments: #args.oContent.getNumberOfComments()#
			</span>
			</cfif>

			<span class="admin-bar-label">
				Hits: #args.oContent.getNumberOfHits()#
			</span>

			<cfif !args.oContent.getIsPublished()>
			<span class="admin-bar-label-red">
				Draft
			</span>
			</cfif>

			<cfif args.oContent.isPublishedInFuture()>
			<span class="admin-bar-label-red">
				Publishes on: #args.oContent.getDisplayPublishedDate()#
			</span>
			</cfif>

			<a href="#args.linkEdit#" class="button" target="_blank">
				&nbsp; Edit &nbsp;
			</a>

			<a href="#args.linkEdit###custom_fields" class="button" target="_blank">
				Custom Fields
			</a>

			<a href="#args.linkEdit###seo" class="button" target="_blank">
				SEO
			</a>

			<a href="#args.linkEdit###history" class="button" target="_blank">
				History
			</a>

			<!--- Only show if we are on a cached page --->
			<cfif structKeyExists( prc, "contentCacheData" )>
			<a href="#event.buildLink( event.getCurrentRoutedURL() )#?cbCache=true" class="button button-admin">
				Clear Cache
			</a>
			</cfif>
		</cfif>

		<a href="#cb.linkAdmin()#" class="button button-admin" target="_blank">
			Admin
		</a>


	</span>

	<h4>
		#getModel( "Avatar@cb" )
			.renderAvatar( email=args.oCurrentAuthor.getEmail(), size="30", title="Hola" )#
		ContentBox Admin Bar
	</h4>

	<cfif !isNull( args.oContent )>
	<p>
		#args.oContent.getAuthorName()# published on
				#args.oContent.getActiveContent().getDisplayCreatedDate()#
	</p>
	</cfif>

</div>
<div id="cb-admin-bar-spacer">&nbsp;</div>

<script>
setTimeout( insertAdminBar, 500 );
function insertAdminBar(){
	document.body.insertBefore(
		document.getElementById( 'cb-admin-bar' ),
		document.body.firstChild
	);
}
</script>

<style>
##cb-admin-bar{
	padding: 7px 20px;
    width: 100%;
    height: 55px;
    top: 0;
    left: 0;
    background: ##333;
    color: white;
    text-align: center;
    position: fixed;
    z-index: 9999;
    box-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5);
}
##cb-admin-bar-spacer{
	height:55px;
}
##cb-admin-bar-actions{
	float: right;
	margin-top: 10px;
	font-size: 12px;
}
##cb-admin-bar h4{
	color: white;
	float: left;
	margin-top: 6px;
}
##cb-admin-bar h4 img{
	vertical-align: middle;
	margin-right: 5px;
}
##cb-admin-bar p{
	font-size: 12px;
	margin-top: 11px;
}
##cb-admin-bar .admin-bar-label-red{
	background-color: red;
	padding: 3px;
	margin-right: 5px;
	border: 2px solid;
    border-radius: 10px;
}
##cb-admin-bar .admin-bar-label{
	background-color: ##3598db;
	padding: 3px;
	margin-right: 5px;
	border: 2px solid;
    border-radius: 10px;
}
##cb-admin-bar a.button {
    background-color: ##4CAF50;
    color: white;
    padding: 5px;
    margin: 0px 1px;
    font-size: 12px;
    border: none;
    cursor: pointer;
    border-radius: 10px;
}
##cb-admin-bar a.button:hover, ##cb-admin-bar a.button:focus {
    background-color: ##3e8e41;
    text-decoration: none;
}
##cb-admin-bar a.button-admin {
    background-color: ##eb6154;
}
##cb-admin-bar a.button-admin:hover, ##cb-admin-bar a.button-admin:focus {
    background-color: ##f28379;
}
</style>
</cfoutput>
