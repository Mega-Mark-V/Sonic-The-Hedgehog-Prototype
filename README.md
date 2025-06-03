# Sonic The Hedgehog (Prototype) Disassembly

A work-in-progress disassembly of the Sonic 1 prototype released by Hidden Palace : https://hiddenpalace.org/Sonic_the_Hedgehog_(Prototype)

This disassembly is meant to serve as the basis for the rest of the disassemblies I plan to release under Mark-V. The reason I started with the prototype is because the engine has less hardcoding and is somewhat simpler, allowing for easier documentation. It's also of interest to research groups, as there are plenty of leftovers from earlier builds that contextualize prerelease media we have of the game, as well as parts of the final game.

This uses a completely different stylization from the disassemblies Sonic Retro hosts. I intend to emphasize documentation over ease-of-access. For one, it somewhat loosely follows the structure and organization of (what little can be determined of) the original source code. This means it's wildly incompatible with the unique file organization and general structure of the existing "standard" ones.

Sonic Retro's disassemblies are highly criticized for their lack of documentation, which is compounded by needlessly complicated presentation. Research and documentation is crucial, and I believe that explaining and providing context to systems and engine functionality not only allow researchers to better understand the thought processes and intent programmers might have had, but would serve to better educate novice ROM-hackers and programmers on the engine's code, which in turn makes things more accessible. 

This disassembly currently targets Naoto's vasm Psi-X module, but **this may change!** You can find that here : https://github.com/NaotoNTP/vasm-psi-x

## Notes

- Mega Drive constants and hardware port equates are derived from Devon's old Sonic CD disassembly, which represent the symbol libraries many Mega Drive developers had to work with. 
- At this time, I have not gone through the sound driver's code yet. It should be assembled separately, alongside the sound driver Z80 ROM which is uncompressed in this build of the game
- Assembly files (.68K and .Z80) should be read with a tab width of 8.
- "src/_temp" contains disorganized unusual or notable code I've documented that doesn't really fit into any files right now.
- "db" contains database files, and temporary full assembly output. It should be used as context for current progress.
- "doc" contains context for functions, libraries, and unused code that would require more context.   

## Notice

This is a work in progress. It currently does not build and likely will not for a while. I have been working on this project for about a year now, and despite my efforts, it may not be entirely consistent and I can also be wrong about things. This is also my first public project like this, so you might cut me a bit of slack as well. 

~Katsushimi (KatKuriN)


  
