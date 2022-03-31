# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

----

## [5.1.2] => 2022-MAR-31

### Fixed

- [CONTENTBOX-1415](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1415) 5.x Updater was not running the right migrations
- [CONTENTBOX-1414](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1414) Migration names cannot have a period or the migrations fail due to a CFC instantiation issue
- [CONTENTBOX-1413](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1413) CBHelper siteBaseURL is not accounting for multi-site

----

## [5.1.1] => 2022-MAR-17

### Fixed

- Master artifact was stuck at `-snapshot` fix with master artifact

### Improvements

- [CONTENTBOX-1412](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1412) VerifyPageLayout\(\) on the page rendering touches the filesystem on each request, removing this as it is not needed
- [CONTENTBOX-1368](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1368) rc.pageUri is only the first segment of the actual slug, now it contains the full hierarchical slug

----

## [5.1.0] => 2022-MAR-17

### Fixed

- [CONTENTBOX-1410](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1410) Widget Form missing type and class elements
- [CONTENTBOX-1409](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1409) regression: issue when resetting an user password due to change to `getFullName()`
- [CONTENTBOX-1407](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1407) Media Manager Item Contextual Menus Do Not Work
- [CONTENTBOX-1405](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1405) Cloning Fails if Title of Page/entry/contentstore that Contains an Apostrophe
- [CONTENTBOX-1398](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1398) Cloning a Page with Children Produces an Error
- [CONTENTBOX-1397](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1397) Settings should not be cached on a per host basis anymore, since a single instance manages 1 or x number of sites
- [CONTENTBOX-1396](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1396) Deleting Permissions is not working due to change of primary key from numeric to string
- [CONTENTBOX-1381](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1381) Individual ContentBox Content-Level Cache Settings are Never Checked
- [CONTENTBOX-1379](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1379) Fail Quietly on ContentBox Module Removal
- [CONTENTBOX-1367](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1367) error on relocate widget when argumetns have no length
- [CONTENTBOX-1365](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1365) Paginated results in CBAdmin for Page Children returns non-parented results for page 2
- [CONTENTBOX-1364](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1364) Relocation Widget Always inserts URL arg even when selecting page
- [CONTENTBOX-1362](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1362) Change all date comparisons on the expirations and publishing dates to dateCompare\(\) to avoid ambiguity with types
- [CONTENTBOX-1361](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1361) Pages with null expiration date show as Expired in Page Editor
- [CONTENTBOX-1358](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1358) API throwing exception when content objects exist in multiple sites
- [CONTENTBOX-1357](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1357) If using the contentbox installer and no database tables are created yet, running the migrations fail due to tables not found
- [CONTENTBOX-1356](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1356) Invalid setting name on migration removing unique constraints
- [CONTENTBOX-1355](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1355) Category isPublic new boolean flag cannot be notnull=true as it has been a new added field
- [CONTENTBOX-1354](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1354) Rapidoc is not publishing on latest builds
- [CONTENTBOX-1353](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1353) MSSQL Issues when upgrading v4 databases due to uuid's and invalid sql syntaxes
- [CONTENTBOX-1333](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1333) If you activate a new theme in the active theme area, contentbox creates double entries for theme settings

### Improvements

- [CONTENTBOX-1401](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1401) Add a Warning Confirmation When a Published Page is About to Be Sent to Draft
- [CONTENTBOX-1386](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1386) cleanup of dev dependencies on site box.json
- [CONTENTBOX-1384](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1384) Remove development environment from 127 ip due to container executions
- [CONTENTBOX-1383](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1383) Remove cacheLayout column/values from SQL seeder files
- [CONTENTBOX-1380](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1380) Remove Individual Page Handling of SSL
- [CONTENTBOX-1373](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1373) Add support for x-forwarded-port to the site root url builder in order to assist with proxied web servers
- [CONTENTBOX-1363](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1363) Consolidate and encapsulate the usage of date/time methods for publish/expire date in the base content
- [CONTENTBOX-1359](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1359) Add Error handling to renderWithSearchResults
- [CONTENTBOX-1351](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1351) Resources folder that contain apidocs \+ seeders \+ migrations is not updateable

### Tasks

- [CONTENTBOX-1394](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1394) Create the migration to remove the page sslOnly bit
- [CONTENTBOX-1389](https://ortussolutions.atlassian.net/browse/CONTENTBOX-1389) QA of the entire admin and API
