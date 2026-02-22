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
**146 skills** across 11 categories — browse via `skillshare search --hub` or the Web UI

### Frontend (23)

<details>
<summary>Show 23 skills</summary>

- [**accessibility-compliance**](https://github.com/wshobson/agents) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Web accessibility compliance patterns and WCAG guidelines
- [**angular-component**](https://github.com/analogjs/angular-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Angular component architecture patterns and best practices
- [**flutter-animations**](https://github.com/madteacher/mad-agents-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Flutter animation patterns and motion design best practices
- [**flutter-expert**](https://github.com/jeffallan/claude-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Flutter framework expertise and cross-platform development patterns
- [**next-best-practices**](https://github.com/vercel-labs/next-skills) ![risk-medium](https://img.shields.io/badge/risk-medium-yellow) — Next.js performance optimization and best practices from Vercel
- [**next-cache-components**](https://github.com/vercel-labs/next-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Next.js caching strategies and optimized component patterns
- [**next-upgrade**](https://github.com/vercel-labs/next-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Next.js version upgrade guide and migration patterns
- [**nuxt**](https://github.com/antfu/skills) ![risk-low](https://img.shields.io/badge/risk-low-green) — Nuxt.js framework best practices and server-side rendering patterns
- [**pinia**](https://github.com/antfu/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Pinia state management best practices for Vue applications
- [**react-components**](https://github.com/google-labs-code/stitch-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — React component patterns and best practices from Google Labs
- [**react-doctor**](https://github.com/millionco/react-doctor) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Scans your React codebase for security, performance, correctness, and architecture issues. Outputs a 0-100 score with actionable diagnostics.
- [**react-native-best-practices**](https://github.com/callstackincubator/agent-skills) ![risk-medium](https://img.shields.io/badge/risk-medium-yellow) — React Native best practices and performance optimization from Callstack
- [**remotion**](https://github.com/google-labs-code/stitch-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Remotion video creation framework patterns from Google Labs
- [**remotion-render**](https://github.com/inference-sh-6/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Cloud-based Remotion video rendering via inference.sh
- [**swiftui-expert-skill**](https://github.com/avdlee/swiftui-agent-skill) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — SwiftUI best practices and modern iOS app development patterns
- [**unocss**](https://github.com/antfu/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — UnoCSS atomic CSS engine configuration and utility patterns
- [**upgrading-expo**](https://github.com/expo/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Upgrade Expo SDK versions and resolve dependency compatibility issues
- [**vite**](https://github.com/antfu/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Vite build tool best practices, configuration, and plugin development
- [**vue**](https://github.com/antfu/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Vue.js framework best practices and idiomatic patterns from Anthony Fu
- [**vue-best-practices**](https://github.com/hyf0/vue-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Vue 3 best practices with Composition API, script setup, and TypeScript
- [**vue-debug-guides**](https://github.com/hyf0/vue-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Vue 3 debugging techniques and error handling patterns
- [**vueuse-functions**](https://github.com/antfu/skills) ![risk-low](https://img.shields.io/badge/risk-low-green) — VueUse composable functions and utility patterns for Vue
- [**web-artifacts-builder**](https://github.com/anthropics/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Build multi-component web artifacts using React, Tailwind, and modern frontend tools

</details>

### Marketing (27)

<details>
<summary>Show 27 skills</summary>

- [**ab-test-setup**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Set up and run A/B tests for marketing optimization
- [**analytics-tracking**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Set up analytics tracking and measurement plans for marketing
- [**backlink-analyzer**](https://github.com/aaron-he-zhu/seo-geo-claude-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — SEO backlink analysis and link building strategy tool
- [**competitor-alternatives**](https://github.com/coreyhaines31/marketingskills) ![risk-low](https://img.shields.io/badge/risk-low-green) — Analyze competitors and craft alternative positioning strategies
- [**content-strategy**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Develop content marketing strategy and editorial plans
- [**copy-editing**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Edit and improve marketing copy for clarity and impact
- [**copywriting**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Write persuasive marketing copy and sales content
- [**email-sequence**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Design email marketing sequences and drip campaign automations
- [**form-cro**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Optimize form design and user flow for higher conversion rates
- [**free-tool-strategy**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Create free tools as marketing lead generation and growth strategy
- [**launch-strategy**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Plan and execute product launch strategies and go-to-market plans
- [**marketing-ideas**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Generate creative marketing campaign ideas and growth strategies
- [**marketing-psychology**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Apply psychological principles to marketing and persuasion strategies
- [**onboarding-cro**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Optimize user onboarding flows for activation and conversion
- [**page-cro**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Optimize landing pages for higher conversion rates
- [**paid-ads**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Create and optimize paid advertising campaigns across platforms
- [**paywall-upgrade-cro**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Optimize paywall and upgrade prompts for subscription conversion
- [**popup-cro**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Design and optimize marketing popups for conversion and engagement
- [**pricing-strategy**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Design and optimize pricing models, tiers, and monetization strategies
- [**product-marketing-context**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Define product positioning, messaging, and marketing context
- [**programmatic-seo**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Create programmatic SEO pages at scale for organic traffic growth
- [**referral-program**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Design and implement customer referral programs for growth
- [**schema-markup**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Implement structured data and schema markup for better SEO
- [**seo-audit**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Audit website SEO and provide actionable optimization recommendations
- [**seo-geo**](https://github.com/resciencelab/opc-skills) ![risk-low](https://img.shields.io/badge/risk-low-green) — Geographic SEO optimization and local search strategies
- [**signup-flow-cro**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Optimize signup flows and registration for higher conversion
- [**social-content**](https://github.com/coreyhaines31/marketingskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Create engaging social media content and posts across platforms

</details>

### Workflow (19)

<details>
<summary>Show 19 skills</summary>

- [**antfu**](https://github.com/antfu/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Anthony Fu's coding conventions and project setup preferences
- [**brainstorming**](https://github.com/obra/superpowers) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Structured creative brainstorming and ideation before implementation
- [**dispatching-parallel-agents**](https://github.com/obra/superpowers) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Dispatch and coordinate independent tasks across parallel agents
- [**executing-plans**](https://github.com/obra/superpowers) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Execute implementation plans step-by-step with review checkpoints
- [**find-skills**](https://github.com/vercel-labs/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Discover and install skills from the open agent skills ecosystem
- [**finishing-a-development-branch**](https://github.com/obra/superpowers) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Complete and integrate development branch work with proper review
- [**planning-with-files**](https://github.com/othmanadi/planning-with-files) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — File-based planning and task management for AI agent workflows
- [**pnpm**](https://github.com/antfu/skills) ![risk-low](https://img.shields.io/badge/risk-low-green) — pnpm package manager best practices and workspace patterns
- [**ralph-tui-prd**](https://github.com/subsy/ralph-tui) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Generate structured product requirements documents for AI agent execution with ralph-tui
- [**skill-creator**](https://github.com/anthropics/skills) ![risk-low](https://img.shields.io/badge/risk-low-green) — Guide for creating effective skills. This skill should be used when users want to create a new skill (or update an existing skill) that extends Claude's capabilities with specialized knowledge, workflows, or tool integrations.
- [**skillshare**](https://github.com/runkids/skillshare/tree/main/skills/skillshare) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Built-in AI skill for skillshare – helps install, search, and manage skills from the hub
- [**stitch-loop**](https://github.com/google-labs-code/stitch-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Iterative design-code loop patterns from Google Labs Stitch
- [**subagent-driven-development**](https://github.com/obra/superpowers) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Execute implementation tasks using coordinated parallel subagents
- [**systematic-debugging**](https://github.com/obra/superpowers) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Systematic approach to diagnosing and fixing bugs before proposing solutions
- [**using-git-worktrees**](https://github.com/obra/superpowers) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Use git worktrees for isolated feature development without stashing
- [**using-superpowers**](https://github.com/obra/superpowers) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Discover and use available superpowers skills at conversation start
- [**verification-before-completion**](https://github.com/obra/superpowers) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Run verification commands before claiming work is complete or fixed
- [**writing-plans**](https://github.com/obra/superpowers) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Create structured, step-by-step implementation plans before writing code
- [**writing-skills**](https://github.com/obra/superpowers) ![risk-critical](https://img.shields.io/badge/risk-critical-red) — Create, edit, and verify skills for AI code agents

</details>

### Agent (26)

<details>
<summary>Show 26 skills</summary>

- [**agent-browser**](https://github.com/vercel-labs/agent-browser) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Browser automation agent for web page interactions using Playwright
- [**agent-tools**](https://github.com/inf-sh/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Run 150+ AI apps in the cloud via inference.sh CLI — image, video, LLM, search, and more
- [**agentation**](https://github.com/benjitaylor/agentation) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Agent coordination framework for multi-agent task execution
- [**baoyu-article-illustrator**](https://github.com/jimliu/baoyu-skills) ![risk-low](https://img.shields.io/badge/risk-low-green) — Generate illustrations for articles and blog posts
- [**baoyu-comic**](https://github.com/jimliu/baoyu-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Create comic strips and visual stories from text prompts
- [**baoyu-compress-image**](https://github.com/jimliu/baoyu-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Compress and optimize images for web and social media
- [**baoyu-cover-image**](https://github.com/jimliu/baoyu-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Generate cover images for articles, posts, and social media
- [**baoyu-danger-gemini-web**](https://github.com/jimliu/baoyu-skills) ![risk-critical](https://img.shields.io/badge/risk-critical-red) — Web browsing and research using Gemini API integration
- [**baoyu-danger-x-to-markdown**](https://github.com/jimliu/baoyu-skills) ![risk-critical](https://img.shields.io/badge/risk-critical-red) — Convert X/Twitter posts and threads to Markdown format
- [**baoyu-image-gen**](https://github.com/jimliu/baoyu-skills) ![risk-critical](https://img.shields.io/badge/risk-critical-red) — Generate images from text prompts using AI models
- [**baoyu-infographic**](https://github.com/jimliu/baoyu-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Create infographic visualizations from data and text
- [**baoyu-post-to-wechat**](https://github.com/jimliu/baoyu-skills) ![risk-critical](https://img.shields.io/badge/risk-critical-red) — Publish and format content for WeChat Official Accounts
- [**baoyu-post-to-x**](https://github.com/jimliu/baoyu-skills) ![risk-low](https://img.shields.io/badge/risk-low-green) — Compose and publish posts to X/Twitter with media support
- [**baoyu-slide-deck**](https://github.com/jimliu/baoyu-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Generate presentation slide decks from text content
- [**baoyu-url-to-markdown**](https://github.com/jimliu/baoyu-skills) ![risk-medium](https://img.shields.io/badge/risk-medium-yellow) — Convert web page content to clean Markdown format
- [**baoyu-xhs-images**](https://github.com/jimliu/baoyu-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Create image posts optimized for Xiaohongshu (RED) platform
- [**browser-use**](https://github.com/browser-use/browser-use) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Browser automation CLI for persistent session-based web interactions
- [**chatgpt-app-builder**](https://github.com/mcp-use/mcp-use) ![risk-low](https://img.shields.io/badge/risk-low-green) — Build ChatGPT-powered applications with MCP integration
- [**clawdirect**](https://github.com/napoleond/clawdirect) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Directory of social web experiences for AI agents — browse, like, and manage listings
- [**clawdirect-dev**](https://github.com/napoleond/clawdirect) ![risk-medium](https://img.shields.io/badge/risk-medium-yellow) — Development tools and utilities for ClawDirect directory extensions
- [**enhance-prompt**](https://github.com/google-labs-code/stitch-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — AI prompt enhancement and optimization techniques
- [**mastra**](https://github.com/mastra-ai/skills) ![risk-low](https://img.shields.io/badge/risk-low-green) — Mastra AI agent framework patterns and workflow orchestration
- [**mcp-builder**](https://github.com/anthropics/skills) ![risk-medium](https://img.shields.io/badge/risk-medium-yellow) — Build Model Context Protocol (MCP) servers and tools for AI agents
- [**release-skills**](https://github.com/jimliu/baoyu-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Automate release notes and changelog generation
- [**remembering-conversations**](https://github.com/obra/episodic-memory) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Episodic memory for AI agents to maintain conversation context
- [**seedance2-api**](https://github.com/hexiaochun/seedance2-api) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Seedance2 video generation API integration and workflow

</details>

### Design (10)

<details>
<summary>Show 10 skills</summary>

- [**algorithmic-art**](https://github.com/anthropics/skills) ![risk-low](https://img.shields.io/badge/risk-low-green) — Generate algorithmic and generative art with code
- [**brand-guidelines**](https://github.com/anthropics/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Create and maintain brand identity guidelines and visual standards
- [**canvas-design**](https://github.com/anthropics/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Design and generate HTML canvas-based visuals and interactive graphics
- [**design-md**](https://github.com/google-labs-code/stitch-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Design system documentation and component specification in Markdown
- [**frontend-design**](https://github.com/anthropics/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Create distinctive, production-grade frontend interfaces with high design quality
- [**interface-design**](https://github.com/dammyjay93/interface-design) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — User interface design principles and interaction patterns
- [**slack-gif-creator**](https://github.com/anthropics/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Create animated GIFs for Slack from text prompts and images
- [**theme-factory**](https://github.com/anthropics/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Create and customize UI themes, color palettes, and design tokens
- [**ui-ux-pro-max**](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) ![risk-low](https://img.shields.io/badge/risk-low-green) — UI/UX design intelligence with 50 styles, 21 palettes, 50 font pairings, and 20 chart types
- [**web-design-guidelines**](https://github.com/vercel-labs/agent-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Review UI code for Web Interface Guidelines compliance and design quality

</details>

### Docs (9)

<details>
<summary>Show 9 skills</summary>

- [**context7**](https://github.com/intellectronica/agent-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Retrieve up-to-date documentation for software libraries by querying the Context7 API
- [**doc-coauthoring**](https://github.com/anthropics/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Collaborative document writing, editing, and coauthoring
- [**docx**](https://github.com/anthropics/skills) ![risk-critical](https://img.shields.io/badge/risk-critical-red) — Create and edit Word documents programmatically
- [**internal-comms**](https://github.com/anthropics/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Draft internal communications, announcements, and team updates
- [**obsidian-bases**](https://github.com/kepano/obsidian-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Obsidian knowledge base patterns and plugin development
- [**pdf**](https://github.com/anthropics/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Generate and manipulate PDF documents programmatically
- [**pptx**](https://github.com/anthropics/skills) ![risk-critical](https://img.shields.io/badge/risk-critical-red) — Create and edit PowerPoint presentations programmatically
- [**vitepress**](https://github.com/antfu/skills) ![risk-low](https://img.shields.io/badge/risk-low-green) — VitePress static site generator configuration and customization
- [**xlsx**](https://github.com/anthropics/skills) ![risk-critical](https://img.shields.io/badge/risk-critical-red) — Create and edit Excel spreadsheets programmatically

</details>

### Testing (5)

<details>
<summary>Show 5 skills</summary>

- [**receiving-code-review**](https://github.com/obra/superpowers) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Process and implement code review feedback effectively
- [**requesting-code-review**](https://github.com/obra/superpowers) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Request and structure code reviews for effective feedback
- [**test-driven-development**](https://github.com/obra/superpowers) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Enforce test-driven development workflow — write tests first, then implement
- [**vitest**](https://github.com/antfu/skills) ![risk-critical](https://img.shields.io/badge/risk-critical-red) — Vitest testing framework best practices and configuration patterns
- [**webapp-testing**](https://github.com/anthropics/skills) ![risk-medium](https://img.shields.io/badge/risk-medium-yellow) — End-to-end web application testing with Playwright and modern testing tools

</details>

### Backend (4)

<details>
<summary>Show 4 skills</summary>

- [**convex**](https://github.com/waynesutton/convexskills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Convex backend platform patterns and real-time data sync
- [**golang-pro**](https://github.com/jeffallan/claude-skills) ![risk-high](https://img.shields.io/badge/risk-high-orange) — Go programming best practices, idioms, and performance patterns
- [**laravel-specialist**](https://github.com/jeffallan/claude-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Laravel PHP framework best practices and application patterns
- [**supabase-postgres-best-practices**](https://github.com/supabase/agent-skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — PostgreSQL best practices, query optimization, and security for Supabase

</details>

### DevOps (22)

<details>
<summary>Show 22 skills</summary>

- [**appinsights-instrumentation**](https://github.com/microsoft/github-copilot-for-azure) ![risk-low](https://img.shields.io/badge/risk-low-green) — Application Insights instrumentation and telemetry for Azure applications
- [**azure-ai**](https://github.com/microsoft/github-copilot-for-azure) ![risk-low](https://img.shields.io/badge/risk-low-green) — Azure AI services integration and management
- [**azure-aigateway**](https://github.com/microsoft/github-copilot-for-azure) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Azure AI Gateway configuration and API management
- [**azure-compliance**](https://github.com/microsoft/github-copilot-for-azure) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Azure compliance assessment and policy management
- [**azure-cost-optimization**](https://github.com/microsoft/github-copilot-for-azure) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Azure cost optimization and spending analysis
- [**azure-deploy**](https://github.com/microsoft/github-copilot-for-azure) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Azure deployment automation and resource provisioning
- [**azure-diagnostics**](https://github.com/microsoft/github-copilot-for-azure) ![risk-low](https://img.shields.io/badge/risk-low-green) — Azure diagnostics and troubleshooting for cloud services
- [**azure-kusto**](https://github.com/microsoft/github-copilot-for-azure) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Azure Data Explorer (Kusto) query and analytics
- [**azure-messaging**](https://github.com/microsoft/github-copilot-for-azure) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Azure messaging services (Service Bus, Event Hubs) patterns
- [**azure-observability**](https://github.com/microsoft/github-copilot-for-azure) ![risk-low](https://img.shields.io/badge/risk-low-green) — Azure monitoring, logging, and observability best practices
- [**azure-postgres**](https://github.com/microsoft/github-copilot-for-azure) ![risk-low](https://img.shields.io/badge/risk-low-green) — Azure Database for PostgreSQL management and optimization
- [**azure-prepare**](https://github.com/microsoft/github-copilot-for-azure) ![risk-critical](https://img.shields.io/badge/risk-critical-red) — Azure environment preparation and prerequisite setup
- [**azure-rbac**](https://github.com/microsoft/github-copilot-for-azure) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Azure role-based access control and identity management
- [**azure-resource-lookup**](https://github.com/microsoft/github-copilot-for-azure) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Azure resource discovery and inventory management
- [**azure-resource-visualizer**](https://github.com/microsoft/github-copilot-for-azure) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Azure resource topology visualization and dependency mapping
- [**azure-storage**](https://github.com/microsoft/github-copilot-for-azure) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Azure Storage services configuration and best practices
- [**azure-validate**](https://github.com/microsoft/github-copilot-for-azure) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Azure resource validation and configuration verification
- [**docker-expert**](https://github.com/sickn33/antigravity-awesome-skills) ![risk-low](https://img.shields.io/badge/risk-low-green) — Docker containerization best practices and multi-stage builds
- [**entra-app-registration**](https://github.com/microsoft/github-copilot-for-azure) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Microsoft Entra ID app registration and authentication setup
- [**expo-deployment**](https://github.com/expo/skills) ![risk-low](https://img.shields.io/badge/risk-low-green) — Deploy Expo apps to iOS App Store, Android Play Store, and web hosting
- [**microsoft-foundry**](https://github.com/microsoft/github-copilot-for-azure) ![risk-low](https://img.shields.io/badge/risk-low-green) — Microsoft AI Foundry platform integration and management
- [**turborepo**](https://github.com/vercel/turborepo) ![risk-low](https://img.shields.io/badge/risk-low-green) — Turborepo monorepo build system configuration and optimization

</details>

### Security (1)

<details>
<summary>Show 1 skills</summary>

- [**audit-website**](https://github.com/squirrelscan/skills) ![risk-clean](https://img.shields.io/badge/risk-clean-brightgreen) — Security audit and vulnerability scanning for websites

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
