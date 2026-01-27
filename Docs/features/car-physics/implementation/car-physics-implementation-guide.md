---
phase: implementation
title: Car Physics - Implementation Guide
description: Technical implementation details, patterns, and code guidelines for ME03-ME08
feature_id: car-physics
status: development
last_updated: 2026-01-26
---

# Car Physics - Implementation Guide

**Breadcrumbs:** [Docs](../../../../) > [Features](../../../) > [Car Physics](../) > [Implementation](./) > Guide

**Feature ID**: `car-physics`  
**Status**: 🔄 Development  
**Version**: 1.1.0
**Date**: 2026-01-26

## Development Setup

### Prerequisites
- Unreal Engine 5.4+
- Visual Studio 2022 (Windows) or Xcode (macOS)
- Android SDK & NDK (for Android builds)
- iOS development certificate (for iOS builds)

### Plugin Structure
```
PrototypeRacing/Plugins/SimpleCarPhysics/
├── Source/SimpleCarPhysics/
│   ├── Public/
│   │   ├── PhysicsSimulateCar/
│   │   │   ├── SimulatePhysicsCar.h
│   │   │   ├── CustomSuspensionComponent.h
│   │   │   └── CustomVehicleWheel.h
│   │   ├── FollowCarCamera.h
│   │   ├── FakeCarBody.h
│   │   ├── KinematicFakeCarBody.h
│   │   └── RoadGuide.h
│   ├── Private/
│   │   └── (implementations)
│   └── SimpleCarPhysics.Build.cs
└── SimpleCarPhysics.uplugin
```

## Code Structure

### Naming Conventions

**C++ Classes**:
- `ASimulatePhysicsCar` - Main car actor (A prefix for Actor)
- `UCustomSuspensionComponent` - Suspension component (U prefix for UObject)
- `FInclineData` - Data structure (F prefix for struct)
- `ECollisionSeverity` - Enumeration (E prefix for enum)

**Variables**:
- `bIsAirborne` - Boolean (b prefix)
- `MaxEngineForce` - Public property (PascalCase)
- `currentSpeed` - Private variable (camelCase)

## Verified Implementation (from Source Code)

### ME03: Suspension Physics ✅ COMPLETED

**UCustomSuspensionComponent** - Individual wheel suspension simulation

**Algorithm**:
```
1. Raycast downward from wheel position
2. Calculate compression = (SuspensionLength - HitDistance)
3. Spring force = compression * SpringStiffness
4. Damper force = compressionVelocity * DamperStrength
5. Total force = Spring + Damper
6. Apply force to car body at wheel location
```

**Visual Body Tilt** (from `SimulatePhysicsCar`):
```cpp
void ASimulatePhysicsCar::SimulateSuspension(TArray<USceneComponent*> SceneComponents, float DeltaTime)
{
    // Get suspension pairs (front/rear, left/right)
    const FSuspensionPair& FrontPair = SuspensionPairs[0];
    const FSuspensionPair& RearPair = SuspensionPairs[1];
    
    // Calculate left/right forces
    float RightForce = FrontPair.SecondSuspension->SuspensionForce + RearPair.SecondSuspension->SuspensionForce;
    float LeftForce = FrontPair.FirstSuspension->SuspensionForce + RearPair.FirstSuspension->SuspensionForce;
    
    // Calculate roll angle
    float ForceDifference = RightForce - LeftForce;
    float RollAngle = ForceDifference * RollSensitivity;
    
    // Apply to visual body with interpolation
    for (USceneComponent* Component : SceneComponents)
    {
        FRotator CurrentRotation = Component->GetRelativeRotation();
        CurrentRotation.Roll = FMath::FInterpTo(CurrentRotation.Roll, RollAngle, DeltaTime, 5.0f);
        Component->SetRelativeRotation(CurrentRotation);
    }
}
```

---

### ME05: Incline & Decline Camera ✅ COMPLETED

**FInclineCameraSettings** (verified from `FollowCarCamera.h`):
```cpp
USTRUCT(BlueprintType)
struct FInclineCameraSettings
{
    GENERATED_BODY()
    
    UPROPERTY(EditAnywhere, Category = "FOV")
    float InclineFOVMultiplier = 1.1f;    // +10%
    
    UPROPERTY(EditAnywhere, Category = "FOV")
    float DeclineFOVMultiplier = 1.1f;    // +10%
    
    UPROPERTY(EditAnywhere, Category = "Position")
    float InclineZOffset = 50.0f;          // +50cm up
    
    UPROPERTY(EditAnywhere, Category = "Position")
    float InclineXOffset = -30.0f;         // -30cm back
    
    UPROPERTY(EditAnywhere, Category = "Position")
    float DeclineZOffset = 50.0f;
    
    UPROPERTY(EditAnywhere, Category = "Position")
    float DeclineXOffset = -30.0f;
    
    UPROPERTY(EditAnywhere, Category = "Interpolation")
    float InterpolationSpeed = 5.0f;
    
    UPROPERTY(EditAnywhere, Category = "Detection")
    float InclineThreshold = 10.0f;        // Degrees
    
    UPROPERTY(EditAnywhere, Category = "Detection")
    float DeclineThreshold = -10.0f;
};
```

**FInclineData** (verified from `SimulatePhysicsCar.h`):
```cpp
UENUM(BlueprintType)
enum class EInclineState : uint8
{
    Flat UMETA(DisplayName = "Flat"),
    Incline UMETA(DisplayName = "Incline"),
    Decline UMETA(DisplayName = "Decline")
};

USTRUCT(BlueprintType)
struct FInclineData
{
    GENERATED_BODY()

    UPROPERTY(BlueprintReadOnly, Category = "Incline")
    float InclineAngle;

    UPROPERTY(BlueprintReadOnly, Category = "Incline")
    EInclineState InclineState;

    UPROPERTY(BlueprintReadOnly, Category = "Incline")
    float AccelerationMultiplier;

    UPROPERTY(BlueprintReadOnly, Category = "Incline")
    FVector RoadNormal = FVector::UpVector;
};
```

**FInclineAccelerationSettings** (verified):
```cpp
USTRUCT(BlueprintType)
struct FInclineAccelerationSettings
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, Category = "Acceleration", 
              meta = (ClampMin = "1.0", ClampMax = "10.0"))
    float UphillMultiplier = 1.3f;     // 130% on uphill

    UPROPERTY(EditAnywhere, Category = "Acceleration", 
              meta = (ClampMin = "1.0", ClampMax = "10.0"))
    float DownhillMultiplier = 1.1f;   // 110% on downhill

    UPROPERTY(EditAnywhere, Category = "Acceleration", 
              meta = (ClampMin = "1.0", ClampMax = "10.0"))
    float FlatMultiplier = 1.0f;       // 100% on flat
};
```

**Key Functions** (from `AFollowCarCamera`):
```cpp
void RegisterFollowTarget(ASimulatePhysicsCar* TargetToFollow);
void AdjustDistance(float NewDistance, bool bSnap);
void AdjustFOV(float NewFOV, bool bSnap);
void AdjustRotationLag(float LagPercent, bool bSnap);
void StartCountdownActiveIncline();
```

---

### ME06: Environment Collision ✅ COMPLETED

**FCollisionCorrectionSettings** (verified from `SimulatePhysicsCar.h`):
```cpp
USTRUCT(BlueprintType)
struct FCollisionCorrectionSettings
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Wall Correction")
    bool bIsUseImpulse = true;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Wall Correction")
    float InterpolationSpeed = 2.0f;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Wall Correction")
    float MaxCorrectionTorque = 2000.0f;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Wall Correction")
    float AngleReductionFactor = 0.5f;     // 50% reduction

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Wall Correction")
    float TraceDistance = 500.0f;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Wall Correction")
    float SmallAngleThreshold = 15.0f;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Wall Correction")
    float LargeAngleThreshold = 45.0f;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Wall Correction")
    float OutwardImpulseStrength = 50.0f;

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Wall Correction")
    TArray<TSubclassOf<AActor>> IgnoreActor;
};
```

**ECollisionSeverity & FWallCollisionData** (verified):
```cpp
UENUM(BlueprintType)
enum class ECollisionSeverity : uint8
{
    Small,   // < 15 degrees
    Medium,  // 15-45 degrees
    Large    // > 45 degrees
};

USTRUCT(BlueprintType)
struct FWallCollisionData
{
    GENERATED_BODY()

    UPROPERTY(BlueprintReadWrite)
    FVector ImpactPoint;

    UPROPERTY(BlueprintReadWrite)
    FVector ImpactNormal;

    UPROPERTY(BlueprintReadWrite)
    float CollisionAngle;              // Degrees

    UPROPERTY(BlueprintReadWrite)
    ECollisionSeverity Severity;

    UPROPERTY(BlueprintReadWrite)
    bool bIsValid = false;
};
```

---

### ME07: Car Collision 🔄 IN PROGRESS

**Pattern**: Fake kinematic body + overlap detection

**Existing Classes**:
- `AFakeCarBody` - Base fake body actor
- `AKinematicFakeCarBody` - Kinematic variant

**Implementation Pattern**:
```cpp
// FakeCarBody syncs with owner car in AsyncPhysicsTick
void AFakeCarBody::AsyncPhysicsTick(float DeltaTime)
{
    if (!OwnerCar) return;

    // Sync position and rotation with owner car
    FTransform OwnerTransform = OwnerCar->GetActorTransform();
    SetActorLocationAndRotation(
        OwnerTransform.GetLocation(),
        OwnerTransform.GetRotation()
    );
}

// Collision case detection
ECollisionCase AFakeCarBody::DetermineCollisionCase(const FVector& ImpactDirection)
{
    FVector LocalImpact = GetActorTransform().InverseTransformVector(ImpactDirection);

    float ForwardDot = FVector::DotProduct(LocalImpact, FVector::ForwardVector);
    float RightDot = FVector::DotProduct(LocalImpact, FVector::RightVector);

    const float CornerThreshold = 0.7f;

    if (FMath::Abs(ForwardDot) > CornerThreshold && FMath::Abs(RightDot) > CornerThreshold)
    {
        // Corner collision
        if (ForwardDot > 0 && RightDot > 0) return ECollisionCase::FrontRight;
        else if (ForwardDot > 0 && RightDot < 0) return ECollisionCase::FrontLeft;
        else if (ForwardDot < 0 && RightDot > 0) return ECollisionCase::RearRight;
        else return ECollisionCase::RearLeft;
    }
    else
    {
        // Side collision
        return (FMath::Abs(RightDot) > FMath::Abs(ForwardDot)) ?
            ((RightDot > 0) ? ECollisionCase::RightSide : ECollisionCase::LeftSide) :
            ((ForwardDot > 0) ? ECollisionCase::FrontRight : ECollisionCase::RearRight);
    }
}
```

---

### ME08: Ramp & Airborne ✅ COMPLETED

**ARampZone** (verified from `RampZone.h/.cpp`):
```cpp
UCLASS()
class ARampZone : public AActor
{
    GENERATED_BODY()

public:
    UPROPERTY(EditAnywhere, Category = "Boost")
    float BoostForce = 50000.0f;
    
    UPROPERTY(VisibleAnywhere, Category = "Collision")
    UBoxComponent* RampTrigger;
    
    UPROPERTY(VisibleAnywhere, Category = "Mesh")
    UStaticMeshComponent* RampMeshComponent;
    
protected:
    void OnRampOverlapBegin(...);
    void OnRampOverlapEnd(...);
    FVector CalculateBoostDirection(const FVector& VehicleVelocity);
};
```

**Boost Logic** (verified from `RampZone.cpp`):
```cpp
void ARampZone::OnRampOverlapBegin(...)
{
    ASimulatePhysicsCar* Car = Cast<ASimulatePhysicsCar>(OtherActor);
    if (!Car) return;
    
    // Cancel drift if active
    if(Car->IsDrifting())
        Car->CancelDrift();
    
    // Calculate boost direction (follows velocity)
    FVector BoostDirection = CalculateBoostDirection(Car->GetVelocity());
    FVector BoostVector = BoostDirection * BoostForce;
    
    // Apply impulse
    UAsyncTickFunctions::ATP_AddImpulse(Car->GetPrimitiveRoot(), BoostVector, true);
    
    // Trigger events
    Car->OnRampBoost(true);
    Car->OnVehicleSkillTriggered.Broadcast(FText::FromString("HangTime"));
}

FVector ARampZone::CalculateBoostDirection(const FVector& VehicleVelocity)
{
    FVector VelocityDirection = VehicleVelocity.GetSafeNormal();
    FVector Up = FVector::UpVector;
    float UpwardBoost = 1.f; // Adjustable
    
    FVector Direction = VelocityDirection + (Up * UpwardBoost);
    return Direction.GetSafeNormal();
}
```

**FAirborneState** (verified from `SimulatePhysicsCar.h`):
```cpp
USTRUCT(BlueprintType)
struct FAirborneState
{
    GENERATED_BODY()

    UPROPERTY(BlueprintReadOnly, Category = "Airborne")
    bool bIsAirborne = false;

    UPROPERTY(BlueprintReadOnly, Category = "Airborne")
    float TimeInAir = 0.0f;

    UPROPERTY(BlueprintReadOnly, Category = "Airborne")
    int32 WheelsInAir = 0;

    UPROPERTY(BlueprintReadOnly, Category = "Airborne")
    FVector LaunchVelocity;

    UPROPERTY(BlueprintReadOnly, Category = "Airborne")
    float MaxHeight = 0.0f;
};
```

**FAirControlSettings** (verified):
```cpp
USTRUCT(BlueprintType)
struct FAirControlSettings
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, Category = "Steering")
    float GroundSteeringSensitivity = 1.0f;

    UPROPERTY(EditAnywhere, Category = "Steering")
    float AirSteeringMultiplier = 0.5f;    // 50% of ground

    UPROPERTY(EditAnywhere, Category = "Control")
    float YawStrength = 4.0f;

    UPROPERTY(EditAnywhere, Category = "Control")
    float RollStrength = 4.0f;

    UPROPERTY(EditAnywhere, Category = "Control")
    float PitchStrength = 4.0f;
};
```

**FAntiRollInAir** (verified):
```cpp
USTRUCT(BlueprintType)
struct FAntiRollInAir
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, Category = "Thresholds", 
              meta = (ClampMin = "0.0", ClampMax = "90.0"))
    float MaxRollAngle = 45.0f;            // Degrees

    UPROPERTY(EditAnywhere, Category = "Thresholds", 
              meta = (ClampMin = "0.0", ClampMax = "90.0"))
    float MaxPitchAngle = 60.0f;           // Upside down

    UPROPERTY(EditAnywhere, Category = "Correction")
    float AntiRollPowerInAir = 3000.0;

    UPROPERTY(EditAnywhere, Category = "Correction")
    float AntiPitchPowerInAir = 2000.0f;
};
```

---

## Error Handling

### Null Checks
```cpp
// Always validate components
if (!IsValid(FollowCamera))
{
    UE_LOG(LogTemp, Warning, TEXT("FollowCamera not initialized"));
    return;
}

if (!GuideLine)
{
    UE_LOG(LogTemp, Error, TEXT("GuideLine is null"));
    return FVector::ForwardVector;
}
```

### Physics Validation
```cpp
// Prevent NaN/Inf crashes
void ASimulatePhysicsCar::ApplyForce(const FVector& Force)
{
    if (!Force.ContainsNaN() && Force.IsFinite())
    {
        UAsyncTickFunctions::ATP_AddForce(PrimitiveComponent, Force, true);
    }
    else
    {
        UE_LOG(LogTemp, Error, TEXT("Invalid force vector: %s"), *Force.ToString());
    }
}
```

## Performance Considerations

### Distance-Based Updates
```cpp
void ASimulatePhysicsCar::NativeAsyncTick(float DeltaTime)
{
    if (bIsPlayerCar)
    {
        // High-priority continuous update for player
        UpdatePhysicsCore(DeltaTime);
    }
    else
    {
        // Distance-based conditional update for AI
        float DistanceToPlayer = (PlayerCar->GetActorLocation() - GetActorLocation()).Size();
        if (DistanceToPlayer < UpdateDistanceThreshold)
        {
            UpdatePhysicsCore(DeltaTime);
        }
    }
}
```

### Object Pooling for Widgets
```cpp
TArray<UUserWidget*> WidgetPool;

UUserWidget* GetPooledWidget()
{
    if (WidgetPool.Num() > 0)
        return WidgetPool.Pop();
    return CreateWidget<UUserWidget>(...);
}

void ReturnWidgetToPool(UUserWidget* Widget)
{
    Widget->SetVisibility(ESlateVisibility::Hidden);
    WidgetPool.Add(Widget);
}
```

## Related Documentation

- **Requirements**: `car-physics-overview.md`
- **Design**: `car-physics-architecture.md`
- **Planning**: `car-physics-master-plan.md`
- **Testing**: `car-physics-testing-strategy.md`
