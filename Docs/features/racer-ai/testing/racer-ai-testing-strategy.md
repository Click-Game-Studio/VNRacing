---
phase: testing
title: Racer AI Testing Strategy
description: Comprehensive testing strategy for Racer AI system including unit, integration, and performance tests
---

# Racer AI Testing Strategy - VNRacing

**Project**: PrototypeRacing - Mobile Racing Game

**Document**: Racer AI Testing Strategy

**Version**: 1.0

**Date**: 2025-11-12

**Status**: Ready for Testing

---

## Testing Overview

This document defines the testing strategy for Racer AI V5 to ensure:
- **Functionality**: All AI behaviors work as specified
- **Performance**: Meets 30 FPS target on mobile with 8 AI
- **Balance**: Difficulty profiles provide appropriate challenge
- **Reliability**: No crashes, stuck AI, or edge case failures

**Testing Levels**:
1. **Unit Tests**: Individual component logic
2. **Integration Tests**: Component interactions
3. **Performance Tests**: FPS, CPU usage
4. **Gameplay Tests**: Balance, fun factor, difficulty

---

## Unit Tests

### 1. AIDecisionComponent Tests

**Test File**: `AIDecisionComponent.spec.cpp`

#### Test Cases

**TC-DEC-001: State Transitions**
```cpp
TEST(AIDecisionComponent, StateTransitions)
{
    // Setup
    UAIDecisionComponent* Component = NewObject<UAIDecisionComponent>();
    
    // Test: NormalDriving -> CheckingConditions
    Component->TransitionToState(EAIDecisionState::CheckingConditions);
    EXPECT_EQ(Component->GetCurrentState(), EAIDecisionState::CheckingConditions);
    
    // Test: CheckingConditions -> Overtaking
    Component->TransitionToState(EAIDecisionState::Overtaking);
    EXPECT_EQ(Component->GetCurrentState(), EAIDecisionState::Overtaking);
    
    // Test: Overtaking -> GlobalCooldown
    Component->TransitionToState(EAIDecisionState::GlobalCooldown);
    EXPECT_EQ(Component->GetCurrentState(), EAIDecisionState::GlobalCooldown);
    EXPECT_TRUE(Component->IsInCooldown());
}
```

**TC-DEC-002: Global Cooldown**
```cpp
TEST(AIDecisionComponent, GlobalCooldown)
{
    UAIDecisionComponent* Component = NewObject<UAIDecisionComponent>();
    
    // Activate skill
    Component->ActivateSkill(EAISkillType::Overtake);
    EXPECT_TRUE(Component->IsInCooldown());
    
    // Wait for Cooldown (3-5 seconds)
    Component->UpdateDecisionTree(5.0f);
    EXPECT_FALSE(Component->IsInCooldown());
}
```

**TC-DEC-003: Probability Checks**
```cpp
TEST(AIDecisionComponent, ProbabilityActivation)
{
    UAIDecisionComponent* Component = NewObject<UAIDecisionComponent>();
    
    // Test 100% probability (should always succeed)
    int SuccessCount = 0;
    for (int i = 0; i < 100; i++)
    {
        if (Component->RollActivationChance(1.0f)) SuccessCount++;
    }
    EXPECT_EQ(SuccessCount, 100);
    
    // Test 0% probability (should always fail)
    SuccessCount = 0;
    for (int i = 0; i < 100; i++)
    {
        if (Component->RollActivationChance(0.0f)) SuccessCount++;
    }
    EXPECT_EQ(SuccessCount, 0);
    
    // Test 50% probability (should be approximately 50)
    SuccessCount = 0;
    for (int i = 0; i < 1000; i++)
    {
        if (Component->RollActivationChance(0.5f)) SuccessCount++;
    }
    EXPECT_NEAR(SuccessCount, 500, 50); // Allow 10% variance
}
```

### 2. AIOvertakeController Tests

**TC-OVT-001: Overtake Initiation**
```cpp
TEST(AIOvertakeController, OvertakeInitiation)
{
    UAIOvertakeController* Controller = NewObject<UAIOvertakeController>();
    AActor* Target = CreateMockVehicle(100.0f); // 100 km/h
    
    // AI faster than target
    Controller->SetOwnerSpeed(120.0f);
    EXPECT_TRUE(Controller->CanOvertake(Target));
    
    // AI slower than target
    Controller->SetOwnerSpeed(80.0f);
    EXPECT_FALSE(Controller->CanOvertake(Target));
}
```

**TC-OVT-002: Racing Line Selection**
```cpp
TEST(AIOvertakeController, RacingLineSelection)
{
    UAIOvertakeController* Controller = NewObject<UAIOvertakeController>();
    AActor* Target = CreateMockVehicle();
    
    // Target on Main line -> AI should choose Inside or Outside
    Target->SetCurrentLine(ERacingLineType::Main);
    USplineComponent* SelectedLine = Controller->SelectOvertakeLine(Target);
    EXPECT_NE(SelectedLine->GetLineType(), ERacingLineType::Main);
}
```

### 3. RubberBandingComponent Tests

**TC-RUB-001: Performance Scaling**
```cpp
TEST(RubberBandingComponent, PerformanceScaling)
{
    URubberBandingComponent* Component = NewObject<URubberBandingComponent>();
    
    // Far behind player (>7000 units) -> 130% performance
    float Scale = Component->CalculatePerformanceScale(8000.0f);
    EXPECT_FLOAT_EQ(Scale, 1.3f);
    
    // Far ahead of player (<-7000 units) -> 80% performance
    Scale = Component->CalculatePerformanceScale(-8000.0f);
    EXPECT_FLOAT_EQ(Scale, 0.8f);
    
    // Within range -> Linear interpolation
    Scale = Component->CalculatePerformanceScale(0.0f);
    EXPECT_NEAR(Scale, 1.05f, 0.1f);
}
```

**TC-RUB-002: Crash Recovery**
```cpp
TEST(RubberBandingComponent, CrashRecovery)
{
    URubberBandingComponent* Component = NewObject<URubberBandingComponent>();
    
    // Simulate crash (speed = 0)
    Component->OnVehicleCrashed();
    EXPECT_FALSE(Component->ShouldApplyRubberBanding());
    
    // Recover (speed > 100 km/h)
    Component->OnVehicleRecovered(120.0f);
    EXPECT_TRUE(Component->ShouldApplyRubberBanding());
}
```

---

## Integration Tests

### 1. Full AI Race Test

**TC-INT-001: 8 AI Race**
```cpp
TEST(RacerAI, FullRaceWith8AI)
{
    // Setup race with 8 AI
    TArray<ASimulatePhysicsCar*> AICars;
    for (int i = 0; i < 8; i++)
    {
        AICars.Add(SpawnAICar());
    }
    
    // Run race for 2 minutes
    RunRaceSimulation(120.0f);
    
    // Verify all AI completed race
    for (auto AI : AICars)
    {
        EXPECT_TRUE(AI->HasFinishedRace());
        EXPECT_GT(AI->GetLapCount(), 0);
    }
}
```

### 2. Overtake Integration Test

**TC-INT-002: Overtake Behavior**
```cpp
TEST(RacerAI, OvertakeBehavior)
{
    // Setup: Fast AI behind slow AI
    ASimulatePhysicsCar* FastAI = SpawnAICar(EAIDifficulty::Hard);
    ASimulatePhysicsCar* SlowAI = SpawnAICar(EAIDifficulty::Easy);
    
    // Position slow AI ahead
    SlowAI->SetActorLocation(FVector(1000, 0, 0));
    FastAI->SetActorLocation(FVector(0, 0, 0));
    
    // Run simulation
    RunSimulation(10.0f);
    
    // Verify fast AI attempted overtake
    EXPECT_TRUE(FastAI->DecisionComponent->HasAttemptedOvertake());
    
    // Verify fast AI is now ahead
    EXPECT_GT(FastAI->GetDistanceAlongTrack(), SlowAI->GetDistanceAlongTrack());
}
```

### 3. Difficulty Profile Test

**TC-INT-003: Difficulty Differences**
```cpp
TEST(RacerAI, DifficultyProfiles)
{
    // Spawn AI with different difficulties
    ASimulatePhysicsCar* EasyAI = SpawnAICar(EAIDifficulty::Easy);
    ASimulatePhysicsCar* HardAI = SpawnAICar(EAIDifficulty::Hard);
    
    // Run race
    RunRaceSimulation(60.0f);
    
    // Verify Hard AI is faster
    EXPECT_GT(HardAI->GetAverageSpeed(), EasyAI->GetAverageSpeed());
    
    // Verify Hard AI overtakes more
    EXPECT_GT(HardAI->GetOvertakeCount(), EasyAI->GetOvertakeCount());
}
```

---

## Performance Tests

### 1. Frame Rate Test

**TC-PERF-001: 30 FPS with 8 AI**
```cpp
TEST(RacerAI, FrameRateTarget)
{
    // Spawn 8 AI
    for (int i = 0; i < 8; i++)
    {
        SpawnAICar();
    }
    
    // Measure FPS over 60 seconds
    float AverageFPS = MeasureFPS(60.0f);
    
    // Verify 30 FPS minimum
    EXPECT_GE(AverageFPS, 30.0f);
}
```

### 2. CPU Usage Test

**TC-PERF-003: CPU Budget**
```cpp
TEST(RacerAI, CPUUsage)
{
    // Spawn 8 AI
    for (int i = 0; i < 8; i++)
    {
        SpawnAICar();
    }
    
    // Measure AI CPU time
    float AICPUTime = MeasureAICPUTime(60.0f);
    float FrameTime = 1000.0f / 30.0f; // 33.33ms at 30 FPS
    
    // Verify <15% of frame budget
    EXPECT_LT(AICPUTime, FrameTime * 0.15f);
}
```

---

## Gameplay Tests

### 1. Difficulty Balance Test

**Manual Test**: Race against each difficulty level

**Test Steps**:
1. Race against 7 Easy AI
2. Race against 7 Medium AI
3. Race against 7 Hard AI

**Success Criteria**:
- Easy AI: Player should win easily (1st-2nd place)
- Medium AI: Competitive race (1st-4th place)
- Hard AI: Challenging race (1st-5th place)

### 2. Rubber Banding Test

**Manual Test**: Test Rubber Banding effectiveness

**Test Steps**:
1. Race normally and stay in middle of pack
2. Intentionally fall far behind (>7000 units)
3. Intentionally get far ahead (>7000 units)

**Success Criteria**:
- When far behind: AI slows down, player can catch up
- When far ahead: AI speeds up, stays competitive
- Rubber Banding feels fair, not artificial

### 3. Overtake Frequency Test

**Manual Test**: Observe overtake behaviors

**Test Steps**:
1. Race with 8 AI for 5 laps
2. Count overtake attempts per difficulty

**Success Criteria**:
- Easy AI: approximately 2-3 overtakes per race
- Medium AI: approximately 5-7 overtakes per race
- Hard AI: approximately 10-15 overtakes per race

---

## PIE (Play In Editor) Testing

### Test Scenarios

**Scenario 1: Normal Race**
- 8 AI, mixed difficulties
- 3 laps
- Verify all AI complete race

**Scenario 2: Crash Recovery**
- Force AI to crash
- Verify AI recovers and continues

**Scenario 3: Racing Line Variety**
- Enable debug visualization
- Verify AI use all 3 racing lines

**Scenario 4: First 10 Seconds**
- Verify Rubber Banding disabled
- Verify AI don't get unfair advantage at start

---

## Mobile Device Testing

### Target Devices

| Device | OS | Specs | Target FPS |
|--------|----|----|-----------|
| Samsung Galaxy A52 | Android 12 | Snapdragon 720G, 6GB RAM | 30 FPS |
| iPhone 11 | iOS 16 | A13 Bionic, 4GB RAM | 30 FPS |
| Xiaomi Redmi Note 10 | Android 11 | Snapdragon 678, 4GB RAM | 30 FPS |

### Test Checklist

- [ ] 30 FPS stable with 8 AI
- [ ] No frame drops during overtakes
- [ ] Battery drain acceptable (<10%/hour)
- [ ] No overheating issues

---

## Regression Testing

### Critical Features to Verify

- [ ] Existing AI still works with Main racing line
- [ ] Player vehicle physics unchanged
- [ ] Car customization system unaffected
- [ ] Race UI displays correctly
- [ ] Leaderboard/results accurate

---

## Test Coverage Goals

| Component | Target Coverage |
|-----------|----------------|
| AIDecisionComponent | 90% |
| AIOvertakeController | 85% |
| RacingLineManager | 80% |
| RubberBandingComponent | 85% |
| Integration Tests | 100% of critical paths |

---

## Summary

**Testing Checklist**:
- [ ] All unit tests passing (30+ tests)
- [ ] Integration tests passing (10+ scenarios)
- [ ] Performance targets met (30 FPS, <15% CPU)
- [ ] Gameplay balanced and fun
- [ ] Mobile device testing complete
- [ ] No regressions in existing features

**Next Steps**: Execute tests during implementation and iterate based on results.

