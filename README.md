<div align="center">

```
     ___       __   _____ __       _ __       
    /   | ____/ /  / ___// /______(_) /_____ 
   / /| |/ __  /   \__ \/ __/ ___/ / //_/ _ \
  / ___ / /_/ /   ___/ / /_/ /  / / ,< /  __/
 /_/  |_\__,_/   /____/\__/_/  /_/_/|_|\___/ 
```

# AdStrike &mdash; `v5.0 «AdStrike»`

**Professional Active Directory Attack Framework**

[![Python](https://img.shields.io/badge/Python-3.10%2B-blue?style=flat-square&logo=python)](https://python.org)
[![Platform](https://img.shields.io/badge/Platform-Kali%20%7C%20Parrot-brightgreen?style=flat-square&logo=linux)](https://www.kali.org)
[![Menu](https://img.shields.io/badge/Menu-56%20entries-purple?style=flat-square)](modules/)
[![Phases](https://img.shields.io/badge/Kill--Chain-8%20Phases-red?style=flat-square)]()
[![Primitives](https://img.shields.io/badge/Tradecraft-400%2B%20Primitives-orange?style=flat-square)]()
[![License](https://img.shields.io/badge/License-GPLv3-yellow?style=flat-square)](LICENSE)
[![Creator](https://img.shields.io/badge/Creator-tmrswrr-cyan?style=flat-square)](https://github.com/capture0x)

> **Authorized penetration testing, red team engagements, and security research only.**
> 
> **Release status:** beta/research build. Menu and import health checks pass, but individual modules still depend on target lab state, credentials, network reachability, and installed third-party tools.

<p align="center">
  <img src="/assets/screenshots/1.png" alt="AdStrike main menu" width="900">
</p>

</div>

---

## Overview

AdStrike is a modular, terminal-based Active Directory attack framework for authorized red team and penetration testing work. It is designed to support the full engagement lifecycle: discovery, enumeration, exploitation, credential access, lateral movement, persistence, and reporting.

The framework is built around a shared session model. Credentials, tickets, findings, and owned assets persist across modules so each step can build on the last without manual state transfer. Every command is logged, and the resulting evidence can be reused in reports.

The platform includes two analysis layers:

- `Smart Analyst` for output parsing, attack-path identification, and next-step prioritization
- `AdStrike Agent` for AI-driven orchestration across modules when autonomous chaining is useful

**Key design goals:**

- Operate cleanly in modern AD environments, including Kerberos-only and LDAP-signing-enforced targets
- Reduce operator friction by carrying session state, credentials, and tickets across tools automatically
- Preserve evidence by printing, logging, and storing executed commands and results
- Keep analysis actionable with path ranking instead of raw output dumps
- Allow either guided use or autonomous execution, depending on engagement needs

---

## Table of Contents

- [Screenshots](#screenshots)
- [Features](#features)
- [Kill-Chain Coverage](#kill-chain-coverage)
- [Module List](#module-list)
- [Module Operating Reference](#module-operating-reference)
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Automatic Target Discovery](#automatic-target-discovery)
- [Usage](#usage)
- [AdStrike Agent Setup](#adstrike-agent-setup)
- [Tool Checker and Missing Tools](#tool-checker-and-missing-tools)
- [NTLM-Disabled Environments](#ntlm-disabled-environments)
- [Troubleshooting](#troubleshooting)

---

## Screenshots

| Active Directory Enumeration | Bloodhound Helper |
|---|---|
| ![AdStrike main menu](assets/screenshots/3.png) | ![AdStrike bloodhound helper](assets/screenshots/4.png) |

| AdStrike Agent | Smart Analyst |
|---|---|
| ![AdStrike Agent AD Attack](assets/screenshots/5.png) | ![AdStrike smart analyst](assets/screenshots/7.png) |

---

## Features

| Capability | Detail |
|---|---|
| **56 menu entries** | 50 attack modules, 4 utilities, and 2 management functions |
| **Unified session state** | Shares credentials, tickets, findings, owned hosts, and loot across the whole run |
| **Kerberos-first workflow** | Handles NTLM-disabled targets with automatic `krb5.conf`, TGT, and environment setup |
| **Smart Analyst** | Parses tool output, extracts findings, and recommends the most relevant next action |
| **AdStrike Agent** | Optional AI orchestrator that chains tools and adapts to the current evidence |
| **Attack coverage** | Recon, enumeration, escalation, lateral movement, persistence, credential access, and hybrid identity |
| **ADCS support** | Certificate abuse coverage across ESC1 through ESC13 |
| **BloodHound workflow** | Collection, path queries, and ACL/object-control analysis |
| **Report output** | Generates HTML, Markdown, and JSON reports with evidence attached |
| **Tool integration** | Wraps impacket, NetExec, Certipy, Kerbrute, PowerView, Rubeus, and related tooling |

---

## Kill-Chain Coverage

```
Phase 0  RECONNAISSANCE       Recon · OSINT · DNS · crt.sh · email harvest
Phase 1  INITIAL ACCESS       NTLM relay · coercion · CVEs (NoPac · Zerologon · PrintNightmare)
Phase 2  ENUMERATION          LDAP · SMB · BloodHound · GPO · Snaffler · PowerView
Phase 3  PRIVILEGE ESCALATION Kerberos attacks · ADCS · RBCD · ACL abuse · Shadow Credentials
Phase 4  LATERAL MOVEMENT     PSExec · WMI · DCOM · WinRM · MSSQL · SCCM · Coercion relay
Phase 5  CREDENTIAL ACCESS    LSASS · NTDS · SAM · DPAPI · DCSync · DCShadow · VSS
Phase 6  PERSISTENCE          Golden/Silver ticket · AdminSDHolder · GPO abuse · Trust attacks
Phase 7  CLOUD / HYBRID       Azure AD · Entra ID · AADConnect · PTA/PHS/PRT · gMSA
Phase 8  ADVANCED OPS         Exploit chains · C2 integration · Loot analysis
```

---

## Module List

<details>
<summary><b>Phase 0 — Reconnaissance (2 modules)</b></summary>

| # | Module | Techniques |
|---|---|---|
| 1 | Recon & OSINT | DNS · WHOIS · email harvest · crt.sh · certificate transparency |
| 2 | Network Discovery | nmap · masscan · nbtscan · netdiscover · IPv6 scanning |

</details>

<details>
<summary><b>Phase 1 — Initial Access (7 modules)</b></summary>

| # | Module | Techniques |
|---|---|---|
| 3 | Initial Access (No Creds) | NTLM capture · relay · ARP spoofing · DHCPv6 · RID cycling |
| 4 | CVE / AD Exploits | NoPac (CVE-2021-42278/42287) · PrintNightmare · Zerologon |
| 5 | AMSI / Defense Evasion | AMSI bypass · CLM bypass · AppLocker · Codecepticon obfuscation |
| 6 | EDR / AV Evasion | NanoDump · MockingJay · RWXfinder · BOF · direct syscalls |
| 7 | UAC Bypass | fodhelper · eventvwr · CMSTP · token impersonation |
| 8 | Pre2K & Timeroasting | Pre-Win2K accounts · MS-SNTP hash · MAQ abuse |
| 9 | WSUS Attack | WSUS HTTP spoof · pywsus · SYSTEM code execution |

</details>

<details>
<summary><b>Phase 2 — Enumeration (7 modules)</b></summary>

| # | Module | Techniques |
|---|---|---|
| 10 | AD Enumeration | LDAP (ldaps://) · SMB · GPO · DNS · Trust · SPN · LAPS · delegations |
| 11 | PowerView Enumeration | Full PowerView cmdlet reference with live execution |
| 12 | BloodHound Helper | SOAPHound · RustHound · ADExplorer snapshot · Neo4j Cypher queries |
| 13 | File & Share Hunter | Snaffler · SYSVOL · GPP password · spider_plus |
| 14 | NetExec / NXC Suite | nxc smb · ldap · mssql · winrm · rdp — Kerberos-aware |
| 15 | User Hunting | SessionHunter · UserHunter · Find-PSRemotingLocalAdminAccess |
| 16 | ADIDNS Abuse | Wildcard DNS · WPAD · record injection · DNSAdmins |

</details>

<details>
<summary><b>Phase 3 — Privilege Escalation (11 modules)</b></summary>

| # | Module | Techniques |
|---|---|---|
| 17 | Local Privilege Escalation | PowerUp · KrbRelayUp · Potato attacks · JEA escape |
| **18** | **Kerberos Attacks** | AS-REP Roast · Kerberoast · PtT · OPtH · Golden · Silver · Diamond · Sapphire · **Bronze Bit** · **kerbrute** · **KrbRelayUp** · **PKINIT** · **NTLM-disabled workflow** |
| 19 | Rubeus Toolkit | TGT · TGS · Roast · PTT · S4U · monitor mode · harvest |
| 20 | Shadow Credentials | msDS-KeyCredentialLink · pywhisker · PKINIT → NT hash |
| 21 | RBCD Full Chain | Powermad · S4U2Proxy · /altservice · Bronze Bit (CVE-2020-17049) |
| 22 | ACL / ACE Abuse | GenericAll · WriteDACL · ForceChangePassword · AddMember |
| 23 | Certificate Abuse (ADCS) | ESC1–ESC13 · certipy-ad · CertSync · CA enumeration |
| 24 | RODC Attacks | PRP abuse · Key List Attack · RODC Golden Ticket |
| 25 | Golden Certificate | ESC13/14/15/16 · CA key theft · UnPAC · PassTheCert |
| 26 | UnPAC / PassTheCert | Targeted Kerberoast · UnPAC · PassTheCert · SPN-Jack |
| 27 | JEA Attacks | JEA bypass · PSReadLine history · CLM escape |

</details>

<details>
<summary><b>Phase 4 — Lateral Movement (5 modules)</b></summary>

| # | Module | Techniques |
|---|---|---|
| 28 | Lateral Movement | PSExec · WMIExec · SMBExec · DCOM · Evil-WinRM · WinRS · atexec |
| 29 | Coercion Attacks | PrinterBug · PetitPotam · DFSCoerce · coerce → relay → Shadow Creds |
| 30 | MSSQL Abuse | xp_cmdshell · PowerUpSQL · linked server RCE · UNC path capture |
| 31 | Password Attacks | Spray · kerbrute · credential stuffing · NTLM relay capture |
| 32 | SCCM / MECM Abuse | NAA credential theft · relay · client-push · AdminService |

</details>

<details>
<summary><b>Phase 5 — Credential Access (4 modules)</b></summary>

| # | Module | Techniques |
|---|---|---|
| 33 | Credential Dumping | LSASS · SAM · NTDS · lsassy · nanodump · pypykatz · procdump |
| 34 | DPAPI & Credential Vault | dploot bulk · SharpDPAPI · LaZagne · KeeThief · Chrome/Firefox |
| 35 | DCSync / DCShadow | Full domain NTDS dump · rogue DC injection |
| 36 | Shadow Copies Abuse | VSS snapshot · NTDS.dit · SAM · SYSTEM hive extraction |

</details>

<details>
<summary><b>Phase 6 — Persistence (6 modules)</b></summary>

| # | Module | Techniques |
|---|---|---|
| 37 | Domain Persistence | Golden/Silver ticket · AdminSDHolder · NPPSPY · TTL group membership |
| 38 | Local Persistence | SharPersist · WMI event subscription · Registry · Startup |
| 39 | GPO Abuse | GPO create · link · scheduled task exec · logon scripts · hijack |
| 40 | DNSAdmins Abuse | DLL injection via DNS service restart |
| 41 | Trust Attacks | TrustKey · SID History · PAM trust · multi-hop · cross-forest escalation |
| 42 | AD Misc Abuse | BackupOperators · Skeleton Key · Exchange RBAC · DSRM |

</details>

<details>
<summary><b>Phase 7 — Cloud / Hybrid (4 modules)</b></summary>

| # | Module | Techniques |
|---|---|---|
| 43 | Azure AD / Entra ID | AADConnect · PTA agent · PHS · PRT · token theft · device code phishing |
| 44 | Entra Hybrid Attacks | MSOL DCSync · adconnect.ps1 · DeviceCode flow · PTA inject |
| 45 | gMSA Attacks | Enumeration · hash extraction · Pass-the-Hash · shadow credentials |
| 46 | ADFS & Golden SAML | Token signing certificate · Golden SAML · AADInternals |

</details>

<details>
<summary><b>Phase 8 — Advanced Operations (4 modules)</b></summary>

| # | Module | Techniques |
|---|---|---|
| 47 | Exploit Chains | 8 pre-built full-DA attack paths (automated step execution) |
| 48 | C2 Integration | Sliver · Havoc · Metasploit · Cobalt Strike payload delivery |
| 49 | Loot Parser & Analyzer | Parse tool output · dedup · score creds · export to report |
| 50 | AD Advanced Playbook | WDAC · MDE/MDI · WMI filters · trusts · deception |

</details>

<details>
<summary><b>Utilities</b></summary>

| # | Module | Description |
|---|---|---|
| 51 | AdStrike Agent (AI) | Claude AI autonomous attack orchestrator — chains all modules |
| 52 | Smart Analyst | Parse scan output · build prioritised attack plan · auto-execute steps |
| 53 | Kerberos Manager | TGT · PTT · S4U2Self/Proxy · ccache · kirbi · krb5.conf generator |
| 54 | Generate Report | HTML · Markdown · JSON pentest report with findings and evidence |
| 55 | Session Manager | Save · load · switch · clear sessions; persist across tool restarts |
| 56 | Tool Checker | Verify all 45+ required offensive tools are installed |

</details>

---

## Module Operating Reference

Most modules follow the same pattern:

1. Read target, domain, user, password/hash, Kerberos state, attacker IP, and output paths from the shared session.
2. Print the exact command that will run.
3. Execute the wrapped third-party tool only after the operator selects an action.
4. Append executed commands, findings, and useful output paths to the session.
5. Return to the main menu without discarding session state.

| Area | Typical Inputs | Typical Output | Notes |
|---|---|---|---|
| Recon and discovery | `DOMAIN`, `DC_IP`, subnet, interface | DNS data, host/service lists | Can be run before credentials exist |
| AD enumeration | Domain, DC, username/password/hash or Kerberos cache | LDAP/SMB/BloodHound output under `output/` | Best first step after credentials |
| Kerberos | Domain, DC, user, password/hash, ccache path | TGT/TGS files, roast hashes, Kerberos env vars | Handles NTLM-disabled workflows |
| ADCS | Domain, DC, CA/template names, Certipy auth | Vulnerable templates, PFX files, NT hashes | Requires reachable ADCS/CA services |
| ACL/RBCD/Shadow Creds | Target account/computer, controlled principal | Delegation paths, PKINIT material, service tickets | Depends on object permissions |
| Lateral movement | Target host, credential material, shell method | WinRM/SMB/WMI command execution | Requires local admin or equivalent rights |
| Credential access | Admin rights, target host/DC, dumping method | Hashes, DPAPI material, LSASS/NTDS data | High impact; run only in scope |
| Persistence | Confirmed admin path, target object/GPO/service | Persistence commands and evidence | Use only when explicitly authorized |
| Reporting | Existing session findings and command history | HTML, Markdown, JSON report files | Review/redact before sharing |

### Output and Evidence

AdStrike writes runtime data under `output/`:

| Path | Purpose |
|---|---|
| `output/session.json` | Persisted session state |
| `output/session_*.log` | Launcher logs from `run.sh` |
| `output/enum/` | LDAP, SMB, GPO, and enumeration artifacts |
| `output/bloodhound/` | BloodHound JSON collections and related data |
| `output/audit/capability_audit.json` | Tool Checker and module health snapshot |
| `output/agent_logs/` | AdStrike Agent Markdown/JSON run logs |
| `output/agent_runtime/` | Generated Kerberos config, ccache, hashes, and temporary agent artifacts |
| `output/reports/` | Generated reports when report modules are used |

`output/` is ignored by Git. Do not publish it unless you have reviewed and redacted it.

---

## Requirements

| Item | Requirement |
|---|---|
| OS | Kali Linux 2024+ or Parrot OS (recommended) |
| Python | 3.10 or higher |
| Privileges | Standard user for most modules; root for packet capture (Responder) |
| Network | Reachability to target DC on ports 88, 389, 443, 445, 636 |

### Key External Tools

```
impacket-scripts    nxc / netexec       bloodhound-python    certipy-ad
evil-winrm          kerbrute            responder             ldap-utils
hashcat             john                nmap / masscan        krb5-user
dnstool.py          dig                 ldapsearch
```

Most tools are installed automatically by `install.sh`; `dnstool.py` is pulled from krbrelayx when network access is available.

---

## Installation

```bash
git clone https://github.com/capture0x/AdStrike.git
cd AdStrike
chmod +x install.sh
bash install.sh
```

The installer will:

1. Verify Python 3.10+
2. Install system-level offensive tools via `apt`
3. Create an isolated Python virtual environment (`adrt_venv/`)
4. Install Python dependencies from `requirements.txt`
5. Copy `.env.example` → `.env` ready for configuration

Do not run `install.sh` with `sudo`. It creates repo-local files such as `adrt_venv/` and `.env`; running it as root can leave those files root-owned. The installer uses `sudo` internally only for system packages.

---

## Configuration

Edit `.env` before starting your engagement:

```env
DC_IP=10.10.10.10
DC_FQDN=dc1.corp.local
DOMAIN=corp.local
USERNAME=tmrswrr
PASSWORD=***
NT_HASH=
USE_KERBEROS=false
ATTACKER_IP=10.10.14.5
ATTACKER_IFACE=tun0
ENGAGEMENT_NAME=Corp-Internal-2026
```

Packaged releases include `.env.example`. If your archive does not, create `.env` manually with the template above before running `bash run.sh`.

All fields can also be entered interactively at startup — the session carries them across every module automatically.

Do not commit real engagement configuration or output. Keep `.env`, `output/`, ticket files, hashes, dumps, reports, and captured loot out of Git.

### Optional Environment Flags

| Variable | Default | Purpose |
|---|---:|---|
| `ADSTRIKE_SHOW_SECRETS` | `false` | Mask passwords, hashes, and loot in logs/reports unless explicitly enabled |
| `ADSTRIKE_NO_ANIMATION` | unset | Disable the startup banner animation for cleaner logs or slow terminals |
| `ADSTRIKE_PORT_CHECK` | unset | Set to `true` to force the quick nmap AD port check during session setup |
| `TGT_AUTO_RENEW` | `true` | Keep Kerberos renewal behavior enabled where supported |
| `ADSTRIKE_OPSEC` | `normal` | Agent OPSEC mode override: `loud`, `normal`, or `stealth` |
| `ADSTRIKE_LDAP_PORT` | `389` | Agent LDAP port override |
| `ADSTRIKE_LDAPS_PORT` | `636` | Agent LDAPS port override |
| `ADSTRIKE_SMB_PORT` | `445` | Agent SMB port override |
| `ADSTRIKE_WINRM_PORT` | `5985` | Agent WinRM port override |
| `ADSTRIKE_BH_HOST` | unset | BloodHound/Agent host override when DNS needs manual correction |
| `ADSTRIKE_BH_DOMAIN` | unset | BloodHound/Agent domain override |
| `ADSTRIKE_BH_IP` | unset | BloodHound/Agent DC IP override |

---

## Automatic Target Discovery

During first-run session setup, entering a DC IP triggers a fast target discovery pass:

1. LDAP rootDSE query to derive `DOMAIN`, `BASE_DN`, and `DC_FQDN` when anonymous rootDSE is available.
2. `nxc smb <dc-ip>` fallback when LDAP does not reveal the domain.
3. Optional quick nmap check of common AD ports.

If LDAP or NetExec already finds the domain, the nmap port check is skipped by default to keep startup fast. To force it:

```bash
ADSTRIKE_PORT_CHECK=true bash run.sh
```

When the quick port check runs, output is saved to `output/nmap_recon.txt`. If clock skew is detected, AdStrike prints a time-sync hint before Kerberos-heavy workflows. If a DC FQDN is discovered, it also prints an `/etc/hosts` line you can add when DNS resolution is unreliable.

---

## Usage

```bash
bash run.sh
```

The launcher activates the virtual environment, sets up logging, and drops you into the interactive menu.

### Main Menu Flow

Recommended first-run sequence:

```text
[55] Session Manager  -> configure target and credentials
[56] Tool Checker     -> confirm external tools
[10] AD Enumeration   -> collect baseline LDAP/SMB/GPO data
[52] Smart Analyst    -> parse output and rank next steps
[54] Generate Report  -> export findings and evidence
```

You can also run a module directly:

```bash
python -m venv venv
source venv/bin/activate
python3 main.py --module 10
python3 main.py --module 56 --no-banner
```

### Session Fields

| Field | Meaning |
|---|---|
| `DC_IP` | Domain Controller IP address |
| `DC_FQDN` | Domain Controller hostname/FQDN, useful for Kerberos |
| `DOMAIN` | AD DNS domain, for example `corp.local` |
| `USERNAME` | Current operator principal or foothold user |
| `PASSWORD` | Password for password auth |
| `NT_HASH` | NT hash for pass-the-hash workflows |
| `USE_KERBEROS` | Set `true` after a valid Kerberos workflow is established |
| `KRB5_CCACHE` | Kerberos ticket cache path |
| `ATTACKER_IP` | Your VPN/tun/wlan IP used for callbacks, relay, or hosting |
| `ATTACKER_IFACE` | Interface such as `tun0`, `eth0`, or `wlan0` |
| `ADSTRIKE_SHOW_SECRETS` | Defaults to `false`; masks secrets in logs/reports |
| `TGT_AUTO_RENEW` | Defaults to `true`; enables Kerberos ticket renewal where supported |

### Health Check / Automation

To validate the local installation or module registry, run:

```bash
python3 -m py_compile main.py
python3 main.py --check
```

Useful non-interactive flags:

```bash
python3 main.py --check
python3 main.py --module 10
python3 main.py --session output/session.json --no-banner
bash run.sh --check
```

### Repair Missing Tools

If a module stops because a required binary or helper script is missing, run:

```bash
bash scripts/repair_tools.sh --check
bash scripts/repair_tools.sh -y
```

Useful scoped repairs:

```bash
bash scripts/repair_tools.sh --no-apt
bash scripts/repair_tools.sh --no-pip
bash scripts/repair_tools.sh --no-github
```

The repair script installs missing apt/pip tools where possible, clones helper tools such as `krbrelayx`/`dnstool.py` into the ignored `tools/` directory, and reruns AdStrike's health check.

---

## AdStrike Agent Setup

AdStrike Agent is optional. Manual modules do not require AI.

### Backend Options

| Backend | Use Case | Requirements |
|---|---|---|
| Ollama | Local/private/offline lab usage | `ollama serve`, a local model, Python `requests` package |
| Claude | Higher reasoning quality through Anthropic API | `ANTHROPIC_API_KEY`, internet/API access |

### Ollama Setup

Install Ollama on Linux:

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Official Linux installation reference: <https://docs.ollama.com/linux>

Start and verify the service:

```bash
ollama serve
# in another terminal
ollama -v
```

If your system installed Ollama as a systemd service, use:

```bash
sudo systemctl enable --now ollama
sudo systemctl status ollama
```

Then pull a local model:

```bash
ollama pull mistral
# or
ollama pull qwen2.5-coder:7b
```

Then run:

```bash
bash run.sh
# choose [51] AdStrike Agent (AI)
# choose Backend [1] Ollama
```

The Agent lists installed Ollama models and asks which one to use.

### Claude Setup

Set your API key in the current shell or `.env`:

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

Then run `[51] AdStrike Agent (AI)` and choose Backend `[2] Claude`.

### Agent Modes

| Mode | Meaning |
|---|---|
| Full Auto | Agent executes tool calls and adapts to evidence |
| Plan Only | Agent produces a prioritized plan without executing tools |

### OPSEC Modes

| Mode | Meaning |
|---|---|
| Loud | Fast lab/CTF mode, minimal delay |
| Normal | Balanced internal pentest mode, default |
| Stealth | More conservative, native-first behavior where possible |

### Agent Logs

| Path | Meaning |
|---|---|
| `output/agent_logs/*.md` | Human-readable Agent run report |
| `output/agent_logs/*.json` | Structured Agent conversation/tool log |
| `output/agent_logs/archive/` | Previous Agent runs |
| `output/agent_runtime/` | Temporary ccache/hash/helper artifacts |

---

## Tool Checker and Missing Tools

Run:

```bash
python3 main.py --module 56 --no-banner
```

The Tool Checker reports two things:

- External tool availability, for example Impacket, NetExec, Certipy, Kerbrute, BloodHound, ADCS, SCCM, C2, and cloud tooling.
- Module health, meaning each registered module file imports and exposes `run()`.

If tools are missing:

```bash
bash scripts/repair_tools.sh --check
bash scripts/repair_tools.sh -y
```

Some tools are optional and only affect specific modules:

| Missing Tool | Affected Area |
|---|---|
| `rustscan` | Faster network discovery |
| `PetitPotam.py`, `printerbug.py` | Coercion attacks |
| `dnstool.py` | ADIDNS write actions |
| `lazagne`, `certsync` | Credential access / ADCS extras |
| `sccmhunter`, `SharpSCCM.exe` | SCCM/MECM modules |
| `AADInternals` | Azure AD / Entra / ADFS modules |
| `sliver-server`, `havoc` | C2 integration |

External tools are intentionally not all vendored into this repository. Licensing, platform, package availability, and operator preference vary by environment.

## NTLM-Disabled Environments

When the DC has NTLM disabled (`STATUS_NOT_SUPPORTED`), use the built-in guided workflow:

```
[18] Kerberos Attacks → [A] NTLM-Disabled Attack Workflow
```

This automatically:

1. Generates a valid `/tmp/krb5_<domain>.conf`
2. Adds the DC FQDN to `/etc/hosts`
3. Requests a TGT using session credentials (`getTGT.py`)
4. Sets `KRB5CCNAME` and `KRB5_CONFIG` in the session environment
5. Enables Kerberos mode — all subsequent modules use `-k --kdcHost`
6. Prints ready-to-use commands for nxc, impacket, bloodhound-python, evil-winrm

The framework also handles:

- LDAP enumeration via `ldaps://dc:636` (signing-enforced DCs)
- nxc SMB with `-k --kdcHost` for Kerberos authentication
- Kerberoasting, AS-REP Roasting, and all delegation attacks via Kerberos

---

## Troubleshooting

### Do Not Run with `sudo`

Run AdStrike as your normal user:

```bash
bash install.sh
bash run.sh
```

If you previously ran it with `sudo` and now see permission errors:

```bash
sudo chown -R "$(id -un):$(id -gn)" .
```

### Virtual Environment Not Found

```bash
bash install.sh
```

Then:

```bash
source adrt_venv/bin/activate
python3 main.py --check
```

### Tool Missing

```bash
bash scripts/repair_tools.sh --check
bash scripts/repair_tools.sh -y
python3 main.py --module 56 --no-banner
```

### Kerberos Fails

Check the basics:

```bash
date
klist
cat "$KRB5_CONFIG"
echo "$KRB5CCNAME"
```

Common causes:

- DC hostname is missing from `/etc/hosts`.
- Time skew is too high.
- `KRB5_CONFIG` points to the wrong realm.
- `KRB5CCNAME` points to an expired or missing ccache.
- You are using an IP where a Kerberos SPN/FQDN is required.

Use `[18] Kerberos Attacks -> NTLM-Disabled Attack Workflow` or `[53] Kerberos Manager` to regenerate a clean target-specific setup.

### NetExec / Impacket Version Issues

AdStrike uses system Impacket scripts through `utils.helpers.imp()` to avoid venv import mismatch. If `nxc` or Impacket fails:

```bash
which nxc
nxc --version
which impacket-secretsdump
python3 main.py --module 56 --no-banner
```

Then run:

```bash
bash scripts/repair_tools.sh -y
```

### Agent Does Not Start

For Ollama:

```bash
ollama list
ollama serve
```

For Claude:

```bash
echo "$ANTHROPIC_API_KEY"
```

Also confirm:

```bash
python3 -c "import requests, anthropic; print('ok')"
```

### Reports Include Secrets

By default, `ADSTRIKE_SHOW_SECRETS=false`. If reports still contain sensitive data, review `.env`, `output/session.json`, and generated reports before sharing.

Set:

```env
ADSTRIKE_SHOW_SECRETS=false
```

---

## Legal Disclaimer

This software is provided for **authorized security testing, red team engagements, and educational purposes only**.

Use of this tool against systems without explicit written authorization from the system owner is **illegal** and may violate the Computer Fraud and Abuse Act (CFAA), the Computer Misuse Act (CMA), and equivalent legislation in your jurisdiction.

The author (**tmrswrr**) accepts no liability for any damage, data loss, or legal consequences arising from misuse of this software.

---

## Developer

**tmrswrr** &mdash; GitHub: [capture0x](https://github.com/capture0x)

Maintained for authorized offensive security research, lab validation, and professional red team operations.

---

<div align="center">

```
  For authorized use only  ·  Validate scope  ·  Document evidence
```

</div>
