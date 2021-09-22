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


<style>
body{
	margin-top:50px !important;
}
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
	transition: all 1s ease;
	-moz-transition: all 1s ease;
    -webkit-transition: all 1s ease;
	left: auto !important;
	right: 0 !important;
	opacity: 50%
}
##cb-admin-bar:hover{
	opacity: 100%
}
.fade_out {
	width: 60px !important;
}
.fade_out > span, .fade_out ##avatar {
	display: none;
}
.fade_out .icon-shrink::before {
	content: "\e98b" !important;
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
	margin-top: 10px;
}

##cb-admin-bar h4 img{
	display: inline-block;
	vertical-align: text-bottom;
	margin-right: 5px;
    margin-bottom: -5px;
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
	/*background-color: ##3598db;*/
	padding: 3px;
	margin-right: 5px;
	/*border: 2px solid;*/
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

##shrink{
	float: left;
}

##enlarge {
	padding: 7px 20px;
    width: 50px;
    height: 55px;
    top: 0;
    right: 0;
    background: ##333;
    color: white;
    text-align: center;
    position: fixed;
    z-index: 9999;
    box-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5);
}

/* responsive */

@media (max-width: 1400px) {
	##avatar{
		 display: none;
	}
}

@media (max-width: 1200px) {
	.admin-bar-label.layout, .admin-bar-label.comments, .admin-bar-label.hits, .admin-bar-label.publisher, .icon-info{
		display: none;
	}
}


@media (max-width: 768px) {
	.button.custom_fields, .button.seo, .button.history{
	  display: none;
	}
}

@media (max-width: 480px) {
	.button.edit, .button.clear-cache{
  		display: none;
	}
}

@font-face {
  font-family: 'icomoon';
  src:  url('data:application/x-font-woff;base64,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');
  font-weight: normal;
  font-style: normal;
}
[class^="icon-"], [class*=" icon-"] {
  /* use !important to prevent issues with browser extensions that change fonts */
  font-family: 'icomoon' !important;
  speak: none;
  font-style: normal;
  font-weight: normal;
  font-variant: normal;
  text-transform: none;
  line-height: 1;

  /* Better Font Rendering =========== */
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.icon-pencil:before {
  content: "\e905";
  margin-left: 38px;
  margin-right: 10px;
  font-size:16px;
  vertical-align: middle;
}
.icon-enlarge:before {
  content: "\e98b";
  float:left;
  font-size: 26px;
  margin-left: -6px;
  margin-top: 7px;
  vertical-align: middle;
  color: white;

}
.icon-shrink:before {
  float:left;
  font-size: 26px;
  content: "\e98c";
  margin-right: 30px;
  margin-top: 7px;
  vertical-align: middle;
  color: white;
}
.icon-info:before {
  content: "\ea0c";
  font-size: 18px;
  margin-right: 10px;
  vertical-align: middle;

}
</style>
</cfoutput>
