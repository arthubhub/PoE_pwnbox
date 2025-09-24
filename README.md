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
5. Install QEMU user (newest versions will allow GDB to map memory)

 
 
