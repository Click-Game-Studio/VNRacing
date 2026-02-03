# Minimap System Feature

**Version:** 1.1.0 | **Date:** 2026-01-26 | **Status:** Development

![Status: Development](https://img.shields.io/badge/Status-Development-blue)

**Breadcrumbs:** [Docs](../../) > [Features](../) > Minimap System

**Feature ID**: `minimap-system`  
**Priority**: High  
**Owner**: UI/UX Team  
**Source of Truth**: `Plugins/Minimap/Source/`

---

## Overview

Minimap System is a third-party plugin (by Radoshaka) providing dynamic minimap functionality for VNRacing. The plugin is integrated into the project at `PrototypeRacing/Plugins/Minimap/`.

### Key Capabilities

- **Dynamic Minimap**: Real-time track overview with player-centered view
- **Actor Following**: Automatically follow actor as center (`SetLookActor()`)
- **Rotatable & Zoomable**: Rotation and zoom controls
- **Entity Registration**: Register objects with simple icon or custom widget
- **Path Drawing**: Draw multi-segment lines on minimap
- **Fog of War Support**: Optional fog of war integration
- **World Map Capture**: Tool to capture world map texture

---

## Feature Structure

```
minimap-system/
├── requirements/       # User stories, minimap requirements
├── design/            # Technical design, architecture
├── planning/          # Implementation roadmap
├── implementation/    # Integration guides
└── testing/           # Test cases
```

**Plugin Location:** `Plugins/Minimap/`

---

## Quick Links

### Design (Source of Truth)
- [TDD_MinimapSystem.md](design/TDD_MinimapSystem.md) - ⭐ Technical Design Document (synced with source code)

### Requirements
- [Minimap System Overview](requirements/minimap-overview.md) - Feature overview and goals

### Implementation
- [Plugin Integration Guide](implementation/minimap-plugin-integration.md) - Setup and configuration

---

## Core Components

### 1. UMinimapSubsystem

**File**: `Plugins/Minimap/Source/Minimap/Public/MinimapSubsystem.h`  
**Base Class**: `UTickableWorldSubsystem`  
**Purpose**: Central management cho minimap system

**Key Functions**:
```cpp
// === Center/Follow ===
void SetLookActor(const AActor* InTargetActor);
void ClearLookActor();
void UpdateCenterLocation(const FVector TargetLocation);

// === Entity Registration ===
void RegisterMinimapEntity(UObject* TargetObject, UUserWidget* EntryWidget);
void RegisterMinimapEntitySimple(UObject* TargetObject, UTexture2D* Icon);
void UnregisterMinimapEntity(UObject* TargetObject);
UUserWidget* GetWidgetOfThisEntity(UObject* TargetObject);

// === World Data ===
void RegisterGameWorldData(FVector InCenterLocation, FVector2D GameWorldMapSize, 
                           float Orientation, UTexture2D* MinimapTexture);

// === Zoom ===
void SetMinimapZoom(float Value);
void UpdateZoomValue(float IncrementalValue);
void UpdateZoomLimit(float InLowerLimit, float InHigherLimit);

// === Rotation ===
void SetMinimapRotation(float Angle);
void RotateMinimap(float IncrementalAngle);

// === Path Drawing ===
void DrawPath(const TArray<FVector>& WorldPoints);
void ClearPath();
void SetPathColor(FLinearColor Color);
void SetPathThickness(float Thickness);

// === Utility ===
FVector GetWorldPointFromMinimap(FVector2D MinimapPoint);
```

---

### 2. IMinimapEntityInterface

**File**: `Plugins/Minimap/Source/Minimap/Public/MinimapEntityInterface.h`  
**Purpose**: Interface cho objects hiển thị trên minimap

```cpp
class IMinimapEntityInterface
{
public:
    // Get icon texture
    UFUNCTION(BlueprintNativeEvent, BlueprintCallable)
    UTexture2D* GetIcon();

    // Get world location
    UFUNCTION(BlueprintNativeEvent, BlueprintCallable)
    FVector GetWorldLocation();

    // Get icon size
    UFUNCTION(BlueprintNativeEvent, BlueprintCallable)
    float GetIconSize();
};
```

---

### 3. UMinimapSetting

**File**: `Plugins/Minimap/Source/Minimap/Public/MinimapSetting.h`  
**Base Class**: `UDeveloperSettings`  
**Location**: Project Settings → Plugins → Minimap

```cpp
UCLASS(Config=Game, defaultconfig, meta = (DisplayName="Minimap"))
class UMinimapSetting : public UDeveloperSettings
{
    float DefaultZoomScale = 0.25f;      // Default zoom
    float ZoomLimitLowerBound = 0.1f;    // Min zoom
    float ZoomLimitUpperBound = 1.0f;    // Max zoom
    FLinearColor DefaultPathColor = FLinearColor::White;
    float DefaultPathThickness = 1.0f;
};
```

---

### 4. UMinimapDefaultWidget

**File**: `Plugins/Minimap/Source/Minimap/Public/MinimapDefaultWidget.h`  
**Base Class**: `UUserWidget`  
**Purpose**: Default widget cho minimap icons

---

### 5. AMinimapDrawer

**File**: `Plugins/Minimap/Source/Minimap/Public/MinimapDrawer.h`  
**Base Class**: `AActor`  
**Purpose**: Editor tool để capture world map texture

---

## Integration Guide

### Setup World Map

1. Add `BP_MinimapDrawerAssistant` vào level
2. Position white quad để cover track area (uniform scale only)
3. Click "Capture" trong Details panel → Minimap category
4. Output: `Saved/Minimap/CaptureImage.jpg`
5. Edit image nếu cần, import vào project
6. Assign texture vào BP_MinimapDrawerAssistant

### Set Look Actor

```cpp
UMinimapSubsystem* MinimapSubsystem = GetWorld()->GetSubsystem<UMinimapSubsystem>();
if (MinimapSubsystem)
{
    MinimapSubsystem->SetLookActor(PlayerPawn);
}
```

### Register Entity

```cpp
// Entity phải implement IMinimapEntityInterface
MinimapSubsystem->RegisterMinimapEntitySimple(this, VehicleIcon);

// Cleanup
MinimapSubsystem->UnregisterMinimapEntity(this);
```

---

## Configuration

### Project Settings (UMinimapSetting)

| Setting | Default | Description |
|---------|---------|-------------|
| `DefaultZoomScale` | 0.25 | Initial zoom level |
| `ZoomLimitLowerBound` | 0.1 | Minimum zoom |
| `ZoomLimitUpperBound` | 1.0 | Maximum zoom |
| `DefaultPathColor` | White | Default path color |
| `DefaultPathThickness` | 1.0 | Default path thickness (px) |

---

## Performance Targets

| Metric | Target | Current |
|--------|--------|---------|
| **Memory Usage** | <5 MB | ✅ ≈4.5 MB |
| **Render Cost** | <0.5ms/frame | ✅ Optimized |
| **Texture Size** | 1024x1024 | ✅ Mobile-friendly |

---

## Dependencies

### Plugin Dependencies
- **UMG**: Widget framework
- **RenderCore**: Render target capture
- **DeveloperSettings**: Project settings

### Game Dependencies
- **UI/UX System**: Parent HUD widget
- **Racing Car Physics**: Vehicle position data
- **Race Modes**: Opponent tracking

---

## Related Features

- [UI/UX System](../ui-ux-system/README.md) - Parent HUD system
- [Racing Car Physics](../racing-car-physics/README.md) - Vehicle position data
- [Race Modes](../race-modes/README.md) - Opponent tracking

---

## References

- [Plugin README](../../../PrototypeRacing/Plugins/Minimap/README.md) - Original plugin documentation
- [TDD_MinimapSystem.md](design/TDD_MinimapSystem.md) - Technical Design Document

---

**Last Updated:** 2026-01-26

