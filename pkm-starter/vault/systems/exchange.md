---
type: system
id: SYS-exchange
title: Exchange Server 2019 (on-prem, hybrid)
systems: [exchange]
status: active
created: 2026-09-04
updated: 2026-09-04
tags: [email, smtp, hybrid, example]
---

# Exchange Server 2019 (on-prem, hybrid)

> ⚠️ **EXAMPLE NOTE** — synthetic, ships with the starter kit to demonstrate the format.
> Delete it (or run `bootstrap.sh --clean`) before real use.

**One-line purpose:** Mailboxes for staff not yet migrated to Exchange Online; SMTP relay for
line-of-business apps.
**Business impact if down:** Total — no internal or external mail, and ~12 LOB apps lose
notification delivery. P1.
**Owner / escalation:** me → infra lead → vendor (see `contacts/`)

## Access
- Console: EAC at `https://mail.internal.example/ecp`, EMS on `EXCH-01`
- Auth: domain admin account, MFA via authenticator
- Credentials: 1Password → "svc-exchange-admin"    <!-- NEVER inline a secret -->
- My access level: Organization Management

## Topology
- Hosts: `EXCH-01`, `EXCH-02` (DAG `DAG-MAIL`), Windows Server 2019
- Version: Exchange 2019 CU14
- Depends on: `adcs` (TLS certs), Active Directory, DNS, the perimeter firewall
- Depended on by: 12 LOB apps relaying via connector `LOB-Relay`

## Where things live
- Logs: `D:\Exchange\Logging\`, SMTP protocol logs under `.\ProtocolLog\SmtpReceive\`
- Config: EMS `Get-TransportConfig`, `Get-ReceiveConnector`
- Backups: Veeam, nightly 01:00. **Last verified restore: 2026-07-12** (mailbox-level, ok)
- Monitoring: SCOM mail-flow pack; synthetic transaction every 5 min

## Known quirks
<!-- Highest-value section: things that cost hours once. -->
- **The `LOB-Relay` receive connector pins an explicit TLS certificate by thumbprint.** Any
  cert rotation on `adcs` silently breaks app relay while Outlook keeps working — so the
  symptom looks app-side, not mail-side. See `incidents/2026-08-14-lob-relay-tls-failure.md`.
- CU updates reset `Set-ReceiveConnector -MaxMessageSize`. Re-apply after every CU.
- `EXCH-02` has a smaller transport queue disk; large NDR storms fill it first.

## Recurring work
- `runbooks/rotate-exchange-tls-cert.md`

## History
- `incidents/2026-08-14-lob-relay-tls-failure.md`

## Open questions / gaps
- No documented DR runbook for full DAG loss. ⚠️ unverified whether the Veeam job covers
  transport config.
