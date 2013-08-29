<cfoutput>
A new entry has been created on your system by @entryAuthor@ (<a href="mailto:@entryAuthorEmail@">@entryAuthorEmail@</a>) : <a href="@entryURL@">@entryTitle@</a>.

<hr>
<p>&nbsp;</p>

<strong>Title:</strong> @entryTitle@<br>
<strong>URL:</strong> <a href="@entryURL@">@entryURL@</a><br>
<strong>Published:</strong> @entryIsPublished@ on @entryPublishedDate@<br>
<strong>Expires:</strong> @entryExpireDate@<br>
<strong>Excerpt:</strong> <br>
@entryExcerpt@
</cfoutput>