# Hermes Persona Manager

A botfile-inspired CLI for managing Hermes agent personas following the botfile standard.

## Overview

This system uses the [botfile standard](https://botfile.org/) to manage Hermes agent personas across multiple agents. It provides:

- **Personas** (skills + instructions) for each Hermes agent
- **Team standards** shared across all agents
- Symlinks from a version-controlled source to `~/.hermes/` targets
- Idempotent sync: safe to run repeatedly

## Structure

```
config/botfile/
  config.toml                     # Botfile config (sources + selections)
  personal/
    hermes-science/
      skills/open-science-researcher.md
      instructions/open-science-researcher.md
    hermes-chemistry/
      skills/chemistry-hobbyist.md
      instructions/chemistry-hobbyist.md
    hermes-biology/
      skills/biology-researcher.md
      instructions/biology-researcher.md
  team/
    standards/
      instructions/
        interaction-guidelines.md
        safety-protocols.md
        documentation-standards.md

scripts/hermes/
  hermes-persona                # CLI tool
  templates/
    persona.template.md         # Persona template
    commands/new-persona.md     # Command template
```

## Usage

```bash
# Show status of all personas
./scripts/hermes/hermes-persona status

# Show what sync would do (dry run)
./scripts/hermes/hermes-persona plan

# Create symlinks (idempotent)
./scripts/hermes/hermes-persona sync

# List all available personas
./scripts/hermes/hermes-persona list

# Show details of a specific persona
./scripts/hermes/hermes-persona show open-science-researcher
```

## Botfile Grammar

Personas follow the `<source>/<plugin>/<kind>/<component>` grammar:

- **source**: `personal` or `team`
- **plugin**: The persona group (e.g., `hermes-science`, `hermes-chemistry`, `hermes-biology`, `standards`)
- **kind**: `skills` or `instructions`
- **component**: The specific persona or instruction name

## Adding a New Persona

1. Create a new persona directory under `config/botfile/personal/`:

```bash
mkdir -p config/botfile/personal/hermes-physics/skills
mkdir -p config/botfile/personal/hermes-physics/instructions
```

2. Create persona skill and instruction files using the template.

3. Add selections to `config/botfile/config.toml`:

```toml
[[selections]]
source = "personal"
plugin = "hermes-physics"
component = "skills/physics-researcher.md"
agents = ["hermes-physics"]
```

4. Run sync:

```bash
./scripts/hermes/hermes-persona sync
```

## Available Personas

| Persona | Agent | Description |
|---------|-------|-------------|
| open-science-researcher | hermes-science | Open science research, transparency, reproducibility |
| chemistry-hobbyist | hermes-chemistry | Hobby chemistry, safety, education |
| biology-researcher | hermes-biology | Biological research, data analysis |

## Team Standards

Shared across all Hermes agents:

- **interaction-guidelines** - Standard interaction guidelines
- **safety-protocols** - Standard safety protocols
- **documentation-standards** - Documentation standards