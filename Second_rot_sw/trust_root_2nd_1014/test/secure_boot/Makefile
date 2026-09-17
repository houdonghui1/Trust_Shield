CC = gcc
CFLAGS ?=
LDLIBS ?= -lssl -lcrypto

.PHONY: all clean

all: rom_uart_send measure_1st attestation_smoketest

rom_uart_send: rom_uart_send.c
	$(CC) $(CFLAGS) $< -o $@ $(LDLIBS)

measure_1st: measure_1st.c
	$(CC) $(CFLAGS) $< -o $@ $(LDLIBS)

attestation_smoketest: attestation_smoketest.c cluster_bls_relay.c cluster_bls_relay.h
	$(CC) $(CFLAGS) attestation_smoketest.c cluster_bls_relay.c -o $@ $(LDLIBS)

clean:
	rm -f rom_uart_send measure_1st attestation_smoketest
