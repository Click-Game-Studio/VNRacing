# VNRacing - Documentation

[![Unreal Engine](https://img.shields.io/badge/Unreal%20Engine-5.4+-blue.svg)](https://www.unrealengine.com/)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green.svg)]()
[![Status](https://img.shields.io/badge/Status-In%20Development-yellow.svg)]()
[![Documentation](https://img.shields.io/badge/Docs-v1.1.0-brightgreen.svg)](./Docs/)

> 📚 Comprehensive documentation for VNRacing - A mobile racing game featuring Vietnamese cultural integration

---

## 🎮 About VNRacing

VNRacing is a mobile-first racing game built with **Unreal Engine 5.4+** featuring:

- 🇻🇳 **VN-Tour Campaign**: Race through 5 iconic Vietnamese cities (Hà Nội, TP.HCM, Đà Nẵng, Huế, Hội An)
- 🏎️ **Mobile-Optimized Physics**: Custom SimpleCarPhysics plugin for 60 FPS performance
- 🎨 **Car Customization**: Visual and performance modifications with RTune integration
- 🏆 **Progression System**: XP, achievements, and city-based campaign unlocks
- 👥 **Multiplayer**: Nakama matchmaking + Edgegap dedicated servers
- 📱 **Cross-Platform**: Android (API 26+) and iOS (13+)

---

## 📖 Documentation Structure

This repository contains the complete technical documentation for VNRacing:

```
Docs/
├── _architecture/       # System architecture, technology stack, data flow
├── _standards/          # Code standards, naming conventions, asset organization
├── _cross-reference/    # Feature dependencies, API integration, data structures
├── _templates/          # Documentation templates for 5-phase development
└── features/            # 12 feature-specific documentation folders
    ├── car-physics/
    ├── car-customization/
    ├── progression-system/
    ├── profiles-inventory/
    ├── setting-system/
    ├── shop-system/
    ├── race-modes/
    ├── multiplayer/
    ├── minimap-system/
    ├── racer-ai/
    ├── tutorials/
    └── ui-ux/               # UI/UX Design System
        ├── requirements/
        ├── design/
        └── implementation/
```

---

## 🚀 Quick Start

### For Developers
1. **Read the main documentation**: [Docs/README.md](./Docs/README.md)
2. **Review architecture**: [Docs/_architecture/](./Docs/_architecture/)
3. **Check coding standards**: [Docs/_standards/](./Docs/_standards/)
4. **Explore features**: [Docs/features/](./Docs/features/)

### For Designers
1. **Feature requirements**: Each feature has a `requirements/` folder
2. **Design documents**: Each feature has a `design/` folder
3. **Asset organization**: [Docs/_standards/asset-organization.md](./Docs/_standards/asset-organization.md)

### For Project Managers
1. **Project overview**: [Docs/README.md](./Docs/README.md)
2. **Feature status**: Check each feature's README.md
3. **Planning documents**: Each feature has a `planning/` folder

---

## 📊 Documentation Statistics

- **Total Files**: 190+ markdown files
- **Foundation Docs**: 20 files (standards, architecture, cross-reference, templates)
- **Feature Docs**: 170+ files across 12 features
- **Version**: 1.0.0
- **Last Updated**: 2026-01-20

---

## 🎯 Feature Status

| Feature | Status | Description |
|---------|--------|-------------|
| Car Physics | 🔄 Development | SimpleCarPhysics integration, drift mechanics, NOS boost |
| Car Customization | 🔄 Development | Visual & performance customization, RTune integration |
| Progression System | 🔄 Development | VN-Tour campaign, XP system, achievements |
| Profiles & Inventory | 🔄 Development | Player profiles, stats, currency, inventory |
| Setting System | 🔄 Development | Game settings, graphics profiles, controls |
| Shop System | 🔄 Development | In-game shop, IAP integration |
| Race Modes | 🔄 Development | Time Attack, Circuit, Sprint, Elimination |
| Multiplayer | ⏸️ Pending | Nakama matchmaking, Edgegap servers |
| Minimap System | 🔄 Development | Real-time minimap, entity tracking |
| Racer AI | 🔄 Development | AI opponents, difficulty scaling |
| Tutorials | 🔄 Development | Interactive tutorials, tooltips |
| UI/UX | 📋 Planning | UI/UX Design System |

---

## 🛠️ Technology Stack

- **Engine**: Unreal Engine 5.4+
- **Languages**: C++17, Blueprint
- **Key Plugins**: SimpleCarPhysics, Nakama, Edgegap, Minimap, RTune, Rive
- **Platforms**: Android (API 26+), iOS (13+)
- **Backend**: Nakama Cloud, Edgegap dedicated servers

---

## 📝 Documentation Standards

All documentation follows a **5-phase development lifecycle** (with optional 6th phase):

1. **Requirements** - User stories, acceptance criteria
2. **Design** - Architecture, data models, technical specs
3. **Planning** - Task breakdown, milestones, estimates
4. **Implementation** - Code patterns, integration guides
5. **Testing** - Test strategies, validation procedures
6. **Deployment** *(optional)* - Feature-specific deployment guides

Each phase document includes:
- YAML frontmatter with metadata
- Consistent formatting and structure
- Mermaid diagrams for visualization
- Cross-references to related documents
- Source code synchronization

---

## 🎨 Vietnamese Cultural Integration

VNRacing celebrates Vietnamese culture through:

- **VN-Tour Campaign**: Race through iconic Vietnamese cities
- **Cultural Themes**: Traditional patterns, landmarks, lanterns
- **Local Landmarks**: Cầu Rồng (Đà Nẵng), Hội An Ancient Town, etc.
- **Authentic Atmosphere**: Vietnamese-inspired UI, music, and visuals

---

## 📈 Performance Targets

- **Frame Rate**: 60 FPS on high-end mobile, 30 FPS on low-end
- **Memory**: <2 GB budget
- **Network**: <100ms latency for multiplayer
- **Loading**: <5s level load times

---

## 📞 Contact

- **Organization**: Click Game Studio
- **Repository**: [VNRacing Documentation](https://github.com/Click-Game-Studio/VNRacing)
- **Documentation Version**: 1.0.0

---

## 📄 License

Proprietary - All Rights Reserved © Click Game Studio

---

## 🔄 Changelog

See [CHANGELOG.md](./Docs/CHANGELOG.md) for detailed version history.

---

**Last Updated**: 2026-01-20  
**Documentation Version**: 1.0.0  
**Maintained By**: Click Game Studio Development Team
