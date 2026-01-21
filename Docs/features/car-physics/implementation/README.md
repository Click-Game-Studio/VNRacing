---
phase: implementation
title: Car Physics - Implementation Guide README
description: Technical implementation notes, patterns, and code guidelines
feature_id: car-physics
status: development
last_updated: 2026-01-20
---

# Implementation Guide

**Breadcrumbs:** [Docs](../../../../) > [Features](../../../) > [Car Physics](../) > Implementation

**Feature ID**: `car-physics`  
**Status**: 🔄 Development  
**Version**: 1.0.0  
**Date:** 2026-01-20

## Development Setup
**How do we get started?**

- Prerequisites and dependencies
- Environment setup steps
- Configuration needed

## Code Structure
**How is the code organized?**

- Directory structure
- Module organization
- Naming conventions

## Implementation Notes
**Key technical details to remember:**

### Core Features
- Feature 1: Implementation approach
- Feature 2: Implementation approach
- Feature 3: Implementation approach

### Patterns & Best Practices
- Design patterns being used
- Code style guidelines
- Common utilities/helpers

## Integration Points
**How do pieces connect?**

- API integration details
- Database connections
- Third-party service setup

## Error Handling
**How do we handle failures?**

- Error handling strategy
- Logging approach
- Retry/fallback mechanisms

## Performance Considerations
**How do we keep it fast?**

- Optimization strategies
- Caching approach
- Query optimization
- Resource management

## Security Notes
**What security measures are in place?**

- Authentication/authorization
- Input validation
- Data encryption
- Secrets management

---

# Unreal Engine Implementation Guide

## Unreal Engine Coding Standards

### C++ Coding Standards

#### Naming Conventions
```cpp
// Classes: Prefix with A for Actors, U for Objects, F for structs, E for enums, I for interfaces
class AMyCharacter : public ACharacter { };
class UMyComponent : public UActorComponent { };
struct FMyStruct { };
enum class EMyEnum : uint8 { };
class IMyInterface { };

// Variables: PascalCase for public, camelCase for private
public:
    int32 MaxHealth;
private:
    int32 currentHealth;

// Functions: PascalCase
void CalculateDamage();

// Booleans: Prefix with 'b'
bool bIsAlive;
bool bCanJump;

// Constants: Prefix with 'k' or use UPPER_CASE
static const float kGravity = 9.81f;
```

#### Header Organization
```cpp
// MyCharacter.h
#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Character.h"
#include "MyCharacter.generated.h"

UCLASS()
class MYGAME_API AMyCharacter : public ACharacter
{
    GENERATED_BODY()

public:
    // Constructor
    AMyCharacter();

    // Public functions
    virtual void BeginPlay() override;
    virtual void Tick(float DeltaTime) override;

protected:
    // Protected functions
    void HandleDeath();

private:
    // Private functions
    void UpdateHealthUI();

public:
    // Public properties (UPROPERTY)
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Health")
    float MaxHealth;

protected:
    // Protected properties
    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category = "Health")
    float CurrentHealth;

private:
    // Private properties
    UPROPERTY()
    class UHealthComponent* HealthComponent;
};
```

### Blueprint Coding Standards

#### Graph Organization
- **Use Comments**: Group related nodes with comment boxes
- **Reroute Nodes**: Keep execution flow clean and readable
- **Functions**: Break complex logic into functions
- **Macros**: Use for frequently repeated node patterns
- **Pure Functions**: Use when no side effects

#### Variable Naming
- PascalCase for all variables
- Prefix booleans with 'b': `bIsJumping`
- Descriptive names: `PlayerHealth` not `PH`

#### Event Graph Best Practices
```
Event BeginPlay
  ├─ Initialize Components
  ├─ Setup Input Bindings
  └─ Load Saved Data

Event Tick (AVOID IF POSSIBLE)
  └─ Use Timers or Events instead
```

## Performance Best Practices

### Tick Optimization

#### Avoid Tick When Possible
```cpp
// BAD: Using Tick for periodic updates
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
```

#### Disable Tick When Not Needed
```cpp
// Disable tick by default
PrimaryActorTick.bCanEverTick = false;

// Enable only when needed
SetActorTickEnabled(true);
```

### Object Pooling

```cpp
// Object Pool for frequently spawned actors (projectiles, effects, etc.)
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

### Memory Management

#### Smart Pointers
```cpp
// Use TSharedPtr for shared ownership
TSharedPtr<FMyData> SharedData = MakeShared<FMyData>();

// Use TWeakPtr to avoid circular references
TWeakPtr<FMyData> WeakData = SharedData;

// Use TUniquePtr for exclusive ownership
TUniquePtr<FMyData> UniqueData = MakeUnique<FMyData>();
```

#### Asset References
```cpp
// AVOID: Hard references load assets immediately
UPROPERTY(EditAnywhere)
UStaticMesh* MyMesh;

// PREFER: Soft references load on demand
UPROPERTY(EditAnywhere)
TSoftObjectPtr<UStaticMesh> MyMesh;

// Load when needed
if (!MyMesh.IsValid())
{
    MyMesh.LoadSynchronous();
}
```

### Blueprint Performance

#### Nativize Critical Blueprints
- Project Settings → Packaging → Blueprint Nativization Method
- Nativize critical gameplay Blueprints
- Keep UI Blueprints non-nativized for iteration

#### Use Pure Functions
```
Pure Function (white execution pin)
  ├─ No side effects
  ├─ Can be called multiple times
  └─ Optimized by compiler

Impure Function (execution pins)
  ├─ Has side effects
  └─ Called once per execution
```

## Multiplayer Implementation (if applicable)

### Replication Setup

#### Actor Replication
```cpp
// In constructor
bReplicates = true;
bAlwaysRelevant = false; // Use distance-based relevancy
NetUpdateFrequency = 10.0f; // Updates per second
```

#### Property Replication
```cpp
// Header
UPROPERTY(Replicated)
float Health;

UPROPERTY(ReplicatedUsing = OnRep_Health)
float Health;

UFUNCTION()
void OnRep_Health();

// Source
void AMyCharacter::GetLifetimeReplicatedProps(TArray<FLifetimeProperty>& OutLifetimeProps) const
{
    Super::GetLifetimeReplicatedProps(OutLifetimeProps);
    
    DOREPLIFETIME(AMyCharacter, Health);
    DOREPLIFETIME_CONDITION(AMyCharacter, Ammo, COND_OwnerOnly);
}
```

#### RPCs (Remote Procedure Calls)
```cpp
// Server RPC: Client → Server
UFUNCTION(Server, Reliable, WithValidation)
void ServerFireWeapon();

void AMyCharacter::ServerFireWeapon_Implementation()
{
    // Server-side logic
}

bool AMyCharacter::ServerFireWeapon_Validate()
{
    return true; // Validation logic
}

// Client RPC: Server → Client
UFUNCTION(Client, Reliable)
void ClientPlayEffect();

void AMyCharacter::ClientPlayEffect_Implementation()
{
    // Client-side effect
}

// Multicast RPC: Server → All Clients
UFUNCTION(NetMulticast, Reliable)
void MulticastPlayExplosion();

void AMyCharacter::MulticastPlayExplosion_Implementation()
{
    // Play explosion on all clients
}
```

### Client Prediction
```cpp
// Predict movement on client
void AMyCharacter::MoveForward(float Value)
{
    if (Controller && Value != 0.0f)
    {
        // Local prediction
        AddMovementInput(GetActorForwardVector(), Value);
        
        // Send to server
        if (GetLocalRole() < ROLE_Authority)
        {
            ServerMoveForward(Value);
        }
    }
}
```

## Asset Pipeline

### Import Settings

#### Static Meshes
- **Collision**: Generate or import custom collision
- **LODs**: Auto-generate or import custom LODs
- **Lightmap Resolution**: Set appropriate resolution
- **Nanite**: Enable for high-poly meshes (UE5)

#### Skeletal Meshes
- **Skeleton**: Assign or create skeleton asset
- **Materials**: Import or assign materials
- **LODs**: Configure skeletal LODs
- **Physics Asset**: Generate or import

#### Textures
- **Compression**: Use appropriate compression (BC1, BC3, BC5, etc.)
- **Mip Maps**: Generate mip maps
- **sRGB**: Enable for color textures, disable for data textures
- **Texture Group**: Assign to appropriate group

### Material Creation

#### Master Materials
```
M_Master_Character
  ├─ Parameters: BaseColor, Roughness, Metallic, Normal
  ├─ Material Functions: Shared logic
  └─ Material Instances: Per-character variations
```

#### Material Instances
- Use Material Instances for variations
- Minimize unique materials
- Use Material Parameter Collections for global parameters

## Animation System

### Animation Blueprint Structure
```
Animation Blueprint (ABP_Character)
  ├─ AnimGraph
  │   ├─ State Machine (Locomotion)
  │   │   ├─ Idle
  │   │   ├─ Walk
  │   │   ├─ Run
  │   │   └─ Jump
  │   └─ Layered Blend (Upper Body)
  ├─ EventGraph
  │   └─ Update Variables
  └─ Functions
      └─ Calculate Speed, Direction, etc.
```

### Animation Montages
- Use for one-shot animations (attacks, abilities)
- Set up notify events for gameplay triggers
- Configure blend in/out times

## UI Implementation

### Widget Blueprint Structure
```cpp
// C++ Base Class
UCLASS()
class UMyUserWidget : public UUserWidget
{
    GENERATED_BODY()

public:
    UFUNCTION(BlueprintImplementableEvent)
    void UpdateHealth(float NewHealth);

protected:
    virtual void NativeConstruct() override;
    virtual void NativeTick(const FGeometry& MyGeometry, float InDeltaTime) override;
};
```

### UMG Best Practices
- **Anchors**: Set proper anchors for responsive design
- **Canvas Panel**: Use sparingly, prefer other panels
- **Invalidation Box**: Use to optimize UI updates
- **Event-Driven**: Update UI via events, not Tick

## Debugging & Profiling

### Debug Commands
```cpp
// Console commands for debugging
stat fps          // Show FPS
stat unit         // Show frame time breakdown
stat game         // Show game thread stats
stat gpu          // Show GPU stats
stat memory       // Show memory usage
stat streaming    // Show asset streaming

// Custom debug commands
UFUNCTION(Exec)
void DebugHealth();
```

### Visual Debugging
```cpp
// Draw debug shapes
DrawDebugLine(GetWorld(), Start, End, FColor::Red, false, 1.0f);
DrawDebugSphere(GetWorld(), Location, Radius, 12, FColor::Green);
DrawDebugBox(GetWorld(), Center, Extent, FColor::Blue);

// Print to screen
GEngine->AddOnScreenDebugMessage(-1, 5.0f, FColor::Yellow, TEXT("Debug Message"));

// Log to output
UE_LOG(LogTemp, Warning, TEXT("Health: %f"), Health);
```

### Profiling Tools
- **Unreal Insights**: Comprehensive profiling (UE5)
- **Session Frontend**: Network profiling
- **GPU Visualizer**: GPU performance analysis
- **Memory Profiler**: Memory usage analysis

## Testing in Editor

### Play-in-Editor (PIE)
- **Number of Players**: Test multiplayer locally
- **Dedicated Server**: Test with dedicated server
- **Network Emulation**: Simulate latency and packet loss

### Automation Testing
```cpp
// Functional test
IMPLEMENT_SIMPLE_AUTOMATION_TEST(FMyTest, "Game.MyTest", EAutomationTestFlags::ApplicationContextMask | EAutomationTestFlags::ProductFilter)

bool FMyTest::RunTest(const FString& Parameters)
{
    // Test logic
    TestTrue("Health should be positive", Health > 0);
    return true;
}
```

