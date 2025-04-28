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

