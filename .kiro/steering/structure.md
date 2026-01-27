# VNRacing - Project Structure

## Repository Layout
```
/
├── PrototypeRacing/          # Unreal Engine project
│   ├── Config/               # Engine and project configuration
│   ├── Content/              # Game assets (Blueprints, Materials, Meshes, etc.)
│   ├── Plugins/              # Custom and third-party plugins
│   └── Source/               # C++ source code
│       └── PrototypeRacing/  # Main game module
│           ├── Public/       # Header files
│           └── Private/      # Implementation files
├── Docs/                     # Project documentation
│   ├── _architecture/        # System architecture docs
│   ├── _standards/           # Code and naming standards
│   ├── _templates/           # Documentation templates
│   ├── _cross-reference/     # Cross-feature references
│   └── features/             # Feature-specific documentation
│       ├── racing-car-physics/
│       ├── progression-system/
│       ├── car-customization/
│       ├── multiplayer/
│       └── ...
└── Docs_Backup_*/            # Legacy documentation backup
```

## Content Folder Organization
```
Content/
├── Actors/           # Core gameplay actors (checkpoints, track manager)
├── AICar/            # AI vehicle blueprints
├── Assets/           # Environment and prop assets
├── Audio/            # Sound effects and music
├── Blueprint/        # General gameplay blueprints
├── CarCustomize/     # Car customization assets
├── Input/            # Enhanced Input actions and contexts
├── Inventory/        # Inventory system assets
├── Map/              # Level maps
├── Material/         # Materials and material instances
├── Multiplayer/      # Multiplayer-specific assets
├── Player/           # Player-related blueprints
├── Progression/      # Progression system assets
├── UI/               # UMG widgets and UI assets
├── Vehicles/         # Vehicle meshes and blueprints
└── VFX/              # Niagara and particle effects
```

## Source Code Organization
Key C++ classes in `Source/PrototypeRacing/`:
- `PrototypeRacingGameMode` - Main game mode
- `PrototypeRacingPlayerController` - Player input handling
- `PrototypeRacingPawn` - Base vehicle pawn
- `PrototypeRacingSportsCar/OffroadCar` - Vehicle variants
- `PhysicCarController` - Physics integration
- `*WheelFront/*WheelRear` - Wheel configurations

## Plugin Structure
Custom plugins in `Plugins/`:
- `SimpleCarPhysics` - Core vehicle physics
- `AsyncTickPhysics` - Async physics updates
- `Minimap` - Minimap rendering
- `CustomBackdrop` - Sky/backdrop system
- `MathHelper` - Math utilities
- `Vehicle_Rig_Module` - Vehicle rigging tools

## Documentation Structure
Each feature in `Docs/features/` follows phases:
- `requirements/` - User stories, acceptance criteria
- `design/` - Architecture, data models, diagrams
- `planning/` - Task breakdown, estimates
- `implementation/` - Code patterns, integration notes
- `testing/` - Test cases, validation procedures
- `deployment/` - Build config, release procedures
- `monitoring/` - Metrics, analytics
