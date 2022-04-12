<cfoutput>
	<div id="cb-adminbar">
		<cfif !isNull( args.oContent )>	
			<div class="cb-adminbar__content">
		<cfelse>
			<!--- evenly distributes children  --->
			<div class="cb-adminbar__content cb-adminbar--justify-content">
		</cfif>
			<a href="#cb.linkAdmin()#" target="_blank" class="cb-adminbar__brand">
				<svg class="cb-adminbar__icon" id="a" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 30 29.6" aria-label="Site Admin">
					<path d="M25.6,5.3c-3.4-2.7-11.3-4.6-17.4,1.4C1.8,14.8,4.6,26.8,17,28c6.8-.2,10.1-3.1,10.1-3.1,.7-.1-8.9,9-20.8,1.9C.7,22.9-.7,16.9,.3,12,1.2,7.2,4.7,3.4,6.7,2.3c8.9-5.5,17.4,.3,18.9,3Z" style="fill:##8fc73e; fill-rule:evenodd;"/>
					<path d="M21.7,4.7s5.3,1.6,5.8,9.3c.6,7.8-8.4,11.7-13.7,9.8-5.2-1.5-7.7-8.2-7.2-12.5-.5,.8-1.1,6.8,1.1,10.5,3,4.7,13.1,8.5,19.8,.7,5-6.2,1-14-.1-14.5-.6-1-4-3.1-5.7-3.3Z" style="fill:##8fc73e; fill-rule:evenodd;"/>
					<path d="M9.1,10.4s5.5-5.8,11.3-1.3c5.4,5,1.3,11.3-.9,12.1-1.9,1.4-6,1.4-6,1.4,1.3,.6,9,1.5,11.3-5.7,1.8-7.1-4.4-11.1-7.8-11.2-4.7,0-7,2.4-8,4.7Z" style="fill:##8fc73e; fill-rule:evenodd;"/>
				</svg>
				<span class="menu-heading">&nbsp; #prc.oCurrentSite.getName()# Site</span>
			</a>
			<cfif !isNull( args.oContent )>
				<nav id="cb-adminbar__actions" aria-label="Page Admin Menu">
					<ul class="cb-adminbar__menu">
						<li class="cb-adminbar__menu-item cb-adminbar__dropdown">
							<button 
								aria-expanded="false"
								aria-controls="cb-adminbar__info-dropdown"
								type="button" 
								class="cb-adminbar__dropdown-toggle info" 
								onclick="toggleDropdown(event, this )" 
							>
								<svg class="cb-adminbar__icon" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
								<span class="menu-heading">Page Info</span>
							</button>
							<!--- Page Info --->
							<div id="cb-adminbar__info-dropdown" class="cb-adminbar__dropdown-menu">
								<cfif !args.oContent.getIsPublished()>
									<span class="cb-adminbar__badge bg-danger">
										<svg aria-hidden="true" class="cb-adminbar__icon" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
											<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"></path>
										</svg>
										<strong>Draft</strong>
									</span></br>
								<cfelse>
									<cfif args.oContent.isPublishedInFuture()>
										<span class="cb-adminbar__badge bg-warning">
											<svg aria-hidden="true" class="cb-adminbar__icon" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
												<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 9v6m4-6v6m7-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
											</svg>
											<strong>Publish Pending</strong>
										</span></br>
									<cfelse>
										<span class="cb-adminbar__badge bg-success">
											<svg aria-hidden="true" class="cb-adminbar__icon" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
												<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z"></path>
											</svg>
											<strong>Published</strong>
										</span></br>
									</cfif>
								</cfif>
								<cfif args.oContent.isPublishedInFuture()>
									<span class="cb-adminbar__info-item">
										<strong>Publishes on:</strong> <br/>#args.oContent.getDisplayPublishedDate()#
									</span>
								</cfif> 
								<span class="cb-adminbar__info-item">
									<strong>Modified:</strong><br/> #args.oContent.getActiveContent().getDisplayCreatedDate()#
								</span><br/>
								<span class="cb-adminbar__info-item">
									#getInstance( "Avatar@contentbox" ).renderAvatar(
										email	= args.oContent.getAuthorEmail(),
										size	= "15",
										class	= "img img-circle"
									)#
									#args.oContent.getAuthorName()#
								</span><br/>
								
								<cfif args.oContent.getContentType() eq "Page">
									<span class="cb-adminbar__info-item">
										<strong>Layout:</strong> #args.oContent.getLayout()#
									</span><br/>
								</cfif>
								<cfif args.oContent.getAllowComments()>
									<span class="cb-adminbar__info-item">
										<strong>Comments:</strong> #args.oContent.getNumberOfComments()#
									</span><br/>
								</cfif>
							</div>
						</li>						
						<li class="cb-adminbar__menu-item">
							<a href="#args.linkEdit#" class="edit" target="_blank">
								<svg class="cb-adminbar__icon" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"></path>
								</svg>
								<span class="menu-heading">Edit</span>
							</a>
						</li>
						<li class="cb-adminbar__menu-item">
							<a href="#args.linkEdit###custom_fields" class="custom_fields" target="_blank">
								<svg class="cb-adminbar__icon" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
								</svg>
								<span class="menu-heading">Custom Fields</span>
							</a>
						</li>
						<li class="cb-adminbar__menu-item">
							<a href="#args.linkEdit###seo" class="seo" target="_blank">
								<svg class="cb-adminbar__icon" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"></path>
								</svg>
								<span class="menu-heading">SEO</span>
							</a>
						</li>
						<li class="cb-adminbar__menu-item">
							<a href="#args.linkEdit###history" class="history" target="_blank">
								<svg class="cb-adminbar__icon" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
								</svg>
								<span class="menu-heading">History</span>
							</a>
						</li>	
						<!--- Only show if we are on a cached page --->
						<cfif structKeyExists( prc, "contentCacheData" )>
							<li class="cb-adminbar__menu-item">
								<a href="#event.buildLink( event.getCurrentRoutedURL() )#?cbCache=true" class="clear-cache">
									<svg class="cb-adminbar__icon" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
										<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4"></path>
									</svg>
									<span class="menu-heading">Clear Cache</span>
								</a>
							</li>
						</cfif>
					</ul>
				</nav>
			</cfif>
			<!--- Avatar --->
			<div id="cb-adminbar__avatar">
				<div class="cb-adminbar__dropdown">
					<button 
						aria-expanded="false"
						aria-controls="cb-adminbar__user-dropdown"
						type="button" 
						class="cb-adminbar__dropdown-toggle" 
						onclick="toggleDropdown(event, this )"
					>
						#getInstance( "Avatar@contentbox" )
							.renderAvatar(
								email 	: args.oCurrentAuthor.getEmail(),
								size 	: "25",
								title	: "Hola"
							)#
					</button>
					<div id="cb-adminbar__user-dropdown" class="cb-adminbar__dropdown-menu">
						<span>#args.oCurrentAuthor.getFullName()#</span><br/>
						<span>#args.oCurrentAuthor.getEmail()#</span><br/>
						<ul>
							<li>
								<a href="#args.linkLogout#">Log Out</a>
							</li>
						</li>
					</div>
				</div>
			</div> 
		</div>
		<!--- Toggle --->
		<button aria-hidden="true" type="button" class="cb-adminbar__toggle" id="adminbar-toggle" onclick="toggleAdminBar()">
			<svg class="svg-cheveron" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7"></path></svg>
		</button>
	</div>
	
	
<script>
	setTimeout( insertAdminBar, 500 );

	var a         = getCookie( "adminbarstatus" );
	var el        = document.getElementById( "cb-adminbar" );
	var hasClass1 = el.classList.contains('cb-adminbar__slide-out');
	
	if( a == "out" ){
		el.classList.add( "cb-adminbar__slide-out" );
	}
	// Close the dropdown if the user clicks outside of it
	window.onclick = function( e ) {
		if ( !e.target.closest( '.cb-adminbar__dropdown' ) ) {
			var dropdowns = document.getElementsByClassName( "cb-adminbar__dropdown" );
			var i;
			for ( i = 0; i < dropdowns.length; i++ ) {
				var openDropdown = dropdowns[i];
				if ( openDropdown.classList.contains( 'active' ) ) {
					openDropdown.classList.remove( 'active' );
					openDropdown.querySelector('.cb-adminbar__dropdown-toggle').setAttribute( 'aria-expanded', false );
				}
			}
		}
	};
	/**
	 * Inserts the admin bar as the first element in the body.
	 */
	function insertAdminBar(){
		document.body.insertBefore(
			document.getElementById( 'cb-adminbar' ),
			document.body.firstChild
		);
	}
	/**
	 * Toggles the dropdown menu.
	 */
	function toggleDropdown( event, element ) {
		if( element.parentNode.classList.contains( 'active' ) ){
			element.parentNode.classList.remove( 'active' );
			element.setAttribute( 'aria-expanded', false );
		} else {
			element.parentNode.classList.add( 'active' );
			element.setAttribute( 'aria-expanded', true );
		}
	}
	/**
	 * Toggles the admin bar.
	 */
	function toggleAdminBar(){
		var el1 = document.getElementById( "cb-adminbar" );
		var hasClass = el1.classList.contains('cb-adminbar__slide-out');

		if( hasClass === false ){
			setCookie( "adminbarstatus", "out", 7);
			el1.classList.add( "cb-adminbar__slide-out" );
		} else {
			setTimeout(
				function(){
					el1.classList.remove( "cb-adminbar__slide-out" );
					setCookie( "adminbarstatus", "in", 7);
				},
				400
			);
		}
	}
	/**
	 * Sets cookie.
     * @param {String} cname - Cookie name.
     * @param {String} cvalue - Cookie value.
     * @param {String} exdays - Cookie active days.
	 */
	function setCookie( cname, cvalue, exdays ){
		var d = new Date();
		d.setTime( d.getTime() + ( exdays * 24 * 60 * 60 * 1000 ) );
		var expires = "expires="+d.toUTCString();
		document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
	}
	/**
	 * Gets cookie.
     * @param {String} cname - Cookie name.
	 */
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
	