<!--- Add our cbroot key for our main admin includes --->
<cfoutput>
<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!-->
<html class="no-js">
<!--<![endif]-->
    <cfinclude template="#prc.assetroot#/layouts/inc/HTMLHead.cfm"/>
	<body class="animated fadeIn">

		<!--- Header Container --->
		<section id="container">
            <header id="header">

            	<!--logo start-->
                <div class="brand text-center">
                    <a class="logo">@
                        <img src="#prc.assetroot#/includes/images/ContentBox_90.png"/>
                    </a>
                </div>

                <div class="user-nav">
	                <!--- i18n navbar --->
					<ul class="pull-right">
						<li class="dropdown settings">
							<a href="##" class="dropdown-toggle" data-toggle="dropdown" role="button">
								<i class="fa fa-globe"></i> #cb.r( "lang.localize@cbcore" )# <b class="caret"></b>
								<ul role="menu" class="dropdown-menu">
									<cfloop array="#prc.langs#" index="thisLang">
										<li>
											<a href="#prc.xehLang#/#thisLang#">#cb.r( "lang.#listFirst( thisLang, "_" )#@cbcore" )#</a>
										</li>
									</cfloop>
								</ul>
							</a>
						</li>
					</ul>
				</div>
            </header>
        </section>

		<!--- Simple Container --->
		<section id="simple-container" class="container">
			#renderView()#
		</section>

        <cfinclude template="#prc.cbroot#/layouts/inc/HTMLBodyEnd.cfm"/>
	</body>
	<!--End Body-->
</html>
</cfoutput>