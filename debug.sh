#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <script.poe> <binary> [gdb_port] [session_name]"
  exit 2
fi

POE_FILE="$1"
BINARY="$2"
GDB_PORT="${3:-1234}"
SESSION="${4:-poe_debug}"

LIB_PATH="/usr/i386-linux-gnu"
ARCH="i386"


# locations
WORKDIR="$(pwd)"
WRAPPER="${WORKDIR}/wrapper.sh"
POE_OUT="input.txt"

# sanity checks
if [[ ! -f "${POE_FILE}" ]]; then
  echo "ERROR: poe file not found: ${POE_FILE}" >&2
  exit 3
fi
if [[ ! -x "${BINARY}" && ! -f "${BINARY}" ]]; then
  echo "ERROR: binary not found: ${BINARY}" >&2
  exit 4
fi

# create the wrapper file
echo "" > "${WRAPPER}"
echo "#!/usr/bin/env bash" > "${WRAPPER}"
echo "exec qemu-i386 -g ${GDB_PORT} -L \"${LIB_PATH}\" \"${BINARY}\"" >> "${WRAPPER}"
chmod +x "${WRAPPER}"
echo "Created wrapper \"${WRAPPER}\" with params" " -g " " -L "

# create tmux session with two sides
# left pane: poe & wrapper
# right pane: gdb connecting to localhost:GDB_PORT

# create session
tmux new-session -d -s "${SESSION}" -c "${WORKDIR}" 

# split window 
tmux split-window -h -t "${SESSION}:0" -c "${WORKDIR}"

LEFT_CMD="poe stdin --default-timeout 64000 -o ${POE_OUT} \"${POE_FILE}\" \"${WRAPPER}\""

RIGHT_CMD="pwndbg -q -ex 'set disassembly-flavor intel'  \
	-ex 'set debuginfod enabled on'  \
	-ex \"file ${BINARY} \"  \
	-ex \"set sysroot ${LIB_PATH} \"  \
	-ex \"set solib-search-path ${LIB_PATH}\" \
	-ex \"set architecture ${ARCH} \"  \
	-ex \"target remote localhost:${GDB_PORT} \"  \
	-ex 'unset env LINES'  \
	-ex 'unset env COLUMNS'"

# send the commands

tmux send-keys -t "${SESSION}:0.0" "${LEFT_CMD}" C-m
tmux send-keys -t "${SESSION}:0.1" "${RIGHT_CMD}" C-m

# set pane titles
tmux select-pane -t "${SESSION}:0.0" -T "POE"
tmux select-pane -t "${SESSION}:0.1" -T "GDB"

# attach to session
echo "Connecting to tmux session '${SESSION}'..."
tmux attach -t "${SESSION}"
