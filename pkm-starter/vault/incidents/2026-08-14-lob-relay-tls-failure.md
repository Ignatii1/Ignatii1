---
type: incident
id: INC-2026-0001
title: LOB apps fail SMTP relay with TLS handshake error after CA cert rotation
systems: [exchange, adcs]
status: resolved
severity: p2
created: 2026-08-14
updated: 2026-08-14
tags: [tls, certificates, smtp, relay, example]
---

# LOB apps fail SMTP relay with TLS handshake error after CA cert rotation

> ⚠️ **EXAMPLE NOTE** — synthetic, demonstrates the format. Delete before real use.

## TL;DR
**Symptom:** 12 LOB apps stopped sending mail. Outlook and external mail unaffected.
**Root cause:** `LOB-Relay` receive connector pins a TLS cert by **thumbprint**; the cert was
rotated on `adcs` the night before, so the pinned thumbprint no longer existed.
**Fix:** Re-bound the connector to the new thumbprint, restarted transport.
**Time lost:** 3h 10m — most of it spent looking at the *applications*, because mail worked
fine for humans.

## Timeline
| When | What |
|------|------|
| 08-13 23:00 | Scheduled CA cert rotation on `adcs` (change CHG-4471) |
| 08-14 07:20 | First app team reports "emails not sending" |
| 08-14 09:05 | Confirmed Outlook + external mail healthy → narrowed to relay path |
| 08-14 10:30 | Found handshake failure in SMTP receive protocol log |
| 08-14 10:45 | Re-bound connector, restarted `MSExchangeTransport`, verified |

## Symptoms observed
<!-- Verbatim — these are the grep targets. -->
```
451 4.7.0 Temporary server error. Please try again later. PRX5
TLS negotiation failed with error UnknownCredentials
```
App-side (varies by stack):
```
System.Net.Mail.SmtpException: Unable to read data from the transport connection
```

## What I tried that did NOT work
<!-- Often worth more than the fix. -->
- Restarting the LOB app services — no effect, and cost ~45 min.
- Checking firewall rules on 587 — unchanged, red herring.
- Assuming an app-side TLS 1.0 deprecation — plausible, wrong. The apps had not changed at all.

## Root cause
`Get-ReceiveConnector "LOB-Relay" | fl TlsCertificateName` returned a thumbprint that no longer
matched any installed certificate. The nightly `adcs` rotation replaced the cert; nothing
re-bound the connector. Outlook was unaffected because the default connector uses subject-name
binding, not thumbprint pinning.

## Fix applied
```powershell
$c = Get-ExchangeCertificate | Where-Object { $_.Subject -like "*mail.internal.example*" } |
     Sort-Object NotBefore -Descending | Select-Object -First 1
Set-ReceiveConnector "LOB-Relay" -TlsCertificateName "<i>$($c.Issuer)<s>$($c.Subject)"
Restart-Service MSExchangeTransport
```

## Verification
- SMTP protocol log shows successful TLS negotiation from an app source IP.
- Sent a test message from the LOB app itself and confirmed delivery end-to-end — not just
  that the service restarted.

## Follow-up
- [x] Update `systems/exchange.md` → Known quirks
- [x] Promote to runbook → `runbooks/rotate-exchange-tls-cert.md`
- [ ] Permanent prevention: add a post-rotation check to the `adcs` change template so this
      cannot recur silently.
