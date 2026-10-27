---
name: "{{PERSONA_NAME}}"
description: "{{SHORT_DESCRIPTION}}"
role: "{{ROLE}}"  # e.g., researcher, engineer, analyst, curator
version: "1.0"
tags: [{{TAGS}}]
---

# {{PERSONA_NAME}}

## System Prompt

{{SYSTEM_PROMPT}}

## Capabilities

- [ ] Filesystem access
- [ ] Web search
- [ ] Git operations
- [ ] Code execution
- [ ] Data analysis
- [ ] Visualization

## Projects

{{PROJECTS}}

## Settings

- auto_run: {{AUTO_RUN}}
- interval_hours: {{INTERVAL_HOURS}}
- priority: {{PRIORITY}}

## Metadata

- author: "{{AUTHOR}}"
- created: "{{CREATED_DATE}}"
- updated: "{{UPDATED_DATE}}"