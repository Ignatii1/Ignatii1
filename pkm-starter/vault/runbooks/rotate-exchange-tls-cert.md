---
type: runbook
id: RUN-rotate-exchange-tls-cert
title: Rotate the Exchange TLS certificate (and re-bind pinned connectors)
systems: [exchange, adcs]
status: verified
created: 2026-08-14
updated: 2026-09-04
last_executed: 2026-08-14
tags: [tls, certificates, smtp, example]
---

# Rotate the Exchange TLS certificate (and re-bind pinned connectors)

> ⚠️ **EXAMPLE NOTE** — synthetic, demonstrates the format. Delete before real use.

**Purpose:** Replace the expiring TLS cert on `EXCH-01`/`EXCH-02` **and** re-bind every
connector that pins by thumbprint.
**When to run:** ≥14 days before `NotAfter`, or immediately after any unplanned CA rotation.
**Duration:** ~40 min.
**Blast radius:** Transport restart drops in-flight SMTP sessions (seconds). **LOB app relay
breaks until step 4 completes** — notify the app teams channel *before* starting.

## Preconditions
- [ ] New cert issued and present on both nodes (`Get-ExchangeCertificate`)
- [ ] Change approved; outside business hours preferred
- [ ] Current connector bindings captured (step 1) — this is the rollback data
- [ ] Rollback confirmed available (old cert not yet removed)

## Steps

1. Capture current state. **Do not skip — this is your rollback.**
   ```powershell
   Get-ExchangeCertificate | Select Thumbprint,Subject,NotAfter,Services |
     Export-Csv C:\temp\certs-before.csv -NoTypeInformation
   Get-ReceiveConnector | Select Identity,TlsCertificateName |
     Export-Csv C:\temp\connectors-before.csv -NoTypeInformation
   ```
   *Expect:* both CSVs written, connector list includes `LOB-Relay`.

2. Enable services on the new cert (run per node).
   ```powershell
   Enable-ExchangeCertificate -Thumbprint <NEW_THUMBPRINT> -Services IIS,SMTP
   ```
   *Expect:* no error; prompt to overwrite the default SMTP cert → **Yes**.

3. Identify connectors pinned by thumbprint.
   ```powershell
   Get-ReceiveConnector | Where-Object { $_.TlsCertificateName -ne $null } |
     Select Identity,TlsCertificateName
   ```
   *Expect:* `LOB-Relay` appears. Any connector listed here needs step 4.

4. Re-bind each pinned connector.
   ```powershell
   $c = Get-ExchangeCertificate -Thumbprint <NEW_THUMBPRINT>
   Set-ReceiveConnector "<CONNECTOR>" -TlsCertificateName "<i>$($c.Issuer)<s>$($c.Subject)"
   ```
   *Expect:* no output. Re-run step 3 to confirm the new value.

5. Restart transport (per node, one at a time).
   ```powershell
   Restart-Service MSExchangeTransport
   ```
   *Expect:* service reaches Running within ~60s.

## Verification
- [ ] `Get-ExchangeCertificate` shows the new cert with `IP.WS` services
- [ ] SMTP protocol log shows a successful TLS negotiation from an app source IP
- [ ] **Send a real test message from a LOB app end-to-end** — the failure mode in
      `incidents/2026-08-14-lob-relay-tls-failure.md` was invisible to Outlook testing
- [ ] External mail flow still healthy

## Rollback
1. Re-bind connectors to the old thumbprint from `connectors-before.csv` (step 4 syntax).
2. `Enable-ExchangeCertificate -Thumbprint <OLD_THUMBPRINT> -Services IIS,SMTP`
3. `Restart-Service MSExchangeTransport`
4. Verify with the same checks above. Old cert must not be deleted until verification passes.

## Gotchas
- ⚠️ Thumbprint-pinned connectors are the whole reason this runbook exists. Step 3 is the step
  people skip, and it is the one that causes the outage.
- Certificate must be enabled on **both** DAG nodes; mail will intermittently fail if only one
  is done — and intermittent failure is much harder to diagnose than total failure.
- CU updates can reset `MaxMessageSize` on connectors; re-check after any CU.

## Change log
| Date | Change | By |
|------|--------|----|
| 2026-08-14 | Created from INC-2026-0001 | me |
| 2026-09-04 | Added step 1 state capture as explicit rollback data | me |
