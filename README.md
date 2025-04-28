# Fawry Internship Task 🚀

Welcome to my internship technical tasks repository!

This project includes two main tasks:
- ✅ MyGrep Command Implementation
- ✅ DNS Troubleshooting and Root Cause Analysis

---

## 1. 🛠️ MyGrep Task

**Objective:**  
Create a bash script `mygrep.sh` that mimics basic functionality of the `grep` command.

**What was done:**
- Developed a bash script that searches for a pattern inside a file.
- Supports basic search functionality.
- Displays matching lines containing the given word or phrase.

**Usage:**
```bash
./mygrep.sh "search_term" filename.txt
```

---

## 2. 🌐 DNS Troubleshooting Task

**Objective:**  
Diagnose and fix DNS resolution issues in a Linux environment.

**What was done:**
- Investigated systemd-resolved service status.
- Fixed broken `/etc/resolv.conf` symbolic link.
- Configured fallback DNS servers (Google DNS 8.8.8.8, Cloudflare DNS 1.1.1.1).
- Implemented a troubleshooting bash script to automate future fixes.

**Troubleshooting Script:**
- Checks if systemd-resolved service is running.
- Ensures `/etc/resolv.conf` is correctly linked.
- Restarts systemd-resolved if needed.
- Tests DNS resolution automatically.
  
---

## 📂 Project Structure

```
Fawry-Internship-Task/
├── Q1-mygrep/                        # MyGrep Task Files
│   ├── mygrep.sh                     # Bash script that mimics grep
│   ├── testfile.txt                  # Sample file to test mygrep
│   └── README.md                     # Task-specific readme
│
├── Q2-Troubleshooting-Internal-Dashboard/    # DNS Troubleshooting Task Files
│   ├── diagnose.sh                   # Script to diagnose DNS issues
│   ├── dns_troubleshoot.sh            # Automated troubleshooting script
│   └── README.md                      # Task-specific readme
│
└── README.md                          # Main README for the whole project
```

---

## ✨ Author

**Mohamed Ahmed Farouk Elweza**  
[GitHub Profile](https://github.com/MohamedElweza) | [LinkedIn](https://www.linkedin.com/in/mohamedelweza/)

---










---
