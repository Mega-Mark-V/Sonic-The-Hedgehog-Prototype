# Sonic The Hedgehog (Prototype) Disassembly

A work-in-progress disassembly of the Sonic 1 prototype released during Hidden Palace's 2021 New Years stream
This disassembly is meant to serve as the basis for the rest of the disassemblies I plan to release under Mark-V. The reason I started with the prototype is because the engine has less hardcoding and is somewhat simpler, allowing for easier documentation. It's also of interest to research groups, as there are plenty of leftovers from earlier builds that contextualize prerelease media we have of the game.

This uses a completely different stylization from the disassemblies Sonic Retro hosts. I intend to emphasize documentation over weird macro-ization of things, so that learners and hackers may understand the engine better, and hopefully learn from it.

## Notes

- This disassembly should target ASM68K or Naoto's vasm Psi-X module. You can find that here : https://github.com/NaotoNTP/vasm-psi-x
- Mega Drive constants and hardware port equates are derived from devon's old Sonic CD disassembly, and much stylization is based on it too : https://github.com/DevsArchive/sonic-cd-disassembly
- At this time, I have not gone through the sound driver's code yet. It should be compiled separately, alongside the sound driver Z80 ROM which is uncompressed in this build of the game
- The special stage should also be compiled separately, as it has its own RAM layout, which is why RAM is currently split into two files ("Variables.i" and "RAM.i")
- Assembly files (.68K and .Z80) should be read with a tab width of 8.
- ../src/_TEMP.ASM contains the raw disassembler output, and should provide context for current progress

## Notice

This is a work in progress. It currently does not build and likely will not for a while. I have been working on this project for about a year now, and despite my efforts, it may not be entirely consistent and I can also be wrong about things. This is also my first public project like this, so you might cut me a bit of slack as well.

~Katsushimi (KatKuriN)


  
