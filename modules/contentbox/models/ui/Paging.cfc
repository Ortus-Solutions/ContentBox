<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author      :	Luis Majano
Date        :	01/10/2008
License		: 	Apache 2 License
Description :
	A paging model.
	
To use this model you need to create some settings in your coldbox.xml and some
css entries.

COLDBOX SETTINGS
- PagingMaxRows : The maximum number of rows per page.
- PagingBandGap : The maximum number of pages in the page carrousel

CSS SETTINGS:
.pagingTabs - The div container
.pagingTabsTotals - The totals
.pagingTabsCarrousel - The carrousel

To use. You must use a "page" variable to move from page to page.
ex: index.cfm?event=users.list&page=2

In your handler you must calculate the boundaries to push into your paging query.
<cfset rc.boundaries = getInstance( "paging" ).getBoundaries()>
Gives you a struct:
[startrow] : the startrow to use
[maxrow] : the max row in this recordset to use.
Ex: [startrow=11][maxrow=20] if we are using a PagingMaxRows of 10

To RENDER:
#getInstance( "paging" ).renderit(FoundRows,link)#

FoundRows = The total rows found in the recordset
link = The link to use for paging, including a placeholder for the page @page@
	ex: index.cfm?event=users.list&page=@page@
----------------------------------------------------------------------->
<cfcomponent hint="A paging object for ContentBox" output="false" accessors="true">

	<!--- DI --->
	<cfproperty name="controller" inject="coldbox">

	<!---Properties --->
	<cfproperty name="pagingMaxRows">
	<cfproperty name="PagingBandGap">
	
<!------------------------------------------- CONSTRUCTOR ------------------------------------------->	
   
    <cffunction name="init" access="public" returntype="Paging" output="false">
		<cfargument name="settingService" required="true" inject="id:settingService@cb"/>
		<cfscript>

  		// Setup Paging Properties
  		setPagingMaxRows( arguments.settingService.getSetting( "cb_paging_maxrows" ) );
  		setPagingBandGap( arguments.settingService.getSetting( "cb_paging_bandgap" ) );
  		
  		//Return instance
  		return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->	
	
	<!--- Get boundaries --->
	<cffunction name="getboundaries" access="public" returntype="struct" hint="Calculate the startrow and maxrow" output="false" >
		<cfargument name="pagingMaxRows" required="false" type="numeric" hint="You can override the paging max rows here.">
		<cfscript>
			var boundaries 	= structnew();
			var event 		= getController().getRequestService().getContext();
			var maxRows 	= getPagingMaxRows();
			
			// Check for Overrides
			if( structKeyExists( arguments, "PagingMaxRows" ) ){
				maxRows = arguments.pagingMaxRows;
			}
						
			boundaries.startrow = ( event.getValue( "page",1 ) * maxrows - maxRows ) + 1;
			boundaries.maxrow = boundaries.startrow + maxRows - 1;
		
			return boundaries;
		</cfscript>
	</cffunction>
	
	<!--- render paging --->
	<cffunction name="renderit" access="public" returntype="any" hint="render tabs" output="false" >
		<!--- ***************************************************************** --->
		<cfargument name="foundRows"    	required="true"  type="numeric" hint="The found rows to page">
		<cfargument name="link"   			required="true"  type="string"  hint="The link to use, you must place the @page@ place holder so the link ca be created correctly">
		<cfargument name="pagingMaxRows" 	required="false" type="numeric" hint="You can override the paging max rows here.">
		<cfargument name="asList"			required="false" type="boolean" default="false" hint="Render the paging links as lists or not"/>
		<!--- ***************************************************************** --->
		<cfset var event = getController().getRequestService().getContext()>
		<cfset var pagingTabs = "">
		<cfset var maxRows = getPagingMaxRows()>
		<cfset var bandGap = getPagingBandGap()>
		<cfset var totalPages = 0>
		<cfset var theLink = arguments.link>
		<!--- Paging vars --->
		<cfset var currentPage = event.getValue( "page",1)>
		<cfset var pageFrom = 0>
		<cfset var pageTo = 0>
		<cfset var pageIndex = 0>
		
		<!--- Override --->
		<cfif structKeyExists(arguments, "pagingMaxRows" )>
			<cfset maxRows = arguments.pagingMaxRows>
		</cfif>
		
		<!--- Only page if records found --->
		<cfif arguments.FoundRows neq 0>
			<!--- Calculate Total Pages --->
			<cfset totalPages = Ceiling( arguments.FoundRows / maxRows )>
			
			<cfif currentPage gt totalPages>
				<cflocation url="#replace(theLink,"@page@",totalPages)#" addtoken="false">
			</cfif>	
			
			<!--- ***************************************************************** --->
			<!--- Paging Tabs 														--->
			<!--- ***************************************************************** --->
			<cfsavecontent variable="pagingtabs">
			<cfoutput>
			<div class="row">
				<div class="col-xs-6">
					<cfset start = ((currentPage*maxRows)-maxRows)+1>
					<cfset end = currentPage*maxRows GT foundRows ? foundRows : currentPage*maxRows>
					<div class="dataTables_info" role="alert" aria-live="polite" aria-relevant="all">Showing #start# to #end# of #arguments.FoundRows# entries (#totalPages# pages)
					</div>
				</div>
				<div class="col-xs-6">
					<div class="dataTables_paginate paging_simple_numbers">
						<cfif arguments.asList><ul class="pagination"></cfif>
						
						<!--- PREVIOUS PAGE --->
						<cfif currentPage-1 gt 0>
							<cfif arguments.asList><li class="paginate_button previous" aria-controls="pages" tabindex="0" id="pages_previous"></cfif>
							<a href="#replace(theLink,"@page@",currentPage-1)#" title="Previous Page">&lt;&lt;</a>
							<cfif arguments.asList></li></cfif>
						</cfif>
						
						<!--- Calcualte PageFrom Carrousel --->
						<cfset pageFrom=1>
						<cfif (currentPage-bandGap) gt 1>
							<cfset pageFrom=currentPage-bandgap>
							<cfif arguments.asList><li class="paginate_button" aria-controls="pages" tabindex="0"></cfif>
							<a href="#replace(theLink,"@page@",1)#">1</a>
							<a href="javascript:void(0)">...</a>
							<cfif arguments.asList></li></cfif>
						</cfif>
						
						<!--- Page TO of Carrousel --->
						<cfset pageTo=currentPage+bandgap>
						<cfif (currentPage+bandgap) gt totalPages>
							<cfset pageTo=totalPages>
						</cfif>
						<cfloop index="pageIndex" from="#pageFrom#" to="#pageTo#">
							<cfif arguments.asList><li class="paginate_button <cfif currentPage eq pageIndex> active"</cfif>" aria-controls="pages" tabindex="0"></cfif>
							<a href="#replace(theLink,"@page@",pageIndex)#"
							   <cfif currentPage eq pageIndex>class="selected active"</cfif>>#pageIndex#</a>
							<cfif arguments.asList></li></cfif>
						</cfloop>
						
						<!--- End Token --->
						<cfif (currentPage+bandgap) lt totalPages>
							<cfif arguments.asList><li class="paginate_button" aria-controls="pages" tabindex="0"></cfif>
							<a href="javascript:void(0)">...</a>
							<a href="#replace(theLink,"@page@",totalPages)#">#totalPages#</a>
							<cfif arguments.asList></li></cfif>
						</cfif>
						
						<!--- NEXT PAGE --->
						<cfif currentPage lt totalPages >
							<cfif arguments.asList><li class="paginate_button next" aria-controls="pages" tabindex="0" id="pages_next"></cfif>
							<a href="#replace(theLink,"@page@",currentPage+1)#" title="Next Page">&gt;&gt;</a>
							<cfif arguments.asList></li></cfif>
						</cfif>
						
						<cfif arguments.asList></ul></cfif>
					</div>
					<!---
					<div class="dataTables_paginate paging_simple_numbers">
						<cfif arguments.asList><ul class="pagination"></cfif>
							<li class="paginate_button previous disabled" aria-controls="pages" tabindex="0" id="pages_previous"><a href="#">Previous</a>
							</li>
							<li class="paginate_button active" aria-controls="pages" tabindex="0"><a href="#">1</a>
							</li>
							<li class="paginate_button next disabled" aria-controls="pages" tabindex="0" id="pages_next"><a href="#">Next</a>
							</li>
						</ul>
					</div>
					--->
				</div>
			</div>	
			<!---
			<div class="pagingTabs pagination pagination-small">
				
				<div class="pagingTabsTotals">
					<span class="label label-info">Total Records: #arguments.FoundRows# &nbsp;</span>
					<span class="label label-info">Total Pages: #totalPages#</span>
				</div>
				
				<div class="pagingTabsCarrousel">
					<cfif arguments.asList><ul></cfif>
					
					<!--- PREVIOUS PAGE --->
					<cfif currentPage-1 gt 0>
						<cfif arguments.asList><li></cfif>
						<a href="#replace(theLink,"@page@",currentPage-1)#" title="Previous Page">&lt;&lt;</a>
						<cfif arguments.asList></li></cfif>
					</cfif>
					
					<!--- Calcualte PageFrom Carrousel --->
					<cfset pageFrom=1>
					<cfif (currentPage-bandGap) gt 1>
						<cfset pageFrom=currentPage-bandgap>
						<cfif arguments.asList><li></cfif>
						<a href="#replace(theLink,"@page@",1)#">1</a>
						<a href="javascript:void(0)">...</a>
						<cfif arguments.asList></li></cfif>
					</cfif>
					
					<!--- Page TO of Carrousel --->
					<cfset pageTo=currentPage+bandgap>
					<cfif (currentPage+bandgap) gt totalPages>
						<cfset pageTo=totalPages>
					</cfif>
					<cfloop index="pageIndex" from="#pageFrom#" to="#pageTo#">
						<cfif arguments.asList><li></cfif>
						<a href="#replace(theLink,"@page@",pageIndex)#"
						   <cfif currentPage eq pageIndex>class="selected active"</cfif>>#pageIndex#</a>
						<cfif arguments.asList></li></cfif>
					</cfloop>
					
					<!--- End Token --->
					<cfif (currentPage+bandgap) lt totalPages>
						<cfif arguments.asList><li></cfif>
						<a href="javascript:void(0)">...</a>
						<a href="#replace(theLink,"@page@",totalPages)#">#totalPages#</a>
						<cfif arguments.asList></li></cfif>
					</cfif>
					
					<!--- NEXT PAGE --->
					<cfif currentPage lt totalPages >
						<cfif arguments.asList><li></cfif>
						<a href="#replace(theLink,"@page@",currentPage+1)#" title="Next Page">&gt;&gt;</a>
						<cfif arguments.asList></li></cfif>
					</cfif>
					
					<cfif arguments.asList></ul></cfif>
				</div>
									
			</div>
			--->
			</cfoutput>
			</cfsavecontent>
		</cfif>
	
		<cfreturn pagingTabs>
	</cffunction>
    
<!------------------------------------------- PRIVATE ------------------------------------------->	

</cfcomponent>