[![Build Status](https://travis-ci.org/Ortus-Solutions/ContentBox.svg?branch=development)](https://travis-ci.org/Ortus-Solutions/ContentBox)

<img src="https://www.contentboxcms.org/__media/ContentBox_300.png" class="img-thumbnail"/>

>Copyright 2012 by Ortus Solutions, Corp - https://www.ortussolutions.com

Because of God's grace, this project exists. If you don't like this, then don't read it, its not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the 
Holy Ghost which is given unto us. ." Romans 5:5

----

# Welcome to ContentBox
ContentBox is a modular content management engine based on the popular [ColdBox](www.coldbox.org) MVC framework.

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

Source Code
- https://github.com/Ortus-Solutions/ContentBox

Bug Tracking/Agile Boards
- https://ortussolutions.atlassian.net/browse/CONTENTBOX

Documentation
- https://contentbox.ortusbooks.com

Blog
- https://www.ortussolutions.com/blog

## System Requirements
- Lucee 4.5+
- ColdFusion 10+

# ContentBox Installation

You can follow in-depth installation instructions here: https://contentbox.ortusbooks.com/content/installation/index.html or you can use [CommandBox](https://www.ortussolutions.com/products/commandbox) to quickly get up and running with ContentBox.  You can install it in three different formats:

1. ContentBox Installer : Install a new site with our DSN Creator, Installer and ContentBox Modules
1. ContentBox Modules: Install ContentBox as a module into an existing ColdBox application (Requires ORM configuration)
1. ContentBox Site: Create a new site with our ContentBox Modules only, no installer or DSN creator (Great for containers) 

```
# Install New Site with DSN Creator, Installer and ContentBox modules
install contentbox-installer

# Install ContentBox Modules Only into an existing ColdBox App
install contentbox

# Install New Site with ContentBox Modules but no DSN Creator and Installer, great for Containers
install contentbox-site
```

## Collaboration

If you want to develop and hack at the source, you will need to download [CommandBox](https://www.ortussolutions.com/products/commandbox) first.  Then in the root of this project, type `box install`.  This will download the necessary dependencies to develop and test ContentBox.  You can then go ahead and start an embedded server `box server start --rewritesEnable` and start hacking around and contributing.  

### Test Suites
For running our test suites you will need 2 more steps, so please refer to the [Readme](tests/readme.md) in the tests folder.

### UI Development
If developing CSS and Javascript assets, please refer to the [Developer Guide](workbench/Developer.md) in the `workbench/Developer.md` folder.

---
 
###THE DAILY BREAD
 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12