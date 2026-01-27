---
title: "Minimap System - Requirements Overview"
version: "1.1.0"
status: "Production"
created: "2025-11-09"
updated: "2025-11-09"
author: "UI/UX Team"
phase: "Requirements"
related_docs:
  - "Docs/features/minimap-system/design/minimap-architecture.md"
  - "Docs/features/minimap-system/implementation/minimap-plugin-integration.md"
  - "PrototypeRacing/Plugins/Minimap/README.md"
tags: ["requirements", "minimap", "navigation", "ui", "plugin"]
---

# Minimap System - Requirements Overview

## Executive Summary

**Problem Statement**: Players need real-time navigation and situational awareness during races to understand track layout, their position relative to opponents, and upcoming track features. Without a minimap, players struggle with spatial orientation, especially on complex tracks with multiple turns and elevation changes.

**Solution Overview**: Integrate the **Minimap Plugin by Radoshaka** to provide a dynamic, rotatable minimap that displays the track layout, player position (centered), opponent positions, and points of interest. The minimap must maintain 60 FPS on high-end mobile devices and provide accurate position tracking within ±2m error margin.

**Success Criteria**:
- Minimap displays correct track layout for all VN-Tour tracks
- Player icon centered and rotates with vehicle direction
- Opponent icons update positions in real-time (within 200m visibility)
- Zoom in/out functionality works smoothly (0.2x - 1.0x range)
- Performance: <0.5ms render cost per frame, <5 MB memory usage

---

## 1. Core Requirements (EARS Format)

### REQ-MAP-001: Dynamic Minimap Display
**WHEN** the player is in an active race **THE SYSTEM SHALL** display a dynamic minimap widget in the top-right corner of the HUD showing the track layout, player position (centered), and opponent positions within 200m radius.

**Acceptance Criteria**:
- Minimap widget visible at all times during race
- Track layout matches actual track geometry
- Player icon always centered in minimap
- Minimap size: 150×150 dp (landscape mode)
- Position: Top-right corner with 16dp padding

---

### REQ-MAP-002: Player Position Tracking
**WHEN** the player vehicle moves **THE SYSTEM SHALL** update the player icon position on the minimap in real-time with rotation matching the vehicle's forward direction.

**Acceptance Criteria**:
- Player icon updates every frame (60 FPS)
- Position accuracy: ±2m error margin
- Rotation accuracy: ±5° error margin
- Smooth interpolation (no jittering)
- Icon color: Blue (distinguishable from opponents)

---

### REQ-MAP-003: Opponent Position Tracking
**WHEN** opponent vehicles are within 200m of the player **THE SYSTEM SHALL** display opponent icons on the minimap with accurate positions and rotations.

**Acceptance Criteria**:
- Opponent icons visible only within 200m radius
- Position updates every 2 frames (30 FPS) for performance
- Icon color: Red (enemy), Yellow (NPC)
- Distance-based culling (hide opponents >200m)
- Maximum 8 opponent icons displayed simultaneously

---

### REQ-MAP-004: Zoom Control
**WHEN** the player adjusts the minimap zoom **THE SYSTEM SHALL** smoothly zoom in/out within the configured range (0.2x - 1.0x) while maintaining centered player position.

**Acceptance Criteria**:
- Zoom range: 0.2x (zoomed out) to 1.0x (zoomed in)
- Default zoom: 0.4x
- Smooth zoom transitions (0.2s duration)
- Zoom controls: Pinch gesture (mobile), Mouse wheel (PC)
- Zoom level persists across races (saved in settings)

---

### REQ-MAP-005: Rotation Mode
**WHEN** the minimap rotation mode is set to "Follow Player" **THE SYSTEM SHALL** rotate the minimap to match the player's forward direction (player icon always pointing up).

**WHEN** the minimap rotation mode is set to "North-Up" **THE SYSTEM SHALL** keep the minimap oriented with north at the top (player icon rotates).

**Acceptance Criteria**:
- Two rotation modes: Follow Player (default), North-Up
- Smooth rotation transitions (no sudden jumps)
- Rotation mode configurable in settings
- Mode persists across races

---

### REQ-MAP-006: Track Capture & Texture
**WHEN** a new track is added to the game **THE SYSTEM SHALL** provide a tool to capture the track layout as a minimap texture using BP_MinimapDrawerAssistant.

**Acceptance Criteria**:
- Capture tool available in editor (BP_MinimapDrawerAssistant)
- Output format: JPG image (Saved/Minimap/CaptureImage.jpg)
- Adjustable capture area (position, rotation, scale)
- Captured texture imported as UTexture2D
- Texture resolution: 1024×1024 (optimized for mobile)

---

### REQ-MAP-007: Points of Interest
**WHEN** the track contains points of interest (checkpoints, power-ups, shortcuts) **THE SYSTEM SHALL** display custom icons on the minimap at their world positions.

**Acceptance Criteria**:
- Support for custom POI icons (checkpoints, power-ups, shortcuts)
- POI icons visible at all zoom levels
- POI registration via IMinimapEntityInterface
- Maximum 20 POI icons per track
- POI icons do not overlap (automatic spacing)

---

## 2. Non-Functional Requirements

### NFR-001: Performance
- **Frame Rate**: Minimap rendering <0.5ms per frame
- **Memory Usage**: <5 MB (texture + widgets + object data)
- **Update Frequency**: Player 60 FPS, Opponents 30 FPS
- **CPU Usage**: <2% of total frame time

### NFR-002: Mobile Optimization
- **Texture Compression**: BC1 compression for minimap texture
- **Widget Pooling**: Opponent icons pooled (max 8 instances)
- **Distance-Based Updates**: Opponents >200m not updated
- **Lazy Loading**: Minimap texture loaded on race start, unloaded on race end

### NFR-003: Accuracy
- **Position Error**: ±2m maximum error
- **Rotation Error**: ±5° maximum error
- **Update Latency**: <16ms (1 frame at 60 FPS)

### NFR-004: Usability
- **Visibility**: Minimap readable at 720p resolution
- **Contrast**: High contrast between track, player, opponents
- **Icon Size**: Minimum 24×24 dp for touch targets
- **Opacity**: Configurable opacity (50%-100%)

---

## 3. Constraints & Assumptions

### Technical Constraints
1. **Plugin Dependency**: Must use Minimap Plugin by Radoshaka (third-party)
2. **UMG Framework**: Minimap widget built with Unreal Motion Graphics
3. **Mobile Rendering**: Limited to 1024×1024 texture resolution
4. **Object Limit**: Maximum 8 opponent icons + 20 POI icons

### Business Constraints
1. **Plugin License**: Minimap Plugin is free (no licensing cost)
2. **Maintenance**: Plugin maintained by third-party (Radoshaka)
3. **Customization**: Limited to plugin's exposed API

### Assumptions
1. All VN-Tour tracks have minimap textures captured
2. Plugin supports UE 5.4+ (current project version)
3. Players understand minimap conventions (blue = player, red = enemy)
4. Minimap is always visible during races (no toggle option)

---

## 4. Dependencies

### Internal Dependencies
- **UI/UX System**: Parent HUD widget (UPrototypeRacingUI)
- **Racing Car Physics**: Player vehicle position and rotation
- **Race Modes**: Opponent vehicle positions
- **Setting System**: Minimap settings (zoom, rotation mode, opacity)

### External Dependencies
- **Minimap Plugin**: Core minimap functionality (by Radoshaka)
- **Unreal Motion Graphics (UMG)**: Widget framework
- **Enhanced Input**: Zoom controls (pinch gesture, mouse wheel)

---

## 5. User Stories

### US-001: Player Navigation
**As a** player  
**I want to** see a minimap showing the track layout and my position  
**So that** I can navigate the track and plan my racing line

**Acceptance Criteria**:
- Minimap visible in top-right corner during race
- Track layout clearly visible
- Player icon centered and rotates with vehicle

---

### US-002: Opponent Awareness
**As a** player  
**I want to** see opponent positions on the minimap  
**So that** I can anticipate overtaking opportunities and defend my position

**Acceptance Criteria**:
- Opponent icons visible within 200m
- Red icons for enemies, yellow for NPCs
- Icons update in real-time

---

### US-003: Zoom Adjustment
**As a** player  
**I want to** zoom in/out on the minimap  
**So that** I can see more detail or get a broader view of the track

**Acceptance Criteria**:
- Pinch gesture zooms in/out (mobile)
- Mouse wheel zooms in/out (PC)
- Zoom range: 0.2x - 1.0x
- Smooth zoom transitions

---

### US-004: Rotation Mode Selection
**As a** player  
**I want to** choose between "Follow Player" and "North-Up" rotation modes  
**So that** I can use the minimap orientation that suits my preference

**Acceptance Criteria**:
- Setting available in Settings menu
- "Follow Player" mode: Minimap rotates with player
- "North-Up" mode: Minimap fixed, player icon rotates
- Setting persists across races

---

## 6. Open Questions

1. **Q**: Should the minimap support fog of war (unexplored areas hidden)?  
   **A**: Deferred to future version (not MVP requirement)

2. **Q**: Should the minimap show track elevation (3D terrain)?  
   **A**: No, 2D top-down view only (performance constraint)

3. **Q**: Should the minimap show race checkpoints?  
   **A**: Yes, as points of interest (REQ-MAP-007)

4. **Q**: Should the minimap be toggleable (show/hide)?  
   **A**: No, always visible during races (usability decision)

---

## 7. Success Metrics

### Functional Metrics
- ✅ Minimap displays on all VN-Tour tracks (5 cities, 15+ tracks)
- ✅ Position accuracy: ±2m error margin
- ✅ Rotation accuracy: ±5° error margin
- ✅ Opponent tracking: 8 opponents within 200m

### Performance Metrics
- ✅ Render cost: <0.5ms per frame
- ✅ Memory usage: <5 MB
- ✅ Frame rate: 60 FPS (high-end), 30 FPS (mid-range)

### Usability Metrics
- ✅ Minimap readable at 720p resolution
- ✅ Player icon distinguishable from opponents
- ✅ Zoom controls responsive (<100ms latency)

---

## 8. Related Documents

- **Design**: `Docs/features/minimap-system/design/minimap-architecture.md`
- **Planning**: `Docs/features/minimap-system/planning/minimap-implementation-plan.md`
- **Implementation**: `Docs/features/minimap-system/implementation/minimap-plugin-integration.md`
- **Plugin README**: `PrototypeRacing/Plugins/Minimap/README.md`

---

**Document Status**: Production - Implemented and deployed  
**Next Steps**: Monitor performance metrics and user feedback for future improvements

