<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<!--- Site Title --->
	<title>#bb.siteName()# - #bb.siteTagLine()#</title>
	<!--- Met Tags --->
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="generator" 	 content="BlogBox powered by ColdBox" />
	<meta name="robots" 	 content="index,follow" />
	<meta name="description" content="#bb.siteDescription()#" />
	<meta name="keywords" 	 content="#bb.siteKeywords()#" />
	
	<!--- Base HREF For SES URLs based on ColdBox--->
	<base href="#getSetting('htmlBaseURL')#/" />
	
	<!--- RSS Stuff --->
	<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="#bb.linkRSS()#" />	
	
	<!--- styles --->
	<link href="#bb.layoutRoot()#/includes/css/style.css" rel="stylesheet" type="text/css" />
	
	<!--- javascript --->
	<script type="text/javascript" src="#bb.layoutRoot()#/includes/js/jquery.tools.min.js"></script>
	<script type="text/javascript" src="#bb.layoutRoot()#/includes/js/default.js"></script>
	
	<!--- Custom HTML --->
	#bb.customHTML('beforeHeadEnd')#
	<!--- BlogBoxEvent --->
	#bb.event("bbui_beforeHeadEnd",{renderer=this})#
</head>
<body>
	<!--- Custom HTML --->
	#bb.customHTML('afterBodyStart')#
	<!--- BlogBoxEvent --->
	#bb.event("bbui_afterBodyStart",{renderer=this})#
	
	<!--- Main Content --->
	<div class="main">
		<!--- blok_Header --->
		<div class="blok_header">	    
			<!--- Header --->
			<div class="header">
				<!--- Logo Title --->
				<div class="logo"><a href="#bb.linkHome()#" title="Go Home!"></a>
					<div id="logoTitle">
		      			#bb.siteName()#      		
		      		</div>
				</div>
				<!--- Search Box --->
		      	<div class="search">
			        <form id="form1" name="form1" method="post" action="">
			          <label><span>
			            <input name="q" type="text" class="keywords" id="textfield" maxlength="50" value="Search..." />
			            </span>
			            <input name="b" type="image" src="#bb.layoutRoot()#/includes/images/search.gif" class="button" />
			          </label>
			        </form>
			    </div>
		      	
				<div class="clr"><br/></div>
				
				<!--- Menu Bar --->
				<div class="menu">
					<ul>
					  <li><a href="#bb.linkHome()#" title="Go Home!">Home</a></li>
					</ul>
					<div id="tagline">#bb.siteTagLine()#</div>
					<div class="clr"></div>
				</div>
				  
		      	<div class="clr"></div>
		    </div> <!--- end header --->		
		    <div class="clr"></div>
		</div> <!--- end block_header --->
	  
	  	<!--- body --->
	  	<div class="body_resize">
	   		<div class="body">
		   		<div class="body_bg">
		   			
					<!--- left bar --->
					<div class="left">
						<!--- BlogBoxEvent --->
						#bb.event("bbui_beforeContent",{renderer=this})#
						
						<div class="post-top-gap"></div>
						
						<!--- iterate over entries --->
						<cfloop array="#prc.entries#" index="entry">
							<!--- post --->
							<div class="post" id="post_#entry.getEntryID()#">
								<!--- Date --->
								<div class="post-date" title="Posted on #entry.getDisplayPublishedDate()#">
						  			<span class="post-month">#dateFormat(entry.getPublishedDate(),"MMM")#</span> 
						  			<span class="post-day">#dateFormat(entry.getPublishedDate(),"dd")#</span>
								</div>
								
								<!--- Title --->
								<div class="post-title">
									<!--- Comments if available? --->
									<cfif entry.getAllowComments()>
										<span class="post-comments">
											<a href="#bb.linkEntry(entry)###comments" title="Check out this entry's comments">
												<img src="#bb.layoutRoot()#/includes/images/mini-comments.gif" alt="comments"/> #entry.getNumberOfComments()#
											</a>
											<!--- content Author --->
											<div class="post-content-author">By: #entry.getAuthorName()#</div>
										</span>
									</cfif>
									<!--- Title --->
									<h2><a href="#bb.linkEntry(entry)#" rel="bookmark" title="#entry.getTitle()#">#entry.getTitle()#</a></h2>
									<!--- Category Bar --->
									<span class="post-cat">#bb.quickCategoryLinks(entry)#</span> 
									<!--- content --->
									<div class="post-content">
										<!--- excerpt or content --->
										<cfif entry.hasExcerpt()>
											#entry.getExcerpt()#
											<div class="post-more"><a href="#bb.linkEntry(entry)#" title="Read More...">Read More...</a></div>
										<cfelse>
											#entry.getContent()#
										</cfif>
									</div>
								</div>
								<div class="separator"></div>
							</div>								
						</cfloop>
						
						
						<!--- BlogBoxEvent --->
						#bb.event("bbui_afterContent",{renderer=this})#					
					</div> <!--- end left bar --->
	
					<!--- SideBar --->
					<div class="right">
						<!--- Custom HTML --->
						#bb.customHTML('beforeSideBar')#
						<!--- BlogBoxEvent --->
						#bb.event("bbui_BeforeSideBar",{renderer=this})#
						
						<!--- SideBar Content --->
						<h4>Categories</h4>
						<div class="bg"></div>
					  	
						<!--- Categories Widget --->
						<cfloop array="#prc.categories#" index="category">
							<div class="categoryList">
								<!--- mini rss --->
								<a class="floatRight" href="#bb.linkRSS(category=category.getSlug())#" title="RSS Feed For Category"><img src="#bb.layoutRoot()#/includes/images/mini-rss.gif" align="absmiddle" border="0"/></a>
								<!--- Category --->
								<img src="#bb.layoutRoot()#/includes/images/tag_blue.png" alt="Category" /> 
								<a href="#bb.linkCategory(category.getSlug())#" title="Filter by #category.getCategory()#">#category.getCategory()# (#category.getNumberOfEntries()#)</a>
							</div>
						</cfloop>
						
						</div>
					    <p>&nbsp;</p>
					    <div class="clr"></div>
						
						<!--- Custom HTML --->
						#bb.customHTML('afterSideBar')#
						<!--- BlogBoxEvent --->
						#bb.event("bbui_afterSideBar",{renderer=this})#
					</div> <!--- end SideBar --->
						
				</div> <!--- end body_bg --->
    			<div class="clr"></div>
  			</div> <!--- end body --->
		</div> <!--- end body_resize --->
	
		<!--- bootom menubar --->
		<div class="FBG">
			<div class="FBG_resize">
				<!--- BlogBoxEvent --->
				#bb.event("bbui_beforeBottomBar",{renderer=this})#
				<div class="left">
				  <h2>About</h2>
				  <ul>
				    <li><a href="##">Overview</a></li>
				    <li> <a href="##">Another Link</a></li>
				    <li> <a href="##">Our Company</a></li>
				    <li> <a href="##">Our Staff</a></li>
				    <li> <a href="##">Mission </a></li>
				    <li> <a href="##">Statement</a></li>
				  </ul>
				</div>
				<div class="left">
				  <h2>Services</h2>
				  <ul>
				    <li><a href="##">First Service</a></li>
				    <li> <a href="##">Second Service</a></li>
				    <li> <a href="##">Another Service</a></li>
				    <li> <a href="##">A Fourth Service</a></li>
				  </ul>
				</div>
				<div class="left">
				  <h2>Media</h2>
				  <ul>
				    <li><a href="##">Image Gallery</a></li>
				    <li> <a href="##">Video Gallery</a></li>
				    <li> <a href="##">Audio Files</a></li>
				    <li> <a href="##">The Podcast</a></li>
				  </ul>
				</div>
				<div class="left">
				  <h2>Blog</h2>
				  <ul>
				    <li><a href="##">Category One</a></li>
				    <li> <a href="##">Category 2</a></li>
				    <li> <a href="##">Another Category</a></li>
				    <li> <a href="##">Category</a></li>
				    <li> <a href="##">A Fifth Category</a></li>
				  </ul>
				</div>
				<div class="left">
				  <h2>More Links</h2>
				  <ul>
				    <li><a href="##">Sign Up Now</a></li>
				    <li> <a href="##">We Are Hiring</a></li>
				    <li> <a href="##">Terms &amp; Conditions</a></li>
				    <li> <a href="##">Privacy Policy</a></li>
				  </ul>
				</div>
				<div class="left">
				  <h2>Contact Us</h2>
				  <ul>
				    <li><a href="##">Email Sales</a></li>
				    <li> <a href="##">Email Support</a></li>
				    <li> <a href="##">Phone: 555-555-3211</a></li>
				    <li> <a href="##">Send Us Feedback</a></li>
				  </ul>
				</div>
				<div class="clr"></div>
				<!--- BlogBoxEvent --->
				#bb.event("bbui_afterBottomBar",{renderer=this})#
			</div> <!--- end fbg-resize --->
			<div class="clr"></div>
		</div> <!--- end bottom bar --->
		
		<!--- footer --->
		<div class="footer">
			<div class="footer_resize">
				<p class="leftt"><a href="##">Home</a></p>
				<p class="right">(DT) <a href="http://www.dreamtemplate.com" title="Awesome Templates!"><strong>Website Templates</strong></a></p>
				<div class="clr"></div>
			</div>
			<!--- BlogBoxEvent --->
			#bb.event("bbui_footer",{renderer=this})#
			<div class="clr"></div>
		</div> <!--- end footer --->
	
	<!--- Custom HTML --->
	#bb.customHTML('beforeBodyEnd')#
	<!--- BlogBoxEvent --->
	#bb.event("bbui_beforeBodyEnd",{renderer=this})#	
</body>
</html>
</cfoutput>