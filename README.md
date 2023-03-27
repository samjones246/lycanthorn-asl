# lycanthorn-asl
LiveSplit autosplitter for [Lycanthorn II - Rain of Beasts](https://store.steampowered.com/app/1546440/Lycanthorn_II__Rain_of_Beasts/).

## Features
- Load Removal
- Auto start
- Auto split points
  - Level entries/exits
  - Run end

## TODO
- Auto split points
  - Key collection
  - Boss kills

## Technical Info
Lycanthorn II is built with [GZDoom 4.3.1](https://github.com/ZDoom/gzdoom/tree/g4.3.1). This engine is open source, which is always helpful when reverse engineering an application. To find the static values outlined below, I used the following process:
 - Locate a reference to the target value in the source code which is close to a unique string literal.
 - Using a reverse engineering tool such as [x64dbg](https://x64dbg.com), search for the string literal in the game's exe.
 - Locate the assembly instruction correspoinding to the reference to the target variable.
 - Either:
   - Copy the constant pointer used by the instruction and use it directly. This is the simpler option, but if the game updates the pointer will probably change.
   - Extract a unique signature which can be used to identify this instruction, then use signature scanning to locate it at runtime and extract the pointer. This is more complicated, and will introduce a small amount of overhead during the autosplitter's initialisation, but should be much more resilient to updates.

### gameaction
The `gameaction` global variable is defined by GZDoom in `d_event.h`. The type of this variable is `gameaction_t`, an enum defined as follows:
```c++
enum gameaction_t : int
{
	ga_nothing,
	ga_loadlevel,
	ga_newgame,
	ga_newgame2,
	ga_recordgame,
	ga_loadgame,
	ga_loadgamehidecon,
	ga_loadgameplaydemo,
	ga_autoloadgame,
	ga_savegame,
	ga_autosave,
	ga_playdemo,
	ga_completed,
	ga_slideshow,
	ga_worlddone,
	ga_screenshot,
	ga_togglemap,
	ga_fullconsole,
	ga_resumeconversation,
};
```

The autosplitter uses this variable for auto start functionality by checking when the value is `ga_newgame` (2).

### nextlevel
The `nextlevel` static variable is defined by GZDoom in `g_level.cpp`. It has type `FString`, a string wrapper. When loading a new level, the variable is updated with the name of the level to load. The autosplitter uses this variable for transition splits.

### Map Names
Below is a mapping from internal map names to descriptions of those maps:
- `MAP02` - Overworld
- `MAP03` - Canyon
- `MAP04` - Lighthouse
- `MAP05` - Observatory
- `MAP06` - Pyramid
- `MAP07` - Volcano
- `MAP08` - Swamp
- `MAP09` - Fish
- `MAP10` - Tundra
- `MAP11` - Nosferatu's Castle
- `MAP12` - End Cutscene
- `MAP13` - Intro Castle