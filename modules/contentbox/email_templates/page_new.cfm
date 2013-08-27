<cfoutput>
A new page has been created on your system by @pageAuthor@ (<a href="mailto:@pageAuthorEmail@">@pageAuthorEmail@</a>) : <a href="@pageURL@">@pageTitle@</a>.

<hr>
<p>&nbsp;</p>

<strong>Title:</strong> @pageTitle@<br>
<strong>URL:</strong> <a href="@pageURL@">@pageURL@</a><br>
<strong>Published:</strong> @pageIsPublished@ on @pagePublishedDate@<br>
<strong>Expires:</strong> @pageExpireDate@<br>
<strong>Excerpt:</strong> <br>
@pageExcerpt@
</cfoutput>