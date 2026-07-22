#!/bin/bash
killall -9 rom_uart_send measure_1st 2>/dev/null
rm -f *.log

touch rom_uart_send.log measure_1st.log

tail -q -f rom_uart_send.log measure_1st.log &
TAIL_PID=$!

stdbuf -o0 sudo ./rom_uart_send > rom_uart_send.log 2>&1

#./../start.sh

sleep 10

stdbuf -o0 sudo ./measure_1st > measure_1st.log 2>&1

kill $TAIL_PID 2>/dev/null

cd ~/
