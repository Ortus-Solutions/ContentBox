<cfoutput>
<div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container-fluid">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
          <a class="brand" href="#event.buildLink('')#">#cb.siteName()#</a>
          <div class="nav-collapse">
             #cb.quickView('_menu')#
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>
</cfoutput>
<!---

<div class="navbar navbar-fixed-top">
  <div class="navbar-inner">
    <div class="container-fluid">
      <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </a>
      <a class="brand" href="">#cb.siteName()#</a>
      <div class="nav-collapse">
        #cb.quickView('_menu')#
        <!---<p class="navbar-text pull-right">Logged in as <a href="">username</a></p>--->
		
      </div><!--/.nav-collapse -->
    </div>
  </div>
</div>
--->