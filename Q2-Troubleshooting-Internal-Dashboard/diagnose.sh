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
