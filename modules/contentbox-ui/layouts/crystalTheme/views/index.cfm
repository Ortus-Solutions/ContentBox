<cfoutput>



	<!--- Main Content Goes Here --->
	<div class="span8">

		Something will go in here eventually


	</div>

	<!--- SideBar: That's right, I can render any layout views by using quickView() or coldbo'x render methods --->
	<div class="span4">

		<div class="sidebar widget-area" id="sidebar">
			<div id="sidebar-top"></div>
			<div class="widget widget_search" id="search-3">
				<div class="widget-wrap">
					<h4 class="widgettitle">Search</h4>
					#cb.widget("SearchForm")#

<!---		<form action="http://demo.studiopress.com/crystal/" class="searchform" method="get">

			<input type="text" onblur="if (this.value == '') {this.value = 'Search this website …';}" onfocus="if (this.value == 'Search this website …') {this.value = '';}" class="s" name="s" value="Search this website …">
			<input type="submit" value="Search" class="searchsubmit">
		</form>--->
				</div>
			</div>

			<div class="widget widget_recent_entries" id="recent-posts-3">
				<div class="widget-wrap">
					<h4 class="widgettitle">Recent Posts</h4>
					#cb.widget('RecentEntries')#
				</div>
			</div>
			<div id="sidebar-bottom"></div></div>














<!---
				<div id="recent-posts-3" class="widget widget_recent_entries">
				<div class="widget-wrap">
					<h4 class="widgettitle">Recent Posts</h4>
					<ul>
							<li><a href="http://demo.studiopress.com/crystal/sample-post-with-threaded-comments.htm" title="Sample Post With Threaded Comments">Sample Post With Threaded Comments</a></li>
							<li><a href="http://demo.studiopress.com/crystal/sample-post-with-image-aligned-left.htm" title="Sample Post With Image Aligned Left">Sample Post With Image Aligned Left</a></li>
							<li><a href="http://demo.studiopress.com/crystal/sample-post-with-image-aligned-right.htm" title="Sample Post With Image Aligned Right">Sample Post With Image Aligned Right</a></li>
							<li><a href="http://demo.studiopress.com/crystal/sample-post-with-image-centered.htm" title="Sample Post With Image Centered">Sample Post With Image Centered</a></li>
							<li><a href="http://demo.studiopress.com/crystal/sample-post-with-an-unordered-list.htm" title="Sample Post With an Unordered List">Sample Post With an Unordered List</a></li>
							</ul>
					</div>
				</div>
				<div id="sidebar-bottom"></div>
				<div id="search-3" class="widget widget_search">
					<div class="widget-wrap"><h4 class="widgettitle">Search</h4>
					<form method="get" class="searchform" action="http://demo.studiopress.com/crystal/">

						<input type="text" value="Search this website …" name="s" class="s" onfocus="if (this.value == 'Search this website …') {this.value = '';}" onblur="if (this.value == '') {this.value = 'Search this website …';}">
						<input type="submit" class="searchsubmit" value="Search">
					</form>
				</div>
			</div>
			<div id="enews-3" class="widget enews-widget">
				<div class="widget-wrap">
					<div class="enews">
						<h4 class="widgettitle">Email Newsletter</h4>
						<p>Sign up to receive email updates and<br>
						to hear what's going on with our company!</p>
						<form id="subscribe" action="http://feedburner.google.com/fb/a/mailverify" method="post" target="popupwindow" onsubmit="window.open( 'http://feedburner.google.com/fb/a/mailverify?uri=studiopress', 'popupwindow', 'scrollbars=yes,width=550,height=520');return true">
							<input type="text" value="Enter your email address..." id="subbox" onfocus="if ( this.value == 'Enter your email address...') { this.value = ''; }" onblur="if ( this.value == '' ) { this.value = 'Enter your email address...'; }" name="email">
							<input type="hidden" name="uri" value="studiopress">
							<input type="hidden" name="loc" value="en_US">
							<input type="submit" value="Go" id="subbutton">
						</form>
					</div>
				</div>
			</div>
			<div id="user-profile-3" class="widget user-profile">
				<div class="widget-wrap">
					<h4 class="widgettitle">User Profile</h4>
					<p><span class="alignleft"><img alt="" src="http://0.gravatar.com/avatar/c845c86ebe395cea0d21c03bc4a93957?s=65&amp;d=http%3A%2F%2F0.gravatar.com%2Favatar%2Fad516503a11cd5ca435acc9bb6523536%3Fs%3D65&amp;r=G" class="avatar avatar-65 photo" height="65" width="65"></span>Self-confessed Starbucks addict. Sarah McLachlan fan. Lover of WordPress. Nomad Theorist. Founder of StudioPress. Partner, Copyblogger Media. For more, follow me <a href="http://twitter.com/bgardner">@bgardner</a> and check out <a href="http://www.briangardner.com">my blog</a>. <a class="pagelink" href="http://demo.studiopress.com/crystal/sample">[Read More …]</a></p>
				</div>
			</div>--->
		</div>

	</div>

	<!--- Separator --->
<!---	<div class="clr"></div>--->
</cfoutput>