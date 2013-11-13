<cfoutput>
A new content store object has been created on your system by @contentAuthor@ (<a href="mailto:@contentAuthorEmail@">@contentAuthorEmail@</a>) : <a href="@contentURL@">@contentTitle@</a>.

<hr>
<p>&nbsp;</p>

<strong>Title:</strong> @contentTitle@<br>
<strong>Description:</strong> @contentDescription@</br>
<strong>Published:</strong> @contentIsPublished@ on @contentPublishedDate@<br>
<strong>Expires:</strong> @contentExpireDate@<br>
<strong>Excerpt:</strong> <br>
@contentExcerpt@
</cfoutput>