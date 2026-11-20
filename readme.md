<p align="center">
	<img src="https://www.contentboxcms.org/__media/ContentBox_300.png" class="img-thumbnail" alt="contentbox"/>
	<br>
	<a href="https://forgebox.io/view/contentbox"><img src="https://forgebox.io/api/v1/entry/contentbox/badges/downloads" alt="Total Downloads" /></a>
	<a href="https://forgebox.io/view/contentbox"><img src="https://forgebox.io/api/v1/entry/contentbox/badges/version" alt="Latest Stable Version" /></a>
	<a href="https://forgebox.io/view/contentbox"><img src="https://img.shields.io/badge/License-Apache2-brightgreen" alt="Apache2 License" /></a>
</p>

<p align="center">
	Copyright Since 2012 by Luis Majano and Ortus Solutions, Corp
	<br>
	<a href="https://www.contentboxcms.org">www.contentboxcms.org</a> |
	<a href="https://www.ortussolutions.com">www.ortussolutions.com</a>
</p>

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

ContentBox is FREE Professional Open Source modular content management engine based on the popular [ColdBox](https://www.coldbox.org) MVC framework.

## License

Apache License, Version 2.0.

## 🏆 Proven & Professional

**Professional Open Source** - Backed by [Ortus Solutions](https://www.ortussolutions.com), ContentBox provides the reliability and support that businesses demand. With dedicated full-time development, comprehensive documentation, and professional services, enterprises can confidently build mission-critical applications on ContentBox.

**Enterprise Ready** - Trusted by Fortune 500 companies and organizations globally, ContentBox delivers the stability, performance, and long-term support that enterprise applications require. Learn more at [www.contentboxcms.org](https://www.contentboxcms.org).

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

* BoxLang 1+
* Adobe ColdFusion 2023+

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

### Environment Variables

Be sure to setup your environment variables by copying the file .env.template to .env.

### JavaScript Assets

You will need to run the following command to ensure that JavaScript assets are compiled for development.

```bash
npm run build-dev
```

### Test Suites

For running our test suites you will need 2 more steps, so please refer to the [Readme](tests/readme.md) in the tests folder.

### UI Development

If developing CSS and Javascript assets, please refer to the [UI Developer Guide](workbench/Developer.md) in the `workbench/Developer.md` folder.

## 🔗 Important Links

### Source Code

- **GitHub Repository**: https://github.com/Ortus-Solutions/ContentBox
- **ContentBox CLI**: https://github.com/Ortus-Solutions/ContentBox-CLI
- **ContentBox Modules**: https://github.com/contentbox-modules
- **ContentBox Themes**: https://github.com/contentbox-themes

### Documentation Books

- **ContentBox Platform**: https://contentbox.ortusbooks.com
- **ColdBox Platform**: https://coldbox.ortusbooks.com
- **WireBox DI**: https://wirebox.ortusbooks.com
- **CacheBox**: https://cachebox.ortusbooks.com
- **LogBox**: https://logbox.ortusbooks.com
- **TestBox**: https://testbox.ortusbooks.com
- **CommandBox**: https://commandbox.ortusbooks.com

### Documentation MCP Servers

Here are the links to the MCP (Machine Comprehension Protocol) servers for our documentation, which can be used with AI tools for enhanced assistance:

- **BoxLang Docs MCP**: https://boxlang.ortusbooks.com/~gitbook/mcp
- **ContentBox Platform**: https://contentbox.ortusbooks.com/~gitbook/mcp
- **ColdBox Platform**: https://coldbox.ortusbooks.com/~gitbook/mcp
- **WireBox DI**: https://wirebox.ortusbooks.com/~gitbook/mcp
- **CacheBox**: https://cachebox.ortusbooks.com/~gitbook/mcp
- **LogBox**: https://logbox.ortusbooks.com/~gitbook/mcp

### Issue Tracking

- **ContentBox Issues**: https://ortussolutions.atlassian.net/browse/CONTENTBOX
- **ColdBox Issues**: https://ortussolutions.atlassian.net/browse/COLDBOX
- **WireBox Issues**: https://ortussolutions.atlassian.net/browse/WIREBOX
- **CacheBox Issues**: https://ortussolutions.atlassian.net/browse/CACHEBOX
- **LogBox Issues**: https://ortussolutions.atlassian.net/browse/LOGBOX

### Official Sites

- **ContentBox CMS**: https://www.contentboxcms.org
- **Ortus Solutions**: https://www.ortussolutions.com/products/contentbox

----

### THE DAILY BREAD

 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12
