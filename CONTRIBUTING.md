# Contributing to Skillshare Hub

Thanks for sharing your skill with the community!

## How to Add a Skill

1. Fork this repo
2. Edit `skillshare-hub.json` — add your skill entry to the `skills` array
3. Open a Pull Request
4. CI will validate your entry automatically
5. A maintainer will review and merge

## Skill Entry Format

```json
{
  "name": "my-skill",
  "description": "One-line description of what the skill does",
  "source": "your-github-username/your-repo",
  "tags": ["relevant", "tags"]
}
```

### Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique skill name — lowercase, hyphens only (e.g. `commit-helper`) |
| `description` | Yes | One-line description of what the skill does |
| `source` | Yes | GitHub `owner/repo` or full URL |
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
skillshare search --hub https://raw.githubusercontent.com/nicholasgasior/skillshare-hub/main/skillshare-hub.json <query>

# Install a skill you found
skillshare install <source>
```
