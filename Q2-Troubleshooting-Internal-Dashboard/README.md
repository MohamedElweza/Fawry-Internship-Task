# Troubleshooting Internal Dashboard

---

## 🧠 Scenario

The internal dashboard (`internal.example.com`) is currently unreachable from multiple systems.  
Users are encountering **"host not found"** errors, although the service seems up and running.  
I was tasked to **troubleshoot, verify, and restore connectivity** by investigating **DNS, network, and service layers**.

---

## 📚 Step-by-Step

### 1. Checked the Current DNS Settings
- **Command Used:**
  ```bash
  systemd-resolve --status
  ```
(or)
- **Command Used:**
  ```bash
  resolvectl status
  ```
- **Expected Output:**
  - Lists current DNS servers.
  - Shows link-specific configurations.
- **How to Know if There’s a Problem:**
  - No DNS listed.
  - Wrong/empty configurations.
  - "Failed to resolve" messages when pinging domains.
![List_DNS_Servers](https://github.com/user-attachments/assets/23194367-bada-4593-a76a-8380cd2c6ad0)

### 2. Checked Service Status
- **Command Used:**
  ```bash
  sudo systemctl status systemd-resolved
  ```
- **Expected Output:**
  - Status: `active (running)`.
- **How to Know if There's a Problem:**
  - Status shows `failed`, `inactive`, or critical logs in the output.
![Screenshot (403)](https://github.com/user-attachments/assets/b6131411-91a6-4177-b9d2-2ee3ec17c4ab)

---

### 5. Confirmed DNS Resolution Works
- **Command Used:**
  ```bash
  dig internal.example.com
  ```
![Screenshot (405)](https://github.com/user-attachments/assets/01048b8f-aa56-4427-b929-cb425ae314c0)

  (or)
  ```bash
 nslookup internal.example.com
  ```
![Screenshot (406)](https://github.com/user-attachments/assets/caa1157d-b5af-49f1-910d-0104f1ee3d21)

- **Expected Output:**
  - IP addresses are returned.
  - No "temporary failure in name resolution" error.
- **How to Know if There’s a Problem:**
  - "NXDOMAIN" errors.
  - "SERVFAIL" responses.
  - No IP address returned.

- If resolving the IP, checked if service ports are reachable:

```bash
telnet IP_ADDRESS 80
telnet IP_ADDRESS 443
```
or

```bash
nc -zv IP_ADDRESS 80
nc -zv IP_ADDRESS 443
```

- Tested HTTP response:

```bash
curl -I http://IP_ADDRESS
curl -I https://IP_ADDRESS
```

- Checked if service is listening:

```bash
ss -tuln | grep ':80\|:443'
```

---

## Diagnose Script: diagnose.sh

A quick bash script to automate basic checks.

```bash
#!/bin/bash

echo "Checking DNS with system resolver..."
dig internal.example.com

echo "Checking DNS with Google DNS..."
dig @8.8.8.8 internal.example.com

echo "Pinging internal.example.com..."
ping -c 4 internal.example.com

IP=$(dig +short internal.example.com)
echo "Resolved IP: $IP"

if [ -n "$IP" ]; then
  echo "Checking port 80 and 443..."
  nc -zv $IP 80
  nc -zv $IP 443
  echo "Checking HTTP response..."
  curl -I http://$IP
  curl -I https://$IP
else
  echo "Failed to resolve internal.example.com"
fi
```

- Run it:
  ```bash
  ./diagnose.sh
  ```

## ⚡ Troubleshooting Section

> If DNS resolution fails even after configuration:

- **Step 1:** Check if `systemd-resolved` is running:
  ```bash
  sudo systemctl status systemd-resolved
  ```
- **Step 2:** Check `/etc/resolv.conf` file:
  ```bash
  cat /etc/resolv.conf
  ```
  ![Screenshot (407)](https://github.com/user-attachments/assets/984c8c92-24ba-4bfa-98cf-92e65bbb0723)

  ➔ It must be a symbolic link to `/run/systemd/resolve/stub-resolv.conf`.  
  If not, fix it using:
  ```bash
  sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
  sudo systemctl restart systemd-resolved
  ```

- **Step 3:** Reboot the server:
  ```bash
  sudo reboot
  ```

- **Step 4:** Re-test DNS using `dig`, `ping`, or `systemd-resolve --status`.

---

## Troubleshhooting Script: `dns_troubleshoot.sh`:

```bash
#!/bin/bash

echo " Checking systemd-resolved service..."
if ! systemctl is-active --quiet systemd-resolved; then
            echo " systemd-resolved service not running. Starting it now..."
                sudo systemctl start systemd-resolved
        else
                    echo " systemd-resolved is active."
fi

echo "-------------------------------------------------------"

echo " Ensuring /etc/resolv.conf is correctly linked..."
if [ "$(readlink /etc/resolv.conf)" != "/run/systemd/resolve/stub-resolv.conf" ]; then
        echo " Fixing /etc/resolv.conf symbolic link..."
        sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
else
        echo " /etc/resolv.conf is correctly linked."
fi

echo "-------------------------------------------------------"

echo " Restarting systemd-resolved..."
sudo systemctl restart systemd-resolved

echo "-------------------------------------------------------"

echo " Testing DNS Resolution..."
if dig google.com | grep -q "ANSWER SECTION"; then
        echo " DNS Resolution is working."
else
        echo " DNS Resolution FAILED. Please investigate manually."
fi
```
![Screenshot (408)](https://github.com/user-attachments/assets/18eb7521-5490-4b27-9901-b153091dd83c)

- Run it:
  ```bash
  ./dns_troubleshoot.sh
  ```
---

###  Identify Potential Causes

| Layer | Potential Problems |
|------|---------------------|
| DNS Layer | - Wrong `/etc/resolv.conf` DNS<br>- DNS server misconfigured<br>- Missing or wrong DNS record |
| Network Layer | - Firewall blocking traffic<br>- Broken routing<br>- Proxy/NAT misconfiguration |
| Service Layer | - Service only bound to `localhost`<br>- Crashed process with open port<br>- SSL misconfiguration |

---

###  Solutions and Commands

| Problem | How to Confirm | How to Fix | Command |
|---------|----------------|------------|---------|
| Wrong DNS Server | View `/etc/resolv.conf` | Update DNS IP | `sudo nano /etc/resolv.conf` |
| Missing DNS Record | `dig` shows no result | Add DNS entry | Update internal DNS server |
| Firewall Blocking | `nc -zv` fails | Open firewall port | `sudo ufw allow 80` |
| Wrong Binding | `ss -tuln` shows `127.0.0.1` | Bind service to `0.0.0.0` | Edit service config and restart |
| SSL Issues | `curl -I https://` fails SSL handshake | Renew SSL certs | `sudo certbot renew` |

---

#### Configure `/etc/hosts` for Testing

```bash
sudo nano /etc/hosts
```
![Screenshot (410)](https://github.com/user-attachments/assets/3df2b601-40c5-492a-87df-fc7fe0cd64e6)

Add:

```
192.168.1.100 internal.example.com
```
![Screenshot (409)](https://github.com/user-attachments/assets/0ff7069d-d7f6-478a-8d71-6227baf6f834)

Test:

```bash
ping internal.example.com
curl http://internal.example.com
```

✅ Works even without DNS.

---

###  Modified the `resolved.conf` File
- **File Edited:**
  ```bash
  sudo nano /etc/systemd/resolved.conf
  ```
- **Changes Added:**
  ```bash
  [Resolve]
  DNS=8.8.8.8
  FallbackDNS=1.1.1.1
  ```
- **Reason:**
  - `8.8.8.8` ➔ Google's Public DNS.
  - `1.1.1.1` ➔ Cloudflare’s Public DNS.
![Resolving_DNS FallbackDNS](https://github.com/user-attachments/assets/3e47370a-1db5-4853-ad18-d59c845f4484)

---

###  Persist DNS Settings with systemd-resolved
- **Command Used:**
  ```bash
  sudo systemctl restart systemd-resolved
  ```
- **Expected Output:**
  - No error message.
  - Command completes silently (success).
- **How to Know if There's a Problem:**
  - If there is an error, it would show immediately.
![Screenshot (402)](https://github.com/user-attachments/assets/2a1019f2-a971-40f9-87c3-1d6e32d7c17a)

---

🧠 **Steps to Prevent the Problem from the Root (Root Cause Fix)**

📈 **Continuous Monitoring of the DNS Server**  
Use **Prometheus + Grafana** with **AlertManager** to send alerts when DNS failures occur.

🛠️ **Increase DNS Reliability**  
- Add multiple DNS servers in `/etc/resolv.conf`.  
- Implement **load balancing** or **failover** mechanisms.

🛡️ **Protect Network Settings**  
Use **Centralized Configuration Management** (such as **Ansible**) to manage and secure network settings.

📅 **Periodic Review of DNS Records**  
Perform a **monthly audit** of DNS records to ensure their correctness and validity.

📜 **Document Configurations and Policies**  
Document all changes and maintain a **backup copy** of configurations.

