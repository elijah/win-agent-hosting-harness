# win-agent-hosting-harness

Bootstrapping and maintenance scripts for the host that runs:
- **Hermes agent** — AI agent runtime
- **Ekko-studio dashboard** — project tracking dashboard

## Structure

```
scripts/
  bootstrap/    # Initial host setup scripts
  maintenance/  # Ongoing maintenance and monitoring scripts
  helpers/      # Shared utility functions
```

## Usage

See individual scripts in `scripts/` for usage details. Most scripts are idempotent and can be run multiple times safely.