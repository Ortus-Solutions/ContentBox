/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Interface to implement ContentBox editors
 */
interface {

	/**
	 * Get the internal name of an editor
	 */
	function getName();

	/**
	 * Get the display name of an editor
	 */
	function getDisplayName();

	/**
	 * This is fired once editor javascript loads, you can use this to return back functions, asset calls, etc.
	 * return the appropriate JavaScript.
	 * Each editor must implement the following JS functions:
	 * checkIsDirty() - Checks if the editor has detected any changes<br>
	 * getEditorContent() - Get's the HTML value of the content field<br>
	 * getEditorExcerpt() - Get's the HTML value of the excerpt field<br>
	 * updateEditorContent() - Updates the HTML value of the content field from the editor (if editor supports it)<br>
	 * updateEditorExcerpt() - Updates the HTML value of the excerpt field from the editor (if editor supports it)<br>
	 */
	function loadAssets();

	/**
	 * Startup the editor(s) on a page. This method is called inline within our dynamic JavaScript and must
	 * return the appropriate JavaScript to turn on the editor.
	 */
	function startup();

	/**
	 * Shutdown the editor(s) on a page.  This method is called inline within our dynamic JavaScript and must
	 * return the appropriate JavaScript to turn off the editor.
	 */
	function shutdown();

}
