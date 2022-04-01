<cfoutput>
<div id="cb-admin-bar">

	<span id="cb-admin-bar-actions">

		<cfif !isNull( args.oContent )>

			<cfif args.oContent.getContentType() eq "Page">
				<span class="icon-info"></span>
				<span class="admin-bar-label layout">
					Layout: #args.oContent.getLayout()#
				</span>
			</cfif>

			<cfif args.oContent.getAllowComments()>
				<span class="admin-bar-label comments">
					Comments: #args.oContent.getNumberOfComments()#
				</span>
			</cfif>

			<cfif !isNull( args.oContent )>
				<span class="admin-bar-label publisher">
					#getInstance( "Avatar@contentbox" ).renderAvatar(
						email	= args.oContent.getAuthorEmail(),
						size	= "15",
						class	= "img img-circle"
					)#
					#args.oContent.getAuthorName()# published on
						#args.oContent.getActiveContent().getDisplayCreatedDate()#
				</span>
			</cfif>

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

			<a href="#args.linkEdit#" class="button edit" target="_blank">
				&nbsp; Edit &nbsp;
			</a>

			<a href="#args.linkEdit###custom_fields" class="button custom_fields" target="_blank">
				Custom Fields
			</a>

			<a href="#args.linkEdit###seo" class="button seo" target="_blank">
				SEO
			</a>

			<a href="#args.linkEdit###history" class="button history" target="_blank">
				History
			</a>

			<!--- Only show if we are on a cached page --->
			<cfif structKeyExists( prc, "contentCacheData" )>
			<a href="#event.buildLink( event.getCurrentRoutedURL() )#?cbCache=true" class="button button-admin clear-cache">
				Clear Cache
			</a>
			</cfif>
		</cfif>

		<a href="#cb.linkAdmin()#" class="button button-admin" target="_blank">
			Admin
		</a>

	</span>

	<div id="shrink">
		<a href="##" class="button_shrink"><span class="icon-shrink"></span></a>
	</div>

	<div id="avatar">
		<h4>
			#getInstance( "Avatar@contentbox" )
				.renderAvatar(
					email 	: args.oCurrentAuthor.getEmail(),
					size 	: "30",
					title	: "Hola"
				)#
			<span class="label label-info mr5">#prc.oCurrentSite.getName()#</span>
		</h4>
	</div>


</div>


<script>
setTimeout( insertAdminBar, 500 );

function insertAdminBar(){
	document.body.insertBefore(
		document.getElementById( 'cb-admin-bar' ),
		document.body.firstChild
	);
}

var a         = getCookie( "adminbarstatus" );
var el        = document.getElementById( "cb-admin-bar" );
var hasClass1 = el.classList.contains('fade_out');

if( a == "out" ){
	el.classList.add( "fade_out" );
}else{
	//do nothing
}


document.addEventListener( "DOMContentLoaded", function(){
	document.getElementById( "shrink" ).addEventListener('click', function() {
		var el1 = document.getElementById( "cb-admin-bar" );
		var hasClass = el1.classList.contains('fade_out');

		if( hasClass === false ){
			setCookie( "adminbarstatus", "out", 7);
			el1.classList.add( "fade_out" );
		} else {

			document.getElementById( "shrink" ).style.visibility="hidden";
			document.getElementById( "avatar" ).style.visibility="hidden";
			document.getElementById( "cb-admin-bar-actions" ).style.visibility="hidden";

			setTimeout(
				function(){
					el1.classList.remove( "fade_out" );
					setCookie( "adminbarstatus", "in", 7);
					setTimeout(
						function(){
		   					document.getElementById( "avatar" ).style.visibility="visible";
							document.getElementById( "cb-admin-bar-actions" ).style.visibility="visible";
							document.getElementById( "shrink" ).style.visibility="visible";
						},
						1500
					);
				},
				400
			);

		}
	});
});

function setCookie( cname, cvalue, exdays ){
    var d = new Date();
    d.setTime( d.getTime() + ( exdays * 24 * 60 * 60 * 1000 ) );
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie( cname ){
    var name 	= cname + "=";
    var ca 		= document.cookie.split( ';' );
    for( var i = 0; i < ca.length; i++ ){
        var c = ca[i];
        while( c.charAt(0) == ' ' ){
            c = c.substring(1);
        }
        if( c.indexOf( name ) == 0 ){
            return c.substring( name.length, c.length );
        }
    }
    return "";
}

</script>
</cfoutput>
