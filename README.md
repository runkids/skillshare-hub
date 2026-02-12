<h1 align="center">skillshare-hub</h1>

<p align="center">
  <strong>Community-curated catalog of <a href="https://github.com/runkids/skillshare">skillshare</a> skills.</strong><br>
  Search, discover, and share AI CLI skills with the community.
</p>

<p align="center">
  <a href="https://github.com/runkids/skillshare-hub/blob/main/skillshare-hub.json"><img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Frunkids%2Fskillshare-hub%2Fmain%2Fskillshare-hub.json&query=%24.skills.length&label=skills&color=blue" alt="Skill Count"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
</p>

## What is this?

A community-maintained index of [skillshare](https://github.com/runkids/skillshare) skills. Anyone can submit their skill via Pull Request — every submission is validated by CI and security-scanned with `skillshare audit`.

## Usage

### Search via CLI

```bash
skillshare search --hub https://raw.githubusercontent.com/runkids/skillshare-hub/main/skillshare-hub.json <query>
```

### Install a skill you found

```bash
skillshare install <source>
```

### Browse all skills

```bash
skillshare search --hub https://raw.githubusercontent.com/runkids/skillshare-hub/main/skillshare-hub.json --json | jq
```

## Add Your Skill

1. Fork this repo
2. Add your skill to `skillshare-hub.json`:
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

See [CONTRIBUTING.md](CONTRIBUTING.md) for full guidelines.

## Schema

```json
{
  "schemaVersion": 1,
  "skills": [
    {
      "name": "commit-helper",
      "description": "Git commit best practices for conventional commits",
      "source": "alice/commit-helper",
      "tags": ["git", "workflow"]
    }
  ]
}
```

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique, lowercase, hyphens only |
| `description` | Yes | One-line description |
| `source` | Yes | GitHub `owner/repo` or full URL |
| `tags` | No | 1-3 classification tags |

## Host Your Own Hub

The same `skillshare-hub.json` schema works for enterprise or private hubs:

```bash
# Generate an index from a local skill directory
skillshare hub index --dir ./my-skills --output skillshare-hub.json

# Search your private hub
skillshare search --hub https://your-internal-url/skillshare-hub.json <query>
```

## License

[MIT](LICENSE)
