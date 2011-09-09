<cfoutput>
A new comment has been posted and needs moderation on the page: <a href="@entryURL@">@entryTitle@<a/>. 
	
<br/><br/>

Author: @author@ <br/>
Author Email: @AuthorEmail@ <br/>
Author URL: <a href="@authorURL@">@authorURL@</a> <br/>
Author IP: @authorIP@ <br/>
Whois  : <a href="@whoisURL@=@authorIP@">@whoisURL@=@authorIP@</a> <br/>
Comment:<br/>
@content@
<br/><br/>

Approve it: <a href="@deleteURL@">@approveURL@</a><br/>
Delete it: <a href="@deleteURL@">@deleteURL@</a><br/>
Comment URL: <a href="@commentURL@">@commentURL@</a><br/>
</cfoutput>