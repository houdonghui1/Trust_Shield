#!/bin/bash

python3 serial_capture_ak_ek.py

./create_ca_root.sh

./sign_ak_cert_by_ca.sh

sleep 3

python3 serial_send_ak_cert.py