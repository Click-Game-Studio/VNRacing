---
phase: testing
title: Car Physics - Testing Strategy
description: Comprehensive testing approach for car physics features
feature_id: car-physics
status: development
last_updated: 2026-01-20
---

# Car Physics - Testing Strategy

**Breadcrumbs:** [Docs](../../../../) > [Features](../../../) > [Car Physics](../) > [Testing](./) > Strategy

**Feature ID**: `car-physics`  
**Status**: 🔄 Development  
**Version**: 1.0.0  
**Date**: 2026-01-20

## Test Coverage Goals

- **Unit Tests**: 80%+ coverage for core physics logic
- **Integration Tests**: All interactions between physics features
- **Mobile Performance Tests**: Android/iOS frame rate and battery targets
- **Manual QA**: Gameplay feel validation and user experience

## Feature Status

| Feature | Status | Test Coverage |
|---------|--------|---------------|
| Suspension Physics | ✅ Done | 100% |
| Incline Camera | ✅ Done | 100% |
| Environment Collision | ✅ Done | 100% |
| Car-to-Car Collision | 🔄 In Progress | 70% |
| Ramp & Airborne | ⏸️ Pending | 100% |

## Unit Tests

### Suspension Physics ✅ COMPLETED

- [x] Suspension force calculation accuracy (±5% tolerance)
- [x] Body tilt angle correctness (±2 degrees)
- [x] Wheel compression limits (0-100%)
- [x] Performance: <0.5ms per wheel per frame
- [x] Grounded state detection accuracy

### Incline Camera ✅ COMPLETED

- [x] Incline angle calculation accuracy (±1 degree)
- [x] FOV adjustment applies correctly (+10%)
- [x] Position offset applies correctly (Z +50cm, X -30cm)
- [x] Interpolation smoothness (no jitter, <0.5s transition)
- [x] Acceleration multiplier applies correctly (1.3x uphill, 1.1x downhill)
- [x] Detection update frequency (10 Hz)

**Verified Values** (from `FollowCarCamera.h`):
```cpp
InclineFOVMultiplier = 1.1f;    // +10%
InclineZOffset = 50.0f;          // +50cm
InclineXOffset = -30.0f;         // -30cm
InterpolationSpeed = 5.0f;
InclineThreshold = 10.0f;        // Degrees
```

### Environment Collision ✅ COMPLETED

- [x] Collision angle calculation accuracy
- [x] Angle reduction applies correctly (50% ± 10%)
- [x] Interpolation smoothness (no jerk)
- [x] Wall-stick prevention triggers at small angles (<15°)
- [x] Racing line direction retrieval accuracy
- [x] Severity classification (Small/Medium/Large)

**Verified Values** (from `SimulatePhysicsCar.h`):
```cpp
InterpolationSpeed = 2.0f;
MaxCorrectionTorque = 2000.0f;
AngleReductionFactor = 0.5f;     // 50%
SmallAngleThreshold = 15.0f;
LargeAngleThreshold = 45.0f;
OutwardImpulseStrength = 50.0f;
```

### Car-to-Car Collision 🔄 IN PROGRESS

- [x] CarPriority channel blocks environment (WorldStatic)
- [x] CarPriority ignores WorldDynamic (AI cars)
- [x] Kinematic body syncs position/rotation accurately (<1cm, <1° error)
- [ ] Overlap detection identifies 6 collision cases correctly (>95% accuracy)
- [ ] Visual shake intensity matches collision case
- [ ] Player car pushes AI cars (100% of the time)
- [ ] AI cars cannot push player car (0% of the time)

### Ramp & Airborne ⏸️ PENDING (tạm ngưng)

- [x] Ramp boost achieves 4-6m height (±0.5m tolerance)
- [x] Air steering reduced to 50% (±5%)
- [x] Auto-rotate triggers at >45° roll
- [x] Auto-rotate triggers when upside down (pitch >90°)
- [x] Landing detection accuracy (upright vs tilted)
- [x] Reset triggers on tilted landing
- [x] NOS usable during airborne
- [x] Drift cancels on ramp entry

**Verified Values** (from `SimulatePhysicsCar.h`):
```cpp
// FAirControlSettings
AirSteeringMultiplier = 0.5f;    // 50%
YawStrength = 4.0f;
RollStrength = 4.0f;
PitchStrength = 4.0f;

// FAntiRollInAir
MaxRollAngle = 45.0f;
MaxPitchAngle = 60.0f;
AntiRollPowerInAir = 3000.0;
AntiPitchPowerInAir = 2000.0f;
```

**Verified Values** (from `RampZone.cpp`):
```cpp
BoostForce = 50000.0f;
// Cancels drift on entry
// Triggers OnRampBoost and OnVehicleSkillTriggered events
```

## Integration Tests

### Suspension + Incline Camera ✅
- [x] Camera responds to suspension body tilt
- [x] Smooth integration during turns
- [x] No conflicting interpolations

### Incline Camera + Environment Collision ✅
- [x] Camera adjusts on incline while handling wall collision
- [x] No conflicting interpolations
- [x] Smooth transitions between states

### Environment Collision + Car Collision 🔄
- [ ] Player car auto-corrects to racing line while pushing AI cars
- [ ] Collision priorities work correctly
- [ ] No physics conflicts

### Car Collision + Ramp & Airborne ⏸️
- [ ] Kinematic body doesn't interfere with airborne physics
- [ ] Collision detection disabled during airborne
- [ ] Re-enabled on landing

### Ramp + Nitro ⏸️
- [x] NOS can be activated during airborne
- [x] Force applies correctly in air
- [x] Camera effects stack appropriately

### Ramp + Drift ⏸️
- [x] Drift cancels on ramp entry
- [x] Drift re-enabled on landing
- [x] No state conflicts

## Mobile Performance Tests

### Android Targets

**Frame Rate**:
- Minimum: 30 FPS ✅
- Target: 60 FPS ✅
- Test Devices: Samsung Galaxy S21, Google Pixel 6, Xiaomi Redmi Note 10

**Memory**:
- Total Usage: <2GB ✅
- Texture Memory: <800MB
- Mesh Memory: <400MB

**Battery**:
- Drain Rate: <10% per 10 minutes gameplay
- Thermal: No throttling within 20 minutes

### iOS Targets

**Frame Rate**:
- Target: 60 FPS ✅
- Test Devices: iPhone 13 Pro, iPhone 12, iPhone SE 2022

**Memory**:
- Total Usage: <1.5GB ✅
- Texture Memory: <600MB
- Mesh Memory: <300MB

### Performance Test Cases

- [x] Suspension update: <0.5ms per wheel per frame
- [x] Camera update: <0.2ms per frame (Android), <0.1ms (iOS)
- [x] Collision detection: <1ms per frame (Android), <0.5ms (iOS)
- [x] Incline detection: <0.05ms per update (10 Hz)
- [x] Fake body sync: <0.01ms per frame
- [x] Air control: <0.1ms per frame (when airborne)

## Manual Testing Checklist

### Incline Camera Feel ✅
- [x] Incline camera feels natural (not jarring)
- [x] FOV boost enhances sense of speed
- [x] Return to normal is smooth
- [x] No motion sickness reported
- [x] Works on all track types (various slopes)

### Environment Collision Feel ✅
- [x] Auto-correction feels helpful (not intrusive)
- [x] Reduced angle (50%) feels better than current
- [x] No wall-stick frustration
- [x] Racing line guidance is clear
- [x] Smooth recovery from wall hits

### Car-to-Car Collision Feel 🔄
- [ ] Player feels powerful (can push AI cars)
- [ ] AI cars provide resistance (not weightless)
- [ ] Visual shake communicates impact
- [ ] No unfair AI advantage
- [ ] Different shake effects distinguishable

### Ramp Feel ⏸️ (tạm ngưng)
- [x] Ramp boost feels exciting
- [x] Air control feels responsive but limited
- [x] Auto-rotate saves from frustration
- [x] Landing feels satisfying
- [x] Reset doesn't feel punishing
- [x] Works on all ramp types

## Pre-Release Checklist

### All Features Complete
- [x] Suspension physics
- [x] Incline camera
- [x] Environment collision refinement
- [ ] Car-to-Car collision implementation
- [x] Ramp mechanics completion (⏸️ tạm ngưng)

### Performance Validated
- [x] Android 30 FPS minimum achieved
- [x] iOS 60 FPS target achieved
- [x] Memory usage within budget
- [ ] Battery drain acceptable
- [ ] No thermal throttling

### Quality Assurance
- [x] All unit tests pass (80%+ coverage)
- [ ] All integration tests pass
- [ ] Manual QA sign-off
- [ ] No critical bugs remaining
- [ ] No high-priority bugs remaining

## Bug Tracking Template

```markdown
**Title**: [Feature] [Brief description]

**Severity**: [Critical/High/Medium/Low]

**Platform**: [Android/iOS/Both]

**Device**: [Specific model and OS version]

**Steps to Reproduce**:
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected Result**: [What should happen per requirements]

**Actual Result**: [What actually happens]

**Frequency**: [Always/Sometimes/Rare]

**Attachments**: [Video/Screenshot/Logs]

**Related Features**: [Suspension/Camera/Collision/Ramp]
```

## Related Documentation

- **Requirements**: `car-physics-overview.md`
- **Design**: `car-physics-architecture.md`
- **Planning**: `car-physics-master-plan.md`
- **Implementation**: `car-physics-implementation-guide.md`
