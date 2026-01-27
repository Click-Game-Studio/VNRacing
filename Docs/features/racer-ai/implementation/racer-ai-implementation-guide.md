---
phase: implementation
title: Racer AI Implementation Guide
description: Implementation notes, code patterns, and integration guidelines for Racer AI system
---

# Racer AI Implementation Guide - VNRacing

**Project**: PrototypeRacing - Mobile Racing Game

**Document**: Racer AI Implementation Guide

**Version**: 1.0

**Date**: 2025-11-12

**Status**: Ready for Development

---

## Implementation Overview

This guide provides implementation details for the Racer AI V5 system based on:
- **Requirements**: `Racer_AI_V5.md`
- **Architecture**: `racer-ai-architecture.md`
- **Planning**: `racer-ai-implementation-plan.md`

**Key Implementation Principles**:
1. **Component-Based**: Use UActorComponent for modularity
2. **Event-Driven**: Minimize Tick usage, prefer timers
3. **Data-Driven**: All tuning in Data Assets
4. **Mobile-Optimized**: Distance-based LOD, efficient updates
5. **Backward Compatible**: Don't break existing AI functionality

---

## Existing Code Reuse

### 1. SimulatePhysicsCar (Enhanced)

**Current AI Functions** (Already Implemented):
```cpp
// Location: Plugins/SimpleCarPhysics/Source/SimpleCarPhysics/Private/PhysicsSimulateCar/SimulatePhysicsCar.cpp

FRotator FindDirectionAI(float Distance);
float CalculatePIDSteering(float Error, float DeltaTime);
void AutoDrive(float DeltaTime);
void ApplyRubberBandTuning(float DeltaTime);
```

**Enhancements Needed**:
- Add component references for new AI systems
- Expose functions for component callbacks
- Maintain backward compatibility

### 2. GuideLineSubsystem (Enhanced)

**Current Functions**:
```cpp
USplineComponent* GetGuideLine();
FVector GetClosestPosition(FVector Location);
FRotator GetDirection(FVector Location, float Distance);
```

**Enhancements Needed**:
- Support multiple racing lines (Main/Inside/Outside)
- Add lane offset management

### 3. AIManagerSubsystem (Enhanced)

**Current Functions**:
```cpp
void RegisterAICar(ASimulatePhysicsCar* AICar);
void ConfigAiCarPerformance(ASimulatePhysicsCar* AICar);
```

**Enhancements Needed**:
- Assign difficulty profiles
- Generate AI names
- Coordinate rubber banding

---

## New Components

### 1. AIDecisionComponent

**Purpose**: AI decision tree and state machine

**Key Functions**:
```cpp
void UpdateDecisionTree(float DeltaTime);
bool CheckOvertakeOpportunity(AActor*& OutTarget);
bool CheckDefenceNeed(AActor*& OutThreat);
void TransitionToState(EAIDecisionState NewState);
```

**State Machine**:
- NormalDriving → CheckingConditions → Overtaking/Defending/AvoidingObstacle
- Global Cooldown (3-5s) between skills

### 2. AIOvertakeController

**Purpose**: Overtake and defence maneuvers

**Key Functions**:
```cpp
bool TryInitiateOvertake(AActor* Target);
void UpdateOvertake(float DeltaTime);
USplineComponent* SelectOvertakeLine(AActor* Target);
bool RollActivationChance(float Probability);
```

**Overtake Flow**:
1. Check speed differential (AI > Target)
2. Roll probability (20%/50%/80% based on difficulty)
3. Select clear racing line (Inside/Outside)
4. Apply 120% speed boost for 3 seconds
5. Retry once if failed

### 3. RacingLineManager

**Purpose**: Manage 3 racing lines per track

**Key Functions**:
```cpp
USplineComponent* GetRacingLine(ERacingLineType LineType);
USplineComponent* GetOptimalLineForOvertake(AActor* Target);
int32 AssignLaneOffset(AActor* Vehicle);
float CalculateRacingLineOffset();
```

**Racing Line Types**:
- Main: Default racing line
- Inside: For inside overtakes
- Outside: For outside overtakes

### 4. RubberBandingComponent

**Purpose**: Dynamic difficulty adjustment

**Key Functions**:
```cpp
void UpdateRubberBanding(float DeltaTime);
float CalculatePerformanceScale(float DistanceToPlayer);
void DisableTemporarily(float Duration);
```

**Scaling Logic**:
- Far behind (>7000): 130% performance
- Far ahead (<-7000): 80% performance
- Within range: Linear interpolation
- Disabled first 10 seconds and during crash

---

## Data Structures

### Difficulty Profile

```cpp
USTRUCT(BlueprintType)
struct FAIDifficultyProfile
{
    GENERATED_BODY()
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    EAIDifficulty DifficultyLevel;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    float PerformanceScaleFactor; // 0.9 / 1.0 / 1.1
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    float OvertakeProbability; // 0.2 / 0.5 / 0.8
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    float DefenceProbability; // 0.4 / 0.7 / 0.9
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    float ReactionTime; // Seconds
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    float RacingLineOffset; // Max offset (cm)
};
```

### Racing Line Set

```cpp
USTRUCT(BlueprintType)
struct FRacingLineSet
{
    GENERATED_BODY()
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    USplineComponent* MainLine;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    USplineComponent* InsideLine;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    USplineComponent* OutsideLine;
};
```

---

## Integration Points

### SimulatePhysicsCar Integration

**Add to BeginPlay()**:
```cpp
if (bIsAICar)
{
    // Create AI components
    DecisionComponent = NewObject<UAIDecisionComponent>(this);
    DecisionComponent->RegisterComponent();
    
    OvertakeController = NewObject<UAIOvertakeController>(this);
    OvertakeController->RegisterComponent();
    
    RubberBanding = NewObject<URubberBandingComponent>(this);
    RubberBanding->RegisterComponent();
    
    // Set up timer for decision updates (not Tick)
    GetWorld()->GetTimerManager().SetTimer(
        DecisionUpdateTimer,
        [this]() { DecisionComponent->UpdateDecisionTree(0.1f); },
        0.1f,  // 10 Hz
        true
    );
}
```

### AIManagerSubsystem Integration

**Assign Difficulty on Spawn**:
```cpp
void UAIManagerSubsystem::RegisterAICar(ASimulatePhysicsCar* AICar)
{
    AICarsManager.Add(AICar);
    
    // Assign difficulty profile
    FAIDifficultyProfile Profile = GetProfileForTrackDifficulty();
    AICar->DecisionComponent->SetDifficultyProfile(Profile);
    
    // Generate AI name
    FString AIName = GenerateAIName(Profile.DifficultyLevel);
    AICar->SetAIName(AIName);
    
    // Configure performance
    ConfigAiCarPerformance(AICar);
}
```

---

## Mobile Optimization

### Distance-Based Update Frequency

```cpp
float GetAIUpdateFrequency(float DistanceToPlayer)
{
    if (DistanceToPlayer < 2000.0f)
        return 0.05f;  // 20 Hz (close)
    else if (DistanceToPlayer < 5000.0f)
        return 0.1f;   // 10 Hz (medium)
    else
        return 0.2f;   // 5 Hz (far)
}
```

### Event-Driven Updates

**Use Timers Instead of Tick**:
```cpp
// DON'T: Update every frame
void Tick(float DeltaTime)
{
    UpdateDecisionTree(DeltaTime);  // BAD for mobile
}

// DO: Use timer with dynamic frequency
void BeginPlay()
{
    UpdateTimerFrequency();
}

void UpdateTimerFrequency()
{
    float Frequency = GetAIUpdateFrequency(DistanceToPlayer);
    GetWorld()->GetTimerManager().SetTimer(
        DecisionUpdateTimer,
        this,
        &UAIDecisionComponent::UpdateDecisionTree,
        Frequency,
        true
    );
}
```

### Caching and Optimization

```cpp
// Cache expensive calculations
FVector CachedPlayerPosition;
float CachedDistanceToPlayer;
float CacheUpdateInterval = 0.5f; // Update cache every 0.5s

void UpdateCache()
{
    CachedPlayerPosition = GetPlayerPosition();
    CachedDistanceToPlayer = FVector::Dist(GetActorLocation(), CachedPlayerPosition);
}
```

---

## Code Patterns

### Probability-Based Activation

```cpp
bool RollActivationChance(float Probability)
{
    return FMath::FRand() <= Probability;
}

// Usage
if (RollActivationChance(DifficultyProfile.OvertakeProbability))
{
    TryInitiateOvertake(Target);
}
```

### State Transition Pattern

```cpp
void TransitionToState(EAIDecisionState NewState)
{
    if (CurrentState == NewState) return;
    
    // Exit current state
    OnExitState(CurrentState);
    
    // Update state
    EAIDecisionState OldState = CurrentState;
    CurrentState = NewState;
    
    // Enter new state
    OnEnterState(NewState);
    
    // Broadcast event
    OnStateChanged.Broadcast(NewState);
    
    UE_LOG(LogAI, Log, TEXT("AI State: %s -> %s"), 
        *UEnum::GetValueAsString(OldState),
        *UEnum::GetValueAsString(NewState));
}
```

---

## Testing Hooks

### Debug Visualization

```cpp
#if !UE_BUILD_SHIPPING
void DrawDebugInfo()
{
    // Draw current state
    DrawDebugString(GetWorld(), GetActorLocation() + FVector(0, 0, 200),
        UEnum::GetValueAsString(CurrentState), nullptr, FColor::Yellow, 0.0f);
    
    // Draw racing line
    if (CurrentRacingLine)
    {
        DrawDebugLine(GetWorld(), GetActorLocation(),
            CurrentRacingLine->GetLocationAtDistanceAlongSpline(1000.0f, ESplineCoordinateSpace::World),
            FColor::Green, false, 0.1f, 0, 2.0f);
    }
}
#endif
```

### Console Commands

```cpp
// Add to AIDecisionComponent
static FAutoConsoleCommand CVarToggleAIDebug(
    TEXT("AI.ToggleDebug"),
    TEXT("Toggle AI debug visualization"),
    FConsoleCommandDelegate::CreateStatic(&UAIDecisionComponent::ToggleDebug)
);
```

---

## Summary

**Implementation Checklist**:
- [ ] Create 4 new components (Decision, Overtake, RacingLine, RubberBanding)
- [ ] Enhance 3 existing systems (SimulatePhysicsCar, GuideLineSubsystem, AIManagerSubsystem)
- [ ] Create 5 Data Assets (3 difficulty profiles, 1 name table, 1 rubber band config)
- [ ] Implement mobile optimizations (distance-based LOD, timers)
- [ ] Add debug visualization tools
- [ ] Write unit tests for decision logic

**Next Steps**: Proceed to Testing phase to define test strategy.

