# Playbook for Investigating Spoofed Email Headers

A structured process to detect email impersonation, domain spoofing, and unauthorized email senders.

---

## 1. Initial Triage

### 📌 Extract Full Email Headers
- The email header contains metadata about the sender’s domain, IP address, routing path, and authentication status.

### 📌 Retrieve Email Headers from Clients or Security Solutions
- Extract headers from the email client (`Outlook`, `Gmail`) or email security gateway (`Proofpoint`, `Mimecast`, `Microsoft Defender`).

**🛠 Tools:** `MXToolbox`, `Google Admin Toolbox`, `Email Header Analyzer`

---

## 2. Analyze the Email Routing Path

### 📌 Inspect ‘Received’ Fields to Track the Email Journey
- Each hop (relay server) adds a `Received` header.
- Compare the originating IP and domain with the sender’s stated domain to detect inconsistencies.

### 📌 Check for Anomalous Sending IPs
- Emails should originate from authorized mail servers.
- If the sending IP is unrecognized or appears in a blacklist, it could indicate spoofing or phishing activity.

**🛠 Tools:** `Talos`, `AbuseIPDB`, `AlienVault OTX`

---

## 3. Validate Email Authentication Mechanisms

### 📌 SPF (Sender Policy Framework) Check
- Confirms if the sending IP is authorized to send emails on behalf of the domain.
- SPF failures indicate potential email spoofing.

### 📌 DKIM (DomainKeys Identified Mail) Signature Verification
- DKIM ensures that the email content has not been modified in transit.
- A missing or invalid DKIM signature suggests the email may have been altered.

### 📌 DMARC (Domain-based Message Authentication) Enforcement
- DMARC applies policies based on SPF/DKIM results.
- If DMARC fails, the email may have been sent from an unauthorized source.

**🛠 Tools:** `MXToolbox`, `DMARC Analyzer`

---

## 4. Detect Email Spoofing Techniques

### 📌 Compare ‘From’, ‘Reply-To’, and ‘Return-Path’ Fields
- Attackers often manipulate multiple fields to bypass detection.
- The `From` field may look legitimate, but the `Reply-To` and `Return-Path` fields can expose the real sender.

**Example of a phishing attempt:**
- `From:` `support@paypal.com`
- `Reply-To:` `frauddept@gmail.com`
- `Return-Path:` `malicious@hacker.com`


### 📌 Analyze the ‘Reply-To’ Field for Mismatches
- Attackers often redirect responses to a fraudulent email address, even if the `From` address appears legitimate.
- **Common in:** Business Email Compromise (BEC), financial fraud, and phishing scams.

### 📌 Verify if the ‘Reply-To’ Domain Matches the ‘From’ Domain
- A mismatch indicates an attempt to redirect communication away from the legitimate sender.

**Example of a spoofed email:**
- `From:` `billing@paypal.com`
- `Reply-To:` `fraudulent@gmail.com`


### 📌 Check for Free Email Services in ‘Reply-To’
- Attackers may use `Gmail`, `Yahoo`, or `Outlook` addresses in the `Reply-To` field while impersonating a corporate email.

**Example:**
- `From:` `security@bankofamerica.com`
- `Reply-To:` `bank.secure@gmail.com`


**🛠 Tools to Analyze the Reply-To Field:**  
- `Google Admin Toolbox Message Header Analyzer`  
- `MXToolbox Email Header Analyzer`  
- `AbuseIPDB` for Checking Reply-To Domain Reputation  

### 📌 Analyze the ‘Return-Path’ Field for Anomalies
- The `Return-Path` specifies the actual email address where bounced messages are sent.
- If the `Return-Path` is different from the `From` field, it may indicate email spoofing or a phishing attack.

### 📌 Check if the ‘Return-Path’ Domain Matches the ‘From’ Domain
- Legitimate emails should have matching domains in the `From` and `Return-Path` fields.

**Example of a spoofed email:**
- `From:` `billing@apple.com`
- `Return-Path:` `mailserver@randomxyz.com`


### 📌 Look for Mismatches Between SPF Authentication and the Return-Path
- If an email fails SPF but has a `Return-Path` mismatch, the sender may be attempting to bypass security filters.
- Verify if the email was truly sent by the domain owner by checking SPF records.

### 📌 Red Flags in the Return-Path Field
- **Generic email providers** in `Return-Path` (e.g., `support@amazon.com` with `Return-Path: amazonhelpdesk@gmail.com`).
- **Misspelled domains** (e.g., `Return-Path: alert@microsft.com` instead of `microsoft.com`).
- **Completely different domains** (`From: ceo@company.com`, `Return-Path: hacker@malicious.net`).

**🛠 Tools for Checking the Return-Path Field:**  
- `MXToolbox Email Header Analyzer`  
- `Google Admin Toolbox`  
- `DMARC Analyzer`  

### 📌 Identify Display Name Spoofing
- Attackers may impersonate trusted contacts by using similar-looking names but with a different sending domain.

**Example:**
- `Legitimate:` John Doe `john.doe@microsoft.com`
- `Spoofed:` John Doe `john.doe@microsoft-support.com`


### 📌 Look for Signs of BEC (Business Email Compromise)
- Verify if the sender is using a legitimate but compromised business account to execute fraud, wire transfer requests, or credential theft.

---

## 5. Investigate Header Anomalies

### 📌 Check X-Originating-IP
- This header field often reveals the true sender IP even if the email has passed through multiple relay servers.

### 📌 Analyze ‘Message-ID’ Consistency
- The `Message-ID` should match the sending domain.
- A mismatch suggests that the email was forged or manipulated.

---

## 6. Incident Response Actions

### 📌 Quarantine and Block Spoofed Emails
- Flag emails failing SPF/DKIM/DMARC and implement stricter filtering rules.

### 📌 Report and Escalate Potential BEC Threats
- If a **Business Email Compromise (BEC)** attack is detected, immediately alert finance and executive teams to prevent fraudulent transactions.

### 📌 Educate Employees on Email Spoofing Risks
- Provide training on recognizing spoofed emails and social engineering techniques used in email fraud.
