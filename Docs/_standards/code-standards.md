# Code Standards - VNRacing

**Project**: VNRacing - Mobile Racing Game  
**Document**: Code Quality and Style Standards  
**Version**: 1.0.0  
**Date**: 2026-01-20  
**Status**: Official Standard - Aligned with Epic C++ Coding Standard

---

## Table of Contents

- [Overview](#overview)
- [C++ Coding Standards](#c-coding-standards)
  - [Header File Organization](#header-file-organization)
  - [Source File Organization](#source-file-organization)
  - [Naming Conventions](#naming-conventions)
  - [Forward Declarations](#forward-declarations)
  - [TObjectPtr - UE5 Feature](#tobjectptrt---ue5-feature)
  - [Auto Keyword Policy](#auto-keyword-policy)
  - [Lambda Best Practices](#lambda-best-practices)
  - [STL Alternatives](#stl-alternatives)
  - [UPROPERTY Specifiers](#uproperty-specifiers)
  - [UFUNCTION Specifiers](#ufunction-specifiers)
  - [Comments and Documentation](#comments-and-documentation)
  - [Error Handling](#error-handling)
  - [Memory Management](#memory-management)
- [Blueprint Standards](#blueprint-standards)
- [Performance Best Practices](#performance-best-practices)
- [Mobile Optimization](#mobile-optimization)
- [Code Review Checklist](#code-review-checklist)
- [Conclusion](#conclusion)

---

## Overview

This document establishes code quality standards, best practices, and style guidelines for C++ and Blueprint development in the VNRacing project. Version 1.2 has been **fully standardized according to Epic Games C++ Coding Standard** for Unreal Engine 5.

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

// 4. Generated header (ALWAYS LAST - CRITICAL!)
#include "MyClass.generated.h"

/**
 * @brief Brief description of the class purpose
 *
 * Detailed description if needed, explaining:
 * - What this class does
 * - How it fits into the system
 * - Any important usage notes
 *
 * @note This follows Epic's C++ Coding Standard
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
    TObjectPtr<UVehicleComponent> VehicleComponent;
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
class SMyWidget : public SCompoundWidget { }; // S for Slate widgets
template<typename T> class TMyTemplate { };   // T for templates

// Variables
public:
    int32 MaxHealth;              // PascalCase for public
    bool bIsAlive;                // 'b' prefix for booleans (MANDATORY)

private:
    float currentSpeed;           // camelCase for private (Project Standard)
    int32 engineRPM;

// Functions
void CalculateDamage();           // PascalCase
float GetCurrentSpeed() const;    // Getters
void SetMaxSpeed(float NewSpeed); // Setters
bool IsEngineRunning() const;     // Boolean getters: Is/Has/Can

// Constants (PROJECT DECISION: Use k prefix with constexpr)
constexpr float kMaxSpeed = 300.0f;
constexpr int32 kMaxGears = 6;

// ⚠️ PROJECT STANDARD: Use k prefix + constexpr for all constants
```

### Forward Declarations

**Epic Guideline**: "Prefer forward declarations over includes when possible".

```cpp
// MyClass.h
#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"

// Forward declarations (instead of #include)
class UParticleSystem;
class UVehicleComponent;
class AVehicleBase;

#include "MyClass.generated.h"

UCLASS()
class PROTOTYPERACING_API AMyClass : public AActor
{
    GENERATED_BODY()

private:
    UPROPERTY()
    TObjectPtr<UParticleSystem> CastingEffect;

    UPROPERTY()
    TObjectPtr<UVehicleComponent> VehicleComp;
};
```

**When to use Forward Declaration**:
- ✅ Pointer or reference to class
- ✅ Function parameters
- ✅ Return types

**When NOT to use**:
- ❌ Inheritance (must include full header)
- ❌ Member variables by value
- ❌ Template arguments (most cases)

### TObjectPtr<T> - UE5 Feature

**Epic Recommendation**: Use `TObjectPtr<T>` instead of raw pointers for UPROPERTY in Unreal Engine 5.

```cpp
// UE4 style (still works)
UPROPERTY()
UVehicleComponent* VehicleComponent;

// UE5 style (RECOMMENDED)
UPROPERTY()
TObjectPtr<UVehicleComponent> VehicleComponent;
```

**Benefits**:
- **Access tracking** in editor builds
- **Dynamic resolution** to support lazy loading
- **Better cooking/packaging** - tracks assets better
- **Editor-only overhead** - no impact on shipped builds

**Important Rules**:
- ✅ Use for UPROPERTY members
- ❌ DO NOT use for function parameters/returns
- ❌ DO NOT use in .cpp files (use raw pointers)
- ✅ Converts automatically to raw pointers when needed

```cpp
// GOOD: Use in header as UPROPERTY
UPROPERTY()
TObjectPtr<UMyComponent> MyComponent;

// GOOD: Use raw pointers in .cpp functions
void AMyClass::ProcessComponent()
{
    UMyComponent* Comp = MyComponent;  // Auto converts
    Comp->DoSomething();
}

// BAD: Don't use as return type
TObjectPtr<UMyComponent> GetComponent() { return MyComponent; }  // ❌

// GOOD: Return raw pointer instead
UMyComponent* GetComponent() { return MyComponent; }  // ✅
```

### Auto Keyword Policy

**Epic Guideline**: "You shouldn't use auto in C++ code".

```cpp
// ❌ BAD: Using auto (ambiguous type)
auto MyVar = GetSomeValue();
auto& RefVar = GetReference();

// ✅ GOOD: Explicit type specification
float MyVar = GetSomeValue();
FVehicleStats& RefVar = GetReference();
```

**Reasons to avoid auto**:
- Reduces code readability (unclear type)
- Can cause confusion about lifetime and ownership
- Affects compile time with large projects

**Exceptions - auto is allowed**:
```cpp
// ✅ Complex template code
template<typename T>
void ProcessContainer(const T& Container)
{
    for (auto It = Container.begin(); It != Container.end(); ++It)
    {
        // Iterator type too long to write out
    }
}

// ✅ Lambda return types
auto Lambda = []() -> float { return 3.14f; };

// ✅ Range-based for loops (type clear from context)
TArray<FString> Names;
for (auto& Name : Names)  // OK: clearly FString&
{
    // ...
}
```

### Lambda Best Practices

**Epic Guideline**: "Explicit captures should be used rather than automatic capture ([&] and [=])".

```cpp
// ❌ BAD: Automatic capture
[&]() { return Health; }      // Captures all by reference
[=]() { return Health; }      // Captures all by value

// ✅ GOOD: Explicit captures
[this]() { return Health; }   // Only capture this
[Health]() { return Health; } // Only capture Health by value
[&Health]() { Health = 0; }   // Only capture Health by reference
[this, MaxHealth]() { return Health / MaxHealth; }  // Multiple explicit
```

**Reasons**:
- Clear about what is captured
- Easier to debug and maintain
- Avoid accidentally capturing unnecessary variables
- Performance: only copy/ref what is actually needed

**Real-world example**:
```cpp
void AMyClass::StartHealthRegen()
{
    float RegenRate = 10.0f;

    // ✅ GOOD: Explicit capture
    GetWorldTimerManager().SetTimer(
        RegenTimerHandle,
        [this, RegenRate]()
        {
            Health = FMath::Min(Health + RegenRate, MaxHealth);
        },
        1.0f,
        true
    );
}
```

### STL Alternatives

**Epic Requirement**: Do not use std:: types in Unreal Engine code.

**Mapping Table**:

| STL Type | Unreal Engine Alternative |
|----------|---------------------------|
| `std::vector<T>` | `TArray<T>` |
| `std::map<K, V>` | `TMap<K, V>` |
| `std::set<T>` | `TSet<T>` |
| `std::unique_ptr<T>` | `TUniquePtr<T>` |
| `std::shared_ptr<T>` | `TSharedPtr<T>` |
| `std::weak_ptr<T>` | `TWeakPtr<T>` |
| `std::string` | `FString` |
| `std::move()` | `MoveTemp()` |
| `std::forward()` | `Forward()` |
| `std::function<>` | `TFunction<>` |

**Example**:
```cpp
// ❌ BAD: Using STL
#include <vector>
#include <map>
#include <memory>

std::vector<int> Numbers;
std::map<FString, int> NameToAge;
std::unique_ptr<FData> DataPtr;

// ✅ GOOD: Using Unreal types
TArray<int32> Numbers;
TMap<FString, int32> NameToAge;
TUniquePtr<FData> DataPtr;
```

**Reasons**:
- UE disables exceptions and RTTI
- UE types have garbage collection support
- Better integration with reflection system
- Optimized for Unreal's memory management

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

**Doxygen-Style Documentation Template**:

```cpp
/**
 * @brief Calculates the vehicle's performance rating
 *
 * This function computes a normalized performance rating (0-100) based on
 * the vehicle's base statistics and any applied modifications. The rating
 * is used for matchmaking and difficulty scaling.
 *
 * @param BaseStats The base vehicle statistics (speed, handling, etc.)
 * @param Modifications Array of modifications applied to the vehicle
 * @return The calculated performance rating (0-100 scale)
 *
 * @note Performance rating is cached and only recalculated when modifications change
 * @warning Do not call this function every frame - use cached value instead
 * @see FVehicleStats, FModification, GetCachedPerformanceRating()
 */
UFUNCTION(BlueprintCallable, Category = "Vehicle|Performance")
float CalculatePerformanceRating(
    const FVehicleStats& BaseStats,
    const TArray<FModification>& Modifications
);
```

**Standard Comments**:
```cpp
// Single-line comments for implementation details
void UpdateSpeed()
{
    // Calculate new speed based on acceleration
    float NewSpeed = CurrentSpeed + (Acceleration * DeltaTime);

    // Clamp to max speed to prevent physics issues
    CurrentSpeed = FMath::Clamp(NewSpeed, 0.0f, MaxSpeed);
}

/**
 * Multi-line comment for class/function documentation
 * Should explain purpose, usage, and any important notes
 */
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
    GEngine->AddOnScreenDebugMessage(-1, 5.0f, FColor::Red,
        TEXT("Debug Message"));
}
```

### Memory Management

```cpp
// Use UPROPERTY() for UObject pointers (garbage collection)
UPROPERTY()
TObjectPtr<UVehicleComponent> VehicleComponent;

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
    TArray<TObjectPtr<AActor>> AvailableObjects;
    TArray<TObjectPtr<AActor>> ActiveObjects;
};
```

### Avoid Expensive Operations

```cpp
// BAD: Expensive operations in Tick
void Tick(float DeltaTime)
{
    TArray<AActor*> Actors;
    UGameplayStatics::GetAllActorsOfClass(GetWorld(),
        AActor::StaticClass(), Actors);
}

// GOOD: Cache results
void BeginPlay()
{
    UGameplayStatics::GetAllActorsOfClass(GetWorld(),
        AActor::StaticClass(), CachedActors);
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
UGameplayStatics::LoadStreamLevel(GetWorld(), LevelName,
    true, true, FLatentActionInfo());
```

---

## Code Review Checklist

Before submitting code, verify:

- [ ] Follows Epic C++ Coding Standard naming conventions
- [ ] Uses TObjectPtr<T> for UPROPERTY pointers (UE5)
- [ ] Avoids auto keyword (unless justified)
- [ ] Uses explicit lambda captures
- [ ] Prefers forward declarations when possible
- [ ] Proper UPROPERTY/UFUNCTION specifiers
- [ ] Includes Doxygen-style documentation comments
- [ ] Error handling implemented (check/ensure/verify)
- [ ] Memory management correct
- [ ] Performance optimized (no unnecessary Tick)
- [ ] Mobile optimization considered
- [ ] No hard-coded values (use config/data assets)
- [ ] Multiplayer considerations (if applicable)
- [ ] Code compiles without warnings
- [ ] Blueprint graphs are clean and organized
- [ ] .generated.h is LAST include in headers

---

## Conclusion

Code standards have been **fully standardized according to Epic C++ Coding Standard** ensuring:

- **Epic Guidelines Compliance**: 100% alignment with official standards
- **UE5 Ready**: Leverages TObjectPtr, enhanced features
- **Maintainability**: Easy to understand and modify
- **Performance**: Optimized for mobile platforms
- **Collaboration**: Team members can work effectively
- **Quality**: Production-ready professional code

Adherence to these standards is **mandatory** for all PrototypeRacing code.

