<!-- COLDBOX-CLI:START -->
<!-- ⚡ This section is managed by ColdBox CLI and will be refreshed on `coldbox ai refresh`. -->
<!-- ⚠️  Do NOT edit content between COLDBOX-CLI:START and COLDBOX-CLI:END markers — changes will be overwritten. -->

# ContentBox Tester Site - AI Agent Instructions

This is a ColdBox HMVC application using the **flat template structure** where all application code lives in the webroot. Compatible with Adobe ColdFusion 2018+, Lucee 5.x+, and BoxLang 1.0+.

## Project Overview

**Language Mode:** BoxLang
**ColdBox Version:** ^8
**Template Type:** Flat (traditional webroot structure)

## Application Structure

```
/                      - Application root (webroot)
├── Application.cfc    - Bootstrap that directly loads ColdBox
├── index.cfm          - Front controller
├── config/            - Framework and app configuration
├── handlers/          - Event handlers (controllers)
├── models/            - Service objects, business logic
├── views/             - HTML templates
├── layouts/           - Page layouts wrapping views
├── includes/          - Public assets (CSS, JS, images)
├── modules_app/       - Application modules (HMVC)
├── tests/             - Test suites
└── lib/               - Framework dependencies
```

**Key Characteristics:**
- Everything in webroot (simpler for traditional hosting)
- No `/app` vs `/public` separation
- All code is web-accessible by default
- `COLDBOX_APP_MAPPING = ""` (empty, app at root)

## Framework Knowledge

Core ColdBox and language guidelines are installed in `.ai/guidelines/core/`. Supported tools
(e.g., VS Code Copilot) load them automatically via file attachments. For other agents, load them
explicitly when you need framework fundamentals:

- `read_file` on `.ai/guidelines/core/coldbox.md` — ColdBox conventions, handlers, routing, DI reference
- `read_file` on `.ai/guidelines/core/boxlang.md` — BoxLang syntax and patterns

## Installed Modules

The following ColdBox modules are installed in this project. Use these when generating code, checking available services, and suggesting relevant skills or guidelines:

No additional modules installed yet.

## Handlers Snapshot

Current event handlers and their public actions (auto-updated on `coldbox ai refresh`):

- **Main**: index, onAppInit, onException, onMissingTemplate

## Interceptors Snapshot

Registered interceptors and their interception points (auto-updated on `coldbox ai refresh`):

No interceptors found.

## Layouts

Available layouts (auto-updated on `coldbox ai refresh`):

- **Main.cfm**

## Custom Modules

Application-level modules located in `/modules_app` (auto-updated on `coldbox ai refresh`):

- **contentbox-custom** (`modules_app`)

## AI Integration & Resources

This project includes AI-powered development assistance with on-demand guidelines, skills, and MCP documentation servers.

## Project-Specific Conventions

### Code Style

- **Semicolons:** Optional in CFML/BoxLang. Only use when demarcating properties or in inline component syntax
- **Handler naming:** Plural nouns (Users.cfc, Orders.cfc)
- **Service naming:** Descriptive with "Service" suffix (UserService.cfc)
- **Dependency injection:** Use `property name="service" inject` over manual getInstance()

### Testing

- Tests located in `/tests/specs/`
- Integration tests extend `BaseTestCase` with `appMapping="/app"`
- **Critical:** Always call `setup()` in `beforeEach()` for test isolation
- Run tests: `box testbox run`

### Configuration

- Environment variables defined in `.env` (copy from `.env.example`)
- Access via `getSystemSetting("VAR_NAME", "default")`
- Framework config in `config/ColdBox.cfc`
- Routes in `config/Router.cfc`

### Application Helpers

- `includes/helpers/ApplicationHelper.cfm` - Available in all handlers/views
- Add common utility functions here

### Development Workflow

```bash
# Install dependencies
box install

# Start server
box server start

# Format code
box run-script format

# Run tests
box testbox run

# Reinit framework (dev)
/?fwreinit=true
```

## AI Integration

This project includes AI-powered development assistance with guidelines, skills, and MCP documentation servers.

### Directory Structure

```
/.agents/
  /manifest.json       - AI configuration (language, agents, guidelines, skills, MCP servers)
  /guidelines/         - Framework documentation and best practices
    /core/             - Core ColdBox/BoxLang guidelines
    /modules/          - Module-specific guidelines
    /custom/           - Your custom guidelines
    /overrides/        - Override core guidelines
  /skills/             - Framework/core implementation cookbooks (auto-managed, can be .gitignored)
    /{name}/           - One folder per skill (flat, no subdirectories)
      SKILL.md         - Skill content (fetched from registry)
  /skills-custom/      - Project-specific skills (commit these to source control)
    /{name}/           - One folder per custom skill
      SKILL.md         - Custom skill content (project-authored or overrides)
  /mcp-servers/        - MCP server configurations
```

### Manifest

The `.agents/manifest.json` file contains the complete AI integration configuration:

- **language**: Project language mode (boxlang, cfml, hybrid)
- **templateType**: Application template (modern, flat)
- **guidelines**: Array of installed guideline names
- **skills**: Array of core/framework skill names (auto-managed)
- **customSkills**: Array of project-specific skill names (in `skills-custom/`)
- **agents**: Array of configured AI agents
- **mcpServers**: Configured MCP documentation servers (core, module, custom)
- **activeAgent**: Currently active AI agent (if set)
- **lastSync**: Last synchronization timestamp

**Reading the manifest** helps you understand available resources and project configuration.

### Using Guidelines & Skills

Guidelines and skills are stored locally in `.agents/` and loaded via `read_file` when needed:

**Core Guidelines** (`.agents/guidelines/core/`) — framework fundamentals:
- `read_file` on `.agents/guidelines/core/coldbox.md` — ColdBox conventions, handler/routing/DI reference
- `read_file` on `.agents/guidelines/core/boxlang.md` — BoxLang syntax, classes, lambdas (or `cfml.md` for CFML)

**Module/Custom Guidelines** — load by name on request from `.agents/guidelines/modules/` or `.agents/guidelines/custom/`.

**Skills** (`.agents/skills/{name}/SKILL.md`) — step-by-step implementation patterns. Examples:
- Implement a CRUD handler: `read_file` on `.agents/skills/coldbox-handler-development/SKILL.md`
- Build a REST API: `read_file` on `.agents/skills/coldbox-rest-api-development/SKILL.md`
- Write tests: `read_file` on `.agents/skills/coldbox-testing-handler/SKILL.md`

**Custom Skills** (`.agents/skills-custom/{name}/SKILL.md`) — project-specific patterns. Load by name from `.agents/skills-custom/`.

**To load any skill or guideline:** use `read_file` on the path shown above or in the inventories below.

### Available Guidelines

The following additional guidelines are available for this project. Request them by name when needed:

No additional module guidelines installed.

**To load a guideline:** Request it by name when you need detailed framework or module documentation.

### Available Skills

The following skills provide step-by-step implementation patterns. Request specific skills when you need detailed how-to instructions:

**Module Skills:**

_BoxLang (43):_
- **boxlang-application-descriptor** - Use this skill when designing or debugging Application.bx behavior: app discover...
- **boxlang-async-programming** - Use this skill when writing BoxLang asynchronous code: BoxFuture, futureNew, asy...
- **boxlang-best-practices** - Use this skill when writing, reviewing, or improving BoxLang code to ensure it f...
- **boxlang-caching** - Use this skill when implementing caching in BoxLang applications: cache provider...
- **boxlang-cfml-migration** - Use this skill when helping developers migrate from CFML (Adobe ColdFusion or Lu...
- **boxlang-classes-and-oop** - Use this skill when writing BoxLang classes, components, interfaces, inheritance...
- **boxlang-code-documenter** - Use this skill when adding documentation comments to BoxLang code: writing funct...
- **boxlang-code-reviewer** - Use this skill when reviewing BoxLang code for quality, correctness, security vu...
- **boxlang-configuration** - Use this skill when configuring BoxLang runtime settings via boxlang.json, setti...
- **boxlang-database-access** - Use this skill when writing BoxLang database code: queryExecute, bx:query, datas...
- **boxlang-deployment** - Use this skill when deploying BoxLang applications: CommandBox server setup, Doc...
- **boxlang-docbox** - Use this skill when generating API documentation for BoxLang or CFML projects wi...
- **boxlang-file-handling** - Use this skill when reading, writing, copying, moving, or deleting files and dir...
- **boxlang-file-watchers** - Use this skill when implementing BoxLang filesystem watchers: watcherNew/watcher...
- **boxlang-functional-programming** - Use this skill when working with BoxLang lambdas, closures, arrow functions, hig...
- **boxlang-interceptors** - Use this skill when working with BoxLang's interceptor/event system: creating in...
- **boxlang-java-integration** - Use this skill when integrating BoxLang with Java: createObject, static method c...
- **boxlang-language-fundamentals** - Use this skill when writing or reviewing BoxLang code covering syntax, file type...
- **boxlang-modules-and-packages** - Use this skill when installing, configuring, or using BoxLang modules: box insta...
- **boxlang-runtime-aws-lambda** - Use this skill when building, deploying, or debugging BoxLang applications on AW...
- **boxlang-runtime-chromebook** - Use this skill when setting up or developing BoxLang on a Chromebook, including ...
- **boxlang-runtime-cli-scripting** - Use this skill when writing BoxLang CLI scripts and classes, handling command-li...
- **boxlang-runtime-commandbox** - Use this skill when deploying BoxLang as an enterprise Java servlet application ...
- **boxlang-runtime-compiled-native-binaries** - Use this skill when compiling BoxLang scripts to standalone native executables u...
- **boxlang-runtime-desktop** - Use this skill when building BoxLang desktop applications with Electron and the ...
- **boxlang-runtime-desktop-electron** - Use this skill when building BoxLang desktop applications with Electron and the ...
- **boxlang-runtime-digitalocean-app** - Use this skill when deploying BoxLang applications to DigitalOcean App Platform ...
- **boxlang-runtime-docker** - Use this skill when containerizing BoxLang applications with Docker, including c...
- **boxlang-runtime-esp32** - Use this skill when deploying BoxLang to ESP32 microcontrollers using MatchBox's...
- **boxlang-runtime-github-actions** - Use this skill when setting up GitHub Actions CI/CD pipelines for BoxLang projec...
- **boxlang-runtime-google-cloud-functions** - Use this skill when building, testing, or deploying BoxLang applications on Goog...
- **boxlang-runtime-jsr-223** - Use this skill when embedding BoxLang into Java applications via the JSR-223 scr...
- **boxlang-runtime-matchbox** - Use this skill when using MatchBox, the Rust-based native implementation of BoxL...
- **boxlang-runtime-miniserver** - Use this skill when running BoxLang as a lightweight web server using the BoxLan...
- **boxlang-runtime-spring-boot** - Use this skill when integrating BoxLang with Spring Boot applications, including...
- **boxlang-runtime-wasm-container** - Use this skill when compiling BoxLang applications to server-side WebAssembly (W...
- **boxlang-runtime-wasm-in-the-browser** - Use this skill when compiling BoxLang to WebAssembly or JavaScript ES modules fo...
- **boxlang-scheduled-tasks** - Use this skill when creating or managing BoxLang scheduled workloads: Scheduler ...
- **boxlang-security** - Use this skill when reviewing BoxLang code or applications for security vulnerab...
- **boxlang-templating** - Use this skill when writing BoxLang markup templates (.bxm files), mixing HTML w...
- **boxlang-testing** - Use this skill when writing, running, or debugging tests for BoxLang application...
- **boxlang-web-development** - Use this skill when building BoxLang web applications: Application.bx lifecycle,...
- **boxlang-zip** - Use this skill when creating, extracting, listing, or modifying ZIP archives in ...

_CacheBox (1):_
- **cachebox-standalone** - Use this skill when working with CacheBox as a standalone caching framework (out...

_ColdBox (29):_
- **coldbox-ai-integration** - Use this skill when integrating AI capabilities into a ColdBox application using...
- **coldbox-app-layouts** - Use this skill when choosing a ColdBox application layout (flat, boxlang, or mod...
- **coldbox-async-programming** - Use this skill when building async pipelines, working with ColdBox Futures, runn...
- **coldbox-cache-integration** - Use this skill when implementing caching inside a ColdBox application -- configu...
- **coldbox-cli** - Use this skill when using the ColdBox CLI (CommandBox module) to scaffold applic...
- **coldbox-configuration** - Use this skill when configuring a ColdBox application in ColdBox.cfc, setting up...
- **coldbox-decorators** - Use this skill when extending or overriding ColdBox framework internals via the ...
- **coldbox-di** - Use this skill when working with dependency injection inside a ColdBox applicati...
- **coldbox-documenter** - Use this skill when writing or improving documentation comments for ColdBox appl...
- **coldbox-event-model** - Use this skill when working with the ColdBox event object (prc/rc), managing req...
- **coldbox-flash-messaging** - Use this skill when implementing flash RAM messaging in ColdBox, using cbMessage...
- **coldbox-handler-development** - Use this skill when creating ColdBox handlers (controllers), implementing CRUD a...
- **coldbox-interceptor-development** - Use this skill when creating ColdBox interceptors for cross-cutting concerns, li...
- **coldbox-layout-development** - Use this skill when creating ColdBox layouts (master page templates), building a...
- **coldbox-logging** - Use this skill for all ColdBox-specific logging concerns: configuring LogBox ins...
- **coldbox-module-development** - Use this skill when creating reusable ColdBox modules, writing ModuleConfig.cfc,...
- **coldbox-proxy** - Use this skill when building ColdBox Proxy objects to expose ColdBox event handl...
- **coldbox-request-context** - Use this skill when working with the ColdBox RequestContext object (event), mana...
- **coldbox-rest-api-development** - Use this skill when building RESTful APIs in ColdBox using RestHandler, creating...
- **coldbox-reviewer** - Use this skill when reviewing ColdBox application code for correctness, security...
- **coldbox-routing-development** - Use this skill when configuring ColdBox routes, setting up RESTful resource rout...
- **coldbox-scheduled-tasks** - Use this skill when creating ColdBox scheduled tasks, building Scheduler.cfc fil...
- **coldbox-testing-base-classes** - Use this skill to understand which ColdBox testing base class to extend for a gi...
- **coldbox-testing-handler** - Use this skill when testing ColdBox event handlers with execute(), asserting rc/...
- **coldbox-testing-http-methods** - Use this skill when simulating HTTP requests in ColdBox tests using the get(), p...
- **coldbox-testing-integration** - Use this skill when writing integration tests for ColdBox that use real dependen...
- **coldbox-testing-interceptor** - Use this skill when unit testing ColdBox interceptors in isolation using BaseInt...
- **coldbox-testing-model** - Use this skill when unit testing ColdBox model objects (services, repositories, ...
- **coldbox-view-rendering** - Use this skill when rendering views and partials in ColdBox, creating reusable v...

_CommandBox (11):_
- **commandbox-config-settings** - Use this skill for CommandBox global configuration: config set/show/clear comman...
- **commandbox-deploying** - Use this skill for deploying CommandBox applications to production: Docker with ...
- **commandbox-developing** - Use this skill for developing CommandBox extensions: creating custom commands (C...
- **commandbox-embedded-server** - Use this skill for the CommandBox embedded server: starting and stopping servers...
- **commandbox-package-management** - Use this skill for CommandBox package management: box.json configuration, instal...
- **commandbox-setup** - Use this skill for installing, configuring, and upgrading CommandBox CLI: Homebr...
- **commandbox-task-runners** - Use this skill for CommandBox task runners: creating task CFCs, targets, passing...
- **commandbox-testing** - Use this skill for CommandBox TestBox integration: testbox run command, running ...
- **commandbox-usage** - Use this skill for CommandBox CLI usage: running commands, namespaces, tab compl...
- **commandbox-boxlang** - Use this skill when configuring CommandBox to run BoxLang server instances, usin...
- **commandbox-migrations** - Use this skill when running database migrations from the CommandBox CLI using co...

_LogBox (1):_
- **logbox** - Use this skill whenever working with LogBox -- standalone or inside a ColdBox ap...

_Other (6):_
- **ortus-coding-standards** - Use this skill when writing, reviewing, or formatting any Ortus Solutions code (...
- **database-migrations** - Use this skill when managing database schema changes in ColdBox/BoxLang using cf...
- **testing-coverage** - Use this skill when setting up code coverage analysis for ColdBox/ColdFusion/Box...
- **testing-fixtures** - Use this skill when creating test fixtures, factory patterns, or test data build...
- **cbdebugger** - Use this skill when installing, configuring, or using the CBDebugger visual debu...
- **route-visualizer** - Use this skill when inspecting all registered ColdBox routes using the route-vis...

_TestBox (9):_
- **testbox-assertions** - Use this skill when using the TestBox $assert object for xUnit-style assertions:...
- **testbox-bdd** - Use this skill when writing BDD-style tests with TestBox using describe/it block...
- **testbox-cbmockdata** - Use this skill when generating realistic fake/mock data in tests using cbMockDat...
- **testbox-expectations** - Use this skill when writing fluent expectations in TestBox using expect(), expec...
- **testbox-listeners** - Use this skill when implementing TestBox run listeners (callbacks): onBundleStar...
- **testbox-mockbox** - Use this skill when creating mocks, stubs, and spies in TestBox using MockBox: c...
- **testbox-reporters** - Use this skill when selecting or configuring TestBox reporters: ANTJunit, Consol...
- **testbox-runners** - Use this skill when running TestBox tests: CommandBox CLI (testbox run), BoxLang...
- **testbox-unit-xunit** - Use this skill when writing xUnit-style tests in TestBox using test functions (t...

_WireBox (2):_
- **wirebox-di** - Use this skill when working with WireBox dependency injection -- bootstrapping t...
- **wirebox-aop** - Use this skill when working with WireBox Aspect-Oriented Programming (AOP) -- ac...

**To load a skill:** Use `read_file` on `.agents/skills/{skill-name}/SKILL.md` (e.g., `.agents/skills/coldbox-handler-development/SKILL.md`) for core skills, or `.agents/skills-custom/{skill-name}/SKILL.md` for custom project skills.

## Important Notes

- Framework reinit: Use `?fwreinit=true` or configure `reinitPassword` for production
- Module routes process before app routes - be aware of conflicts
- Use PRC for internal data, RC only for user input
- Always validate user input from RC

## MCP Documentation Servers

This project has access to the following Model Context Protocol (MCP) documentation servers for live, up-to-date information:

**Core Documentation Servers:**

- **boxlang**: BoxLang Language Documentation - https://ai.ortusbooks.com/~gitbook/mcp
- **coldbox**: ColdBox Framework Documentation - https://coldbox.ortusbooks.com/~gitbook/mcp
- **commandbox**: CommandBox CLI Documentation - https://commandbox.ortusbooks.com/~gitbook/mcp
- **testbox**: TestBox Testing Framework - https://testbox.ortusbooks.com/~gitbook/mcp
- **wirebox**: WireBox Dependency Injection - https://wirebox.ortusbooks.com/~gitbook/mcp
- **cachebox**: CacheBox Caching Framework - https://cachebox.ortusbooks.com/~gitbook/mcp
- **logbox**: LogBox Logging Framework - https://logbox.ortusbooks.com/~gitbook/mcp

**Module Documentation Servers:**

- **cfmigrations**: Database Migrations - https://cfmigrations.ortusbooks.com/~gitbook/mcp
- **cbdebugger**: CBDebugger Debugging Tools - https://cbdebugger.ortusbooks.com/~gitbook/mcp

**Using MCP Servers:** Query these servers when you need current documentation, API references, or code examples. They provide live, up-to-date information directly from official documentation sources.

<!-- COLDBOX-CLI:END -->

<!-- ℹ️ YOUR PROJECT DOCUMENTATION — Add your custom details below. ColdBox CLI will NOT overwrite this section. -->

## About This Application

> ⚠️ Fill in this section to give your AI assistant context about your specific application.

### Business Domain

<!-- Describe what this application does and its primary purpose -->

### Key Services & Models

<!-- List important services and their responsibilities, e.g.:
- UserService — authentication, registration, profile management
- OrderService — cart, checkout, order lifecycle
-->

### Authentication & Security

<!-- Describe authentication approach, e.g., cbSecurity + JWT, session-based, etc. -->

### API Endpoints

<!-- Document REST API routes if applicable, e.g.:
- GET /api/v1/users — list users
- POST /api/v1/users — create user
-->

### Database

<!-- Document database setup, ORM entities, migrations if applicable -->

### Deployment

<!-- Document deployment process, environments, CI/CD pipeline -->