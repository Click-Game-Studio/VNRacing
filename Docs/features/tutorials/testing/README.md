---
phase: testing
title: Tutorial System Testing Strategy
description: Comprehensive testing approach including unit tests, integration tests, manual testing, and debug tools
---

# Tutorial System Testing Strategy

## Testing Approach

### Testing Philosophy
- **Target**: 100% coverage of tutorial trigger conditions, steps, and tooltips
- **Strategy**: Simple, direct test cases following anti-overengineering principles
- **Tools**: UE5 built-in automation framework, manual testing on target devices
- **Focus**: Functional correctness, mobile performance, user experience

### Test Pyramid

```
        /\
       /  \  Manual Testing (UX, Edge Cases)
      /____\
     /      \  Integration Tests (Tutorial Flows)
    /________\
   /          \  Unit Tests (Subsystem Logic)
  /__________  \
```

## Unit Test Cases

### UTutorialManagerSubsystem Tests

**Test Suite**: `TutorialManagerSubsystemTest.cpp`

#### Test 1: Subsystem Initialization
```cpp
IMPLEMENT_SIMPLE_AUTOMATION_TEST(FTutorialManagerInitTest, 
    "PrototypeRacing.Tutorial.Subsystem.Initialize", 
    EAutomationTestFlags::ApplicationContextMask | EAutomationTestFlags::ProductFilter)

bool FTutorialManagerInitTest::RunTest(const FString& Parameters)
{
    // Arrange
    UGameInstance* GameInstance = NewObject<UGameInstance>();
    
    // Act
    UTutorialManagerSubsystem* TutorialMgr = GameInstance->GetSubsystem<UTutorialManagerSubsystem>();
    
    // Assert
    TestNotNull("Subsystem should be created", TutorialMgr);
    TestEqual("No tutorials completed initially", TutorialMgr->IsTutorialCompleted(ETutorialID::BasicControls1), false);
    
    return true;
}
```

#### Test 2: Mark Tutorial Completed
```cpp
IMPLEMENT_SIMPLE_AUTOMATION_TEST(FTutorialMarkCompletedTest, 
    "PrototypeRacing.Tutorial.Subsystem.MarkCompleted", 
    EAutomationTestFlags::ApplicationContextMask | EAutomationTestFlags::ProductFilter)

bool FTutorialMarkCompletedTest::RunTest(const FString& Parameters)
{
    // Arrange
    UTutorialManagerSubsystem* TutorialMgr = GetSubsystem();
    
    // Act
    TutorialMgr->MarkTutorialCompleted(ETutorialID::BasicControls1);
    
    // Assert
    TestTrue("Tutorial should be marked completed", TutorialMgr->IsTutorialCompleted(ETutorialID::BasicControls1));
    TestFalse("Other tutorials should not be completed", TutorialMgr->IsTutorialCompleted(ETutorialID::BasicControls2));
    
    return true;
}
```

#### Test 3: Save/Load Round-Trip
```cpp
IMPLEMENT_SIMPLE_AUTOMATION_TEST(FTutorialSaveLoadTest, 
    "PrototypeRacing.Tutorial.Subsystem.SaveLoad", 
    EAutomationTestFlags::ApplicationContextMask | EAutomationTestFlags::ProductFilter)

bool FTutorialSaveLoadTest::RunTest(const FString& Parameters)
{
    // Arrange
    UTutorialManagerSubsystem* TutorialMgr = GetSubsystem();
    TutorialMgr->MarkTutorialCompleted(ETutorialID::BasicControls1);
    TutorialMgr->MarkTutorialCompleted(ETutorialID::VnTourMap);
    
    // Act - Save
    TutorialMgr->SaveTutorialProgress();
    
    // Act - Reset and Load
    TutorialMgr->ResetTutorials();
    TestFalse("Tutorial should be reset", TutorialMgr->IsTutorialCompleted(ETutorialID::BasicControls1));
    
    TutorialMgr->LoadTutorialProgress();
    
    // Assert
    TestTrue("BasicControls1 should be loaded", TutorialMgr->IsTutorialCompleted(ETutorialID::BasicControls1));
    TestTrue("VnTourMap should be loaded", TutorialMgr->IsTutorialCompleted(ETutorialID::VnTourMap));
    TestFalse("BasicControls2 should not be loaded", TutorialMgr->IsTutorialCompleted(ETutorialID::BasicControls2));
    
    return true;
}
```

#### Test 4: Tooltip Spam Prevention
```cpp
IMPLEMENT_SIMPLE_AUTOMATION_TEST(FTooltipSpamPreventionTest, 
    "PrototypeRacing.Tutorial.Subsystem.TooltipSpam", 
    EAutomationTestFlags::ApplicationContextMask | EAutomationTestFlags::ProductFilter)

bool FTooltipSpamPreventionTest::RunTest(const FString& Parameters)
{
    // Arrange
    UTutorialManagerSubsystem* TutorialMgr = GetSubsystem();
    
    // Act - Show tooltip twice
    TutorialMgr->ShowTooltip(ETooltipType::UpgradeAvailable, FText::FromString("Test"));
    int32 FirstCallWidgetCount = GetActiveTooltipCount();
    
    TutorialMgr->ShowTooltip(ETooltipType::UpgradeAvailable, FText::FromString("Test"));
    int32 SecondCallWidgetCount = GetActiveTooltipCount();
    
    // Assert
    TestEqual("First call should show tooltip", FirstCallWidgetCount, 1);
    TestEqual("Second call should not show duplicate", SecondCallWidgetCount, 1);
    
    return true;
}
```

## Integration Test Scenarios

### Scenario 1: Script Tutorial Activation on Race Start

**Test**: Basic Controls 1 triggers on first race, first curve approach

**Setup**:
1. Create test level with race track
2. Reset tutorial completion state
3. Start race as new player

**Steps**:
1. Trigger race start event
2. Move player vehicle to first curve (distance < 50m)
3. Wait for tutorial widget to appear

**Expected Results**:
- ✅ Tutorial widget appears when approaching first curve
- ✅ Time dilation applied (0.3x speed)
- ✅ All controls locked except steering
- ✅ Screen mask visible with cutout for steering control
- ✅ Panel displays correct text and image

**Cleanup**: Reset tutorial state, restore normal speed

### Scenario 2: Control Locking During Tutorial

**Test**: Only highlighted control responds to input during tutorial

**Setup**:
1. Trigger Basic Controls 1 tutorial
2. Advance to step highlighting "Drift" control

**Steps**:
1. Attempt to steer left/right (should be locked)
2. Attempt to use NOS (should be locked)
3. Attempt to drift (should work)

**Expected Results**:
- ✅ Steering input ignored
- ✅ NOS input ignored
- ✅ Drift input processed
- ✅ Tutorial advances to next step after drift

### Scenario 3: Auto-Dismiss Timer

**Test**: Tutorial step auto-dismisses after configured duration

**Setup**:
1. Trigger tutorial with 2-second auto-dismiss
2. Do not perform any input

**Steps**:
1. Wait 2 seconds
2. Observe tutorial behavior

**Expected Results**:
- ✅ Tutorial advances to next step after 2 seconds
- ✅ No input required
- ✅ Timer resets for next step

### Scenario 4: Tooltip Display and Dismissal

**Test**: Tooltip shows and auto-dismisses after 10 seconds

**Setup**:
1. Trigger "Upgrade Available" tooltip

**Steps**:
1. Observe tooltip appearance
2. Wait 10 seconds
3. Observe tooltip dismissal

**Expected Results**:
- ✅ Tooltip appears with correct icon and text
- ✅ Tooltip positioned at top-center of screen
- ✅ Tooltip fades in smoothly
- ✅ Tooltip auto-dismisses after 10 seconds
- ✅ Tooltip fades out smoothly
- ✅ Tooltip returns to pool (not destroyed)

### Scenario 5: Save/Load Persistence

**Test**: Tutorial completion persists across game sessions

**Setup**:
1. Complete Basic Controls 1 tutorial
2. Save game
3. Exit and restart game

**Steps**:
1. Load save game
2. Start first race again
3. Approach first curve

**Expected Results**:
- ✅ Tutorial does not re-trigger
- ✅ Completion state loaded correctly
- ✅ Game continues normally without tutorial

## Manual Testing Procedures

### Procedure 1: Complete All Tutorial Scripts

**Objective**: Verify all 6 tutorial scripts work correctly

**Steps**:
1. Reset all tutorials (`ResetTutorials` console command)
2. Start new game
3. Complete Basic Controls 1 (8 steps)
4. Complete Basic Controls 2 (2 steps)
5. Complete VnTourMap (5 steps)
6. Complete Basic Car Upgrade (pending details)
7. Complete Advanced Car Upgrade (pending details)
8. Complete Basic Car Customize (pending details)

**Checklist**:
- [ ] All tutorial steps display correct text and images
- [ ] Control highlighting works for each step
- [ ] Screen mask cutout reveals correct control
- [ ] Auto-dismiss timing feels appropriate
- [ ] Slow motion (0.3x) is smooth and playable
- [ ] Normal speed restored after tutorial
- [ ] Tutorial completion saved correctly

### Procedure 2: Test All Tooltip Types

**Objective**: Verify all 3 tooltip types trigger correctly

**Steps**:
1. Trigger "New Car Upgrade Available" (unlock upgrade)
2. Trigger "You Are Out Of Fuel" (deplete fuel)
3. Trigger "New Items Available In Shop" (unlock shop item)

**Checklist**:
- [ ] Tooltip appears with correct icon
- [ ] Tooltip text is correct and readable
- [ ] Tooltip positioned correctly (top-center)
- [ ] Tooltip auto-dismisses after 10 seconds
- [ ] Tooltip does not show twice in same session

### Procedure 3: Edge Case Testing

**Objective**: Test tutorial behavior in unusual situations

**Test Cases**:
1. **Rapid Input**: Spam controls during tutorial
   - Expected: Tutorial handles input gracefully, no crashes
2. **Tutorial Interruption**: Pause game during tutorial
   - Expected: Tutorial pauses, resumes correctly
3. **App Minimize**: Minimize app during tutorial
   - Expected: Normal speed restored, tutorial state preserved
4. **Low Battery Mode**: Enable low battery mode during tutorial
   - Expected: Tutorial still playable, performance acceptable
5. **Tutorial Skip**: Wait 60 seconds without input
   - Expected: Tutorial offers skip option (if implemented)

## Debug Tools

### Console Commands

#### ResetTutorials
**Usage**: `ResetTutorials`

**Description**: Clears all tutorial completion flags and save data

**Example**:
```
> ResetTutorials
Tutorial completion state reset. All tutorials will re-trigger.
```

#### TriggerTutorial
**Usage**: `TriggerTutorial <TutorialName>`

**Description**: Force trigger specific tutorial regardless of completion state

**Example**:
```
> TriggerTutorial BasicControls1
Triggering tutorial: BasicControls1
```

#### ShowTutorialDebug
**Usage**: `ShowTutorialDebug`

**Description**: Display all tutorial completion states in console

**Example**:
```
> ShowTutorialDebug
Tutorial Completion State:
- BasicControls1: Completed
- BasicControls2: Not Completed
- VnTourMap: Completed
- BasicCarUpgrade: Not Completed
```

## Coverage Targets

### Code Coverage
- **Target**: 100% of tutorial trigger conditions
- **Target**: 100% of tutorial step logic
- **Target**: 100% of tooltip display logic
- **Target**: 100% of save/load logic

### Functional Coverage
- **6 Tutorial Scripts**: All steps tested
- **3 Tooltip Types**: All triggers tested
- **Edge Cases**: Interruption, rapid input, skip behavior

## Test Execution Plan

### Phase 1: Unit Tests (Day 1)
- Write and run all unit tests
- Achieve 100% code coverage for UTutorialManagerSubsystem
- Fix any bugs discovered

### Phase 2: Integration Tests (Day 2-3)
- Implement integration test scenarios
- Test tutorial flows end-to-end
- Verify integration with existing systems

### Phase 3: Manual Testing (Day 4)
- Execute manual testing procedures
- Test on target platforms (Android/iOS)
- Document bugs and issues

### Phase 4: Performance Testing (Day 5)
- Profile tutorial system with Unreal Insights
- Verify 60 FPS during slow motion
- Optimize if needed

### Phase 5: Regression Testing (Ongoing)
- Re-run all tests after bug fixes
- Verify no new issues introduced
- Final sign-off before production

---

**References**:
- Requirements: `Docs/features/tutorials/requirements/README.md`
- Design: `Docs/features/tutorials/design/README.md`
- Implementation: `Docs/features/tutorials/implementation/README.md`

