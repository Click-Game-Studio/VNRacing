---
phase: overview
title: Car Physics Feature
description: Mobile-optimized vehicle physics system for VNRacing
feature_id: car-physics
status: development
priority: critical
owner: Physics Team
last_updated: 2026-01-20
---

# Car Physics Feature

**Breadcrumbs:** [Docs](../../../) > [Features](../) > Car Physics

**Feature ID**: `car-physics`  
**Status**: 🔄 Development  
**Priority**: Critical  
**Owner**: Physics Team  
**Version**: 1.0.0  
**Date**: 2026-01-20

---

## Overview

Hệ thống Car Physics cung cấp vật lý xe đua arcade-style được tối ưu cho mobile, sử dụng plugin **SimpleCarPhysics** thay thế Chaos Vehicle của Unreal Engine. Hệ thống đạt 60 FPS trên thiết bị mobile tầm trung với cảm giác lái xe chân thực.

### Key Capabilities

- **Vehicle Dynamics**: Tăng tốc, phanh, lái, hệ thống treo, độ bám đường
- **Mobile-Optimized Physics**: Tính toán nhẹ, cập nhật theo khoảng cách
- **Incline Camera System**: Camera theo dõi động với FOV và vị trí thay đổi theo địa hình
- **Collision Detection**: Va chạm môi trường, va chạm xe-xe
- **Airborne Mechanics**: Vật lý nhảy ramp và điều khiển trên không (⏸️ tạm ngưng)
- **Drift System**: Hệ thống drift với tích điểm và hiệu ứng
- **Nitro Boost**: Hệ thống tăng tốc nitro

---

## Feature Structure

```
car-physics/
├── requirements/       # User stories, acceptance criteria
├── design/            # Architecture, camera, collision, ramp designs
├── planning/          # Master plan, task breakdown, timeline
├── implementation/    # Implementation guide, code examples
├── testing/           # Testing strategy, test cases, validation
└── monitoring/        # Performance metrics, telemetry, analytics
```

---

## Core Components (Verified from Source Code)

### 1. ASimulatePhysicsCar (Main Actor)
**Location**: `Plugins/SimpleCarPhysics/Source/SimpleCarPhysics/Public/PhysicsSimulateCar/SimulatePhysicsCar.h`

**Key Properties** (verified):
```cpp
// Engine & Transmission
float EngineTorque = 850.f;
float MaxSpeed = 210.f;
float BrakeForce = 15000.f;

// Handling
float ConsiderSlowSpeed = 40;
float ConsiderFastSpeed = 100;
float SlipAngleToConsiderDrifting = 20.0f;
float DriftTorque = 0.f;
float DriftLimitAngle = 89.0f;

// Incline System
FInclineData InclineData;
FInclineAccelerationSettings InclineAccelerationSettings;

// Airborne System
FAirborneState AirborneState;
FAirControlSettings AirControlSettings;
FAntiRollInAir AntiRollInAir;

// Collision Correction
FCollisionCorrectionSettings CollisionCorrectionSettings;
FWallCollisionData WallCollisionData;
```

**Key Data Structures** (verified):
```cpp
// Incline State
UENUM(BlueprintType)
enum class EInclineState : uint8 { Flat, Incline, Decline };

struct FInclineData {
    float InclineAngle;
    EInclineState InclineState;
    float AccelerationMultiplier;
    FVector RoadNormal;
};

struct FInclineAccelerationSettings {
    float UphillMultiplier = 1.3f;
    float DownhillMultiplier = 1.1f;
    float FlatMultiplier = 1.0f;
};

// Airborne State
struct FAirborneState {
    bool bIsAirborne = false;
    float TimeInAir = 0.0f;
    int32 WheelsInAir = 0;
    FVector LaunchVelocity;
    float MaxHeight = 0.0f;
};

// Collision Correction
struct FCollisionCorrectionSettings {
    bool bIsUseImpulse = true;
    float InterpolationSpeed = 2.0f;
    float MaxCorrectionTorque = 2000.0f;
    float AngleReductionFactor = 0.5f;
    float TraceDistance = 500.0f;
    float SmallAngleThreshold = 15.0f;
    float LargeAngleThreshold = 45.0f;
    float OutwardImpulseStrength = 50.0f;
};
```

### 2. AFollowCarCamera
**Location**: `Plugins/SimpleCarPhysics/Source/SimpleCarPhysics/Public/FollowCarCamera.h`

**Key Properties** (verified):
```cpp
struct FInclineCameraSettings {
    float InclineFOVMultiplier = 1.1f;    // +10%
    float DeclineFOVMultiplier = 1.1f;    // +10%
    float InclineZOffset = 50.0f;          // +50cm up
    float InclineXOffset = -30.0f;         // -30cm back
    float DeclineZOffset = 50.0f;
    float DeclineXOffset = -30.0f;
    float InterpolationSpeed = 5.0f;
    float InclineThreshold = 10.0f;        // Degrees
    float DeclineThreshold = -10.0f;
};
```

### 3. ARampZone (⏸️ In Progress)
**Location**: `Source/PrototypeRacing/Public/RampZone.h`

**Implementation** (verified):
```cpp
UCLASS()
class ARampZone : public AActor {
    UPROPERTY(EditAnywhere, Category = "Boost")
    float BoostForce = 50000.0f;
    
    UPROPERTY(VisibleAnywhere, Category = "Collision")
    UBoxComponent* RampTrigger;
    
    // Boost direction follows vehicle velocity + upward component
    FVector CalculateBoostDirection(const FVector& VehicleVelocity);
};
```

### 4. UVehicleFactory
**Location**: `Source/PrototypeRacing/Public/VehicleFactory.h`

**Functions** (verified):
```cpp
static ASimulatePhysicsCarWithCustom* CreateRacingCar(
    UWorld* World, 
    const FVector& Location, 
    const FRotator& Rotation, 
    const FName& CarName, 
    const UDataTable* CarDefinitionTable, 
    const FCarConfiguration& CarConfiguration
);
```

---

## Feature Status by Component

| Component | Status | Completion | Notes |
|-----------|--------|------------|-------|
| Suspension Physics | 🔄 Development | 100% | UCustomSuspensionComponent implemented |
| Incline Camera | 🔄 Development | 100% | FInclineCameraSettings in FollowCarCamera |
| Environment Collision | 🔄 Development | 100% | FCollisionCorrectionSettings implemented |
| Car-to-Car Collision | 🔄 In Progress | 70% | AFakeCarBody exists, needs refinement |
| Ramp & Airborne | ⏸️ In Progress | 100% | ARampZone + FAirborneState implemented, tạm ngưng sử dụng |
| Drift System | 🔄 Development | 100% | Full drift mechanics with scoring |
| Nitro System | 🔄 Development | 100% | BoostNitro() implemented |

---

## Dependencies

### Internal Dependencies
- **Car Customization**: Performance tuning affects physics parameters
- **Progression System**: Unlockable vehicles, performance upgrades
- **Race Modes**: Time Attack, Circuit, Sprint integration
- **Setting System**: Graphics quality affects physics tick rate

### External Dependencies
- **SimpleCarPhysics Plugin** (custom)
- **AsyncTickPhysics Plugin** (custom)
- **Unreal Engine 5.4+**
- **Enhanced Input System**

---

## Performance Targets

| Metric | Target | Current |
|--------|--------|---------|
| Frame Rate | 60 FPS (high-end), 30 FPS (low-end) | ✅ 60 FPS |
| Physics Tick | 60 Hz (player), 30 Hz (AI) | ✅ 60 Hz |
| Memory Usage | <50 MB per vehicle | ✅ 35 MB |
| CPU Time | <2ms per frame | ✅ 1.5ms |

---

## Quick Links

### Requirements
- [Car Physics Overview](requirements/car-physics-overview.md)
- [Suspension Physics](requirements/suspension-physics.md)
- [Incline Camera System](requirements/incline-camera.md)
- [Environment Collision](requirements/environment-collision.md)
- [Car-to-Car Collision](requirements/car-collision.md)
- [Ramp & Airborne](requirements/ramp-airborne.md)

### Design
- [System Architecture](design/car-physics-architecture.md)
- [Incline Camera Design](design/incline-camera-design.md)
- [Environment Collision Design](design/environment-collision-design.md)
- [Car Collision Design](design/car-collision-design.md)
- [Ramp & Airborne Design](design/ramp-airborne-design.md)

### Planning
- [Master Plan](planning/car-physics-master-plan.md)

### Implementation
- [Implementation Guide](implementation/car-physics-implementation-guide.md)

### Testing
- [Testing Strategy](testing/car-physics-testing-strategy.md)

---

## Related Features

- [Car Customization](../car-customization/README.md) - Performance tuning
- [Progression System](../progression-system/README.md) - Vehicle unlocks
- [Race Modes](../race-modes/README.md) - Time Attack, Circuit, Sprint
- [Racer AI](../racer-ai/README.md) - AI vehicle physics
- [Mobile Optimization](../mobile-optimization/README.md) - Performance strategies

---

## References

### Source Code Locations
- **Plugin**: `PrototypeRacing/Plugins/SimpleCarPhysics/`
- **Game Module**: `PrototypeRacing/Source/PrototypeRacing/`
- **Key Classes**:
  - `SimulatePhysicsCar.h` - Main physics car
  - `FollowCarCamera.h` - Camera system
  - `CustomSuspensionComponent.h` - Suspension
  - `RampZone.h` - Ramp mechanics
  - `VehicleFactory.h` - Vehicle spawning

### Architecture
- [System Overview](../../_architecture/system-overview.md)
- [Mobile Optimization Architecture](../../_architecture/mobile-optimization.md)

---

**Last Review**: 2025-12-30  
**Next Review**: 2026-01-30  
**Version**: 2.1
