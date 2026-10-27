# New Persona

Create a new persona for your Hermes agent fleet.

## Usage

```bash
hermes-persona add my-new-persona
```

## Template

The persona will be created using the template at:
`scripts/hermes/templates/persona.template.md`

## Structure

Personas are stored in:
- `config/botfile/personal/<plugin>/<kind>/<component>`
- `config/botfile/team/<plugin>/<kind>/<component>`

Where:
- `plugin` = the persona name (e.g., `hermes-science`)
- `kind` = `skills`, `instructions`, or `commands`
- `component` = the specific persona or command name

## Example

```bash
# Create a new chemistry persona
hermes-persona add chemistry-hobbyist

# This creates:
# - config/botfile/personal/hermes-chemistry/skills/chemistry-hobbyist.md
# - config/botfile/personal/hermes-chemistry/instructions/chemistry-hobbyist.md
```