# Contributing to Skillshare Hub

Thanks for sharing your skill with the community!

## How to Add a Skill

1. Fork this repo
2. Edit `skillshare-hub.json` — add your skill entry to the `skills` array
3. Open a Pull Request
4. CI will validate your entry automatically
5. A maintainer will review and merge

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

Multi-skill repo (use `skill` to specify which one):

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
| `source` | Yes | GitHub `owner/repo`, full git URL, or any platform URL |
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

## Using Skills from the Hub

```bash
# Search the hub
skillshare search --hub https://raw.githubusercontent.com/runkids/skillshare-hub/main/skillshare-hub.json <query>

# Install a skill you found
skillshare install <source>

# Install a specific skill from a multi-skill repo
skillshare install <source> -s <skill>
```
