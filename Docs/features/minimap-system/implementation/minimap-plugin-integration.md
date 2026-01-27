---
title: "Minimap Plugin Integration Guide"
version: "1.0.0"
status: "Development"
created: "2025-11-09"
updated: "2026-01-26"
author: "UI/UX Team"
phase: "Implementation"
source_of_truth: "PrototypeRacing/Plugins/Minimap/Source/"
last_synced_with_source: "2026-01-26"
related_docs:
  - "Docs/features/minimap-system/design/TDD_MinimapSystem.md"
  - "PrototypeRacing/Plugins/Minimap/README.md"
tags: ["implementation", "minimap", "plugin", "integration"]
---

# Minimap Plugin Integration Guide

## 1. Plugin Overview

**Plugin Name**: Minimap Plugin  
**Author**: Radoshaka  
**Location**: `PrototypeRacing/Plugins/Minimap/`  
**Version**: 1.0 (bundled with project)  
**License**: Free

**Key Features** (từ Plugin README):
- Dynamic minimap với rotation và zoom
- Actor following (center of minimap)
- Markers/icons với hide/show
- Multi-segment line drawing (path)
- World map capture tool
- Fog of war support (optional)

---

## 2. Plugin Architecture

### Core Classes (từ Source Code)

| Class | File | Purpose |
|-------|------|---------|
| `UMinimapSubsystem` | `MinimapSubsystem.h` | Central management (UTickableWorldSubsystem) |
| `IMinimapEntityInterface` | `MinimapEntityInterface.h` | Interface cho entities trên minimap |
| `UMinimapDefaultWidget` | `MinimapDefaultWidget.h` | Default icon widget |
| `UMinimapSetting` | `MinimapSetting.h` | Developer settings |
| `AMinimapDrawer` | `MinimapDrawer.h` | Capture tool actor |

---

## 3. Setup & Configuration

### Step 1: Enable Plugin

1. Open Unreal Editor
2. Navigate to **Edit → Plugins**
3. Search for "Minimap"
4. Ensure **Minimap Plugin** is enabled
5. Restart editor if prompted

---

### Step 2: Configure Project Settings

**Location**: Project Settings → Plugins → Minimap

```cpp
// UMinimapSetting (Developer Settings)
DefaultZoomScale = 0.25f;           // Initial zoom level
ZoomLimitLowerBound = 0.1f;         // Min zoom
ZoomLimitUpperBound = 1.0f;         // Max zoom
DefaultPathColor = FLinearColor::White;
DefaultPathThickness = 1.0f;
```

---

### Step 3: Capture World Map Texture

**Tool**: `BP_MinimapDrawerAssistant`

**Steps**:

1. **Add Capture Actor to Level**:
   ```
   Content Browser → Plugins/Minimap Content/Blueprints/
   → Drag BP_MinimapDrawerAssistant into level
   ```

2. **Position Capture Area**:
   - Select `BP_MinimapDrawerAssistant` in viewport
   - Adjust position to center over track
   - Adjust scale to cover entire track area
   - **Note**: Use uniform scale only (X=Y=Z)

3. **Capture Minimap Texture**:
   - Select `BP_MinimapDrawerAssistant` in World Outliner
   - In Details panel, find **Minimap** category
   - Click **Capture** button
   - Output saved to: `Saved/Minimap/CaptureImage.jpg`

4. **Edit Captured Image** (Optional):
   - Open `CaptureImage.jpg` in image editor
   - Enhance contrast, add track markings
   - Save edited version

5. **Import to Project**:
   - Import edited image as Texture2D
   - Assign to `BP_MinimapDrawerAssistant` → Minimap Texture slot

---

### Step 4: Add Minimap Widget to HUD

**Widget**: `WBP_Minimap` (from plugin Content)

1. Open HUD Widget Blueprint
2. Add `WBP_Minimap` widget
3. Position: Top-right corner (150×150 dp)

---

### Step 5: Initialize Minimap System

**Get Subsystem** (C++):
```cpp
// UMinimapSubsystem là UTickableWorldSubsystem
UMinimapSubsystem* MinimapSubsystem = GetWorld()->GetSubsystem<UMinimapSubsystem>();
```

**Register World Data**:
```cpp
// Register map bounds và texture
MinimapSubsystem->RegisterGameWorldData(
    MapCenterLocation,      // FVector - center of map in world space
    GameWorldSize,          // FVector2D - size of map
    InitOrientation,        // float - initial orientation
    MinimapTexture          // UTexture2D* - minimap texture
);
```

**Set Look Actor** (Follow Player):
```cpp
// Set player vehicle as center of minimap
APawn* PlayerPawn = GetWorld()->GetFirstPlayerController()->GetPawn();
MinimapSubsystem->SetLookActor(PlayerPawn);
```

**Blueprint Alternative**:
```
Event BeginPlay
    ↓
Get World → Get Subsystem (MinimapSubsystem)
    ↓
Register Game World Data
    - Center Location: (0, 0, 0)
    - World Size: (10000, 10000)
    - Orientation: 0
    - Texture: T_MinimapTexture
    ↓
Set Look Actor: Player Pawn
```

---

## 4. Entity Registration

### Implement IMinimapEntityInterface

```cpp
// MyVehicle.h
#include "MinimapEntityInterface.h"

UCLASS()
class AMyVehicle : public APawn, public IMinimapEntityInterface
{
    GENERATED_BODY()

public:
    // IMinimapEntityInterface implementation
    virtual UTexture2D* GetIcon_Implementation() override
    {
        return VehicleIcon;
    }

    virtual FVector GetWorldLocation_Implementation() override
    {
        return GetActorLocation();
    }

    virtual float GetIconSize_Implementation() override
    {
        return 32.0f;
    }

private:
    UPROPERTY(EditDefaultsOnly)
    UTexture2D* VehicleIcon;
};
```

### Register Entity (Simple Icon)

```cpp
// BeginPlay
void AMyVehicle::BeginPlay()
{
    Super::BeginPlay();

    UMinimapSubsystem* MinimapSubsystem = GetWorld()->GetSubsystem<UMinimapSubsystem>();
    if (MinimapSubsystem)
    {
        // Register với simple icon
        MinimapSubsystem->RegisterMinimapEntitySimple(this, VehicleIcon);
    }
}

// EndPlay - QUAN TRỌNG: Phải unregister!
void AMyVehicle::EndPlay(const EEndPlayReason::Type EndPlayReason)
{
    UMinimapSubsystem* MinimapSubsystem = GetWorld()->GetSubsystem<UMinimapSubsystem>();
    if (MinimapSubsystem)
    {
        MinimapSubsystem->UnregisterMinimapEntity(this);
    }

    Super::EndPlay(EndPlayReason);
}
```

### Register Entity (Custom Widget)

```cpp
// Cho complex behavior (glow, aura, color change...)
UUserWidget* CustomWidget = CreateWidget<UUserWidget>(GetWorld(), CustomWidgetClass);
MinimapSubsystem->RegisterMinimapEntity(this, CustomWidget);
```

### Get Widget of Entity

```cpp
UUserWidget* Widget = MinimapSubsystem->GetWidgetOfThisEntity(TargetObject);
```

---

## 5. Zoom & Rotation Control

### Zoom

```cpp
// Set zoom directly (0.0 - 1.0)
MinimapSubsystem->SetMinimapZoom(0.5f);

// Incremental zoom (for scroll wheel)
MinimapSubsystem->UpdateZoomValue(0.05f);  // Zoom in
MinimapSubsystem->UpdateZoomValue(-0.05f); // Zoom out

// Update zoom limits
MinimapSubsystem->UpdateZoomLimit(0.2f, 0.8f);

// Read current zoom
float CurrentZoom = MinimapSubsystem->CurrentZoomValue;
```

### Rotation

```cpp
// Set rotation directly (degrees)
MinimapSubsystem->SetMinimapRotation(45.0f);

// Incremental rotation
MinimapSubsystem->RotateMinimap(20.0f);

// Read current rotation
float CurrentRotation = MinimapSubsystem->CurrentRotation;
```

---

## 6. Path Drawing

```cpp
// Draw path on minimap
TArray<FVector> PathPoints;
PathPoints.Add(FVector(0, 0, 0));
PathPoints.Add(FVector(1000, 500, 0));
PathPoints.Add(FVector(2000, 0, 0));

MinimapSubsystem->DrawPath(PathPoints);

// Customize path appearance
MinimapSubsystem->SetPathColor(FLinearColor::Yellow);
MinimapSubsystem->SetPathThickness(3.0f);

// Clear path
MinimapSubsystem->ClearPath();
```

---

## 7. Manual Center Control

```cpp
// Khi không có look actor, update center manually
MinimapSubsystem->ClearLookActor();
MinimapSubsystem->UpdateCenterLocation(FVector(5000, 5000, 0));
```

---

## 8. Get World Position from Minimap

```cpp
// Trong WBP_Minimap widget OnClick event
void UMyMinimapWidget::OnMinimapClicked(FVector2D ScreenPosition)
{
    UMinimapSubsystem* MinimapSubsystem = GetWorld()->GetSubsystem<UMinimapSubsystem>();
    if (MinimapSubsystem)
    {
        FVector WorldPosition = MinimapSubsystem->GetWorldPointFromMinimap(ScreenPosition);
        // Use WorldPosition for waypoint, ping, etc.
    }
}
```

---

## 9. Event Delegates

```cpp
// Subscribe to events
MinimapSubsystem->OnEntityAdded.AddDynamic(this, &AMyClass::OnEntityAdded);
MinimapSubsystem->OnEntityRemoved.AddDynamic(this, &AMyClass::OnEntityRemoved);
MinimapSubsystem->OnEntityMove.AddDynamic(this, &AMyClass::OnEntityMove);
MinimapSubsystem->OnZoomValueChange.AddDynamic(this, &AMyClass::OnZoomChanged);
MinimapSubsystem->OnRotationChange.AddDynamic(this, &AMyClass::OnRotationChanged);
MinimapSubsystem->OnPathPointsChange.AddDynamic(this, &AMyClass::OnPathChanged);
MinimapSubsystem->OnPathColorChange.AddDynamic(this, &AMyClass::OnPathColorChanged);
MinimapSubsystem->OnPathThicknessChange.AddDynamic(this, &AMyClass::OnPathThicknessChanged);
MinimapSubsystem->OnMinimapManualWorldCenterUpdate.AddDynamic(this, &AMyClass::OnManualCenterUpdate);
MinimapSubsystem->OnMinimapGameWorldDataReceived.AddDynamic(this, &AMyClass::OnWorldDataReceived);
MinimapSubsystem->OnRequestToFindWorldPosition.AddDynamic(this, &AMyClass::OnRequestWorldPosition);

// Callback signatures
void OnEntityAdded(UObject* TargetAdded);
void OnEntityRemoved(UObject* TargetRemoved);
void OnEntityMove(UObject* Entity, FVector NewLocation);
void OnZoomChanged();
void OnRotationChanged();
void OnPathChanged();
void OnPathColorChanged(FLinearColor NewColor);
void OnPathThicknessChanged(float NewThickness);
void OnManualCenterUpdate(FVector NewCenter);
void OnWorldDataReceived();
void OnRequestWorldPosition(FVector WorldPosition);
```

---

## 10. Fog of War (Optional)

Từ Plugin README:
1. Add `WBP_Minimap` widget có default RenderTarget "Fog Of War Map"
2. Replace với custom RenderTarget:
   - ClearColor: White
   - AddressX/Y: Clamp
   - RenderTargetFormat: RTF R8
3. Red/White = visible, Black = invisible
4. Manipulate RenderTarget từ Fog of War system riêng

---

## 11. Troubleshooting

### Issue: Minimap not showing

**Causes**:
1. Minimap texture not assigned
2. `WBP_Minimap` not added to HUD
3. `RegisterGameWorldData()` not called

**Solution**:
- Check BP_MinimapDrawerAssistant has valid texture
- Verify WBP_Minimap exists in HUD hierarchy
- Call `RegisterGameWorldData()` on BeginPlay

---

### Issue: Player icon not centered

**Causes**:
1. `SetLookActor()` not called

**Solution**:
```cpp
MinimapSubsystem->SetLookActor(PlayerPawn);
```

---

### Issue: Entity icons not showing

**Causes**:
1. Entity not implementing `IMinimapEntityInterface`
2. `RegisterMinimapEntitySimple()` not called
3. Entity destroyed without `UnregisterMinimapEntity()`

**Solution**:
- Implement interface với `GetIcon()`, `GetWorldLocation()`, `GetIconSize()`
- Call register on BeginPlay, unregister on EndPlay

---

## 12. Testing Checklist

- [ ] Minimap displays correct track layout
- [ ] Player icon centered và follows player
- [ ] Entity icons register/unregister correctly
- [ ] Zoom in/out works smoothly
- [ ] Rotation works correctly
- [ ] Path drawing works
- [ ] No memory leaks (entities unregistered)
- [ ] Performance: <0.5ms render cost

---

## 13. Related Documents

- **TDD**: `Docs/features/minimap-system/design/TDD_MinimapSystem.md`
- **Plugin README**: `PrototypeRacing/Plugins/Minimap/README.md`
- **Requirements**: `Docs/features/minimap-system/requirements/minimap-overview.md`

---

**Document Status**: Development - Synced with source code
**Last Updated**: 2026-01-26
**Last synced with source code**: 2026-01-26
