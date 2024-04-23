# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

* * *

## [Unreleased]

### Fixed

- CONTENTBOX-1510 - Emails being sanitized and invalidated on Comment form submission

## [6.0.4] - 2024-02-20

### Fixed

-   JS Library Patches
-   [CONTENTBOX-1509](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1509) `featuredImage` URL on initial migration should be nullable

## [6.0.3] - 2024-02-13

### Updated

-   All github actions

### Bugs

-   [CONTENTBOX-1507](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1507) BulkSave not accounting for sites when filtering and saving
-   [CONTENTBOX-1506](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1506) Updated all server.jsons to use \`env\` for the ortus orm extension since the latest lucee build broken extensions via jvm args
-   [CONTENTBOX-1505](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1505) RenderView widget exception when using \`view()\` to render the view

## [6.0.2] - 2024-01-15

### Bugs

-   [CONTENTBOX-1501](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1501) Init migration needs to verify permissions and roles separately to make sure it passes on created dbs

## [6.0.1] - 2023-12-20

### Bugs

-   [CONTENTBOX-1500](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1500) Defensive coding for permissions migration on new instance

## [6.0.0] - 2023-12-18

### Bugs

-   [CONTENTBOX-1323](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1323) Import With Overwrite Throws an Error
-   [CONTENTBOX-1370](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1370) UI Disappoints in Menu Manager and Broken ContentMenuItem Functionality
-   [CONTENTBOX-1404](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1404) Issue Importing Site using ContentBox 5.03 and a fresh export
-   [CONTENTBOX-1406](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1406) Switching Editors Sends Item Being Edited in to Draft Status
-   [CONTENTBOX-1427](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1427) CBRequest postRender of AdminBar will throw errors if Buffer is flushed to Browser
-   [CONTENTBOX-1428](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1428) Incorrect Site and Parent Re-Assignment When Using Admin Bar Edit
-   [CONTENTBOX-1439](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1439) NOW for a new blog post doesn't update the time anymore with the alpine updates
-   [CONTENTBOX-1445](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1445) Menu Manager Create new does not working
-   [CONTENTBOX-1450](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1450) menu manager sandbox display is broken
-   [CONTENTBOX-1453](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1453) modules_user is not currently included in the ormSettings so some contentbox modules on forgebox don't work without Application.cfc being updated by the user
-   [CONTENTBOX-1454](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1454) files fail to upload in media manager after server restart
-   [CONTENTBOX-1462](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1462) Generated Sitemap has broken links
-   [CONTENTBOX-1467](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1467) FeedGenerator.cfc Incompatible with ACF 2018+
-   [CONTENTBOX-1468](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1468) getOpenGraphMeta broken for description
-   [CONTENTBOX-1472](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1472) Ensure visibility of Menu Toggle in mobile views
-   [CONTENTBOX-1476](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1476) Links do not have enough contrast
-   [CONTENTBOX-1481](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1481) Missing Icons
-   [CONTENTBOX-1482](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1482) PageInclude/EntryInclude/Menu widgets are not including the current site
-   [CONTENTBOX-1484](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1484) Menu Preview Error
-   [CONTENTBOX-1496](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1496) checkAll failing due to window scoping issues
-   [CONTENTBOX-1498](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1498) Missing fieldset tag
-   [CONTENTBOX-1499](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1499) An error is recorded in the log when initialising a custom widget in an add-on module

### New Features

-   [CONTENTBOX-1270](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1270) ContentBox Content Templates
-   [CONTENTBOX-1377](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1377) Add Child Layout Property to Pages
-   [CONTENTBOX-1451](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1451) use onServerInstall migration scripts from latest CommandBox on server scripts
-   [CONTENTBOX-1477](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1477) Upgrade to ColdBox 7
-   [CONTENTBOX-1480](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1480) cfconfig definitions additions to the server definitions
-   [CONTENTBOX-1487](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1487) Ability to define domain aliases for sites for domain detection
-   [CONTENTBOX-1491](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1491) Migration to cfmigrations for full database and seeding creations instead of ORM
-   [CONTENTBOX-1492](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1492) Added the cors module to the site since we have API deployments now
-   [CONTENTBOX-1497](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1497) New Content Editing Focus mode to remove distractions
-   [CONTENTBOX-1452](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1452) Convert File Operations to cbfs

### Improvements

-   [CONTENTBOX-721](https://ortussolutions.atlassian.net/browse/CONTENTBOX-721) Menu Manager Improvements
-   [CONTENTBOX-1296](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1296) Add historical slug storage and automatic redirects
-   [CONTENTBOX-1399](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1399) Editors Should Have the Ability to Evict Content Cache with new permission: RELOAD_CACHES
-   [CONTENTBOX-1429](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1429) Sitemap Search in Admin is extremely slow on large sites.
-   [CONTENTBOX-1447](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1447) Logical Groupings for Content Template Form Fields
-   [CONTENTBOX-1448](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1448) Move Global Content Template Assignment Up to Template List
-   [CONTENTBOX-1455](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1455) 'Remove All' button is displayed under Blog > Custom Fields even when there are no custom fields defined.
-   [CONTENTBOX-1458](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1458) Remove content returnformats for pdf to avoid server and bot attacks
-   [CONTENTBOX-1469](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1469) Improve position of the menu toggle
-   [CONTENTBOX-1474](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1474) Enhance logo quality
-   [CONTENTBOX-1488](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1488) latest logins should only be displayed if the tracker is enabled
-   [CONTENTBOX-1489](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1489) SEO for meta data on home page, needs to follow site rules instead of page only rules
-   [CONTENTBOX-1490](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1490) Removed moment js to luxon for increased support and viability
-   [CONTENTBOX-1494](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1494) When using hierarchical slugs on the contentstore and pages the api does not work for retreiveing the right slug due to CF decoding of encoded slugs

### Tasks

-   [CONTENTBOX-1172](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1172) Migrate UI development from bower/grunt to npm/elixir
-   [CONTENTBOX-1321](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1321) Convert from Yarn to NPM for package management
-   [CONTENTBOX-1470](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1470) Update Panels Styles
-   [CONTENTBOX-1471](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1471) Update Tabs Styles
-   [CONTENTBOX-1473](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1473) Update Sidebar Styles
-   [CONTENTBOX-1478](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1478) Remove old tuckey urlrewrite.xml as this is now in the CommandBox Core
-   [CONTENTBOX-1493](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1493) ContentBox Express removed since we now have CommandBox

[Unreleased]: https://github.com/Ortus-Solutions/ContentBox/compare/v6.0.4...HEAD

[6.0.4]: https://github.com/Ortus-Solutions/ContentBox/compare/v6.0.3...v6.0.4

[6.0.3]: https://github.com/Ortus-Solutions/ContentBox/compare/v6.0.2...v6.0.3

[6.0.2]: https://github.com/Ortus-Solutions/ContentBox/compare/v6.0.1...v6.0.2

[6.0.1]: https://github.com/Ortus-Solutions/ContentBox/compare/v6.0.0...v6.0.1

[6.0.0]: https://github.com/Ortus-Solutions/ContentBox/compare/71a6cf9852fa15afd7732da947c2738f9fc7d844...v6.0.0
