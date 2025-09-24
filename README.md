# PoE_pwnbox
This repo aims to provide a simple to setup way to interactively debug exploits with B2R2/Poe tool.


# Setup
1. Clone the PoE tool with `git clone https://github.com/B2R2-org/PoE`
2. Increase the `DefaultTimeout` value in `PoE/src/PoE.Core/Stream.fs` -> 64000 is good, Busan too.
3. Compile the tool
   ```
   dotnet tool uninstall PoE.Replayer --tool-path /home/USER/.dotnet/tools/
   dotnet tool install --tool-path /home/USER/.dotnet/tools --add-source /tmp/poe_nupkgs PoE.Replayer
   dotnet pack src/PoE.Replayer -c Release -o /tmp/poe_nupkgs
   ```
4. Add it to the $PATH -> `export PATH="$PATH:/home/USER/.dotnet/tools"`
5. Install QEMU user (newest versions will allow GDB to map memory), and Tmux

# Example of usage

```
[arthub@archlinux dir]$ ./debug.sh 
Usage: ./debug.sh <script.poe> <binary> [gdb_port] [session_name]
[arthub@archlinux dir]$ ./debug.sh exploit.poe badformat
Created wrapper "{/home/.../wrapper.sh}" with params  -g   -L 
Connecting to tmux session 'poe_debug'...
[exited]
```

<img width="1919" height="1004" alt="image" src="https://github.com/user-attachments/assets/59cb517a-2bbd-435e-bf46-9faa51a42988" />


 
 
