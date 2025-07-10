# Check_SUID_Bash

## 🔍 Bash Script for Detecting Unexpected SUID Files on Linux

This script scans a Linux system for files with the **SUID (Set User ID)** permission, which can allow executables to run with elevated privileges. It detects **any new or removed SUID files** compared to a saved baseline, logs the changes, and helps identify potential privilege escalation risks.

---

## 🎯 Project Purpose

This script was developed as part of my **self-training in Bash scripting applied to cybersecurity**. The main objectives of this project were to:

- Learn how to write secure and portable Bash scripts
- Understand the implications of SUID permissions on Linux systems
- Implement a basic form of system integrity monitoring
- Practice secure file scanning, comparison, and logging techniques

---

## 🧠 Key Concepts Learned

- Using `find` to locate files with specific permissions (e.g., `-perm -4000` for SUID)
- Creating and managing a **baseline snapshot** of system state
- Comparing files using the `comm` command to detect differences
- Implementing secure and informative logging
- Handling errors and validating execution as root
- Writing scripts that can be automated via `cron` for regular security monitoring

---

## ⚙️ Requirements

- A Linux system with Bash (version 4+ recommended)
- Root privileges to scan the entire filesystem (`sudo`)
- Log directory `/var/log/` must exist and be writable by root

---

## 🚀 Usage

### 🔁 Manual Run

```bash
sudo ./check_suid_integrity.sh
```

⚠️ The script must be run as `root` or with `sudo` to access all system directories.

### 🗂️ Files Used

| File                         | Purpose                               |
| ---------------------------- | ------------------------------------- |
| `/var/log/suid_baseline.txt` | Stores the initial list of SUID files |
| `/tmp/suid_current.txt`      | Temporary file for current scan       |
| `/var/log/suid_diff.log`     | Logs changes detected since baseline  |

### 🧪 How It Works

1. First execution: the script creates a baseline of current SUID files.

2. Subsequent runs: the script compares the current system state to the baseline.

3. Any new or missing SUID files are logged with timestamps in `/var/log/suid_diff.log`.

### 📝 Example Output (in `/var/log/suid_diff.log`)

```text
[2025-07-10 03:00:00] SUID scan launched...
[2025-07-10 03:00:01] New SUID files detected:
/usr/local/bin/custom_suid_tool
[2025-07-10 03:00:01] SUID files removed since last baseline:
/usr/bin/ping
```

## 🔒 Security-Oriented Design

  - Only accessible and executable by `root`

  - Writes logs to a system log directory

  - Avoids false positives by comparing sorted lists

  -  Cleans up temporary files after execution

## 📄 License

MIT License
