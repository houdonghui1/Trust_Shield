#!/bin/bash

killall -9 rom_uart_send measure_1st attestation_smoketest 2>/dev/null
rm -f *.log

touch rom_uart_send.log measure_1st.log attestation_smoketest.log

tail -q -f rom_uart_send.log measure_1st.log attestation_smoketest.log &
TAIL_PID=$!
trap 'kill "$TAIL_PID" 2>/dev/null' EXIT INT TERM

if ! stdbuf -o0 -e0 sudo -n ./rom_uart_send > rom_uart_send.log 2>&1; then
    echo "[ERROR] L2 certificate provisioning failed; stop before L1 measurement" \
        >> rom_uart_send.log
    exit 1
fi

#./../start.sh

sleep 10

if ! stdbuf -o0 -e0 sudo -n ./measure_1st > measure_1st.log 2>&1; then
    echo "[ERROR] L1 measurement or certificate provisioning failed" \
        >> measure_1st.log
    exit 1
fi

stdbuf -o0 -e0 sudo -n ./attestation_smoketest \
    > attestation_smoketest.log 2>&1
ATTESTATION_STATUS=$?

kill $TAIL_PID 2>/dev/null

cd ~/
exit "$ATTESTATION_STATUS"
