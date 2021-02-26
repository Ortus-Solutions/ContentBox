[![Build Status](https://travis-ci.com/Ortus-Solutions/ContentBox.svg?branch=development)](https://travis-ci.com/Ortus-Solutions/ContentBox)

<img src="https://www.contentboxcms.org/__media/ContentBox_300.png" class="img-thumbnail"/>

>Copyright Since 2012 by Ortus Solutions, Corp - https://www.ortussolutions.com/products/contentbox

Because of God's grace, this project exists. If you don't like this, then don't read it, its not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the
Holy Ghost which is given unto us. ." Romans 5:5

----

# Welcome to ContentBox

ContentBox is FREE Professional Open Source modular content management engine based on the popular [ColdBox](https://www.coldbox.org) MVC framework.

## License

Apache License, Version 2.0.

## Versioning

ContentBox is maintained under the Semantic Versioning guidelines as much as possible.

Releases will be numbered with the following format:

```
<major>.<minor>.<patch>
```

And constructed with the following guidelines:

* Breaking backward compatibility bumps the major (and resets the minor and patch)
* New additions without breaking backward compatibility bumps the minor (and resets the patch)
* Bug fixes and misc changes bumps the patch

## Important Links

* Source Code - https://github.com/Ortus-Solutions/ContentBox
* Bug Tracking - https://ortussolutions.atlassian.net/browse/CONTENTBOX
* Documentation - https://contentbox.ortusbooks.com
* Support Community - https://community.ortussolutions.com/c/communities/contentbox/15

## System Requirements

* Lucee 5+
* Adobe ColdFusion 2016+

# ContentBox Installation

You can follow in-depth installation instructions here: https://contentbox.ortusbooks.com/getting-started/installation or you can use [CommandBox](https://www.ortussolutions.com/products/commandbox) to quickly get up and running with ContentBox.  You can install it in three different formats:

1. **ContentBox Installer** : Installs a new ColdBox configured site with our ContentBox DSN Creator, ContentBox Installer and ContentBox Modules installed: `box install contentbox-installer`
2. **ContentBox Site**: Create a new ColdBox configured site with the ContentBox Module installed.  This does not contain our installer or DSN creator modules (Great for containers or pre-installed sites) : `box install contentbox-site`
3. **ContentBox Module**: Install ContentBox as a module into an existing ColdBox application (Requires ORM configuration, manual installation): `box install contentbox`
4. **ContentBox Installer Module** : You can also install ONLY the ContentBox installer module as an addon: `box install contentbox-installer-module`.

```bash
# Install New Site with DSN Creator, Installer and ContentBox modules
install contentbox-installer

# This will install the ContentBox installer module ONLY!
install contentbox-installer-module

# Install New Site with ContentBox Modules but no DSN Creator and Installer, great for Containers
install contentbox-site

# Install ContentBox Modules Only into an existing ColdBox App
install contentbox
```

## Collaboration

If you want to develop and hack at the source, you will need to download [CommandBox](https://www.ortussolutions.com/products/commandbox), and have [NodeJS](https://nodejs.org/en/) installed for UI development.  Then in the root of this project, type `box recipe workbench/setup.boxr`.  This will download the necessary dependencies to develop and test with ContentBox.  

You can then go ahead and start an embedded server according to which engine you would like to hack in. Please note that the default CFML engine is a Lucee 5 engine.  You can start any of the following engines:

* `run-script start:2016` - ACF 2016
* `run-script start:2018` - ACF 2018
* `run-script start:lucee` - Lucee 5

You can also stop any server:

* `run-script stop:2016` - ACF 2016
* `run-script stop:2018` - ACF 2018
* `run-script stop:lucee` - Lucee 5

You can also tail the logs for each server:

* `run-script log:2016` - ACF 2016
* `run-script log:2018` - ACF 2018
* `run-script log:lucee` - Lucee 5


### Test Suites

For running our test suites you will need 2 more steps, so please refer to the [Readme](tests/readme.md) in the tests folder.

### UI Development

If developing CSS and Javascript assets, please refer to the [UI Developer Guide](workbench/Developer.md) in the `workbench/Developer.md` folder.

## Ortus Community

Join us in our Ortus Community and become a valuable member of this project https://community.ortussolutions.com/c/communities/contentbox/15. We are looking forward to hearing from you!

----

### THE DAILY BREAD

 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12
