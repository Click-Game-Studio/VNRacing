---
phase: requirements
title: Car Customization Requirements
description: User stories, acceptance criteria, and functional requirements for car customization system
feature_id: car-customization
status: development
last_updated: 2026-01-20
---

# Car Customization Requirements

**Breadcrumbs:** [Docs](../../../../) > [Features](../../../) > [Car Customization](../) > Requirements

**Feature ID**: `car-customization`  
**Status**: 🔄 Development  
**Version**: 1.0.0  
**Date**: 2026-01-20

---

## Overview

Hệ thống Car Customization cho phép người chơi tùy chỉnh xe của họ cả về mặt hình ảnh và hiệu năng, với tích hợp đặc biệt các chủ đề văn hóa Việt Nam thông qua hệ thống tiến độ VN-Tour.

---

## User Stories

### US-CC-001: Visual Customization
**As a** player
**I want to** customize my car's appearance with different parts and colors
**So that** I can create a unique racing machine that reflects my style

**Acceptance Criteria:**
- [ ] Player can change body parts (Front Bumper, Rear Bumper, Side Board, Spoiler, Exhaust, Wheels)
- [ ] Player can change colors (Body, Wheel, Caliper)
- [ ] Changes are displayed in real-time 3D preview
- [ ] Customization persists across game sessions

### US-CC-002: Style Packages
**As a** player
**I want to** apply complete style packages to my car
**So that** I can quickly transform my car's look with a coordinated design

**Acceptance Criteria:**
- [ ] Player can browse available style packages
- [ ] Applying a style changes all included parts at once
- [ ] Player can further customize individual parts after applying a style
- [ ] Style packages show preview before purchase/application

### US-CC-003: Performance Impact
**As a** player
**I want to** see how customization affects my car's performance
**So that** I can make informed decisions about my build

**Acceptance Criteria:**
- [ ] Performance stats (Acceleration, Grip, Speed, Nitrous) are displayed
- [ ] Stats update in real-time when changing parts
- [ ] Visual indicators show stat changes (increase/decrease)
- [ ] Performance changes are reflected in actual gameplay

### US-CC-004: Vietnamese Cultural Integration
**As a** player
**I want to** unlock Vietnamese-themed customization options through VN-Tour
**So that** I can celebrate Vietnamese culture while racing

**Acceptance Criteria:**
- [ ] Vietnamese-themed parts unlock when completing VN-Tour cities
- [ ] Cultural significance is displayed for Vietnamese items
- [ ] Vietnamese color palettes are available (Đỏ, Vàng, Xanh lá, Xanh dương)
- [ ] Cultural decals (Rồng, Sen, Tre) are available

### US-CC-005: Save/Load Configurations
**As a** player
**I want to** save and load my car configurations
**So that** I can switch between different setups easily

**Acceptance Criteria:**
- [ ] Player can save current configuration as a preset
- [ ] Player can load saved presets
- [ ] Presets persist across game sessions
- [ ] Player can delete unwanted presets

---

## Functional Requirements

### FR-CC-001: Part Management
- System shall support 6 visual part slots: Front Bumper, Rear Bumper, Side Board, Spoiler, Exhaust, Wheels
- System shall support 3 color slots: Body, Wheel, Caliper
- Each part shall have associated performance modifiers
- Parts shall be loaded asynchronously to prevent frame drops

### FR-CC-002: Style System
- Style packages shall contain predefined part combinations
- Applying a style shall replace all included parts
- Individual parts can be modified after applying a style
- Style changes reset when applying a new style

### FR-CC-003: Performance Calculation
- Performance shall be calculated as: `FinalStats = BaseStats + Sum(PartModifiers) + CulturalBonus`
- Four main stats: Acceleration, Grip, Speed, Nitrous
- Stats shall be displayed on a 1-5 scale for UI
- Performance changes shall affect actual vehicle physics

### FR-CC-004: Unlock System
- Parts unlock through progression, shop purchases, or VN-Tour completion
- Vietnamese-themed items unlock through VN-Tour city completion
- Unlock status persists in save data
- Locked items are visible but not selectable

### FR-CC-005: Preview System
- 3D preview with 360° rotation
- Zoom in/out capability
- Real-time part and color changes
- Performance stats overlay

---

## Non-Functional Requirements

### NFR-CC-001: Performance
- Preview load time < 1 second
- Material switch < 100ms
- Save time < 500ms
- Memory per vehicle < 20 MB

### NFR-CC-002: Mobile Optimization
- Maintain 30+ FPS during customization
- Use TSoftObjectPtr for asset references
- Implement async loading for all assets
- Compress textures for mobile platforms

### NFR-CC-003: Scalability
- Support 50+ parts per slot
- Support 100+ color options
- Support 20+ style packages
- Support 100+ decals

---

## Dependencies

### Internal Dependencies
- **Progression System**: Unlock customization items through progression
- **Shop System**: Purchase customization items with currency
- **Racing Car Physics**: Performance tuning affects vehicle physics
- **Setting System**: Save/load customization data

### External Dependencies
- Unreal Engine Material System
- Unreal Engine Decal System
- Skeletal Mesh System

---

## References

- [GDD Car Customizations](GDD-Car-Customization.md) - Visual customization spec
- [GDD Car Performance](GDD-Car-Performance.md) - Performance tuning spec
- [TDD Car Customization](../design/TDD_CarCustomization.md) - Technical design
