<cfoutput>
<div class="panel panel-primary">

	<!--- Installer Heading --->
	<div class="panel-heading">
		<h3 class="panel-title">
			<i class="fa fa-lightbulb"></i> #cb.r( "labels.wizard@installer" )#
		</h3>
	</div>

	<!--- Installer Body --->
    <div class="panel-body p30">
        #html.startForm(
            action 		= "cbinstaller/install",
            name 		= "installerForm",
            novalidate 	= "novalidate",
            class 		= "form-vertical"
        )#
            <div class="tabs">
                <!--- Tabs --->
                <ul class="nav nav-tabs" id="tabs" role="tablist">
					<li class="nav-item active">
						<a href="##introduction" class="nav-link" data-toggle="tab">
							#cb.r( "tab.intro@installer" )#
						</a>
					</li>
					<li class="nav-item">
						<a href="##step1" data-toggle="tab" class="nav-link">
							1: #cb.r( "tab.admin@installer" )#
						</a>
					</li>
					<li class="nav-item">
						<a href="##step2" data-toggle="tab" class="nav-link">
							2: #cb.r( "tab.site@installer" )#
						</a>
					</li>
					<li class="nav-item">
						<a href="##step3" data-toggle="tab" class="nav-link">
							3: #cb.r( "tab.email@installer" )#
						</a>
					</li>
					<li class="nav-item">
						<a href="##step4" data-toggle="tab" class="nav-link">
							4: #cb.r( "tab.rewrites@installer" )#
						</a>
					</li>
                </ul>

                <div class="tab-content">
                    <!--- ****************************************************************************** --->
                    <!--- Intro Panel --->
                    <!--- ****************************************************************************** --->
                    <div class="jumbotron tab-pane active" id="introduction">
                    	<div class="text-center">
                    		<img src="#prc.assetRoot#/includes/images/ContentBox_300.png" />
                    	</div>
                        <p>#cb.r( "tab.intro.message@installer" )#</p>
                        <div class="text-center">
	                        <a href="javascript:nextStep()" class="btn btn-primary btn-lg">
	                            <i class="fa fa-check"></i> #cb.r( "tab.intro.start@installer" )#
	                        </a>
                    	</div>
                    </div>
                    <!--- end panel 1 --->

                    <!--- ****************************************************************************** --->
                    <!--- Step 1 : Admin Setup--->
                    <!--- ****************************************************************************** --->
                    <div class="tab-pane" id="step1">
                        #view( view="home/steps/step1", prePostExempt = true )#
                    </div>

                    <!--- ****************************************************************************** --->
                    <!--- Step 2 : Site Setup--->
                    <!--- ****************************************************************************** --->
                    <div class="tab-pane" id="step2">
                        #view( view="home/steps/step2", prePostExempt = true )#
                    </div>

                    <!--- ****************************************************************************** --->
                    <!--- Step 3 : Email Setup--->
                    <!--- ****************************************************************************** --->
                    <div class="tab-pane" id="step3">
                        #view( view="home/steps/step3", prePostExempt = true )#
                    </div>

                    <!--- ****************************************************************************** --->
                    <!--- Step 4 : Site URL Rewrites --->
                    <!--- ****************************************************************************** --->
                    <div class="tab-pane" id="step4">
                        #view( view="home/steps/step4", prePostExempt = true )#
                    </div>

                    <!---Error Bar --->
                    <div id="errorBar"></div>
                </div>
                <!--- End Tab Content --->
            </div>
        #html.endForm()#
    </div>
</div>
</cfoutput>
