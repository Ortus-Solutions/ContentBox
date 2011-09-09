<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--============================Head============================-->
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="robots" content="noindex,nofollow" />	
	<!--- SES --->
	<base href="#getSetting('htmlBaseURL')#" />
<!--=========Title=========-->
    <title>ColdBox Relax - RESTful Tools For Lazy Experts</title> 
<!--=========Stylesheets=========-->
	<link href="#prc.bbRoot#/includes/css/style.css"	 	rel="stylesheet" type="text/css"/>
	<link href="#prc.bbRoot#/includes/css/teal.css" 		rel="stylesheet" type="text/css"/>
	<link href="#prc.bbRoot#/includes/css/invalid.css" 	rel="stylesheet" type="text/css"/>
    <link href="#prc.bbRoot#/includes/css/sort.css"	 	rel="stylesheet" type="text/css"/>
	        
<!--========= JAVASCRIPT -->
	<script type="text/javascript" src="#prc.bbRoot#/includes/javascript/jquery-1.4.4.min.js"></script> <!--Import jquery tools-->
	<script type="text/javascript" src="#prc.bbRoot#/includes/javascript/jquery.tools.min.js"></script> <!--Import jquery tools-->
	<script type="text/javascript" src="#prc.bbRoot#/includes/javascript/jquery.uitablefilter.js"></script>
	<script type="text/javascript" src="#prc.bbRoot#/includes/javascript/metadata.pack.js"></script>
	<script type="text/javascript" src="#prc.bbRoot#/includes/javascript/tablesorter.min.js"></script>
	<script type="text/javascript" src="#prc.bbRoot#/includes/javascript/relax.js"></script>
</head>
<!--End Head-->
<!--============================Body============================-->
<body>

<!--==================== Header =======================-->
<div id="header_bg">

	<!--============Header Wrapper============-->
	<div class="wrapper">
       
		<!--=======Top Header area======-->
		<div id="header_top">
			<span class="fr">
		  		<a href="http://www.ortussolutions.com">OrtusSolutions.com</a>
				<a href="http://www.coldbox.org">ColdBox.org</a>
				<a href="http://www.github.com/coldbox/coldbox-relax">Github Repo</a>
				<a href="http://www.twitter.com/coldbox">Twitter</a>
			</span>
		  RESTful Tools For Lazy Experts
		</div>
		<!--End Header top Area=-->
    
		<!--=========Header Area including search field and logo=========-->
		<div id="logo">
			<img src="#prc.bbRoot#/includes/images/ColdBoxLogoSquare_125.png" border="0" alt="logo" />
		</div>
		
		<div id="header_main" class="clearfix">
           	<h1>Relax <span>v1</span></h1>		
		</div>
		<!--End Search field and logo Header Area-->
      
		<!--=========Main Navigation=========-->
		<ul id="main_nav">
			<li> <a href="##" class="current">Dashboard</a>
				<ul>
					<li><a href="##" class="current">Home</a></li>
					<li><a href="##" class="confirmIt">Open Modal</a></li>
				</ul>
			</li>
			<li><a href="##">Forms</a>
				<ul>
					<li><a href="##">Example Link 1</a></li>
					<li><a href="##">Example Link 2</a></li>
				</ul>
			</li>
			<li><a href="##">Messages</a>
				<ul>
					<li><a href="##">Example Link 1</a></li>
					<li><a href="##">Example Link 2</a></li>
					<li><a href="##">Example Link 3</a></li>
					<li><a href="##">Example Link 4</a></li>
					<li><a href="##">Example Link 5</a></li>
				</ul>
			</li>
		</ul>
		<!--End Main Navigation-->
        
		
		<!--=========Jump Menu=========-->
		<!---
        <div class="jump_menu">
            <a href="##" class="jump_menu_btn">Jump To</a>
            <ul class="jump_menu_list">
                <li><a href="##"><img src="#prc.bbRoot#/includes/images/users2_icon.png" alt="" width="24" height="24" />Users</a></li>
                <li><a href="##"><img src="#prc.bbRoot#/includes/images/tools_icon.png" alt="" width="24" height="24" />Settings</a></li>
                <li><a href="##"><img src="#prc.bbRoot#/includes/images/messages_icon.png" alt="" width="24" height="24" />Messages</a></li>
                <li><a href="##"><img src="#prc.bbRoot#/includes/images/key_icon.png" alt="" width="24" height="24" />Credentials</a></li>
                <li><a href="##"><img src="#prc.bbRoot#/includes/images/documents_icon.png" alt="" width="24" height="24" />Pages</a></li>
            </ul>
        </div>
		--->
		<!--End Jump Menu-->
    
  	</div>
  <!--End Wrapper-->
</div>
<!--End Header-->

<!--============================ Template Content Background ============================-->
<div id="content_bg" class="clearfix">

<!--============================ Main Content Area ============================-->
<div class="content wrapper clearfix">
	<!--============================Sidebar============================-->
	<div class="sidebar">
		<!--=========History Box=========-->
		<div class="small_box">
			<div class="header">
				<img src="#prc.bbRoot#/includes/images/history_icon.png" alt="History" width="24" height="24" />History
			</div>
			<div class="body">
				<ul class="bulleted_list">
					<li><a href="@">Lorem ipsum dolor sit amet,<br />
						consectetur</a></li>
					<li><a href="@">Excepteur sint occaecat cupidatat</a></li>
				</ul>
			</div>
		</div>
		<!--End History Box-->
		<!--=========Calendar Box=========-->
		<div class="small_box">
			<div class="header">
				<img src="#prc.bbRoot#/includes/images/calendar_icon.png" alt="Calendar" width="24" height="24" />Calendar
			</div>
			<div class="body">
				<div id="date" class="clearfix">
				</div>
				<!--Date picker applied to any div of date id-->
			</div>
		</div>
		<!--End Calendar Box-->
		<!--=========Users Box=========-->
		<div class="small_box">
			<div class="header">
				<img src="#prc.bbRoot#/includes/images/users_icon.png" alt="History" width="24" height="24" />Online Users
			</div>
			<div class="body">
				<ul class="user_list">
					<li><img src="#prc.bbRoot#/includes/images/user_placeholder.gif" width="54" height="54" alt="Username" /><a href="##">John Doe</a><small>Administrator</small></li>
					<li><img src="#prc.bbRoot#/includes/images/user_placeholder.gif" width="54" height="54" alt="Username" /><a href="##">John Doe</a><small>Administrator</small></li>
				</ul>
			</div>
		</div>
		<!--End Users Box-->
		<!--========= Accordion Box =========-->
		<div class="small_box clearfix">
			<div class="header">
				<img src="#prc.bbRoot#/includes/images/accordion_icon.png" alt="Accordion" width="24" height="24" />Accordion
			</div>
			<div class="body">
				<!--=== Accordion ===-->
				<div id="accordion" class="clearfix">
					<!-- Accordion 1 -->
					<h2 class="current"> <img src="#prc.bbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" /> <img src="#prc.bbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" /> First pane </h2>
					<div class="pane">
						<!-- All div's with a class of .pane will become accordion panes -->
						<ul>
							<li>Sub Menu Item</li>
							<li>Sub Menu Item</li>
							<li>Sub Menu Item</li>
						</ul>
					</div>
					<!-- Accordion 2-->
					<h2> <img src="#prc.bbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" /> <img src="#prc.bbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" /> Second pane </h2>
					<div class="pane">
						<ul>
							<li>Sub Menu Item</li>
							<li>Sub Menu Item</li>
							<li>Sub Menu Item</li>
						</ul>
					</div>
					<!-- Accordion 3 -->
					<h2> <img src="#prc.bbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" /> <img src="#prc.bbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" /> Third pane </h2>
					<div class="pane">
						<ul>
							<li>Sub Menu Item</li>
							<li>Sub Menu Item</li>
							<li>Sub Menu Item</li>
						</ul>
					</div>
				</div>
				<!--End Accordion-->
			</div>
		</div>
		<!--End Accordion Box-->
	</div>
	<!--End sidebar-->
	<!--============================Main Column============================-->
	<div class="main_column">
		<!--=========Graph Box=========-->
		<div  class="box expose">
			<!-- A box with class of expose will call expose plugin automatically -->
			<div class="header">
				<small class="fr">Click anywhere on this box to expose it</small>
			Graph
			
			</div>
			<div class="body">
				<table width="100%" class="graph">
					<!-- Any table with the class ".graph" will be converted into a graph using visualize plugin -->
					<thead>
						<tr>
							<td></td>
							<th scope="col">food</th>
							<th scope="col">auto</th>
							<th scope="col">household</th>
							<th scope="col">furniture</th>
							<th scope="col">kitchen</th>
							<th scope="col">bath</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th scope="row">Mary</th>
							<td>190</td>
							<td>160</td>
							<td>40</td>
							<td>120</td>
							<td>30</td>
							<td>70</td>
						</tr>
						<tr>
							<th scope="row">Tom</th>
							<td>3</td>
							<td>40</td>
							<td>30</td>
							<td>45</td>
							<td>35</td>
							<td>49</td>
						</tr>
						<tr>
							<th scope="row">Brad</th>
							<td>10</td>
							<td>180</td>
							<td>10</td>
							<td>85</td>
							<td>25</td>
							<td>79</td>
						</tr>
						<tr>
							<th scope="row">Kate</th>
							<td>40</td>
							<td>80</td>
							<td>90</td>
							<td>25</td>
							<td>15</td>
							<td>119</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<!--End Graph Box-->
		
		<!--=========Tables Box=========-->
		<div class="box">
			<div class="header">
				<!--===Sub Navigation===-->
				<ul class="sub_nav">
					<!-- To make tabs in box header, just use "sub_nav" class on UL -->
					<li title="Data Table Example"><a href="##" class="current">Data Table</a></li>
					<li title="A simple table with minimum styling"><a href="##">Simple Table</a></li>
					<li title="Click on any row in the table to expand it"><a href="##">Expandable Table With Pagination</a></li>
				</ul>
				<!--End sub navigation-->
				<img src="#prc.bbRoot#/includes/images/tables_icon.png" alt="Accordion" width="30" height="30" />Tables
			</div>
			<div class="body">
				<div class="panes">
					<!-- Any div under the class of "panes" will associate itself in the same order as the tabs defined above under "sub_nav"-->
					<!-- Pane 1 -->
					<div class="clearfix">
					Pane 1
					</div>
					<!-- Pane 2 -->
					<div>
						Pane 2
					</div>
					<!-- Pane 3 -->
					<div>
						Pane 3
					</div>
				</div>
			</div>
		</div>
		<!--End Tables Box-->
		
	</div>
	<!--End Main Column-->
	<!--=======================Forms and Further Sub-Navigations==========================-->
	<div class="box clear">
		<div class="header">
			<img src="#prc.bbRoot#/includes/images/tables_icon.png" alt="Accordion" width="30" height="30" />Forms &amp; Typography
		</div>
		<div class="body_vertical_nav clearfix">
			<!-- Grey backgound applied to box body -->
			<!-- Vertical nav -->
			<ul class="vertical_nav">
				<li class="active"><a href="##">Forms</a></li>
				<li><a href="##">Typography</a></li>
				<li><a href="##">More Horizontal Tabs</a></li>
				<li><a href="##">Editor</a></li>
			</ul>
			<div class="main_column">
				<!-- Content area that wil show the form and stuff -->
				<div class="panes_vertical">
					<!-- All divs inside this div will become panes for navigation above -->
					<div>
						<!-- First Pane -->
						<!--=========Forms=========-->
						<form action="##" method="post">
							<fieldset>
								<legend>Fieldset Legend</legend>
								<p>
									<label>Text field:</label>
									<input name="textfield2" type="text" class="textfield" />
									<span class="form_hint">Form Hint</span> <small>This is a normal text field</small></p>
								<p>
									<label>Medium Textfield:</label>
									<input name="textfield2" type="text" class="textfield med" />
									<small>This is a medium sized text field</small></p>
								<p>
									<label>Textfield with Error:</label>
									<input name="textfield4" type="text" class="textfield med error" />
									<span class="form_error">Form Error</span> <small>This is a large textfield with error</small></p>
								<p>
									<input type="checkbox" name="checkbox" id="checkbox" />
									This is a check box</p>
								<p>
									<input type="radio" name="radio" />
									This is an option box
									<input type="radio" name="radio" />
									This is an option box
									<label>Dropdown:</label>
									<select name="select" id="select">
										<option>This is a dropdown</option>
										<option>Another Value</option>
										<option>And Another Value</option>
									</select>
								</p>
								<p>
									<label>Multi Line Textfield:</label>
									<textarea name="textfield3" rows="8" cols="5" id="textfield3">
</textarea>
								</p>
								<p>
									<input name="button2" type="submit" class="button2" id="button2" value="Submit" />
									<input name="button" type="submit" class="button" id="button" value="Cancel" />
								</p>
							</fieldset>
						</form>
					</div>
					<div>
						<!-- Second Pane -->
						<!--=========Typography=========-->
						<h1>Heading 1</h1>
						<p>Lorem ipsum dolor sit amet, <a href="##">consectetur</a> adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo <a href="##">consequat</a>. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
						<h2>Heading 2</h2>
						Lorem ipsum dolor sit amet, <a href="##">consectetur</a> adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo <a href="##">consequat</a>. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
						<blockquote>
							<p>Lorem ipsum dolor sit amet, <a href="##">consectetur</a> adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo <a href="##">consequat</a>.</p>
						</blockquote>
						<p>Lorem ipsum dolor sit amet, <a href="##">consectetur</a> adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo <a href="##">consequat</a>.</p>
						<h3>Heading 3</h3>
						<ul>
							<li>Lorem ipsum dolor sit amet,</li>
							<li>consectetur adipisicing elit</li>
							<li>sed do eiusmod tempor incididunt</li>
						</ul>
						<h4>Heading 4</h4>
						<ol>
							<li>Lorem ipsum dolor sit amet,</li>
							<li>consectetur adipisicing elit</li>
							<li>sed do eiusmod tempor incididunt</li>
						</ol>
						<h5>Heading 5</h5>
						<ul class="bulleted_list">
							<li>Lorem ipsum dolor sit amet,</li>
							<li>consectetur adipisicing elit</li>
							<li>sed do eiusmod tempor incididnt</li>
						</ul>
						<h6>Heading 6</h6>
						<p>Lorem ipsum dolor sit amet, <a href="##">consectetur</a> adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo <a href="##">consequat</a>. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
						<p>Â </p>
						<hr />
						<!-- Heading with borders -->
						<h1 class="border_blue">Heading 1 with border style</h1>
						<h2 class="border_lt_blue">Heading 2 with another border style</h2>
						<h3 class="border_grey">Heading 3 with yet another border style</h3>
					</div>
					<div>
						<!-- Third Pane -->
						<ul class="horizontal_nav">
							<li class="active"><a href="##">Tab1 With Long Text</a></li>
							<li><a href="##">Tab 2</a></li>
							<li><a href="##">Tab 3</a></li>
							<li><a href="##">Tab 4</a></li>
						</ul>
						Lorem ipsum dolor sit amet, <a href="##">consectetur</a> adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo <a href="##">consequat</a>. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
					</div>
					<!-- Fourth Pane -->
					<div>
						<form action="##">
							<div>
								<textarea name="textfield3" rows="8" cols="50" id="wysiwyg" class="wysiwyg"></textarea>
								<!-- WYSIWYG Editor -->
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!--End Forms and Sub-Nav's Box-->
	<!--=========Containers for boxes which are placed side by side=========-->
	<!--=========Container Box on the left=========-->
	<div class="box column-left">
		<!--Begin Box-->
		<div class="header">
			<p><img src="#prc.bbRoot#/includes/images/half_width_icon.png" alt="Half Width Box" width="30" height="30" />Half Width</p>
		</div>
		<div class="body">
			Lorem ipsum dolor sit amet, <a href="##">consectetur</a> adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo <a href="##">consequat</a>. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
		</div>
	</div>
	<!--=========Container for Box on the Right=========-->
	<div class="box column-right">
		<!--Begin Box-->
		<div class="header">
			<p><img src="#prc.bbRoot#/includes/images/half_width_icon.png" alt="Half Width Box" width="30" height="30" />Half Width</p>
		</div>
		<div class="body">
			<ul class="bulleted_list">
				<li>Lorem ipsum dolor sit amet,</li>
				<li>consectetur adipisicing elit</li>
				<li>sed do eiusmod tempor incididunt</li>
				<li>ut labore et dolore magna aliqua.</li>
			</ul>
		</div>
	</div>
</div>
<!--End main content area-->
</div>
<!--End Template Content bacground-->



<!--============================Footer============================-->
<div id="footer">
	<div class="wrapper">
	Copyright (C) 2009   Â Your Company  . All Rights Reserved. Powered by <a href="##">Evolution</a>.
	</div>
</div>
<!--End Footer-->

<!--- ============================ confirm it modal dialog ============================ --->
<div id="confirmIt"> 
	<div> 
		<h2 id="confirmItTitle">Are you sure?</h2> 
		<p id="confirmItMessage">Are you sure you want to perform this action?</p> 
		<hr />
		<p class="textRight">
			<button class="close button" 	data-action="cancel"> Cancel </button>
			<button class="close buttonred" data-action="confirm"> Confirm </button>
		</p>
	</div> 
</div>
<!--- ============================ end Confirmit ============================ --->

<!--- ============================ Remote Modal Window ============================ --->
<div id="remoteModal">
	<div id="remoteModelContent">
		<img src="includes/images/ajax-loader-horizontal.gif" title="loading" alt="title" />
	</div>
</div>
<!--- ============================ end Confirmit ============================ --->

</body>
<!--End Body-->
</html>
</cfoutput>