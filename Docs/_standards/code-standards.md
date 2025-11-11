# Code Standards - PrototypeRacing

**Project**: PrototypeRacing - Mobile Racing Game
**Document**: Code Quality and Style Standards
**Version**: 1.0
**Date**: 2025-11-07
**Status**: Official Standard

## Overview

This document establishes code quality standards, best practices, and style guidelines for C++ and Blueprint development in the PrototypeRacing project.

---

## C++ Coding Standards

### Header File Organization

```cpp
// MyClass.h
#pragma once

// 1. Core includes
#include "CoreMinimal.h"

// 2. Engine includes (alphabetical)
#include "GameFramework/Actor.h"
#include "Components/ActorComponent.h"

// 3. Project includes (alphabetical)
#include "Vehicles/VehicleBase.h"
#include "Subsystems/CustomizationSubsystem.h"

// 4. Generated header (ALWAYS LAST)
#include "MyClass.generated.h"

/**
 * Brief description of the class purpose
 * 
 * Detailed description if needed, explaining:
 * - What this class does
 * - How it fits into the system
 * - Any important usage notes
 */
UCLASS(BlueprintType, Blueprintable)
class PROTOTYPERACING_API AMyClass : public AActor
{
    GENERATED_BODY()

public:
    // Constructor
    AMyClass();

    // Public functions
    virtual void BeginPlay() override;
    virtual void Tick(float DeltaTime) override;

protected:
    // Protected functions
    void InitializeComponents();

private:
    // Private functions
    void UpdateInternalState();

public:
    // Public properties (UPROPERTY)
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Configuration")
    float MaxSpeed;

protected:
    // Protected properties
    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category = "State")
    float CurrentSpeed;

private:
    // Private properties
    UPROPERTY()
    class UVehicleComponent* VehicleComponent;
};
```

### Source File Organization

```cpp
// MyClass.cpp
#include "MyClass.h"

// Additional includes
#include "Engine/World.h"
#include "TimerManager.h"

AMyClass::AMyClass()
{
    // Set this actor to call Tick() every frame
    PrimaryActorTick.bCanEverTick = true;
    
    // Initialize components
    VehicleComponent = CreateDefaultSubobject<UVehicleComponent>(TEXT("VehicleComponent"));
}

void AMyClass::BeginPlay()
{
    Super::BeginPlay();
    
    InitializeComponents();
}

void AMyClass::Tick(float DeltaTime)
{
    Super::Tick(DeltaTime);
    
    UpdateInternalState();
}

void AMyClass::InitializeComponents()
{
    // Implementation
}

void AMyClass::UpdateInternalState()
{
    // Implementation
}
```

### Naming Conventions

```cpp
// Classes: Prefix based on type
class AMyActor : public AActor { };           // A for Actors
class UMyComponent : public UObject { };      // U for UObjects
struct FMyStruct { };                         // F for structs
enum class EMyEnum : uint8 { };               // E for enums
class IMyInterface { };                       // I for interfaces

// Variables
public:
    int32 MaxHealth;              // PascalCase for public
    bool bIsAlive;                // 'b' prefix for booleans
    
private:
    float currentSpeed;           // camelCase for private
    int32 engineRPM;
    
// Functions
void CalculateDamage();           // PascalCase
float GetCurrentSpeed() const;    // Getters
void SetMaxSpeed(float NewSpeed); // Setters
bool IsEngineRunning() const;     // Boolean getters

// Constants
static const float MAX_SPEED = 300.0f;
constexpr int32 kMaxGears = 6;
```

### UPROPERTY Specifiers

```cpp
// EditAnywhere: Editable in editor and instances
UPROPERTY(EditAnywhere, Category = "Configuration")
float MaxSpeed;

// EditDefaultsOnly: Editable only in Blueprint defaults
UPROPERTY(EditDefaultsOnly, Category = "Configuration")
TSubclassOf<AActor> ActorClass;

// VisibleAnywhere: Visible but not editable
UPROPERTY(VisibleAnywhere, Category = "State")
float CurrentSpeed;

// BlueprintReadWrite: Accessible in Blueprints
UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Configuration")
float Acceleration;

// BlueprintReadOnly: Read-only in Blueprints
UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category = "State")
bool bIsMoving;

// Replicated: Network replication
UPROPERTY(Replicated)
float Health;

// ReplicatedUsing: Replication with callback
UPROPERTY(ReplicatedUsing = OnRep_Health)
float Health;

// Transient: Not saved or loaded
UPROPERTY(Transient)
float TemporaryValue;

// Config: Saved to config file
UPROPERTY(Config, EditAnywhere, Category = "Settings")
float MasterVolume;
```

### UFUNCTION Specifiers

```cpp
// BlueprintCallable: Can be called from Blueprints
UFUNCTION(BlueprintCallable, Category = "Vehicle")
void StartEngine();

// BlueprintPure: Pure function (no side effects)
UFUNCTION(BlueprintPure, Category = "Vehicle")
float GetCurrentSpeed() const;

// BlueprintImplementableEvent: Implemented in Blueprint
UFUNCTION(BlueprintImplementableEvent, Category = "Vehicle")
void OnEngineStarted();

// BlueprintNativeEvent: Can be overridden in Blueprint
UFUNCTION(BlueprintNativeEvent, Category = "Vehicle")
void OnDamageReceived(float Damage);
virtual void OnDamageReceived_Implementation(float Damage);

// Server RPC
UFUNCTION(Server, Reliable, WithValidation)
void ServerFireWeapon();
void ServerFireWeapon_Implementation();
bool ServerFireWeapon_Validate();

// Client RPC
UFUNCTION(Client, Reliable)
void ClientPlayEffect();
void ClientPlayEffect_Implementation();

// Multicast RPC
UFUNCTION(NetMulticast, Reliable)
void MulticastPlayExplosion();
void MulticastPlayExplosion_Implementation();

// Exec: Console command
UFUNCTION(Exec)
void DebugVehicleStats();
```

### Comments and Documentation

```cpp
/**
 * Calculates the vehicle's performance rating based on current stats
 * 
 * @param BaseStats The base vehicle statistics
 * @param Modifications Array of applied modifications
 * @return The calculated performance rating (0-100)
 */
UFUNCTION(BlueprintCallable, Category = "Vehicle")
float CalculatePerformanceRating(const FVehicleStats& BaseStats, const TArray<FModification>& Modifications);

// Single-line comments for implementation details
void UpdateSpeed()
{
    // Calculate new speed based on acceleration
    float NewSpeed = CurrentSpeed + (Acceleration * DeltaTime);
    
    // Clamp to max speed
    CurrentSpeed = FMath::Clamp(NewSpeed, 0.0f, MaxSpeed);
}
```

### Error Handling

```cpp
// Use check() for critical errors (crashes in development)
check(VehicleComponent != nullptr);

// Use ensure() for non-critical errors (logs in development)
if (!ensure(IsValid(OwningController)))
{
    return;
}

// Use verify() for expressions that should always succeed
verify(InitializeSystem());

// Use UE_LOG for logging
UE_LOG(LogTemp, Warning, TEXT("Vehicle speed: %f"), CurrentSpeed);
UE_LOG(LogTemp, Error, TEXT("Failed to initialize vehicle component"));

// Use GEngine for on-screen debug messages
if (GEngine)
{
    GEngine->AddOnScreenDebugMessage(-1, 5.0f, FColor::Red, TEXT("Debug Message"));
}
```

### Memory Management

```cpp
// Use UPROPERTY() for UObject pointers (garbage collection)
UPROPERTY()
UVehicleComponent* VehicleComponent;

// Use TSharedPtr for shared ownership
TSharedPtr<FVehicleData> SharedData = MakeShared<FVehicleData>();

// Use TWeakPtr to avoid circular references
TWeakPtr<FVehicleData> WeakData = SharedData;

// Use TUniquePtr for exclusive ownership
TUniquePtr<FVehicleData> UniqueData = MakeUnique<FVehicleData>();

// Use TSoftObjectPtr for soft references (lazy loading)
UPROPERTY(EditAnywhere)
TSoftObjectPtr<UStaticMesh> VehicleMesh;

// Load soft reference when needed
if (!VehicleMesh.IsValid())
{
    VehicleMesh.LoadSynchronous();
}
```

---

## Blueprint Standards

### Graph Organization

1. **Use Comment Boxes**: Group related nodes
2. **Reroute Nodes**: Keep execution flow clean
3. **Functions**: Break complex logic into functions
4. **Macros**: Use for frequently repeated patterns
5. **Collapse to Function/Macro**: Simplify complex graphs

### Variable Naming

```
// PascalCase for all variables
MaxSpeed
CurrentGear
IsEngineRunning

// Prefix booleans with 'b'
bIsMoving
bCanDrift
bHasNitro

// Descriptive names
PlayerVehicleReference (not PVR or Vehicle1)
CurrentLapTime (not Time or T)
```

### Event Graph Best Practices

```
Event BeginPlay
  ├─ Initialize Components
  ├─ Setup Input Bindings
  ├─ Load Saved Data
  └─ Start Background Systems

Event Tick (AVOID IF POSSIBLE)
  └─ Use Timers or Events instead

Custom Events
  ├─ Use for reusable logic
  └─ Clear, descriptive names
```

### Function Best Practices

- **Pure Functions**: Use when no side effects
- **Return Values**: Always specify return type
- **Input Parameters**: Use descriptive names
- **Output Parameters**: Use sparingly
- **Local Variables**: Minimize scope

---

## Performance Best Practices

### Tick Optimization

```cpp
// BAD: Using Tick unnecessarily
void AMyActor::Tick(float DeltaTime)
{
    Super::Tick(DeltaTime);
    UpdateSomething(); // Called every frame!
}

// GOOD: Using Timer
void AMyActor::BeginPlay()
{
    Super::BeginPlay();
    GetWorldTimerManager().SetTimer(
        UpdateTimerHandle,
        this,
        &AMyActor::UpdateSomething,
        1.0f,  // Update every 1 second
        true   // Loop
    );
}

// GOOD: Disable Tick by default
PrimaryActorTick.bCanEverTick = false;

// Enable only when needed
SetActorTickEnabled(true);
```

### Object Pooling

```cpp
// Pool frequently spawned/destroyed actors
class UObjectPool : public UObject
{
public:
    AActor* GetPooledObject();
    void ReturnToPool(AActor* Object);

private:
    TArray<AActor*> AvailableObjects;
    TArray<AActor*> ActiveObjects;
};
```

### Avoid Expensive Operations

```cpp
// BAD: Expensive operations in Tick
void Tick(float DeltaTime)
{
    TArray<AActor*> Actors;
    UGameplayStatics::GetAllActorsOfClass(GetWorld(), AActor::StaticClass(), Actors);
}

// GOOD: Cache results
void BeginPlay()
{
    UGameplayStatics::GetAllActorsOfClass(GetWorld(), AActor::StaticClass(), CachedActors);
}
```

---

## Mobile Optimization

### Distance-Based Updates

```cpp
// Update frequency based on distance from player
void UpdateBasedOnDistance()
{
    float Distance = FVector::Dist(GetActorLocation(), PlayerLocation);
    
    if (Distance < 1000.0f)
    {
        // High priority: Update every frame
        SetActorTickInterval(0.0f);
    }
    else if (Distance < 5000.0f)
    {
        // Medium priority: Update every 0.1s
        SetActorTickInterval(0.1f);
    }
    else
    {
        // Low priority: Update every 0.5s
        SetActorTickInterval(0.5f);
    }
}
```

### Memory Management

```cpp
// Use soft references for large assets
UPROPERTY(EditAnywhere)
TSoftObjectPtr<UStaticMesh> LargeAsset;

// Stream levels for large worlds
UGameplayStatics::LoadStreamLevel(GetWorld(), LevelName, true, true, FLatentActionInfo());
```

---

## Code Review Checklist

Before submitting code, verify:

- [ ] Follows naming conventions
- [ ] Proper UPROPERTY/UFUNCTION specifiers
- [ ] Includes documentation comments
- [ ] Error handling implemented
- [ ] Memory management correct
- [ ] Performance optimized (no unnecessary Tick)
- [ ] Mobile optimization considered
- [ ] No hard-coded values (use config/data assets)
- [ ] Multiplayer considerations (if applicable)
- [ ] Code compiles without warnings
- [ ] Blueprint graphs are clean and organized

---

## Conclusion

Consistent code standards ensure:
- **Maintainability**: Easy to understand and modify
- **Performance**: Optimized for mobile platforms
- **Collaboration**: Team members can work together effectively
- **Quality**: Professional, production-ready code

Adherence to these standards is mandatory for all PrototypeRacing code.

