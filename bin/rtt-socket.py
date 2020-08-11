#!/usr/bin/env python3

import time
import socket
import sys


def RTT(host="127.0.0.1", port=80, timeout=40):
    # Format our parameters into a tuple to be passed to the socket
    sock_params = (host, port)
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        # Set the timeout in the event that the host/port we
        # are pinging doesn't send information back
        sock.settimeout(timeout)
        # Open a TCP Connection
        sock.connect(sock_params)
        # Time prior to sending 1 byte
        t1 = time.time()
        sock.sendall(b'1')
        # data = sock.recv(1)
        # Time after receiving 1 byte
        t2 = time.time()
        # RTT
        return t2-t1


print(RTT(sys.argv[1], int(sys.argv[2])))
