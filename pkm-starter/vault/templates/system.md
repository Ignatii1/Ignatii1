---
type: system
id: SYS-{{SLUG}}
title: {{TITLE}}
systems: [{{SLUG}}]
status: active
tier:                 # 1 = business-critical (shown ⚠️ on the map), 2, 3
depends_on: []        # upstream system slugs — drives MAP.md. Be complete here.
used_by: []           # downstream system slugs
created: {{DATE}}
updated: {{DATE}}
tags: []
---

# {{TITLE}}

**One-line purpose:**
**Business impact if down:**
**Owner / escalation:** → `contacts/`

## Access
- Console/URL:
- Auth method:
- Credentials: 1Password → ""    <!-- NEVER inline a secret -->
- My access level:

## Topology
- Hosts/instances:
- Version / build:
- Depends on:            <!-- upstream systems; use systems/ slugs -->
- Depended on by:        <!-- downstream -->

## Where things live
- Logs:
- Config:
- Backups (and last verified restore):
- Monitoring/alerts:

## Known quirks
<!-- The highest-value section. Things that cost you hours once. -->
- 

## Recurring work
<!-- Link runbooks -->
- 

## History
<!-- Link incidents + decisions -->
- 

## Open questions / gaps
- 
