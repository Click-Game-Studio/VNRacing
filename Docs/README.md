# VNRacing Documentation

**Breadcrumbs:** Docs

**Project**: VNRacing - Mobile Racing Game  
**Engine**: Unreal Engine 5.4+  
**Platform**: Mobile (Android, iOS)  
**Documentation Version**: 1.0.0  
**Last Updated**: 2026-01-20

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Documentation Structure](#-documentation-structure)
- [Quick Start](#-quick-start)
- [Features](#-features)
- [Foundation Documentation](#-foundation-documentation)
- [Development Phases](#️-development-phases)
- [VN-Tour Campaign](#-vn-tour-campaign)
- [Technology Stack](#️-technology-stack)
- [Performance Targets](#-performance-targets)
- [Contributing](#-contributing)

---

## 📖 Overview

Welcome to the VNRacing documentation! This repository contains comprehensive documentation for a mobile racing game built with Unreal Engine 5.4+ and optimized for mobile devices.

### Key Features

- **VN-Tour Campaign**: Race through 5 iconic Vietnamese cities (Hà Nội, TP.HCM, Đà Nẵng, Huế, Hội An)
- **Mobile-First Design**: 60 FPS on mid-range devices with adaptive quality
- **SimpleCarPhysics**: Lightweight vehicle physics replacing Chaos Vehicle
- **Multiplayer**: Nakama matchmaking + Edgegap dedicated servers
- **Vietnamese Cultural Integration**: Traditional patterns, colors, and landmarks

---

## 📁 Documentation Structure

This documentation follows the **AI DevKit** phase-based approach with feature-first organization:

```
Docs/
├── _templates/          # Phase templates (5 phases)
├── _standards/          # Project-wide standards and conventions
├── _architecture/       # System architecture documentation
├── _cross-reference/    # Cross-feature reference documents
├── features/            # Feature-based documentation (11 features)
│   ├── car-physics/           # Vehicle dynamics, camera, collision
│   ├── car-customization/     # Visual & performance customization
│   ├── progression-system/    # VN-Tour, XP, achievements
│   ├── profiles-inventory/    # Player profiles & inventory
│   ├── setting-system/        # Graphics, audio, controls
│   ├── shop-system/           # IAP, currency, shop items
│   ├── race-modes/            # Time Attack, Circuit, Sprint
│   ├── multiplayer/           # Matchmaking, dedicated servers
│   ├── minimap-system/        # Real-time navigation
│   ├── racer-ai/              # AI opponent behavior
│   └── tutorials/             # In-game tutorials
├── CHANGELOG.md         # Documentation changelog
└── README.md            # This file
```

---

## 🚀 Quick Start

### For New Team Members

1. **Start Here**: Read this README
2. **Architecture**: Review [System Overview](_architecture/system-overview.md)
3. **Standards**: Familiarize with [Documentation Standards](_standards/documentation-standards.md)
4. **Features**: Explore feature READMEs in `features/` directory

### For Developers

1. **Code Standards**: [Code Standards](_standards/code-standards.md)
2. **Naming Conventions**: [Naming Conventions](_standards/naming-conventions.md)
3. **Asset Organization**: [Asset Organization](_standards/asset-organization.md)

### For Designers

1. **VN-Tour Campaign**: [Progression System](features/progression-system/README.md)
2. **Race Modes**: [Race Modes](features/race-modes/README.md)
3. **Car Customization**: [Car Customization](features/car-customization/README.md)

---

## 🎯 Features

### Core Features (11 total)

| Feature | Status | Priority | Description |
|---------|--------|----------|-------------|
| [Car Physics](features/car-physics/README.md) | 🔄 Development | Critical | Vehicle dynamics, camera, collision |
| [Car Customization](features/car-customization/README.md) | 🔄 Development | High | Visual & performance customization |
| [Progression System](features/progression-system/README.md) | 🔄 Development | Critical | VN-Tour, XP, achievements |
| [Profiles & Inventory](features/profiles-inventory/README.md) | 🔄 Development | High | Player profiles, inventory management |
| [Setting System](features/setting-system/README.md) | 🔄 Development | Critical | Graphics, audio, controls, mobile settings |
| [Shop System](features/shop-system/README.md) | 🔄 Development | High | IAP, currency, shop items |
| [Race Modes](features/race-modes/README.md) | 🔄 Development | High | Time Attack, Circuit, Sprint, Elimination |
| [Multiplayer](features/multiplayer/README.md) | ⏸️ Pending | Critical | Matchmaking, dedicated servers, leaderboards |
| [Minimap System](features/minimap-system/README.md) | 🔄 Development | High | Real-time navigation, opponent tracking |
| [Racer AI](features/racer-ai/README.md) | 🔄 Development | High | AI opponent behavior, difficulty scaling |
| [Tutorials](features/tutorials/README.md) | 🔄 Development | Medium | In-game tutorials, onboarding |

---

## 📚 Foundation Documentation

### Templates

Phase templates for creating new feature documentation (5 phases):

- [Requirements Template](_templates/requirements/README.md)
- [Design Template](_templates/design/README.md)
- [Planning Template](_templates/planning/README.md)
- [Implementation Template](_templates/implementation/README.md)
- [Testing Template](_templates/testing/README.md)

> **Note**: Monitoring phase has been deprecated. Use analytics integration instead.

### Standards

Project-wide standards and conventions:

- [Documentation Standards](_standards/documentation-standards.md) - Header format, terminology, formatting
- [Naming Conventions](_standards/naming-conventions.md) - UE assets, C++, files
- [Code Standards](_standards/code-standards.md) - C++, Blueprint, performance best practices
- [Asset Organization](_standards/asset-organization.md) - Content folder structure, LODs, textures

### Architecture

System-level architecture documentation:

- [System Overview](_architecture/system-overview.md) - High-level architecture, core components
- [Technology Stack](_architecture/technology-stack.md) - UE5.4+, plugins, frameworks
- [Data Flow](_architecture/data-flow.md) - Data flow patterns, sequence diagrams
- [Integration Patterns](_architecture/integration-patterns.md) - Subsystems, plugins, event-driven
- [Mobile Optimization](_architecture/mobile-optimization.md) - Distance-based updates, pooling
- [Performance Targets](_architecture/performance-targets.md) - FPS, memory, network budgets
- [Security Architecture](_architecture/security-architecture.md) - Anti-cheat, validation, encryption

### Cross-Reference

Cross-feature reference documents:

- [Feature Dependency Matrix](_cross-reference/feature-dependency-matrix.md) - Feature dependencies, initialization order
- [API Integration Map](_cross-reference/api-integration-map.md) - Nakama, Edgegap, Firebase, Platform SDKs
- [Data Structure Index](_cross-reference/data-structure-index.md) - All USTRUCT, UENUM, classes
- [Component Interaction Map](_cross-reference/component-interaction-map.md) - UE component interactions

---

## 🏗️ Development Phases

Each feature follows a **5-phase** development lifecycle:

### 1. Requirements
- User stories and acceptance criteria
- Feature scope and boundaries
- Constraints and assumptions

### 2. Design
- Architecture and data models
- API/interface contracts
- Mermaid diagrams

### 3. Planning
- Task breakdown and dependencies
- Effort estimates
- Implementation order

### 4. Implementation
- Code structure and patterns
- Technical decisions
- Integration notes

### 5. Testing
- Test cases and coverage
- Manual testing procedures
- Performance validation

---

## 🎮 VN-Tour Campaign

The heart of VNRacing is the **VN-Tour Campaign**, featuring 5 Vietnamese cities:

| City | Tracks | Difficulty | Cultural Theme |
|------|--------|------------|----------------|
| **Hà Nội** | 15 | ⭐ Beginner | Ancient capital, Old Quarter, Hồ Gươm |
| **TP. Hồ Chí Minh** | 15 | ⭐⭐ Intermediate | Modern metropolis, Bến Thành, Bitexco |
| **Đà Nẵng** | 12 | ⭐⭐ Intermediate | Coastal city, Cầu Rồng, Bà Nà Hills |
| **Huế** | 12 | ⭐⭐⭐ Advanced | Imperial city, Citadel, Perfume River |
| **Hội An** | 9 | ⭐⭐⭐ Expert | Ancient town, lanterns, Japanese Bridge |
| **TOTAL** | **63** | Progressive | Vietnamese heritage |

Learn more: [Progression System](features/progression-system/README.md)

---

## 🛠️ Technology Stack

### Core Engine
- **Unreal Engine 5.4+**: Game engine
- **C++17**: Primary programming language
- **Blueprint**: Visual scripting

### Plugins
- **SimpleCarPhysics**: Lightweight vehicle physics
- **Nakama**: Multiplayer backend (matchmaking, leaderboards)
- **EdgegapIntegrationKit**: Dedicated server deployment
- **Rive**: Vector-based UI animations
- **VNMinimap**: In-game minimap
- **AsyncTickPhysics**: Async physics simulation

### Backend Services
- **Nakama Cloud**: Authentication, matchmaking, cloud storage
- **Edgegap**: Dedicated server orchestration
- **Firebase**: Analytics, crashlytics, remote config
- **Google Play Services**: Android platform services
- **App Store Connect**: iOS platform services

Learn more: [Technology Stack](_architecture/technology-stack.md)

---

## 📊 Performance Targets

| Metric | Target | Platform |
|--------|--------|----------|
| **Frame Rate** | 60 FPS | High-end mobile |
| **Frame Rate** | 30 FPS | Low-end mobile |
| **Memory Usage** | <2 GB | Total budget |
| **Network Latency** | <100ms | Multiplayer |
| **Draw Calls** | <1500 | Per frame |
| **Load Time** | <5s | Level loading |

Learn more: [Performance Targets](_architecture/performance-targets.md)

---

## 🔗 Important Links

### External Documentation
- [Unreal Engine 5 Documentation](https://docs.unrealengine.com/5.4/)
- [SimpleCarPhysics Plugin](https://www.unrealengine.com/marketplace/)
- [Nakama Documentation](https://heroiclabs.com/docs/)
- [Edgegap Documentation](https://docs.edgegap.com/)

### Project Resources
- **Issue Tracker**: [YouTrack Link]
- **Version Control**: [Git Repository]
- **CI/CD**: [Build Pipeline]
- **Analytics**: [Firebase Console]

---

## 👥 Team

### Core Teams
- **Physics Team**: Racing car physics, vehicle dynamics
- **Game Design Team**: Progression, VN-Tour, race modes
- **Customization Team**: Car customization, visual design
- **Systems Team**: Settings, save/load, performance
- **Monetization Team**: Shop, IAP, currency
- **Network Team**: Multiplayer, matchmaking, servers
- **AI Team**: Racer AI, difficulty scaling
- **Performance Team**: Mobile optimization, profiling

---

## 📝 Contributing

### Adding New Features

1. Create feature directory: `features/[feature-name]/`
2. Create 5 phase subdirectories (requirements, design, planning, implementation, testing)
3. Use templates from `_templates/`
4. Follow standards from `_standards/`
5. Update cross-references in `_cross-reference/`
6. Add feature to this README

### Updating Documentation

1. Follow [Documentation Standards](_standards/documentation-standards.md)
2. Use YAML frontmatter for metadata
3. Include Mermaid diagrams where appropriate
4. Add cross-references to related docs
5. Update last modified date

---

## 📄 License

[License Information]

---

## 📞 Contact

**Project Lead**: [Name]  
**Technical Lead**: [Name]  
**Documentation**: This repository  

---

**Last Updated**: 2026-01-20  
**Documentation Version**: 1.0.0  
**Project Status**: In Development
