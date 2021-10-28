<cfoutput>
	<div id="body-header" class="bg-light bg-darken-xs">
		<div class="container">
			<!--- Title --->
			<div class="py-4 text-center">
				<h1>Blog</h1>
				<div id="body-search" class="searchBlogPage p-5">
					<!--- Blog Search Form --->
					<form id="searchForm" class="navbar-form navbar-right" name="searchForm" method="post" action="#cb.linkSearch()#">
						<input type="text" class="form-control col-lg-8" placeholder="Search" value="#cb.getSearchTerm()#">
						<button type="submit" class="btn btn-primary">
							Search
						</button>
					</form>
				</div>
			</div>
		</div>
	</div>

	<!--- Body Main --->
	<section id="body-main" class="bg-light bg-darken-xs">
		<div class="container">
			<div class="row">
				<!--- Content --->
				<div class="col-sm-12">

					<!--- ContentBoxEvent --->
					#cb.event( "cbui_preIndexDisplay" )#

					<!--- Are we filtering by category? --->
					<cfif len( rc.category )>
						<p class="infoBar categories">
							Category: <span class="badge badge-category selected">'#encodeForHTML( rc.category )#'</span>
							<a href="#cb.linkBlog()#" class="btn btn-link" title="Remove filter and view all entries"> 
								<svg xmlns="http://www.w3.org/2000/svg" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
								</svg>
								Remove Filter</a>
						</p>

						<br />
					</cfif>

					<!--- Are we searching --->
					<cfif len( rc.q )>
						<p class="buttonBar">
							<a class="btn btn-primary" href="#cb.linkBlog()#" title="Clear search and view all entries">Clear Search</a>
						</p>

						<div class="infoBar">
							Searching by: '#encodeForHTML( rc.q )#'
						</div>

						<br />
					</cfif>
				</div>

				<div class="row">
					<div class="categories col-md-8">
						<p> You may like:
							#cb.quickCategories()#
						</p>
					</div>
					<div class="archives col-md-4">
						<div class="text-right">
							<label>Jump in time:</label>
							<select class="minimal">
								<option value="" disabled="disabled" hidden="hidden">
								Month
								</option> <option value="0">
								January
								</option><option value="1">
									February
								</option><option value="2">
									March
								</option><option value="3">
									April
								</option><option value="4">
									May
								</option><option value="5">
									June
								</option><option value="6">
									July
								</option><option value="7">
									August
								</option><option value="8">
									September
								</option><option value="9">
									October
								</option><option value="10">
									November
								</option><option value="11">
									December
								</option>
							</select>
							
							<select class="minimal">
								<option value="" disabled="disabled" hidden="hidden">
								Year
								</option> <option>
									2021
								</option><option>
									2020
								</option><option>
									2019
								</option><option>
									2018
								</option><option>
									2017
								</option><option>
									2016
								</option><option>
									2015
								</option><option>
									2014
								</option><option>
									2013
								</option><option>
									2012
								</option><option>
									2011
								</option><option>
									2010
								</option><option>
									2009
								</option><option>
									2008
								</option><option>
									2007
								</option>
							</select>
						</div>
					</div>
				</div>
			</div>

			<div class="row">
				<cfif len( prc.entries )>
					<cfset counter = 0 />
					<cfset counterEntries = 0 />
					<cfset totalEntries = ArrayLen( prc.entries ) />

					<!--- Pagination 
					<cfif prc.entriesCount>
						<div class="contentBar pagingTop">
							#cb.quickPaging()#
						</div>
					</cfif>--->

					<cfloop array="#prc.entries#" item="entry" index="x">
						<cfset template = "entry" />
						<cfset counter = counter + 1 />
						<cfset counterEntries = counterEntries + 1 />

						<cfif x eq 1 && len( prc.entries ) gt 1 && rc.page eq 1 && len( rc.q ) eq 0 && len( rc.category ) eq 0>
							<cfset template = "latestEntry" />
							<cfset counter = 0 />
						</cfif>
						
						<cfif counter eq 1 >
							<div class='row row-cols-1 row-cols-md-3 g-4'>
						</cfif>
						
						#cb.quickView(
							view = "../templates/#template#",
							collection = [ entry ],
							collectionAs = "entry"
						)#

						<cfif counter eq 3 || counterEntries eq totalEntries>
							</div>
							
							<cfset counter = 0 />
						</cfif>
						
					</cfloop>
				<cfelse>
					<div class="container">
						No Results Found
					</div>
				</cfif>	
			</div>

			<div>
				<!--- Pagination --->
				<cfif prc.entriesCount>
					<div class="contentBar">
						#cb.quickPaging()#
					</div>
				</cfif>

				<!--- ContentBoxEvent --->
				#cb.event( "cbui_postIndexDisplay" )#
			</div>
		</div>
	</section>
</cfoutput>
