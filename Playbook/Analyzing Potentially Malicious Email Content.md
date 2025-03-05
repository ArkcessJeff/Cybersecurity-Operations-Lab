# Playbook for Analyzing Potentially Malicious Email Content

A structured approach to investigate phishing emails, malware attachments, and social engineering attempts.

## 1. Initial Triage

### 📌 Collect the Email Sample
- Obtain the original email in `.eml` or `.msg` format to retain metadata, attachments, and hidden headers for deeper analysis.

### 📌 Review Email Security Gateway Logs
- Check SMTP logs, spam/malware logs, and quarantine logs to see if the email bypassed security filters or was flagged by threat detection mechanisms.

---

## 2. Email Body and Subject Line Analysis

### 📌 Identify Common Phishing Language
- Look for urgent requests, threats, or financial warnings that pressure the recipient into quick action, often bypassing rational decision-making.

### 📌 Detect Social Engineering Tactics
- Attackers impersonate executives, banks, or IT departments to manipulate victims into clicking malicious links or opening infected attachments.

### 📌 Verify Email Formatting and Grammar
- Poor grammar, awkward sentence structure, or generic greetings (e.g., “Dear User”) indicate bulk phishing campaigns.

---

## 3. Embedded Links and URL Analysis

### 📌 Extract and Expand Shortened Links
- Attackers use `Bit.ly`, `TinyURL`, and other link shorteners to hide the real destination. Expanding links reveals the actual domain.

### 📌 Analyze Links for Phishing Attempts
- Compare the displayed URL with the actual hyperlink destination.
- Hovering over links often reveals mismatched or typo-squatted domains (e.g., `micr0soft.com` instead of `microsoft.com`).

### 📌 Check Domain Reputation
- Use threat intelligence tools to verify if the domain has been recently registered or flagged for malicious activity in previous phishing campaigns.

**🛠 Tools:** `URLScan.io`, `VirusTotal`, `PhishTank`

---

## 4. Investigate Attachments for Malware

### 📌 Identify High-Risk File Types
- Malicious attachments often come in the form of macro-enabled documents (`.docm`, `.xlsm`), compressed files (`.zip`, `.iso`), or executable scripts (`.js`, `.vbs`).

### 📌 Calculate File Hash and Compare Against Threat Databases
- Every file has a unique hash (`SHA256`, `MD5`). Checking the hash against `VirusTotal` and `Hybrid-Analysis` determines if it is linked to known malware.

### 📌 Run Static and Dynamic Analysis in a Sandbox
- Opening files in `ANY.RUN` or `Cuckoo Sandbox` helps identify whether they download payloads, execute hidden scripts, or modify system settings.

**🛠 Tools:** `VirusTotal`, `ANY.RUN`, `Hybrid-Analysis`

---

## 5. Identify and Extract Indicators of Compromise (IOCs)

### 📌 Document Suspicious Sender Domains and IPs
- Identify email domains and originating SMTP servers used in previous phishing campaigns.

### 📌 Correlate Malicious URLs with Threat Feeds
- Cross-check suspicious links against public phishing databases to determine if they have been used in active attacks.

### 📌 Extract Malware Hashes for Detection Rules
- Use `YARA` rules and endpoint protection to block similar malware variants in the future.

---

## 6. Incident Response and Mitigation

### 📌 Block Malicious Senders, Domains, and IPs
- Add verified phishing domains and IPs to email security blocklists to prevent future attacks.

### 📌 Educate Users About the Phishing Attempt
- Send an awareness alert to employees to reinforce phishing recognition and safe email practices.

### 📌 Report the Attack to Threat Intelligence Platforms
- Submit phishing emails to `Google Safe Browsing`, `AbuseIPDB`, and `SpamCop` to improve global threat awareness.

---

## 7. Reporting and Documentation

### 📌 Compile Findings in a Case Management System
- Ensure all `IOCs`, attachments, and investigation steps are documented for future reference and security audits.

### 📌 Update SIEM and Endpoint Detection Rules
- Adjust detection parameters to identify similar phishing attempts before they reach end users.
