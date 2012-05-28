<cfoutput>
<div class="search">
    <form id="searchForm" name="searchForm" method="post" action="#cb.linkContentSearch()#">
      <label>
      	<span><input name="q" type="text" class="keywords" id="textfield" maxlength="50" value="Search..." onclick="this.value=''"/></span>
        <input name="b" type="image" src="#cb.layoutRoot()#/includes/images/search.gif" class="button" />
      </label>
    </form>
</div>
</cfoutput>				
