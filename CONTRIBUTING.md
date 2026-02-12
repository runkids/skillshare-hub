# Contributing to Skillshare Hub

Thanks for sharing your skill with the community!

## How to Add a Skill

1. Fork this repo
2. Find the right category file in `skills/` (see [Categories](#categories) below)
3. Add your skill entry to the JSON array in that file
4. Run `make build` to regenerate `skillshare-hub.json`
5. Commit **both** the `skills/*.json` change and `skillshare-hub.json`
6. Open a Pull Request
7. CI will validate and audit your entry automatically
8. A maintainer will review and merge

> **Important**: Do not edit `skillshare-hub.json` directly — it is generated from `skills/*.json` by `make build`. CI will reject PRs where the hub file is out of sync.

## Categories

| File | Description |
|------|-------------|
| `skills/skill.json` | Hub meta-skills (skillshare, skill-creator, find-skills, template-skill) |
| `skills/anthropic.json` | Skills from `anthropics/skills` |
| `skills/marketing.json` | Skills from `coreyhaines31/marketingskills` |
| `skills/workflow.json` | Skills from `obra/superpowers` and `obra/episodic-memory` |
| `skills/expo.json` | Skills from `expo/skills` |
| `skills/vercel.json` | Skills from `vercel-labs/*` and `vercel/*` |
| `skills/community.json` | Everything else — independent authors and orgs |

> **Not sure where to put your skill?** Just add it to `skills/community.json`. Maintainers will move it if needed.

## Skill Entry Format

Single-skill repo:

```json
{
  "name": "my-skill",
  "description": "One-line description of what the skill does",
  "source": "your-username/your-repo",
  "tags": ["relevant", "tags"]
}
```

Multi-skill repo (use subpath in `source`):

```json
{
  "name": "my-skill",
  "description": "One-line description of what the skill does",
  "source": "your-username/your-repo/my-skill",
  "tags": ["relevant", "tags"]
}
```

Multi-skill repo (use `skill` field to specify which one):

```json
{
  "name": "ascii-box-check",
  "description": "Verify and fix ASCII box-drawing diagram alignment",
  "source": "runkids/my-skills",
  "skill": "ascii-box-check",
  "tags": ["docs", "workflow"]
}
```

Non-GitHub platforms (GitLab, Bitbucket, self-hosted, etc.):

```json
{
  "name": "deploy-guard",
  "description": "Pre-deployment safety checks and rollback procedures",
  "source": "https://gitlab.com/team/deploy-guard",
  "tags": ["devops", "security"]
}
```

### Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique skill name — lowercase, hyphens only (e.g. `commit-helper`) |
| `description` | Yes | One-line description of what the skill does |
| `source` | Yes | GitHub `owner/repo[/subpath]`, full git URL, or any platform URL |
| `skill` | No | Specific skill name within a multi-skill repo (installs via `-s`) |
| `tags` | No | 1-3 classification tags |

### Tags

Use lowercase, single words or hyphenated:

`git` · `workflow` · `testing` · `security` · `frontend` · `backend` · `devops` · `docs` · `ai` · `code-review` · `python` · `react` · `typescript`

Feel free to introduce new tags if none fit — maintainers may suggest changes during review.

## Quality Guidelines

- **One skill per entry** — don't bundle multiple skills into one
- **Working source** — the `source` repo must be publicly accessible and contain a valid `SKILL.md`
- **Clear description** — explain what the skill does, not how it works
- **No duplicates** — search existing entries before adding

## Local Development

```bash
make build      # Build skillshare-hub.json from skills/*.json
make validate   # Validate format and rules
make audit      # Audit new/changed skills against main
make ci         # Run all three (build → validate → audit)
```

## Using Skills from the Hub

```bash
# Search the hub
skillshare search --hub https://raw.githubusercontent.com/runkids/skillshare-hub/main/skillshare-hub.json <query>

# Install a skill you found
skillshare install <source>

# Install a specific skill from a multi-skill repo
skillshare install <source> -s <skill>
```
