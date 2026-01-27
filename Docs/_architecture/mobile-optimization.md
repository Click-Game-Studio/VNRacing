# Mobile Optimization Architecture - VNRacing

**Breadcrumbs:** Docs > Architecture > Mobile Optimization

**Version:** 1.1.0 | **Date:** 2026-01-26

![Status: Development](https://img.shields.io/badge/Status-Development-blue)

---

## Table of Contents

1. [Overview](#overview)
2. [Distance-Based Update System](#1-distance-based-update-system)
   - [Architecture Overview](#architecture-overview)
   - [Update Priority Tiers](#update-priority-tiers)
3. [Object Pooling Architecture](#2-object-pooling-architecture)
   - [Pool Manager](#pool-manager)
   - [Pooled Object Types](#pooled-object-types)
4. [Adaptive Quality Settings](#3-adaptive-quality-settings)
   - [Quality Manager](#quality-manager)
5. [Memory Management Strategies](#4-memory-management-strategies)
   - [Texture Streaming](#texture-streaming)
   - [Asset Streaming](#asset-streaming)
6. [Battery Optimization Patterns](#5-battery-optimization-patterns)
   - [Frame Rate Throttling](#frame-rate-throttling)
7. [Touch Input Architecture](#6-touch-input-architecture)
   - [Touch Input Manager](#touch-input-manager)
8. [Rendering Optimizations](#7-rendering-optimizations)
   - [Draw Call Reduction](#draw-call-reduction)
   - [LOD Configuration](#lod-configuration)
9. [Network Optimization for Mobile](#8-network-optimization-for-mobile)
   - [Bandwidth Reduction](#bandwidth-reduction)
10. [Mobile Optimization Checklist](#mobile-optimization-checklist)
11. [Conclusion](#conclusion)

---

## Overview

This document describes the mobile-specific architectural decisions and optimization strategies employed in PrototypeRacing to achieve 60 FPS performance on mobile devices while maintaining visual quality and gameplay experience.

---

## 1. Distance-Based Update System

### Architecture Overview

The center actor (player vehicle) receives continuous high-priority updates in the main update loop, while other entities use distance-based conditional updates relative to the center actor.

```cpp
// Distance-Based Update Manager
UCLASS()
class UDistanceBasedUpdateManager : public UGameInstanceSubsystem
{
    GENERATED_BODY()

public:
    // Register actor for distance-based updates
    void RegisterActor(AActor* Actor, EUpdatePriority Priority);
    
    // Unregister actor
    void UnregisterActor(AActor* Actor);
    
    // Set center actor (player vehicle)
    void SetCenterActor(AActor* Actor);
    
    virtual void Tick(float DeltaTime) override;
    
private:
    AActor* CenterActor;
    TMap<AActor*, FUpdateInfo> RegisteredActors;
    
    void UpdateActorsByDistance(float DeltaTime);
    float CalculateUpdateInterval(float Distance, EUpdatePriority Priority);
};

// Update intervals based on distance
float UDistanceBasedUpdateManager::CalculateUpdateInterval(float Distance, EUpdatePriority Priority)
{
    if (Distance < 1000.0f)
    {
        // High priority: Update every frame
        return 0.0f;
    }
    else if (Distance < 3000.0f)
    {
        // Medium priority: Update every 0.1s
        return 0.1f;
    }
    else if (Distance < 5000.0f)
    {
        // Low priority: Update every 0.3s
        return 0.3f;
    }
    else
    {
        // Very low priority: Update every 0.5s
        return 0.5f;
    }
}
```

### Update Priority Tiers

| Distance from Player | Update Frequency | Use Case |
|---------------------|------------------|----------|
| **Center Actor** | Every frame (0.0s) | Player vehicle |
| **0-1000 units** | Every frame (0.0s) | Nearby AI vehicles, pickups |
| **1000-3000 units** | Every 0.1s | Medium-distance AI, VFX |
| **3000-5000 units** | Every 0.3s | Far AI, environment actors |
| **5000+ units** | Every 0.5s | Very far actors, background |

---

## 2. Object Pooling Architecture

### Pool Manager

```cpp
// Object Pool Manager
UCLASS()
class UObjectPoolManager : public UGameInstanceSubsystem
{
    GENERATED_BODY()

public:
    // Get pooled object
    template<typename T>
    T* GetPooledObject(TSubclassOf<T> Class);
    
    // Return object to pool
    void ReturnToPool(AActor* Actor);
    
    // Pre-warm pool
    void PreWarmPool(TSubclassOf<AActor> Class, int32 Count);
    
private:
    TMap<UClass*, TArray<AActor*>> AvailablePools;
    TMap<UClass*, TArray<AActor*>> ActivePools;
    
    AActor* CreateNewPooledObject(TSubclassOf<AActor> Class);
};

// Usage example
void AWeaponSystem::FireProjectile()
{
    UObjectPoolManager* PoolManager = GetGameInstance()->GetSubsystem<UObjectPoolManager>();
    
    // Get pooled projectile instead of spawning new
    AProjectile* Projectile = PoolManager->GetPooledObject<AProjectile>(ProjectileClass);
    
    if (Projectile)
    {
        Projectile->SetActorLocation(MuzzleLocation);
        Projectile->Fire(Direction);
    }
}

void AProjectile::OnHit()
{
    // Return to pool instead of destroying
    UObjectPoolManager* PoolManager = GetGameInstance()->GetSubsystem<UObjectPoolManager>();
    PoolManager->ReturnToPool(this);
}
```

### Pooled Object Types

- **VFX Particles**: Exhaust smoke, tire smoke, sparks, explosions
- **Projectiles**: If applicable (power-ups, weapons)
- **Pickups**: Nitro boosts, power-ups
- **UI Widgets**: Reusable menu elements, notifications
- **Audio Components**: Sound effects

---

## 3. Adaptive Quality Settings

### Quality Manager

```cpp
// Adaptive Quality Manager
UCLASS()
class UAdaptiveQualityManager : public UGameInstanceSubsystem
{
    GENERATED_BODY()

public:
    virtual void Initialize(FSubsystemCollectionBase& Collection) override;
    virtual void Tick(float DeltaTime) override;
    
    // Get current quality level
    EQualityLevel GetCurrentQualityLevel() const { return CurrentQualityLevel; }
    
private:
    EQualityLevel CurrentQualityLevel;
    float AverageFPS;
    TArray<float> FPSSamples;
    
    void MonitorPerformance(float DeltaTime);
    void AdjustQuality();
    void ApplyQualitySettings(EQualityLevel Level);
};

// Quality levels
UENUM(BlueprintType)
enum class EQualityLevel : uint8
{
    Low,
    Medium,
    High,
    Ultra
};

// Adaptive quality adjustment
void UAdaptiveQualityManager::AdjustQuality()
{
    if (AverageFPS < 50.0f && CurrentQualityLevel > EQualityLevel::Low)
    {
        // Decrease quality
        CurrentQualityLevel = (EQualityLevel)((uint8)CurrentQualityLevel - 1);
        ApplyQualitySettings(CurrentQualityLevel);
    }
    else if (AverageFPS > 58.0f && CurrentQualityLevel < EQualityLevel::Ultra)
    {
        // Increase quality
        CurrentQualityLevel = (EQualityLevel)((uint8)CurrentQualityLevel + 1);
        ApplyQualitySettings(CurrentQualityLevel);
    }
}

void UAdaptiveQualityManager::ApplyQualitySettings(EQualityLevel Level)
{
    switch (Level)
    {
        case EQualityLevel::Low:
            // Low quality settings
            GEngine->Exec(GetWorld(), TEXT("sg.ViewDistanceQuality 0"));
            GEngine->Exec(GetWorld(), TEXT("sg.ShadowQuality 0"));
            GEngine->Exec(GetWorld(), TEXT("sg.PostProcessQuality 0"));
            GEngine->Exec(GetWorld(), TEXT("sg.TextureQuality 0"));
            GEngine->Exec(GetWorld(), TEXT("sg.EffectsQuality 0"));
            break;
            
        case EQualityLevel::Medium:
            // Medium quality settings
            GEngine->Exec(GetWorld(), TEXT("sg.ViewDistanceQuality 1"));
            GEngine->Exec(GetWorld(), TEXT("sg.ShadowQuality 1"));
            GEngine->Exec(GetWorld(), TEXT("sg.PostProcessQuality 1"));
            GEngine->Exec(GetWorld(), TEXT("sg.TextureQuality 1"));
            GEngine->Exec(GetWorld(), TEXT("sg.EffectsQuality 1"));
            break;
            
        case EQualityLevel::High:
            // High quality settings
            GEngine->Exec(GetWorld(), TEXT("sg.ViewDistanceQuality 2"));
            GEngine->Exec(GetWorld(), TEXT("sg.ShadowQuality 2"));
            GEngine->Exec(GetWorld(), TEXT("sg.PostProcessQuality 2"));
            GEngine->Exec(GetWorld(), TEXT("sg.TextureQuality 2"));
            GEngine->Exec(GetWorld(), TEXT("sg.EffectsQuality 2"));
            break;
    }
}
```

---

## 4. Memory Management Strategies

### Texture Streaming

```cpp
// Texture streaming configuration
void ConfigureTextureStreaming()
{
    // Set streaming pool size based on device
    int32 PoolSizeMB = 512; // Default for mid-range devices
    
    if (IsHighEndDevice())
    {
        PoolSizeMB = 1024;
    }
    else if (IsLowEndDevice())
    {
        PoolSizeMB = 256;
    }
    
    GEngine->Exec(GetWorld(), *FString::Printf(TEXT("r.Streaming.PoolSize %d"), PoolSizeMB));
}
```

### Asset Streaming

```cpp
// Level streaming for large worlds
void AGameMode::LoadNextSection(const FVector& PlayerLocation)
{
    // Unload far sections
    for (ULevelStreaming* Level : FarSections)
    {
        if (Level && Level->IsLevelLoaded())
        {
            Level->SetShouldBeLoaded(false);
            Level->SetShouldBeVisible(false);
        }
    }
    
    // Load nearby sections
    for (ULevelStreaming* Level : NearbySections)
    {
        if (Level && !Level->IsLevelLoaded())
        {
            Level->SetShouldBeLoaded(true);
            Level->SetShouldBeVisible(true);
        }
    }
}
```

---

## 5. Battery Optimization Patterns

### Frame Rate Throttling

```cpp
// Battery-saving mode
void USettingSubsystem::SetBatterySavingMode(bool bEnabled)
{
    if (bEnabled)
    {
        // Limit to 30 FPS
        GEngine->Exec(GetWorld(), TEXT("t.MaxFPS 30"));
        
        // Reduce quality
        AdaptiveQualityManager->SetQualityLevel(EQualityLevel::Low);
        
        // Reduce update frequencies
        DistanceUpdateManager->SetGlobalUpdateMultiplier(2.0f);
    }
    else
    {
        // Target 60 FPS
        GEngine->Exec(GetWorld(), TEXT("t.MaxFPS 60"));
        
        // Restore quality
        AdaptiveQualityManager->SetQualityLevel(EQualityLevel::Medium);
        
        // Restore update frequencies
        DistanceUpdateManager->SetGlobalUpdateMultiplier(1.0f);
    }
}
```

---

## 6. Touch Input Architecture

### Touch Input Manager

```cpp
// Touch input manager
UCLASS()
class UTouchInputManager : public UActorComponent
{
    GENERATED_BODY()

public:
    // Touch zones
    UPROPERTY(EditAnywhere, Category = "Input")
    FTouchZone SteeringZone;
    
    UPROPERTY(EditAnywhere, Category = "Input")
    FTouchZone AccelerateZone;
    
    UPROPERTY(EditAnywhere, Category = "Input")
    FTouchZone BrakeZone;
    
    // Process touch input
    void ProcessTouch(const FVector2D& TouchLocation, ETouchType::Type TouchType);
    
private:
    void HandleSteering(const FVector2D& TouchLocation);
    void HandleAccelerate(bool bPressed);
    void HandleBrake(bool bPressed);
};

// Touch zone definition
USTRUCT(BlueprintType)
struct FTouchZone
{
    GENERATED_BODY()
    
    UPROPERTY(EditAnywhere)
    FVector2D Min;
    
    UPROPERTY(EditAnywhere)
    FVector2D Max;
    
    bool Contains(const FVector2D& Point) const
    {
        return Point.X >= Min.X && Point.X <= Max.X &&
               Point.Y >= Min.Y && Point.Y <= Max.Y;
    }
};
```

---

## 7. Rendering Optimizations

### Draw Call Reduction

```cpp
// Instanced Static Mesh Component for repeated objects
UCLASS()
class AEnvironmentManager : public AActor
{
    GENERATED_BODY()

public:
    AEnvironmentManager();
    
protected:
    // Use HISM for trees, rocks, etc.
    UPROPERTY(VisibleAnywhere)
    UHierarchicalInstancedStaticMeshComponent* TreeInstances;
    
    UPROPERTY(VisibleAnywhere)
    UHierarchicalInstancedStaticMeshComponent* RockInstances;
    
    void SpawnEnvironmentObjects();
};

// Spawn many instances with single draw call
void AEnvironmentManager::SpawnEnvironmentObjects()
{
    for (int32 i = 0; i < 100; i++)
    {
        FTransform Transform;
        Transform.SetLocation(GetRandomLocation());
        Transform.SetRotation(GetRandomRotation());
        
        // Add instance (single draw call for all instances)
        TreeInstances->AddInstance(Transform);
    }
}
```

### LOD Configuration

```cpp
// Automatic LOD configuration
void ConfigureLODs(UStaticMesh* Mesh)
{
    FStaticMeshSourceModel& LOD0 = Mesh->GetSourceModel(0);
    FStaticMeshSourceModel& LOD1 = Mesh->AddSourceModel();
    FStaticMeshSourceModel& LOD2 = Mesh->AddSourceModel();
    FStaticMeshSourceModel& LOD3 = Mesh->AddSourceModel();
    
    // LOD 0: Full detail (0-1000 units)
    LOD0.ScreenSize = 1.0f;
    
    // LOD 1: 50% reduction (1000-3000 units)
    LOD1.ScreenSize = 0.5f;
    LOD1.ReductionSettings.PercentTriangles = 0.5f;
    
    // LOD 2: 75% reduction (3000-6000 units)
    LOD2.ScreenSize = 0.25f;
    LOD2.ReductionSettings.PercentTriangles = 0.25f;
    
    // LOD 3: 90% reduction (6000+ units)
    LOD3.ScreenSize = 0.1f;
    LOD3.ReductionSettings.PercentTriangles = 0.1f;
}
```

---

## 8. Network Optimization for Mobile

### Bandwidth Reduction

```cpp
// Reduce replication frequency for mobile
void APlayerVehicle::GetLifetimeReplicatedProps(TArray<FLifetimeProperty>& OutLifetimeProps) const
{
    Super::GetLifetimeReplicatedProps(OutLifetimeProps);
    
    // Replicate position/rotation less frequently on mobile
    DOREPLIFETIME_CONDITION(APlayerVehicle, ReplicatedMovement, COND_SimulatedOnly);
    
    // Only replicate to owner
    DOREPLIFETIME_CONDITION(APlayerVehicle, CurrentSpeed, COND_OwnerOnly);
    
    // Replicate only on change
    DOREPLIFETIME_CONDITION(APlayerVehicle, CurrentGear, COND_OnlyInitialOrOwner);
}

// Adjust net update frequency based on distance
void APlayerVehicle::Tick(float DeltaTime)
{
    Super::Tick(DeltaTime);
    
    if (HasAuthority())
    {
        float Distance = FVector::Dist(GetActorLocation(), GetPlayerLocation());
        
        if (Distance < 2000.0f)
        {
            NetUpdateFrequency = 30.0f; // High frequency for nearby
        }
        else if (Distance < 5000.0f)
        {
            NetUpdateFrequency = 10.0f; // Medium frequency
        }
        else
        {
            NetUpdateFrequency = 1.0f; // Low frequency for far
        }
    }
}
```

---

## Mobile Optimization Checklist

### Rendering
- [ ] Forward shading enabled
- [ ] Mobile HDR disabled (or limited)
- [ ] Dynamic shadows limited
- [ ] LODs configured for all meshes
- [ ] Texture compression optimized
- [ ] Draw calls minimized (HISM)
- [ ] Post-processing effects limited

### Performance
- [ ] Distance-based updates implemented
- [ ] Object pooling for frequent spawns
- [ ] Adaptive quality system active
- [ ] Tick optimization (disable unnecessary ticks)
- [ ] Async loading for large assets
- [ ] Level streaming configured

### Memory
- [ ] Texture streaming enabled
- [ ] Streaming pool size configured
- [ ] Asset references use soft pointers
- [ ] Memory budgets defined
- [ ] Garbage collection optimized

### Battery
- [ ] Frame rate throttling option
- [ ] Battery-saving mode available
- [ ] Background app handling
- [ ] Wake lock management

### Input
- [ ] Touch zones defined
- [ ] Touch input responsive
- [ ] Haptic feedback (optional)
- [ ] Gesture support

---

## Conclusion

The PrototypeRacing mobile optimization architecture ensures:
- **60 FPS Performance**: Distance-based updates, object pooling, adaptive quality
- **Low Memory Usage**: Texture streaming, level streaming, soft references
- **Battery Efficiency**: Frame rate throttling, quality reduction options
- **Responsive Input**: Optimized touch input system

For implementation details, refer to feature-specific implementation documentation.

