/**
* A Widget to use that uses the SyntaxHighlighter project to format your code
* SyntaxHighlighter URL: http://alexgorbatchev.com/SyntaxHighlighter/
* Credit to Tony Garcia as this is mainly based off the Mango Plugin he wrote
* Tony Garcia Mango Plugin URL: https://github.com/tony-garcia/SyntaxHighlighter-Mango-Plugin
	ContentBox setting:
		shLanguages - comma delimited list of languages you want available, defaults to "AS3,ColdFusion,Java,JScript,Plain,Sql,Xml"
		shTheme - Theme css file to use for highlighting, defaults to "shThemeDefault.css"
	Usage:

	Call the widget and pass it the text you want to format

	#cb.widget('SyntaxHighlighter',{content=prc.entry.getContent()})#

	You designate which language to highlight by using an alias for the language in the opening code tag after a colon. For example,
	the alias for ColdFusion code highlighting is "cf":

	[code:cf]
	<cfset message = "This plugin is really cool!!!" />
	<cfoutput>#message#</cfoutput>
	[/code]

	Here is a list of aliases for all code brushes included in the plugin (also, make sure the brushes you want to use are
	selected in the plugin configuration --see above):

	as3  (ActionScript3)
	bash (Bash)
	cf   (ColdFusion)
	cpp  (C++)
	csharp   (C#)
	css  (CSS)
	delph  (Delphi)
	diff  (Diff, Pascal)
	erlang (Erlang)
	groovy (Groovy)
	java  (Java)
	javafx  (JavaFX)
	js   (JavaScript, JScript)
	perl  (Perl)
	php  (PHP)
	ps  (PowerShell)
	python (Python)
	ruby  (Ruby)
	scala  (Scala)
	sql   (SQL)
	text  (Text)
	vb  (VB, VB.NET)
	xml (XML, XHTML, HTML)
*/
component extends="contentbox.model.ui.BaseWidget" singleton{

	SyntaxHighlighter function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setPluginName("SyntaxHighlighter");
		setPluginVersion("1.0");
		setPluginDescription("A Widget to use that uses the SyntaxHighlighter project to format your code");
		setPluginAuthor("Computer Know How");
		setPluginAuthorURL("www.compknowhow.com");
		setForgeBoxSlug("cbwidget-syntaxhighlighter");

		variables.break = chr(13) & chr(10);
		variables.shLanguagesDefault = "AS3,ColdFusion,Java,JScript,Plain,Sql,Xml";
		variables.shThemeDefault = "shThemeDefault.css";

		return this;
	}

	/**
	* returns the syntax highlighted formatted string and adds assets to page
	* @content The string of HTML to format
	*/
	any function renderIt(string content){
		var rString = arguments.content;
		//check for code block
		if (findNoCase('[code',rString) and findNoCase("[/code]",rString)) {
			addAssets();
			addJS();
			var noMatches = false;
			var startPos = 1;
			while (!noMatches) {
				var startMatch = reFindNoCase("\[code:([-_[:alnum:]]+)\]", rString, startPos, true);
				if (startMatch.len[1] eq 0) {
					noMatches = true;
				} else {
					endMatch = findNoCase("[/code]",rString,startMatch.pos[1] + startMatch.len[1]);
					codeBody = mid(rString,startMatch.pos[1],(endMatch - startMatch.pos[1]) + 7);
					language = mid(rString, startMatch.pos[2], startMatch.len[2]);
					highlightedCode = replaceNoCase(codeBody,"<br />",variables.break,"all");
					highlightedCode = replaceList(highlightedCode,"<p>,</p>,<p></p>,<p> </p>","#variables.break##variables.break#");
					highlightedCode = rereplaceNoCase(highlightedCode,"\[code:([-_[:alnum:]]+)\]",'<pre class="brush: #language#">',"one");
					highlightedCode = replaceNoCase(highlightedCode,"[/code]","</pre>","one");
					rString = replaceNoCase(rString,codeBody,highlightedCode,"all");
					startPos = startMatch.pos[1] + len(codeBody);
				}
			}
		}
		return rString;
	}

	void function addAssets() {
		var assetRoot = cb.widgetRoot() & "/syntaxHighlighter/";
		var assets = arrayNew(1);
		arrayAppend(assets,assetRoot&'styles/shCore.css');
		arrayAppend(assets,assetRoot&'styles/#cb.setting("shTheme",variables.shThemeDefault)#');
		arrayAppend(assets,assetRoot&'scripts/shCore.js');
		var langs = cb.setting("shLanguages",variables.shLanguagesDefault);
		langs = listToArray(langs);
		for (lang in langs) {
			arrayAppend(assets,assetRoot&'scripts/shBrush#lang#.js');
		}
		addAsset(arrayToList(assets));
	}

	void function addJS() {
			var assetRoot = cb.widgetRoot() & "/syntaxHighlighter/";
			var shJS = '
			<script type="text/javascript">
				SyntaxHighlighter.config.clipboardSwf =  "#assetRoot#scripts/clipboard.swf";
				SyntaxHighlighter.all();
			</script>
			';

		$htmlHead(shJS);
	}
}
