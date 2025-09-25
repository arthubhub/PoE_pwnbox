#!/usr/bin/env bash
exec qemu-i386 -g 1234 -L "/usr/i386-linux-gnu" "pwn_me.bin"
