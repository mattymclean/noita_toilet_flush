# Noita Toilet Flush Spell Mod

A humorous Noita mod that adds a "Toilet Flush" spell which spawns a toilet with gravity field effects that draws enemies in and flushes them away.

## 🚽 Installation (So Easy, Even Grady Can Do It!)

**Step 1: Find Your Noita Folder** 🔍
- Open Steam
- Right-click on Noita in your library
- Click "Manage" → "Browse local files"
- You should see a folder that says "Noita" (congratulations, you found it!)

**Step 2: Find the Mods Folder** 📁
- Look for a folder called "mods" inside your Noita folder
- If you don't see one, create it (yes, just make a new folder and name it "mods")
- Don't panic if it wasn't there - that's totally normal!

**Step 3: Download This Mod** ⬇️
- Download this entire repository as a ZIP file
- Extract it somewhere you can find it again (like your Desktop)
- You should now have a folder called "noita_toilet_flush"

**Step 4: Move the Magic** ✨
- Copy the "noita_toilet_flush" folder
- Paste it into that "mods" folder you found/created in Step 2
- Your path should look like: `Noita/mods/noita_toilet_flush/`

**Step 5: Turn It On** 🔌
- Start Noita
- Go to "Mods" in the main menu
- Find "Toilet Flush Spell" and click the checkbox to enable it
- Restart Noita (yes, you have to restart - trust the process)

**Step 6: Flush Your Enemies!** 💩
- Start a new game
- Find the "Toilet Flush" spell (it's purple and has a toilet icon)
- Cast it near enemies and watch the magic happen
- Enjoy the satisfying sounds of your foes getting flushed!

*If these instructions were too complicated, ask Grady for help - he's probably figured it out by now.*

---

## Mod Description

The **Toilet Flush** spell creates a toilet entity at a distance from the caster. The toilet has a gravity field that draws enemies toward it. When enemies contact the toilet:

- **Small enemies**: Begin swirling around the toilet bowl as if being flushed, then shrink and disappear (die)
- **Large enemies**: Get "clogged" - they swirl around but take damage instead of dying
- **Audio progression**: Starts with running water sound, transitions to flush sound that ends when enemies are shrunk
- **Visual effects**: Mud particles are flung around for humorous effect
- **Duration**: Toilet disappears after 30 seconds

## Implementation Plan

### 1. Mod Directory Structure
```
noita_toilet_flush/
├── mod.xml                          # Mod metadata
├── init.lua                         # Mod entry point with hooks
├── data/
│   ├── gun_actions/
│   │   └── gun_actions.lua         # Spell registration
│   └── scripts/
│       └── toilet_flush_action.lua # Main spell action script
├── files/
│   ├── entities/
│   │   └── toilet_flush/
│   │       ├── toilet.xml          # Toilet entity definition
│   │       └── toilet_sprite.png   # Toilet sprite asset
│   ├── scripts/
│   │   ├── toilet_interaction.lua  # Enemy interaction logic
│   │   ├── toilet_swirl.lua        # Swirling animation system
│   │   └── toilet_effects.lua      # Particle and audio effects
│   └── audio/
│       ├── running_water.ogg       # Running water sound
│       └── flush_sound.ogg         # Toilet flush sound
└── README.md                        # This file
```

### 2. Core Components

#### Spell Registration (`data/gun_actions/gun_actions.lua`)
- Register new spell with ID "TOILET_FLUSH"
- Set spell properties: mana cost (50-80), cast delay, spread
- Reference existing spell patterns for consistency

#### Toilet Entity (`files/entities/toilet_flush/toilet.xml`)
- Define entity components:
  - `SpriteComponent` for toilet visual
  - `PhysicsBodyComponent` for collision detection
  - `GravityFieldComponent` based on Personal Gravity Field implementation
  - `LifetimeComponent` for 30-second duration
  - Custom collision detection components

#### Spell Action (`data/scripts/toilet_flush_action.lua`)
- Use `EntityLoad()` to spawn toilet entity at calculated distance from caster
- Set up entity positioning and initial properties
- Initialize gravity field and timer systems

#### Enemy Interaction System (`files/scripts/toilet_interaction.lua`)
- Implement collision detection between enemies and toilet
- Determine enemy size classification (small vs large)
- Trigger appropriate behavior (death vs damage)
- Manage swirling animation state

#### Swirling Animation (`files/scripts/toilet_swirl.lua`)
- Implement circular motion mathematics for swirling effect
- Use trigonometric calculations for smooth orbital movement
- Add timer-based shrinking effect using SpriteComponent scaling
- Handle entity cleanup and removal

#### Audio & Effects (`files/scripts/toilet_effects.lua`)
- Manage audio progression (running water → flush sound)
- Implement mud particle effects using Noita's particle system
- Coordinate timing between audio and visual effects

### 3. Technical Implementation Details

#### Gravity Field Mechanics
- Reference "Personal Gravity Field" spell (ID: PERSONAL_GRAVITY_FIELD)
- Use existing `GravityFieldComponent` with appropriate radius (100-150 pixels)
- Adjust gravity strength for balanced gameplay

#### Enemy Size Detection
- Use entity bounding box or health values to classify enemy size
- Small enemies: < 100 HP or specific entity tags
- Large enemies: > 100 HP or boss-type entities
- Implement fallback logic for edge cases

#### Swirling Mathematics
```lua
-- Circular motion around toilet center
local angle = GameGetFrameNum() * swirl_speed
local radius = base_radius + (shrink_factor * time_elapsed)
local new_x = toilet_x + math.cos(angle) * radius
local new_y = toilet_y + math.sin(angle) * radius
```

#### Audio System
- Use `GamePlaySound()` for audio playback
- Implement state machine for audio progression
- Coordinate audio timing with animation phases

### 4. Asset Requirements

#### Sprites
- Extract toilet sprite from Noita's game files using data extraction tools
- Location: `%localappdata%Low\Nolla_Games_Noita\data\enemies_gfx\` (approximate)
- Alternative: Create custom toilet sprite if needed

#### Audio Files
- Running water sound effect (looping)
- Toilet flush sound effect (one-shot)
- Format: OGG Vorbis (Noita standard)

### 5. Balancing Parameters

#### Spell Properties
- **Mana cost**: 60 mana (moderate-high cost for powerful effect)
- **Cast delay**: 30 frames (0.5 seconds)
- **Spread**: 0 degrees (precise targeting)
- **Spawn distance**: 150-200 pixels from caster

#### Gravity Field
- **Radius**: 120 pixels
- **Strength**: Moderate (enough to pull enemies but not overpowered)
- **Duration**: 30 seconds total

#### Enemy Interactions
- **Swirling duration**: 2-3 seconds before shrinking
- **Damage for large enemies**: 25-50 HP per flush cycle
- **Shrinking speed**: 0.1 scale reduction per frame

### 6. Testing Strategy

#### Development Testing
1. Load mod in Noita with console enabled
2. Spawn spell using console commands or wand editor
3. Test toilet spawning at correct distance
4. Verify gravity field attracts different enemy types
5. Test swirling and shrinking animations
6. Verify audio progression timing
7. Check particle effects appearance

#### Compatibility Testing
- Test with various enemy types (small, medium, large, bosses)
- Verify mod doesn't conflict with other popular mods
- Test performance impact with multiple toilets
- Ensure proper cleanup prevents memory leaks

#### Edge Case Testing
- Multiple enemies simultaneously
- Very large enemies (bosses)
- Enemies with special properties (flying, incorporeal)
- Toilet spawning in confined spaces

### 7. Installation Instructions

1. Extract Noita's game data using modding tools
2. Copy mod folder to `Noita/mods/noita_toilet_flush/`
3. Enable mod in Noita's mod menu
4. Restart Noita
5. Find "Toilet Flush" spell in spell pools or use console to spawn

### 8. Known Limitations

- May not work properly with all enemy types
- Performance impact with many simultaneous toilets
- Audio timing may vary based on game performance
- Large enemies might clip through toilet geometry

### 9. Future Enhancements

- Multiple toilet variants (golden toilet, cursed toilet)
- Upgradeable flush power
- Special interactions with water-based enemies
- Toilet paper projectile spell
- Plumber enemy type that repairs broken toilets

## Development Status

- [ ] Set up mod directory structure
- [ ] Extract toilet sprite assets
- [ ] Implement spell registration
- [ ] Create toilet entity definition
- [ ] Implement gravity field mechanics
- [ ] Add enemy interaction system
- [ ] Create swirling animation logic
- [ ] Implement audio progression
- [ ] Add mud particle effects
- [ ] Test and balance gameplay
- [ ] Create installation package

## Credits

- **Concept**: Grady
- **Implementation**: Devin AI
- **Noita**: Nolla Games
- **Inspiration**: Personal Gravity Field spell mechanics

## License

This mod is created for educational and entertainment purposes. Noita is property of Nolla Games.
