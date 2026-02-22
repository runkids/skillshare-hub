<h1 align="center">skillshare-hub</h1>

<p align="center">
  <strong>A curated catalog of <a href="https://github.com/runkids/skillshare">skillshare</a> skills — and a reference for building your own.</strong><br>
  Search, discover, and install AI CLI skills. Fork this repo to create your organization's internal hub.
</p>

<p align="center">
  <a href="https://github.com/runkids/skillshare-hub/blob/main/skillshare-hub.json"><img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Frunkids%2Fskillshare-hub%2Fmain%2Fskillshare-hub.json&query=%24.skills.length&label=skills&color=blue" alt="Skill Count"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
</p>

## What is this?

A curated index of [skillshare](https://github.com/runkids/skillshare) skills that serves two purposes:

1. **Ready-to-use catalog** — Pre-configured as the default hub in skillshare. Run `skillshare search --hub` or open **Search** > **Hub** in the Web UI.
2. **Reference for your own hub** — Fork this repo, replace the skills with your organization's catalog, and customize the CI pipeline. Same schema, same tooling.

## Usage

### Search via CLI

```bash
skillshare search --hub https://raw.githubusercontent.com/runkids/skillshare-hub/main/skillshare-hub.json <query>
```

<p align="center">
  <img src="assets/hub-search-cli.png" alt="Hub search via CLI" width="960">
</p>

### Search via Web UI (built-in)

Run `skillshare ui`, go to **Search** > **Hub** — Skillshare Hub is pre-selected. Browse or search the catalog with one-click install.

<p align="center">
  <img src="assets/hub-search-ui.png" alt="Hub search in skillshare Web UI" width="960">
</p>

### Install a skill you found

```bash
skillshare install <source>
```

## Skills Catalog

<!-- CATALOG:START -->
**199 skills** across 11 categories — browse via `skillshare search --hub` or the Web UI

### Frontend (39)

<details>
<summary>Show 39 skills</summary>

- [**accessibility-compliance**](https://github.com/wshobson/agents) — Web accessibility compliance patterns and WCAG guidelines
- [**angular-component**](https://github.com/analogjs/angular-skills) — Angular component architecture patterns and best practices
- [**antfu-vue-best-practices**](https://github.com/antfu/skills) — Vue.js best practices and patterns from Anthony Fu
- [**building-native-ui**](https://github.com/expo/skills) — Build beautiful native UIs with Expo and React Native
- [**expo-api-routes**](https://github.com/expo/skills) — Create API routes in Expo Router with EAS Hosting
- [**expo-dev-client**](https://github.com/expo/skills) — Build and distribute Expo development clients locally or via TestFlight
- [**expo-tailwind-setup**](https://github.com/expo/skills) — Set up Tailwind CSS v4 in Expo with NativeWind for universal styling
- [**flutter-animations**](https://github.com/madteacher/mad-agents-skills) — Flutter animation patterns and motion design best practices
- [**flutter-expert**](https://github.com/jeffallan/claude-skills) — Flutter framework expertise and cross-platform development patterns
- [**modern-javascript-patterns**](https://github.com/wshobson/agents) — Modern JavaScript patterns and ES2024+ best practices
- [**native-data-fetching**](https://github.com/expo/skills) — Implement data fetching patterns in Expo and React Native apps
- [**next-best-practices**](https://github.com/vercel-labs/next-skills) — Next.js performance optimization and best practices from Vercel
- [**next-cache-components**](https://github.com/vercel-labs/next-skills) — Next.js caching strategies and optimized component patterns
- [**next-upgrade**](https://github.com/vercel-labs/next-skills) — Next.js version upgrade guide and migration patterns
- [**nextjs-app-router-patterns**](https://github.com/wshobson/agents) — Next.js App Router patterns for server components and routing
- [**nuxt**](https://github.com/antfu/skills) — Nuxt.js framework best practices and server-side rendering patterns
- [**pinia**](https://github.com/antfu/skills) — Pinia state management best practices for Vue applications
- [**react-components**](https://github.com/google-labs-code/stitch-skills) — React component patterns and best practices from Google Labs
- [**react-doctor**](https://github.com/millionco/react-doctor) — Scans your React codebase for security, performance, correctness, and architecture issues. Outputs a 0-100 score with actionable diagnostics.
- [**react-native-architecture**](https://github.com/wshobson/agents) — React Native application architecture and scalability patterns
- [**react-native-best-practices**](https://github.com/callstackincubator/agent-skills) — React Native best practices and performance optimization from Callstack
- [**react-native-design**](https://github.com/wshobson/agents) — React Native UI design patterns and cross-platform styling
- [**remotion**](https://github.com/google-labs-code/stitch-skills) — Remotion video creation framework patterns from Google Labs
- [**remotion-best-practices**](https://github.com/remotion-dev/skills) — Best practices for creating videos programmatically with Remotion in React
- [**remotion-render**](https://github.com/inference-sh-6/skills) — Cloud-based Remotion video rendering via inference.sh
- [**swiftui-expert-skill**](https://github.com/avdlee/swiftui-agent-skill) — SwiftUI best practices and modern iOS app development patterns
- [**typescript-advanced-types**](https://github.com/wshobson/agents) — Advanced TypeScript type patterns and type-level programming
- [**unocss**](https://github.com/antfu/skills) — UnoCSS atomic CSS engine configuration and utility patterns
- [**upgrading-expo**](https://github.com/expo/skills) — Upgrade Expo SDK versions and resolve dependency compatibility issues
- [**use-dom**](https://github.com/expo/skills) — Use Expo DOM components to run web code in native webviews and incrementally migrate web to native
- [**vercel-composition-patterns**](https://github.com/vercel-labs/agent-skills) — React composition patterns and component architecture from Vercel Engineering
- [**vercel-react-best-practices**](https://github.com/vercel-labs/agent-skills) — React performance optimization and best practices from Vercel Engineering
- [**vercel-react-native-skills**](https://github.com/vercel-labs/agent-skills) — React Native performance and best practices from Vercel Engineering
- [**vite**](https://github.com/antfu/skills) — Vite build tool best practices, configuration, and plugin development
- [**vue**](https://github.com/antfu/skills) — Vue.js framework best practices and idiomatic patterns from Anthony Fu
- [**vue-best-practices**](https://github.com/hyf0/vue-skills) — Vue 3 best practices with Composition API, script setup, and TypeScript
- [**vue-debug-guides**](https://github.com/hyf0/vue-skills) — Vue 3 debugging techniques and error handling patterns
- [**vueuse-functions**](https://github.com/antfu/skills) — VueUse composable functions and utility patterns for Vue
- [**web-artifacts-builder**](https://github.com/anthropics/skills) — Build multi-component web artifacts using React, Tailwind, and modern frontend tools

</details>

### Marketing (27)

<details>
<summary>Show 27 skills</summary>

- [**ab-test-setup**](https://github.com/coreyhaines31/marketingskills) — Set up and run A/B tests for marketing optimization
- [**analytics-tracking**](https://github.com/coreyhaines31/marketingskills) — Set up analytics tracking and measurement plans for marketing
- [**backlink-analyzer**](https://github.com/aaron-he-zhu/seo-geo-claude-skills) — SEO backlink analysis and link building strategy tool
- [**competitor-alternatives**](https://github.com/coreyhaines31/marketingskills) — Analyze competitors and craft alternative positioning strategies
- [**content-strategy**](https://github.com/coreyhaines31/marketingskills) — Develop content marketing strategy and editorial plans
- [**copy-editing**](https://github.com/coreyhaines31/marketingskills) — Edit and improve marketing copy for clarity and impact
- [**copywriting**](https://github.com/coreyhaines31/marketingskills) — Write persuasive marketing copy and sales content
- [**email-sequence**](https://github.com/coreyhaines31/marketingskills) — Design email marketing sequences and drip campaign automations
- [**form-cro**](https://github.com/coreyhaines31/marketingskills) — Optimize form design and user flow for higher conversion rates
- [**free-tool-strategy**](https://github.com/coreyhaines31/marketingskills) — Create free tools as marketing lead generation and growth strategy
- [**launch-strategy**](https://github.com/coreyhaines31/marketingskills) — Plan and execute product launch strategies and go-to-market plans
- [**marketing-ideas**](https://github.com/coreyhaines31/marketingskills) — Generate creative marketing campaign ideas and growth strategies
- [**marketing-psychology**](https://github.com/coreyhaines31/marketingskills) — Apply psychological principles to marketing and persuasion strategies
- [**onboarding-cro**](https://github.com/coreyhaines31/marketingskills) — Optimize user onboarding flows for activation and conversion
- [**page-cro**](https://github.com/coreyhaines31/marketingskills) — Optimize landing pages for higher conversion rates
- [**paid-ads**](https://github.com/coreyhaines31/marketingskills) — Create and optimize paid advertising campaigns across platforms
- [**paywall-upgrade-cro**](https://github.com/coreyhaines31/marketingskills) — Optimize paywall and upgrade prompts for subscription conversion
- [**popup-cro**](https://github.com/coreyhaines31/marketingskills) — Design and optimize marketing popups for conversion and engagement
- [**pricing-strategy**](https://github.com/coreyhaines31/marketingskills) — Design and optimize pricing models, tiers, and monetization strategies
- [**product-marketing-context**](https://github.com/coreyhaines31/marketingskills) — Define product positioning, messaging, and marketing context
- [**programmatic-seo**](https://github.com/coreyhaines31/marketingskills) — Create programmatic SEO pages at scale for organic traffic growth
- [**referral-program**](https://github.com/coreyhaines31/marketingskills) — Design and implement customer referral programs for growth
- [**schema-markup**](https://github.com/coreyhaines31/marketingskills) — Implement structured data and schema markup for better SEO
- [**seo-audit**](https://github.com/coreyhaines31/marketingskills) — Audit website SEO and provide actionable optimization recommendations
- [**seo-geo**](https://github.com/resciencelab/opc-skills) — Geographic SEO optimization and local search strategies
- [**signup-flow-cro**](https://github.com/coreyhaines31/marketingskills) — Optimize signup flows and registration for higher conversion
- [**social-content**](https://github.com/coreyhaines31/marketingskills) — Create engaging social media content and posts across platforms

</details>

### Workflow (21)

<details>
<summary>Show 21 skills</summary>

- [**antfu**](https://github.com/antfu/skills) — Anthony Fu's coding conventions and project setup preferences
- [**brainstorming**](https://github.com/obra/superpowers) — Structured creative brainstorming and ideation before implementation
- [**dispatching-parallel-agents**](https://github.com/obra/superpowers) — Dispatch and coordinate independent tasks across parallel agents
- [**executing-plans**](https://github.com/obra/superpowers) — Execute implementation plans step-by-step with review checkpoints
- [**find-skills**](https://github.com/vercel-labs/skills) — Discover and install skills from the open agent skills ecosystem
- [**finishing-a-development-branch**](https://github.com/obra/superpowers) — Complete and integrate development branch work with proper review
- [**git-advanced-workflows**](https://github.com/wshobson/agents) — Advanced Git workflows, branching strategies, and collaboration patterns
- [**planning-with-files**](https://github.com/othmanadi/planning-with-files) — File-based planning and task management for AI agent workflows
- [**pnpm**](https://github.com/antfu/skills) — pnpm package manager best practices and workspace patterns
- [**ralph-tui-prd**](https://github.com/subsy/ralph-tui) — Generate structured product requirements documents for AI agent execution with ralph-tui
- [**skill-creator**](https://github.com/anthropics/skills) — Guide for creating effective skills. This skill should be used when users want to create a new skill (or update an existing skill) that extends Claude's capabilities with specialized knowledge, workflows, or tool integrations.
- [**skillshare**](https://github.com/runkids/skillshare/tree/main/skills/skillshare) — Built-in AI skill for skillshare – helps install, search, and manage skills from the hub
- [**stitch-loop**](https://github.com/google-labs-code/stitch-skills) — Iterative design-code loop patterns from Google Labs Stitch
- [**subagent-driven-development**](https://github.com/obra/superpowers) — Execute implementation tasks using coordinated parallel subagents
- [**systematic-debugging**](https://github.com/obra/superpowers) — Systematic approach to diagnosing and fixing bugs before proposing solutions
- [**template-skill**](https://github.com/anthropics/skills) — Template and starter for creating new AI agent skills
- [**using-git-worktrees**](https://github.com/obra/superpowers) — Use git worktrees for isolated feature development without stashing
- [**using-superpowers**](https://github.com/obra/superpowers) — Discover and use available superpowers skills at conversation start
- [**verification-before-completion**](https://github.com/obra/superpowers) — Run verification commands before claiming work is complete or fixed
- [**writing-plans**](https://github.com/obra/superpowers) — Create structured, step-by-step implementation plans before writing code
- [**writing-skills**](https://github.com/obra/superpowers) — Create, edit, and verify skills for AI code agents

</details>

### Agent (34)

<details>
<summary>Show 34 skills</summary>

- [**agent-browser**](https://github.com/vercel-labs/agent-browser) — Browser automation agent for web page interactions using Playwright
- [**agent-tools**](https://github.com/inf-sh/skills) — Run 150+ AI apps in the cloud via inference.sh CLI — image, video, LLM, search, and more
- [**agentation**](https://github.com/benjitaylor/agentation) — Agent coordination framework for multi-agent task execution
- [**ai-sdk**](https://github.com/vercel/ai) — Vercel AI SDK patterns for building AI-powered applications
- [**baoyu-article-illustrator**](https://github.com/jimliu/baoyu-skills) — Generate illustrations for articles and blog posts
- [**baoyu-comic**](https://github.com/jimliu/baoyu-skills) — Create comic strips and visual stories from text prompts
- [**baoyu-compress-image**](https://github.com/jimliu/baoyu-skills) — Compress and optimize images for web and social media
- [**baoyu-cover-image**](https://github.com/jimliu/baoyu-skills) — Generate cover images for articles, posts, and social media
- [**baoyu-danger-gemini-web**](https://github.com/jimliu/baoyu-skills) — Web browsing and research using Gemini API integration
- [**baoyu-danger-x-to-markdown**](https://github.com/jimliu/baoyu-skills) — Convert X/Twitter posts and threads to Markdown format
- [**baoyu-image-gen**](https://github.com/jimliu/baoyu-skills) — Generate images from text prompts using AI models
- [**baoyu-infographic**](https://github.com/jimliu/baoyu-skills) — Create infographic visualizations from data and text
- [**baoyu-post-to-wechat**](https://github.com/jimliu/baoyu-skills) — Publish and format content for WeChat Official Accounts
- [**baoyu-post-to-x**](https://github.com/jimliu/baoyu-skills) — Compose and publish posts to X/Twitter with media support
- [**baoyu-slide-deck**](https://github.com/jimliu/baoyu-skills) — Generate presentation slide decks from text content
- [**baoyu-url-to-markdown**](https://github.com/jimliu/baoyu-skills) — Convert web page content to clean Markdown format
- [**baoyu-xhs-images**](https://github.com/jimliu/baoyu-skills) — Create image posts optimized for Xiaohongshu (RED) platform
- [**browser-use**](https://github.com/browser-use/browser-use) — Browser automation CLI for persistent session-based web interactions
- [**chatgpt-app-builder**](https://github.com/mcp-use/mcp-use) — Build ChatGPT-powered applications with MCP integration
- [**clawdirect**](https://github.com/napoleond/clawdirect) — Directory of social web experiences for AI agents — browse, like, and manage listings
- [**clawdirect-dev**](https://github.com/napoleond/clawdirect) — Development tools and utilities for ClawDirect directory extensions
- [**enhance-prompt**](https://github.com/google-labs-code/stitch-skills) — AI prompt enhancement and optimization techniques
- [**firecrawl**](https://github.com/firecrawl/cli) — Web scraping and crawling with Firecrawl for structured data extraction
- [**humanizer-zh**](https://github.com/op7418/humanizer-zh) — Chinese text humanization for natural-sounding AI-generated content
- [**inf-agent-browser**](https://github.com/inf-sh/skills) — Browser automation for AI agents via inference.sh with element refs and session management
- [**instaclaw**](https://github.com/napoleond/instaclaw) — AI agent photo sharing platform — generate, share, and interact with AI-created content
- [**mastra**](https://github.com/mastra-ai/skills) — Mastra AI agent framework patterns and workflow orchestration
- [**mcp-builder**](https://github.com/anthropics/skills) — Build Model Context Protocol (MCP) servers and tools for AI agents
- [**mcp-builder-mcp-use**](https://github.com/mcp-use/mcp-use) — MCP server builder and integration patterns via mcp-use
- [**nblm**](https://github.com/magicseek/nblm) — NBLM natural language business logic modeling and generation
- [**prompt-engineering-patterns**](https://github.com/wshobson/agents) — Prompt engineering patterns for effective AI agent interactions
- [**release-skills**](https://github.com/jimliu/baoyu-skills) — Automate release notes and changelog generation
- [**remembering-conversations**](https://github.com/obra/episodic-memory) — Episodic memory for AI agents to maintain conversation context
- [**seedance2-api**](https://github.com/hexiaochun/seedance2-api) — Seedance2 video generation API integration and workflow

</details>

### Design (17)

<details>
<summary>Show 17 skills</summary>

- [**algorithmic-art**](https://github.com/anthropics/skills) — Generate algorithmic and generative art with code
- [**brand-guidelines**](https://github.com/anthropics/skills) — Create and maintain brand identity guidelines and visual standards
- [**canvas-design**](https://github.com/anthropics/skills) — Design and generate HTML canvas-based visuals and interactive graphics
- [**design-md**](https://github.com/google-labs-code/stitch-skills) — Design system documentation and component specification in Markdown
- [**design-system-patterns**](https://github.com/wshobson/agents) — Design system architecture and component library patterns
- [**frontend-design**](https://github.com/anthropics/skills) — Create distinctive, production-grade frontend interfaces with high design quality
- [**interface-design**](https://github.com/dammyjay93/interface-design) — User interface design principles and interaction patterns
- [**mobile-android-design**](https://github.com/wshobson/agents) — Android mobile UI design patterns and Material Design guidelines
- [**mobile-ios-design**](https://github.com/wshobson/agents) — iOS mobile UI design patterns and Human Interface Guidelines
- [**responsive-design**](https://github.com/wshobson/agents) — Responsive web design patterns for multi-device experiences
- [**shadcn-ui**](https://github.com/giuseppe-trisciuoglio/developer-kit) — shadcn/ui component library patterns and customization
- [**slack-gif-creator**](https://github.com/anthropics/skills) — Create animated GIFs for Slack from text prompts and images
- [**tailwind-design-system**](https://github.com/wshobson/agents) — Tailwind CSS design system setup and component patterns
- [**tailwind-v4-shadcn**](https://github.com/jezweb/claude-skills) — Tailwind CSS v4 with shadcn/ui integration and component patterns
- [**theme-factory**](https://github.com/anthropics/skills) — Create and customize UI themes, color palettes, and design tokens
- [**ui-ux-pro-max**](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) — UI/UX design intelligence with 50 styles, 21 palettes, 50 font pairings, and 20 chart types
- [**web-design-guidelines**](https://github.com/vercel-labs/agent-skills) — Review UI code for Web Interface Guidelines compliance and design quality

</details>

### Docs (9)

<details>
<summary>Show 9 skills</summary>

- [**context7**](https://github.com/intellectronica/agent-skills) — Retrieve up-to-date documentation for software libraries by querying the Context7 API
- [**doc-coauthoring**](https://github.com/anthropics/skills) — Collaborative document writing, editing, and coauthoring
- [**docx**](https://github.com/anthropics/skills) — Create and edit Word documents programmatically
- [**internal-comms**](https://github.com/anthropics/skills) — Draft internal communications, announcements, and team updates
- [**obsidian-bases**](https://github.com/kepano/obsidian-skills) — Obsidian knowledge base patterns and plugin development
- [**pdf**](https://github.com/anthropics/skills) — Generate and manipulate PDF documents programmatically
- [**pptx**](https://github.com/anthropics/skills) — Create and edit PowerPoint presentations programmatically
- [**vitepress**](https://github.com/antfu/skills) — VitePress static site generator configuration and customization
- [**xlsx**](https://github.com/anthropics/skills) — Create and edit Excel spreadsheets programmatically

</details>

### Testing (9)

<details>
<summary>Show 9 skills</summary>

- [**code-review-excellence**](https://github.com/wshobson/agents) — Code review best practices for effective and constructive feedback
- [**e2e-testing-patterns**](https://github.com/wshobson/agents) — End-to-end testing patterns with Playwright and Cypress
- [**javascript-testing-patterns**](https://github.com/wshobson/agents) — JavaScript testing patterns with Jest, Vitest, and Testing Library
- [**python-testing-patterns**](https://github.com/wshobson/agents) — Python testing patterns with pytest and test automation
- [**receiving-code-review**](https://github.com/obra/superpowers) — Process and implement code review feedback effectively
- [**requesting-code-review**](https://github.com/obra/superpowers) — Request and structure code reviews for effective feedback
- [**test-driven-development**](https://github.com/obra/superpowers) — Enforce test-driven development workflow — write tests first, then implement
- [**vitest**](https://github.com/antfu/skills) — Vitest testing framework best practices and configuration patterns
- [**webapp-testing**](https://github.com/anthropics/skills) — End-to-end web application testing with Playwright and modern testing tools

</details>

### Backend (15)

<details>
<summary>Show 15 skills</summary>

- [**api-design-principles**](https://github.com/wshobson/agents) — REST API design principles and best practices
- [**architecture-patterns**](https://github.com/wshobson/agents) — Software architecture patterns and design decisions
- [**async-python-patterns**](https://github.com/wshobson/agents) — Asynchronous Python patterns with asyncio and concurrent programming
- [**convex**](https://github.com/waynesutton/convexskills) — Convex backend platform patterns and real-time data sync
- [**error-handling-patterns**](https://github.com/wshobson/agents) — Error handling patterns and resilient application design
- [**fastapi-templates**](https://github.com/wshobson/agents) — FastAPI project templates and REST API patterns for Python
- [**golang-pro**](https://github.com/jeffallan/claude-skills) — Go programming best practices, idioms, and performance patterns
- [**laravel-specialist**](https://github.com/jeffallan/claude-skills) — Laravel PHP framework best practices and application patterns
- [**nestjs-best-practices**](https://github.com/kadajett/agent-nestjs-skills) — NestJS framework best practices for scalable Node.js applications
- [**nodejs-backend-patterns**](https://github.com/wshobson/agents) — Node.js backend architecture patterns and best practices
- [**postgresql-table-design**](https://github.com/wshobson/agents) — PostgreSQL table design, indexing, and schema optimization
- [**python-performance-optimization**](https://github.com/wshobson/agents) — Python performance optimization techniques and profiling
- [**sql-optimization-patterns**](https://github.com/wshobson/agents) — SQL query optimization patterns and database performance tuning
- [**stripe-integration**](https://github.com/wshobson/agents) — Stripe payment integration patterns and best practices
- [**supabase-postgres-best-practices**](https://github.com/supabase/agent-skills) — PostgreSQL best practices, query optimization, and security for Supabase

</details>

### DevOps (24)

<details>
<summary>Show 24 skills</summary>

- [**appinsights-instrumentation**](https://github.com/microsoft/github-copilot-for-azure) — Application Insights instrumentation and telemetry for Azure applications
- [**azure-ai**](https://github.com/microsoft/github-copilot-for-azure) — Azure AI services integration and management
- [**azure-aigateway**](https://github.com/microsoft/github-copilot-for-azure) — Azure AI Gateway configuration and API management
- [**azure-compliance**](https://github.com/microsoft/github-copilot-for-azure) — Azure compliance assessment and policy management
- [**azure-cost-optimization**](https://github.com/microsoft/github-copilot-for-azure) — Azure cost optimization and spending analysis
- [**azure-deploy**](https://github.com/microsoft/github-copilot-for-azure) — Azure deployment automation and resource provisioning
- [**azure-diagnostics**](https://github.com/microsoft/github-copilot-for-azure) — Azure diagnostics and troubleshooting for cloud services
- [**azure-kusto**](https://github.com/microsoft/github-copilot-for-azure) — Azure Data Explorer (Kusto) query and analytics
- [**azure-messaging**](https://github.com/microsoft/github-copilot-for-azure) — Azure messaging services (Service Bus, Event Hubs) patterns
- [**azure-observability**](https://github.com/microsoft/github-copilot-for-azure) — Azure monitoring, logging, and observability best practices
- [**azure-postgres**](https://github.com/microsoft/github-copilot-for-azure) — Azure Database for PostgreSQL management and optimization
- [**azure-prepare**](https://github.com/microsoft/github-copilot-for-azure) — Azure environment preparation and prerequisite setup
- [**azure-rbac**](https://github.com/microsoft/github-copilot-for-azure) — Azure role-based access control and identity management
- [**azure-resource-lookup**](https://github.com/microsoft/github-copilot-for-azure) — Azure resource discovery and inventory management
- [**azure-resource-visualizer**](https://github.com/microsoft/github-copilot-for-azure) — Azure resource topology visualization and dependency mapping
- [**azure-storage**](https://github.com/microsoft/github-copilot-for-azure) — Azure Storage services configuration and best practices
- [**azure-validate**](https://github.com/microsoft/github-copilot-for-azure) — Azure resource validation and configuration verification
- [**docker-expert**](https://github.com/sickn33/antigravity-awesome-skills) — Docker containerization best practices and multi-stage builds
- [**entra-app-registration**](https://github.com/microsoft/github-copilot-for-azure) — Microsoft Entra ID app registration and authentication setup
- [**expo-cicd-workflows**](https://github.com/expo/skills) — Write EAS CI/CD workflow YAML files for Expo projects
- [**expo-deployment**](https://github.com/expo/skills) — Deploy Expo apps to iOS App Store, Android Play Store, and web hosting
- [**github-actions-templates**](https://github.com/wshobson/agents) — GitHub Actions workflow templates for CI/CD automation
- [**microsoft-foundry**](https://github.com/microsoft/github-copilot-for-azure) — Microsoft AI Foundry platform integration and management
- [**turborepo**](https://github.com/vercel/turborepo) — Turborepo monorepo build system configuration and optimization

</details>

### Security (4)

<details>
<summary>Show 4 skills</summary>

- [**audit-website**](https://github.com/squirrelscan/skills) — Security audit and vulnerability scanning for websites
- [**better-auth-best-practices**](https://github.com/better-auth/skills) — Better Auth library best practices for authentication and authorization
- [**create-auth-skill**](https://github.com/better-auth/skills) — Create custom authentication skills using Better Auth framework
- [**security-requirement-extraction**](https://github.com/wshobson/agents) — Security requirement extraction and threat modeling patterns

</details>

<!-- CATALOG:END -->

## Share Your Skill

Built a useful skill? Share it with the community! Adding your skill to this hub makes it discoverable by all skillshare users — via CLI, Web UI, or direct install.

### How to Submit

1. Fork this repo
2. Add your skill entry to the appropriate `skills/*.json` category file:
   ```json
   {
     "name": "my-skill",
     "description": "One-line description of what the skill does",
     "source": "your-username/your-repo",
     "tags": ["relevant", "tags"]
   }
   ```
3. Open a Pull Request

CI will automatically:
- Validate JSON format, required fields, and naming conventions
- Clone your skill repo and run `skillshare audit` (security scan)
- Post audit results as a PR comment

See [CONTRIBUTING.md](CONTRIBUTING.md) for full guidelines.

## Schema

```json
{
  "schemaVersion": 1,
  "skills": [
    {
      "name": "ascii-box-check",
      "description": "Verify and fix ASCII box-drawing diagram alignment in markdown files",
      "source": "runkids/my-skills",
      "skill": "ascii-box-check",
      "tags": ["docs", "workflow"],
      "riskScore": 8,
      "riskLabel": "clean",
      "auditedAt": "2026-02-22T04:00:00Z"
    }
  ]
}
```

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique, lowercase, hyphens only |
| `description` | Yes | One-line description |
| `source` | Yes | GitHub `owner/repo`, full git URL, or any platform URL (GitLab, Bitbucket, etc.) |
| `skill` | No | Specific skill name within a multi-skill repo (used with `install -s`) |
| `tags` | No | 1-3 classification tags |
| `riskScore` | No | Security audit risk score (0 = clean, 100 = critical). Auto-generated by CI. |
| `riskLabel` | No | Risk classification: `clean` / `low` / `medium` / `high` / `critical` |
| `auditedAt` | No | ISO 8601 timestamp of last audit |

## CI Automation

This hub runs three automated workflows:

| Workflow | Trigger | What it does |
|----------|---------|--------------|
| **Validate PR** | Pull request | Validates schema, runs `skillshare audit`, posts results as PR comment |
| **Update Index** | Push to main / weekly | Builds hub JSON, audits all skills, generates README catalog, commits |

## Build Your Organization's Hub

Fork this repo to create an internal hub for your team or company. What you get out of the box:

- **CI validation** — JSON format checks and `skillshare audit` security scans on every PR
- **Audit scores** — Weekly security scans with risk scores written to the hub JSON
- **Contribution workflow** — Fork → add entry → PR, with automated gates

```bash
# 1. Fork this repo and replace skills with your internal sources
#    e.g. "source": "ghe.internal.company.com/platform/ai-skills/code-review"

# 2. Or auto-generate an index from installed skills
skillshare hub index -o ./skillshare-hub.json

# 3. Team members add your hub once
skillshare hub add https://skills.internal.company.com/skillshare-hub.json --label company

# 4. Search and install — only accessible behind VPN
skillshare search --hub company
```

The key advantage: `source` fields can point to **private repos** (GitHub Enterprise, internal GitLab, etc.) that public tools like GitHub Search can never reach. Host the JSON file anywhere — internal Git repo, intranet server, S3, file share.

## Documentation

- [skillshare documentation](https://skillshare.runkids.cc/docs) — full CLI reference and guides
- [Hub Index guide](https://skillshare.runkids.cc/docs/hub-index) — create and manage hub indexes
- [CONTRIBUTING.md](CONTRIBUTING.md) — how to submit a skill

## License

[MIT](LICENSE)
