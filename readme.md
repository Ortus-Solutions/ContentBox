```
   ____            _             _   ____            
  / ___|___  _ __ | |_ ___ _ __ | |_| __ )  _____  __
 | |   / _ \| '_ \| __/ _ \ '_ \| __|  _ \ / _ \ \/ /
 | |__| (_) | | | | ||  __/ | | | |_| |_) | (_) >  < 
  \____\___/|_| |_|\__\___|_| |_|\__|____/ \___/_/\_\
                                                     
```

# ContentBox Modular CMS - A Modular Content Platform

Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com

----

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

Continuous Integration
- http://jenkins.staging.ortussolutions.com/job/OS-ContentBox%20BE/

Bug Tracking/Agile Boards
- https://ortussolutions.atlassian.net/browse/CONTENTBOX

Documentation
- http://contentbox.ortusbooks.com

Blog
- http://www.ortussolutions.com/blog

## System Requirements
- Lucee 4.5+
- Railo 4+ (Deprecated)
- ColdFusion 10+

# ContentBox Installation

You can follow in-depth installation instructions here: http://contentbox.ortusbooks.com/content/installation/index.html or you can use [CommandBox](http://www.ortussolutions.com/products/commandbox) to quickly get up and running via the following commands:

**Stable Release**

```bash
mkdir mysite && cd mysite
# Install latest release
box install contentbox
box server start --rewritesEnable
```

**Bleeding Edge Release**

```bash
mkdir mysite && cd mysite
# Install latest release
box install contentbox-be
box server start --rewritesEnable
```

## Collaboration

If you want to develop and hack at the source, you will need to download [CommandBox](http://www.ortussolutions.com/products/commandbox) first.  Then in the root of this project, type `box install`.  This will download the necessary dependencies to develop and test ContentBox.  You can then go ahead and start an embedded server `box server start --rewritesEnable` and start hacking around and contributing.  

For running our test suites you will need 2 more steps, so please refer to the [Readme](tests/readme.md) in the tests folder.

If developing CSS and Javascript assets, please read `workbench/Developer.md`.

---
 
###THE DAILY BREAD
 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12