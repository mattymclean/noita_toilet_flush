# Noita Toilet Flush Spell Mod 🚽

A humorous Noita mod that adds the **Toilet Flush** spell: lob a porcelain throne at your enemies, watch it suck them in, swirl them around the bowl, and flush them into the abyss. The more it flushes, the hungrier it gets.

## Installation (So Easy, Even Grady Can Do It!)

**Step 1: Find Your Noita Folder** 🔍
- Open Steam
- Right-click on Noita in your library
- Click "Manage" → "Browse local files"
- You should see a folder that says "Noita" (congratulations, you found it!)

**Step 2: Find the Mods Folder** 📁
- Look for a folder called "mods" inside your Noita folder
- If you don't see one, create it (yes, just make a new folder and name it "mods")

**Step 3: Get This Mod** ⬇️
- Download this repository as a ZIP and extract it
- Rename the extracted folder to exactly `noita_toilet_flush` (GitHub likes to add `-main` to the name — delete that part, it matters!)
- Move it into the mods folder: `Noita/mods/noita_toilet_flush/`

**Step 4: Turn It On** 🔌
- Start Noita → "Mods" in the main menu
- Click **Toilet Flush Spell** so it shows `[x]` (careful: clicking the name toggles it on AND off)
- Restart Noita (yes, you have to restart - trust the process)

**Step 5: Flush Your Enemies!** 💩
- The spell appears in the world like any other: in chests, shops, and wands (rare early, common deep down)
- Lob it near enemies and enjoy the satisfying sound of your foes going down the drain

*If these instructions were too complicated, ask Grady for help - he's probably figured it out by now.*

## What It Does

- **Lob a toilet.** It's a real physics object — it arcs, bounces, tumbles, and lands. It's even destructible, so guard your throne.
- **Suction.** Enemies within range get dragged toward the bowl. Ragdolls and loose props get pulled too, because physics is funny.
- **The swirl.** Anything that touches the bowl spins around it in a shrinking spiral with water splashing everywhere.
- **The flush.** Small enemies (≤150 max HP) go down the pipes for good — proper deaths, gold and all, killed by *"flushed down the toilet"*.
- **The clog.** Big enemies don't fit: they take 50 damage per cycle and get spat back out... until they come back for more.
- **THE PIPES HUNGER.** Every successful flush raises that toilet's kill threshold by 50 HP. Feed it the little ones, and eventually it can swallow the big ones. Listen for the milestones:
  - 3 flushes: *"The toilet gurgles ominously. The pipes are warming up..."*
  - 6 flushes: *"The toilet's suction grows unnatural. Larger prey beware."*
  - 10 flushes: *"THE PORCELAIN THRONE HUNGERS."*
- Each toilet lasts **30 seconds**, each spell card has **15 uses**, and yes, you can have multiple toilets going at once.

## The Secret Code 🤫

There's a hidden way to summon the **Flusher 3000** — a wand that is itself a tiny floating toilet, pre-loaded with the spell.

<details>
<summary>Spoiler (Grady, earn it honestly first)</summary>

Open **Options → Mods → Mod settings** (works mid-run from the pause menu), find **Toilet Flush Spell**, and type `FLUSHME` into the Secret code box. The wand appears at your feet. The code is consumed each time — type it again for another.

</details>

## Balance Cheat Sheet

| Thing | Value | Where to tweak |
|---|---|---|
| Uses per spell card | 15 | `data/gun_actions/gun_actions.lua` |
| Mana cost | 60 | same |
| Toilet lifetime | 30 s | `lifetime` in `files/entities/projectiles/toilet_flush.xml` |
| Suction radius | 96 px | `SUCK_RADIUS` in `files/scripts/toilet_update.lua` |
| Swirl duration | ~1.8 s | `SWIRL_FRAMES`, same file |
| Base kill line | 150 max HP | `SMALL_MAX_HP` (internal units ×25), same file |
| Kill line growth per flush | +50 HP | `KILL_GROWTH`, same file |
| Clog damage | 50 per cycle | `CLOG_DAMAGE`, same file |

## How It Works (For Modders)

The mod is small on purpose — three Lua scripts and three entity XMLs:

```
noita_toilet_flush/
├── mod.xml                                  # Mod metadata
├── init.lua                                 # Spell registration hook + secret code watcher
├── settings.lua                             # Mod settings page (the secret code box)
├── data/
│   ├── gun_actions/gun_actions.lua          # Spell definition (appended to the game's spell list)
│   └── ui_gfx/gun_actions/*.png             # 16x16 spell icons
└── files/
    ├── entities/
    │   ├── projectiles/toilet_flush.xml     # THE toilet: a physics projectile (TNT-box pattern)
    │   ├── toilet_wand.xml                  # The Flusher 3000
    │   └── toilet_wand_sprite.xml           # Wand sprite layout
    ├── scripts/
    │   ├── toilet_update.lua                # All gameplay: suction, swirl, flush, clog, scaling
    │   └── toilet_wand_setup.lua            # Puts the spell into the Flusher 3000
    └── sprites/                             # 16x16 toilet art
```

Design notes, learned the hard way:

- **The projectile IS the toilet.** Modeled on vanilla `data/entities/projectiles/deck/tntbox.xml` — no fragile "spawn a second entity on death" handoff. `<Base file="data/entities/base_projectile_physics.xml">` does the heavy lifting.
- **There is no gravity-field component in Noita.** Suction is a Lua script (`toilet_update.lua`, run every 2 frames by a `LuaComponent`), patterned on vanilla `data/scripts/buildings/gravity_field.lua`: velocity nudges for creatures via `VelocityComponent`/`CharacterDataComponent`, `PhysicsApplyForceOnArea()` for physics bodies.
- **State lives in `VariableStorageComponent`s** (per-toilet flush count and age, per-victim swirl timer). You cannot invent new fields on components.
- **Sounds are vanilla FMOD bank events** (`GamePlaySound` can't play loose .ogg files). Water is real `GameCreateParticle("water", ...)` — the flush splash is wet because it actually is.
- Unpack the game data with `noita_dev.exe -wizard_unpak` and keep `tools_modding/component_documentation.txt` + `lua_api_documentation.txt` open. Verify every component and function name against them — the engine fails silently on things that don't exist.

## Credits

- **Concept**: Grady
- **Implementation**: Matty & Claude (rebuilt from the ground up after a valiant 25-commit siege by Devin AI)
- **Noita**: Nolla Games
- **Inspiration**: The TNT Box spell, vanilla gravity fields, and household plumbing

## License

This mod is created for educational and entertainment purposes. Noita is property of Nolla Games.
