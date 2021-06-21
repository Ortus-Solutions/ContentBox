/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * This is the main exporter for exporting content from ContentBox
 */
interface {

	/**
	 * Custom validator for this exporter...any rules can be applied
	 */
	public array function validate();

	/**
	 * Determines if exporter is valid based on validation criteria
	 */
	public boolean function isValid();

	/**
	 * Gets "total" based on content type
	 */
	public numeric function getTotal();

}
